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

; Return `entry` from entry string.
(define (entry-string->entry entry-string)
  (define the-match
    (regexp-match
      (pregexp
        (~a ; Everything up to last closing `}`.
            "(?m:@glossary-entry\\{(.*)\\}\\s*$"
            "\\s+"
            "^  @level-(.*)\\s*$"
            "((?s:.*)))"))
      entry-string))
  (unless the-match
    (raise-argument-error
      'entry-string->entry
      "valid entry string"
      entry-string))
  (match-define (list _ title category raw-text) the-match)
  (unless (index-of CATEGORIES category)
    (raise-argument-error
      'entry-string->entry
      (~a "valid category (one of " CATEGORIES ")")
      entry-string))
  (define text
    ; Remove trailing spaces at end of line.
    (regexp-replace* " *\n" (string-trim raw-text) "\n"))
  (entry title category text))

; Return a list of paragraphs (strings).
(define (entry-paragraphs entry)
  (regexp-split "\n\n+" (entry-text entry)))

; Return number of paragraphs.
(define (entry-paragraph-count entry)
  (length (entry-paragraphs entry)))

; Return `#t` if the entry is only a reference to another entry.
(define (entry-only-reference? entry)
  (and (= (entry-paragraph-count entry) 1)
       (string-prefix? (entry-text entry) "See @secref*[")))

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
(struct glossary-stats/category
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

; Return `glossary-stats/category` for a given category.
(define (make-glossary-stats/category entries category)
  (define-values
    (all-count done-count only-reference-count)
    (for/fold ([all-count 0]
               [done-count 0]
               [only-reference-count 0])
              ([entry entries])
      (if (string=? (entry-category entry) category)
          (values
            (add1 all-count)
            (+ done-count
               ; If the entry has only one paragraph, it's likely that this is
               ; just some form of comment and not the real entry.
               (if (or (> (entry-paragraph-count entry) 1)
                       (entry-only-reference? entry))
                   1
                   0))
            (+ only-reference-count
               (if (entry-only-reference? entry)
                   1
                   0)))
          (values
            all-count
            done-count
            only-reference-count))))
  (glossary-stats/category category all-count done-count only-reference-count))

; Format a given `glossary-stats/category` value.
(define (glossary-stats/category->string stats)
  (~a (~a (glossary-stats/category-category stats) #:width 12)
      ": "
      (~a (glossary-stats/category-done-count stats) #:width 3 #:align 'right)
      " /"
      (~a (glossary-stats/category-all-count stats) #:width 3 #:align 'right)
      " ("
      (~r (* 100.0
             (/ (glossary-stats/category-done-count stats)
                (glossary-stats/category-all-count stats)))
          #:precision 0 #:min-width 3)
      " %) done, including "
      (~a (glossary-stats/category-only-reference-count stats) #:width 2 #:align 'right)
      " reference(s)"))

; Print statistics for a `glossary-stats/category` to standard output.
; TODO: Add line for totals.
; TODO: Option to exclude refs to give a more meaningful picture of what's done.
(define (print-stats path)
  (define entries (file->entries path))
  (for ([category CATEGORIES])
    (define stats (make-glossary-stats/category entries category))
    (displayln (glossary-stats/category->string stats))))

(module+ main
  (print-stats "scribblings/racket-glossary.scrbl"))

; ----------------------------------------------------------------------
; Tests

(module+ test
  (require
    rackunit
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
