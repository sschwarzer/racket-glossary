#lang info
(define collection "racket-glossary")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/glossary.scrbl" ())))
(define pkg-desc "Glossary of Racket concepts")
(define version "0.1.0-dev")
(define pkg-authors '(sschwarzer))
(define license '(Apache-2.0 OR MIT))
