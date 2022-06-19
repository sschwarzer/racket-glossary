#lang info
(define collection "racket-glossary")
(define deps '("base"))
(define build-deps '("racket-doc"
                     "rackunit-lib"
                     "scribble-lib"
                     "al2-test-runner"))
(define scribblings '(("scribblings/racket-glossary.scrbl" ())))
(define pkg-desc "Glossary of Racket concepts")
(define version "0.1.0-dev")
(define pkg-authors '(sschwarzer))
(define license '(Apache-2.0 OR MIT))
