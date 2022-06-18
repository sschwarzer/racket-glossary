#lang racket/base

(require
  racket/file
  racket/format
  racket/function
  racket/list
  racket/match
  racket/string)

(provide
  entries-string->entries
  entry-paragraphs
  entry-paragraph-count
  entry-only-reference?)

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
