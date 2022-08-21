#lang racket/base

(require
  racket/file
  racket/format
  racket/match
  xml
  xml/path)

; Return `#t` if the XML `document` needs fixing. Otherwise return `#f`. See
; `fix-svg` on what "fixing" means.
;
; To keep things simple, check only the style information. If we don't find it,
; assume we both need to add the style information and change the `stroke`
; attributes.
(define (needs-fixing? document)
  (define document-xexpr
    (xml->xexpr (document-element document)))
  (define style-element
    (se-path* '(svg defs style) document-xexpr))
  (not style-element))

; For `prefers-color-scheme` to be applied, either the system color scheme or
; the browser's color scheme must be set to "dark."
; See https://todo.sr.ht/~sschwarzer/racket-glossary/4 .
(define COLOR-STYLE "
  <defs>
    <style>
      svg {
        color: black;
        background-color: white;
      }
      @media (prefers-color-scheme: dark) {
        svg {
          color: white;
          background-color: black;
        }
      }
    </style>
  </defs>
")

; Return an updated XML object: If `xml` is the `svg` element, insert
; the `defs`/`style` element as the first new child.
;
; `xml` is an XML `document`, `element` etc.
; `path` is a list of symbols, e.g. '(svg defs font).
(define (style-updater xml path)
  (cond
    [(and (element? xml)
          (equal? path '(svg)))
     (define style-element (xexpr->xml (string->xexpr COLOR-STYLE)))
     (struct-copy
       element
       xml
       [content (cons style-element (element-content xml))])]
    [else
     xml]))

(define (black-updater xml path)
  (cond
    [(element? xml)
     (define new-attributes
       (for/list ([an-attribute (element-attributes xml)])
         (match an-attribute
           [(attribute start stop name "rgb(0,0,0)")
            (attribute start stop name "currentColor")]
           [_
            an-attribute])))
     (struct-copy
       element
       xml
       [attributes new-attributes])]
    [else
     xml]))

; Return an updated XML object: In any element, replace an attribute value pair
; '(stroke "rgb(0,0,0)") with '(stroke "currentColor").
;
; `xml` is an XML `document`, `element` etc.
; `path` is a list of symbols, e.g. '(svg defs font).
(define (update xml updater)
  (let visit ([xml xml]
              [path '()])
    (cond
      [(document? xml)
       (struct-copy
         document
         xml
         [element (visit (document-element xml) path)])]
      [(element? xml)
       (define new-path (append path (list (element-name xml))))
       (define updated-xml (updater xml new-path))
       (define new-content
         (for/list ([content-item (element-content updated-xml)])
           (visit content-item new-path)))
       (struct-copy
         element
         updated-xml
         [content new-content])]
      [else
       xml])))

; Return fixed SVG XML for dark mode support.
(define (fix-document xml)
  (define xml1 (update xml style-updater))
  (define xml2 (update xml1 black-updater))
  xml2)

; Read the SVG file at `path`. If it's not "fixed" yet, fix it and write the
; new version. Otherwise do nothing.
;
; "Fixing" implies:
; - If the file doesn't yet contain color style information, add it.
; - Change attribute values `stroke="rgb(0,0,0)"` to `stroke="currentColor"`.
(define (fix-svg path)
  (define document
    (with-input-from-file path read-xml))
  (cond
    [(needs-fixing? document)
     (define fixed-document (fix-document document))
     (write-xml fixed-document (current-output-port))]
    [else
     (printf "path ~a is already fixed" path)]))

(fix-svg "scribblings/list-1234.svg")
