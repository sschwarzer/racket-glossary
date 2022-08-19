#lang racket/base

(require
  racket/file
  racket/format
  sxml
  ; For `current-sxml-warning-handler`
  sxml/ssax/errors-and-warnings
  sxml/sxpath)

; Return `#t` if the XML `document` needs fixing. Otherwise return `#f`. See
; `fix-svg` on what "fixing" means.
;
; To keep things simple, check only the style information. If we don't find it,
; assume we both need to add the style information and change the `stroke`
; attributes.
(define (needs-fixing? document)
  (define style-element
    ((sxpath "/svg/defs/style") document))
  (equal? style-element '())
)

; For `prefers-color-scheme` to be applied, either the system color scheme or
; the browser's color scheme must be set to "dark."
; See https://todo.sr.ht/~sschwarzer/racket-glossary/4 .
(define COLOR_STYLES "
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
 ")

(define (fix-document document)
  #f
)

; Read the SVG file at `path`. If it's not "fixed" yet, fix it and write the
; new version. Otherwise do nothing.
;
; "Fixing" implies:
; - If the file doesn't yet contain color style information, add it.
; - Change attribute values `stroke="rgb(0,0,0)"` to `stroke="currentColor"`.
(define (fix-svg path)
  (define document
    (call-with-input-file*
      path
      (lambda (port)
        ; Hack to suppress warning
        ;   ssax:warn: warning at position 137:
        ;   DOCTYPE DECL svg http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd
        ;   found and skipped
        ; There doesn't seem to be a public API for this.
        (parameterize ([current-sxml-warning-handler (lambda args void)])
          (ssax:xml->sxml port '())))))
  (cond
    [(needs-fixing? document)
     (define fixed-document (fix-document document))
     (srl:sxml->xml fixed-document (current-output-port))]
    [else
     (printf "path ~a is already fixed" path)]))

(fix-svg "scribblings/list-1234.svg")
