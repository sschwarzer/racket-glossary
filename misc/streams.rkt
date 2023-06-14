#lang racket

; Basic list operations vs. basic stream operations.
(define a-list
  (cons 1 (cons 2 (cons 3 '()))))
a-list

(define a-stream
  (stream-cons
    1
    (stream-cons
      2
      (stream-cons
        (begin (displayln "three") 3)
        empty-stream))))

a-stream
(stream->list a-stream)
(displayln "second item:")
(stream-first (stream-rest a-stream))

(define a-stream-2
  (stream
    1
    2
    (begin (displayln "three") 3)))

a-stream-2
(stream->list a-stream-2)
(displayln "second item:")
(stream-first (stream-rest a-stream-2))

;; Convert a list algorithm to a stream algorithm.

; Create a finite list of squares.
(define (squares)
  (let loop ([i 0])
    (if (> i 10)
        '()
        (cons (* i i) (loop (add1 i))))))

(displayln "Create finite list:")
(squares)


; Create an infinite stream of squares.
(define (stream-squares)
  (let loop ([i 0])
    (stream-cons (* i i) (loop (add1 i)))))

(displayln "Create \"infinite\" stream; stop at 10")
; Needs parallel range to prevent infinite run.
(for/list ([unused (in-inclusive-range 0 10)]
           [item (stream-squares)])
  item)

(displayln "Second item from stream (corresponds to `(car (cdr lst))`):")
(stream-first (stream-rest (stream-squares)))

(displayln "Use `stream->list` to take a part of the infinite stream:")
(stream->list (stream-take (stream-squares) 11))

; Both arguments of `stream-cons` are lazy by default, so
; "one" is _not_ printed here.
(stream-cons (begin (displayln "one") 1) empty-stream)
(stream (begin (displayln "two") 2))

stream-empty?