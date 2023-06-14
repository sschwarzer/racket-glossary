#lang racket

(require racket/generator)

; Provide alternatives for sequence constructors.
;
; Define the sequence constructors before the struct
; so that the constructors are available for use in
; `#:property prop:sequence`.
(define (in-myvec-stream a-myvec)
  (define inner-vec (myvec-v a-myvec))
  (for/stream ([index (in-range 0 (vector-length inner-vec))])
    (define item (vector-ref inner-vec index))
    ; Use `displayln` to verify that the sequence items
    ; are created on-demand.
    (displayln item)
    item))

(define (in-myvec-generator a-myvec)
  (define inner-vec (myvec-v a-myvec))
  (in-generator
    (for ([index (in-range 0 (vector-length inner-vec))])
      (define item (vector-ref inner-vec index))
      (displayln item)
      (yield item))))

(struct myvec (v)
  #:property prop:sequence
  ; Or, alternatively, `in-myvec-gemerator`
  in-myvec-stream)

; Pretend that this isn't a normal Racket vector,
; but something else internally, so that we need a
; custom sequence constructor.
(define (make-myvec . values)
  (define a-vec (apply vector values))
  (myvec a-vec))

(define (test a-myvec [sequence-constructor #f])
  (define the-sequence
    (if sequence-constructor
        (sequence-constructor a-myvec)
        ; Use the value itself as sequence.
        a-myvec))
  (displayln sequence-constructor)
  (for/list ([unused (in-range 0 2)]
             [vec-item the-sequence])
    vec-item))

(define a-myvec (make-myvec 10 11 12 13))

(test a-myvec in-myvec-stream)
(test a-myvec in-myvec-generator)
(test a-myvec)