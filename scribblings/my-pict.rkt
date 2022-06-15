#lang racket/base

(require
  racket/format
  pict)

(provide
  text-rectangle-pict
  cons-cell-pict
  cons-cells-pict)

(define LINE-WIDTH 1.5)
(define RECTANGLE-WIDTH 40)
(define RECTANGLE-HEIGHT 30)
(define PICT-DISTANCE 60)
(define ARROW-SIZE 8)

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
  (hc-append car-pict
             ; Move right rectangle so that the borders of the two rectangles
             ; overlap.
             (translate cdr-pict (- LINE-WIDTH) 0)))

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
