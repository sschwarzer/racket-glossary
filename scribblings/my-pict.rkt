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
  (let ([text-pict (text the-text)])
    (cc-superimpose
      (rectangle RECTANGLE-WIDTH RECTANGLE-HEIGHT #:border-width LINE-WIDTH)
      text-pict)))

; Return pict of a cons cell.
(define (cons-cell car-value [cdr-value (void)])
  (let ([car-pict (text-rectangle (~a car-value))]
        [cdr-pict (if (void? cdr-value)
                      (text-rectangle "")
                      (text-rectangle (~a cdr-value)))])
    (hc-append car-pict
               ; Move right rectangle so that the borders of the two rectangles
               ; overlap.
               (translate cdr-pict (- LINE-WIDTH) 0))))

; Return pict of cons cells with an arrow between cdrs and their pointed-to
; cars.
(define (cons-cells . the-cons-cells)
  (let* ([all-cons-cells (apply hc-append PICT-DISTANCE the-cons-cells)]
         [with-arrow (lambda (current-pict cc1 cc2)
                       (pin-arrow-line ARROW-SIZE
                                       current-pict
                                       ; Right half of cons cell.
                                       (child-pict (cadr (pict-children cc1))) cc-find
                                       cc2 lc-find))])
    (let loop ([cons-cells the-cons-cells]
               [shifted-cons-cells (cdr the-cons-cells)]
               [current-pict all-cons-cells])
      (cond
        [(null? shifted-cons-cells)
         current-pict]
        [else
         (loop (cdr cons-cells)
               (cdr shifted-cons-cells)
               (with-arrow current-pict (car cons-cells) (car shifted-cons-cells)))]))))
