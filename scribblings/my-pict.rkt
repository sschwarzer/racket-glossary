#lang racket/base

; Support code for the Racket glossary.
;
; This code is just enough to support the use cases in the glossary. Don't use
; it in other contexts without being aware of the limitations.
;
; In particular, `combined-lists-pict` uses a module-global hash. This approach
; may fail if any of the list arguments have any items in common.

(require
  racket/format
  pict)

(provide
  text-rectangle-pict
  cons-cell-pict
  cons-cells-pict
  list-pict
  combined-lists-pict)

(define LINE-WIDTH 1.5)
(define RECTANGLE-WIDTH 30)
(define RECTANGLE-HEIGHT 30)
(define PICT-DISTANCE 50)
(define ARROW-SIZE 8)

(define cons-cell-pict-hash (make-hash))

; Return pict with text centered inside rectangle.
(define (text-rectangle-pict the-text)
  (define text-pict (text the-text))
  (cc-superimpose
    (rectangle RECTANGLE-WIDTH RECTANGLE-HEIGHT #:border-width LINE-WIDTH)
    text-pict))

; Return pict of a cons cell.
(define (cons-cell-pict car-value [cdr-value (void)])
  (define car-pict (text-rectangle-pict (~a car-value)))
  (define cdr-pict (if (void? cdr-value)
                       (text-rectangle-pict "")
                       (text-rectangle-pict (~a cdr-value))))
  (define result
    (hc-append car-pict
             ; Move right rectangle so that the borders of the two rectangles
             ; overlap.
             (translate cdr-pict (- LINE-WIDTH) 0)))
  (hash-set! cons-cell-pict-hash car-value result)
  result)

; Return sub-picts for left and right half of cons cell pict.
(define (cons-cell-car-pict cons-cell-pict)
  (child-pict (car (pict-children cons-cell-pict))))

(define (cons-cell-cdr-pict cons-cell-pict)
  (child-pict (cadr (pict-children cons-cell-pict))))

; Return pict of cons cells with an arrow between cdrs and their pointed-to
; cars.
(define (cons-cells-pict . the-cons-cell-picts)
  (define all-cons-cells-pict (apply hc-append PICT-DISTANCE the-cons-cell-picts))
  (for/fold ([current-pict all-cons-cells-pict])
            ([cons-cell-pict1 the-cons-cell-picts]
             [cons-cell-pict2 (cdr the-cons-cell-picts)])
    (pin-arrow-line ARROW-SIZE
                    current-pict
                    (cons-cell-cdr-pict cons-cell-pict1) cc-find
                    cons-cell-pict2 lc-find)))

; Return pict of list `the-list`.
(define (list-pict the-list)
  (define the-list-length (length the-list))
  (apply
    cons-cells-pict
    (for/list ([index (in-naturals)]
               [item (in-list the-list)])
      (if (= index (sub1 the-list-length))
          (cons-cell-pict item '())
          (cons-cell-pict item)))))

(define (combined-lists-pict top-left-list bottom-left-list right-list)
  ; Get last items of left lists.
  (define top-left-last-item (list-ref top-left-list
                                       (sub1 (length top-left-list))))
  (define bottom-left-last-item (list-ref bottom-left-list
                                          (sub1 (length bottom-left-list))))
  ; Create the three list subpicts.
  (define top-left-list-pict (apply cons-cells-pict
                                    (map cons-cell-pict top-left-list)))
  (define bottom-left-list-pict (apply cons-cells-pict
                                       (map cons-cell-pict bottom-left-list)))
  (define right-list-pict (list-pict right-list))
  ; Combine picts, including arrows.
  (define left-pict (vr-append 50 top-left-list-pict bottom-left-list-pict))
  (define lists-pict (hc-append 50 left-pict right-list-pict))
  (define with-arrow1
    (pin-arrow-line ARROW-SIZE
                    lists-pict
                    (cons-cell-cdr-pict (hash-ref cons-cell-pict-hash top-left-last-item))
                    cc-find
                    (hash-ref cons-cell-pict-hash (car right-list))
                    lt-find))
  (define with-arrow2
    (pin-arrow-line ARROW-SIZE
                    with-arrow1
                    (cons-cell-cdr-pict (hash-ref cons-cell-pict-hash bottom-left-last-item))
                    cc-find
                    (hash-ref cons-cell-pict-hash (car right-list))
                    lb-find))
  with-arrow2)
