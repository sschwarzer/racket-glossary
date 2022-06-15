#lang racket/base

(require
  racket/format
  pict)

(provide
  text-rectangle
  cons-cell
  cons-cells)

(define LINE-WIDTH 1.5)
(define RECTANGLE-WIDTH 40)
(define RECTANGLE-HEIGHT 30)
(define PICT-DISTANCE 60)
(define ARROW-SIZE 8)

; Return pict with text centered inside rectangle.
(define (text-rectangle the-text)
  (define text-pict (text the-text))
  (cc-superimpose
    (rectangle RECTANGLE-WIDTH RECTANGLE-HEIGHT #:border-width LINE-WIDTH)
    text-pict))

; Return pict of a cons cell.
(define (cons-cell car-value [cdr-value (void)])
  (define car-pict (text-rectangle (~a car-value)))
  (define cdr-pict (if (void? cdr-value)
                       (text-rectangle "")
                       (text-rectangle (~a cdr-value))))
  (hc-append car-pict
             ; Move right rectangle so that the borders of the two rectangles
             ; overlap.
             (translate cdr-pict (- LINE-WIDTH) 0)))

; Return sub-picts for left and right half of cons cell pict.
(define (cons-cell-car cons-cell)
  (child-pict (car (pict-children cons-cell))))

(define (cons-cell-cdr cons-cell)
  (child-pict (cadr (pict-children cons-cell))))

; Return pict of cons cells with an arrow between cdrs and their pointed-to
; cars.
(define (cons-cells . the-cons-cells)
  (define all-cons-cells (apply hc-append PICT-DISTANCE the-cons-cells))
  (define (with-arrow current-pict cons-cell1 cons-cell2)
    (pin-arrow-line ARROW-SIZE
                    current-pict
                    (cons-cell-cdr cons-cell1) cc-find
                    cons-cell2 lc-find))
  (for/fold ([current-pict all-cons-cells])
            ([cons-cell1 the-cons-cells]
             [cons-cell2 (cdr the-cons-cells)])
    (with-arrow current-pict cons-cell1 cons-cell2)))
