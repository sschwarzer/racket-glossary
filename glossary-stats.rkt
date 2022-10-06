#lang racket/base

(require
  racket/file
  racket/format
  racket/function
  racket/list
  racket/match
  racket/string
  ; Implicitly generate stats.
  "scribblings/racket-glossary.scrbl")

; ----------------------------------------------------------------------
; Statistics

; Glossary stats for a single level.
(struct glossary-stats
  (; Level symbol.
   level
   ; Total number of entries for level, including cross references.
   all-count
   ; Number of presumably finished entries, including cross references.
   done-count
   ; Number of entries that are cross references to other entries and hence
   ; don't require "real" work.
   only-reference-count)
  #:transparent)

; Return `#t` if the entry seems to be done (fully written, apart from later
; improvements). This includes cross references.
(define (entry-done? entry)
  (not (entry-stub? entry)))

; Return `glossary-stats` for a given level.
(define (make-glossary-stats entries level)
  (define-values (all-count done-count only-reference-count)
    (for/fold ([all-count 0]
               [done-count 0]
               [only-reference-count 0])
              ([entry entries])
      (cond
        [(eq? (entry-level entry) level)
         (values
           (+ all-count 1)
           (+ done-count           (if (entry-done? entry)            1 0))
           (+ only-reference-count (if (entry-cross-reference? entry) 1 0)))]
        [else
         ; Keep values accumulated so far.
         (values
           all-count
           done-count
           only-reference-count)])))
  (glossary-stats level all-count done-count only-reference-count))

; Characters for bar graph.
;
; Intentionally repeat the code points in the comments so it's an _obvious_
; contradiction if I change the code points for the constants and forget to
; update the comment.
(define DONE-CHAR #\u25a0)  ; 25a0 = BLACK SQUARE
(define NOT-DONE-CHAR #\u00b7)  ; 00b7 = MIDDLE DOT

; Bar length in characters.
(define TOTAL-BAR-LENGTH 50)

; Return a progress bar string for a given ratio. The length of the bar
; including the "|" delimiters is `TOTAL-BAR-LENGTH + 2`.
(define (bar-graph-string ratio)
  (define done-length (round (* ratio TOTAL-BAR-LENGTH)))
  ; Just subtract from total length to avoid that we get different bar lengths
  ; due to rounding errors.
  (define rest-length (- TOTAL-BAR-LENGTH done-length))
  (~a "|"
      (make-string done-length DONE-CHAR)
      (make-string rest-length NOT-DONE-CHAR)
      "|"))

; Return a given `glossary-stats` value as a progress string.
(define (glossary-stats->string stats)
  ; Counts _excluding_ references.
  (define done-count (- (glossary-stats-done-count stats)
                        (glossary-stats-only-reference-count stats)))
  (define all-count (- (glossary-stats-all-count stats)
                       (glossary-stats-only-reference-count stats)))
  (~a (~a (glossary-stats-level stats) #:width 12)
      " "
      (bar-graph-string (/ done-count all-count))
      " "
      (~a done-count #:width 3 #:align 'right)
      " of "
      (~a all-count #:width 3 #:align 'right)
      " done"))

; Return `glossary-stats` from summing the fields in a list of
; `glossary-stats`.
(define (total-glossary-stats stats-list)
  (define-values (all-count done-count only-reference-count)
    (for/fold ([all-count 0]
               [done-count 0]
               [only-reference-count 0])
              ([stats stats-list])
      (values (+ all-count (glossary-stats-all-count stats))
              (+ done-count (glossary-stats-done-count stats))
              (+ only-reference-count (glossary-stats-only-reference-count stats)))))
  (glossary-stats "total" all-count done-count only-reference-count))

; Print statistics for a `glossary-stats` to standard output.
(define (print-stats)
  (define entries (hash-values stats-hash))
  (define glossary-stats/levels
    (for/list ([level LEVELS])
      (make-glossary-stats entries level)))
  (displayln "Completion stats, ignoring cross references:\n")
  (for ([stats glossary-stats/levels])
    (displayln (glossary-stats->string stats)))
  (define glossary-stats/total (total-glossary-stats glossary-stats/levels))
  (displayln "")
  (displayln (glossary-stats->string glossary-stats/total)))

; Print titles of entries to be written.
(define (print-stub-titles levels)
  (define entries (hash-values stats-hash))
  (for ([level levels])
    (displayln (~a "Missing entries for level " level ":"))
    (define stub-entries
      (filter
        (lambda (entry)
          (and (eq? (entry-level entry) level)
               (entry-stub? entry)))
        entries))
    (define stub-titles
      (sort
        (map entry-title stub-entries)
        string<?))
    (for ([title stub-titles])
      (displayln (~a "  " title)))
  (displayln "")))

(module+ main
  (print-stats)
  (displayln "")
  (print-stub-titles '(basic)))
