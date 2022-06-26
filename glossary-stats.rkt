#lang racket/base

(require
  racket/file
  racket/format
  racket/function
  racket/list
  racket/match
  racket/string)

; ----------------------------------------------------------------------
; Entries parsing

(define CATEGORIES '("basic" "intermediate" "advanced"))

(struct entry (title category text)
  #:transparent)

(define (normalize-string the-string)
  ; Strip surrounding whitespace.
  (define string1 (string-trim the-string))
  ; Remove line comments. Don't try to remove multi-line comments because this
  ; can't really be done reliably with just regular expressions.
  (define string2 (regexp-replace* "(?m:^(.*?)@;[^{].*$)" string1 "\\1"))
  ; Remove trailing spaces before line breaks.
  (define string3 (regexp-replace* " *\n" string2 "\n"))
  ; Collapse more than two linebreaks into two linebreaks.
  (regexp-replace* "\n\n+" string3 "\n\n"))

; Return `entry` from entry string.
(define (entry-string->entry entry-string)
  (define normalized-entry-string (normalize-string entry-string))
  (define the-match
    (regexp-match
      (pregexp
        (~a ; Everything up to last closing `}`.
            "(?m:@glossary-entry\\{(.*)\\}\\s*$"
            "\\s+"
            "^  @level-(.*)\\s*$"
            "((?s:.*)))"))
      normalized-entry-string))
  (unless the-match
    (raise-argument-error
      'entry-string->entry
      "valid entry string"
      entry-string))
  (match-define (list _ title category text) the-match)
  (unless (index-of CATEGORIES category)
    (raise-argument-error
      'entry-string->entry
      (~a "valid category (one of " CATEGORIES ")")
      entry-string))
  (entry title category (string-trim text)))

; Return a list of paragraphs (strings).
(define (entry-paragraphs entry)
  (regexp-split "\n\n" (entry-text entry)))

; Return number of paragraphs.
(define (entry-paragraph-count entry)
  (length (entry-paragraphs entry)))

; Return `#t` if the entry is only a reference to another entry.
(define (entry-only-reference? entry)
  (and (= (entry-paragraph-count entry) 1)
       (string-prefix? (entry-text entry) "See @secref*[")))

; Return `#t` if the entry seems to be done (fully written, apart from later
; improvements).
(define (entry-done? entry)
  ; If the entry has only one paragraph, it's likely that this is just some
  ; form of comment and not the real entry.
  (or (> (entry-paragraph-count entry) 1)
      (entry-only-reference? entry)))

; Return list of `entry`s from a string multiple entries.
(define (entries-string->entries entries-string)
  (define matches
    (regexp-match*
      (pregexp
        (~a "@glossary-entry\\{"
            ".*?"
            "(?:$|(?=@glossary-entry\\{))"))
        entries-string))
  (map (compose entry-string->entry string-trim) matches))

; Return a list of `entry`s from a file path.
(define (file->entries path)
  (entries-string->entries (file->string path)))

; ----------------------------------------------------------------------
; Statistics

; Glossary stats for a single category.
(struct glossary-stats
   ; Category string.
  (category
   ; Total number of entries in category, including references.
   all-count
   ; Number of presumably finished entries, including references.
   done-count
   ; Number of entries that are only references to other entries and hence
   ; don't require "real" work.
   only-reference-count)
  #:transparent)

; Return `glossary-stats` for a given category.
(define (make-glossary-stats entries category)
  (define-values (all-count done-count only-reference-count)
    (for/fold ([all-count 0]
               [done-count 0]
               [only-reference-count 0])
              ([entry entries])
      (if (string=? (entry-category entry) category)
          (values
            (+ all-count 1)
            (+ done-count           (if (entry-done? entry)           1 0))
            (+ only-reference-count (if (entry-only-reference? entry) 1 0)))
          (values
            all-count
            done-count
            only-reference-count))))
  (glossary-stats category all-count done-count only-reference-count))

; Characters for bar graph.
(define DONE-CHAR #\u25a0)
(define NOT-DONE-CHAR #\u00b7)

; Bar length in characters.
(define TOTAL-BAR-LENGTH 50)

; Format a given `glossary-stats` value.
(define (glossary-stats->string stats)
  ; Counts _excluding_ references.
  (define done-count (- (glossary-stats-done-count stats)
                        (glossary-stats-only-reference-count stats)))
  (define all-count (- (glossary-stats-all-count stats)
                       (glossary-stats-only-reference-count stats)))
  (define done-length (round (* (/ done-count all-count) TOTAL-BAR-LENGTH)))
  ; Just subtract from total length to avoid that we get different bar lengths
  ; due to rounding errors.
  (define rest-length (- TOTAL-BAR-LENGTH done-length))
  (~a (~a (glossary-stats-category stats) #:width 12)
      " |"
      (make-string done-length DONE-CHAR)
      (make-string rest-length NOT-DONE-CHAR)
      "| "
      (~a done-count #:width 3 #:align 'right)
      " / "
      (~a all-count #:width 3 #:align 'right)
      " done"))

; Print statistics for a `glossary-stats` to standard output.
; TODO: Add line for totals.
; TODO: Option to exclude refs to give a more meaningful picture of what's done.
(define (print-stats path)
  (define entries (file->entries path))
  (displayln "Completion stats, ignoring cross references:")
  (for ([category CATEGORIES])
    (define stats (make-glossary-stats entries category))
    (displayln (glossary-stats->string stats))))

(module+ main
  (print-stats "scribblings/racket-glossary.scrbl"))

; ----------------------------------------------------------------------
; Tests

(module+ test
  (require
    rackunit
    errortrace
    al2-test-runner)

  (run-tests
    (test-suite "test-entry-string->entry"
      ; Test simple input.
      (test-case "Minimal string"
        (define input-string "@glossary-entry{Foo}\n\n  @level-basic")
        (define expected-entry (entry "Foo" "basic" ""))
        (check-equal? (entry-string->entry input-string) expected-entry))
      (test-case "Minimal string with actual text"
        (define input-string
          "@glossary-entry{Foo}\n\n  @level-basic\n\nFirst paragraph\n\nSecond paragraph")
        (define expected-entry (entry "Foo" "basic" "First paragraph\n\nSecond paragraph"))
        (check-equal? (entry-string->entry input-string) expected-entry))
      (test-case "Input normalization"
        (define input-string
          (~a ; Leading whitespace should be stripped.
              "  \n"
              "@glossary-entry{Foo}\n"
              "\n"
              ; Line comments should be removed.
              "  @; Comment line 1\n"
              "  @; Comment line 2\n"
              ; Trailing spaces should be removed.
              " \n"
              "  @level-basic\n"
              "\n"
              "First paragraph\n"
              ; More than one empty line should be collapsed into one empty line.
              "\n"
              "  \n"
              "\n"
              "Second paragraph\n"
              "  \n"))
        (define expected-entry
          (entry "Foo"
                 "basic"
                 "First paragraph\n\nSecond paragraph"))
        (check-equal? (entry-string->entry input-string) expected-entry))
      ; Test invalid input.
      (test-exn "Empty string"
        exn:fail:contract?
        (thunk (entry-string->entry "")))
      (test-exn "Missing `glossary-entry`"
        exn:fail:contract?
        (thunk (entry-string->entry "  @level-basic")))
      (test-exn "Invalid category"
        exn:fail:contract?
        (thunk (entry-string->entry "@glossary-entry{Foo}\n  @level-invalid")))
  ))
)
