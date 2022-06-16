# Glossary notes

This document should be used to collect hints for writing the actual entries in
the glossary. Having this auxiliary information in the glossary itself might be
confusing.

The notes in this file can be anything to help write the actual glossary
entries: definitions, examples, common pitfalls or other potentially useful
information. If you have information that doesn't fit into a specific glossary
entry, add it at the end of the document.

The "natural" format for this document is Markdown, but it's fine to use
Scribble notation. In this case, to have the content rendered properly in the
Github web interface, put the Scribble code between triple backticks, i.e. mark
them up as code.

Additions should be made in bullet points. That is, the entries in this file
shouldn't look like already finished glossary entries. Otherwise contributors
may be discouraged to add more information.

----

## Assignment

## Binding

## Boolean

## Box

## Call

## Channel

## Chaperone

## Class

## Closure

- Fix one or more free variables of a function by defining them in a scope
  outside the function.
- The closure is the function, plus access to the bindings from the outer
  scope.

## Collection

- Discuss uses and tradeoffs for different common data structures (list,
  vector, hash, set, maybe gvector?).
- Maybe relevant: https://en.wikipedia.org/wiki/Linked_list#Tradeoffs
- There's a [common collection API](https://docs.racket-lang.org/collections/index.html)
- Mention https://alex-hhh.github.io/2019/02/racket-data-structures.html ?

## Combinator

## Comprehension

## Cons cell

## Continuation

## Contract

## Core form

## Custodian

## Debugging

## Definition

## Display

## DrRacket

## DSL (domain-specific language)

## Environment

## Equality

## Exact number

## Executor

## Exception

## Expression (always lvalue? may result in one or more values)

## Field

## Fixnum

## Flat contract

## Flonum

## Form

## Formatting (‘format‘, ‘~a‘ etc.)

## Function

## Functional programming (FP)

## Functional update

## Future

## Generator

## Generic API

## GUI programming

## Hash

## Higher-order function

## Hygiene

## Identifier (differences to identifiers in other languages)

## Identity (also refer to ‘eq?‘)

## Impersonator

## Inexact number → Exact number

## Inspector

## Interface (API)

## Interface (OOP)

## Keyword arguments (positional and keyword args are separate)

## Lambda

## Lang (as in ‘\#lang‘)

## Language-oriented programming

## Let

## Let over lambda

- ```scribble
  "Let over lambda is a nickname given to a lexical closure." - Doug Hoyte, in
  @hyperlink["https://letoverlambda.com/textmode.cl/guest/chap2.html#sec_5doc"]{Let over Lambda}
  ```

## List

- Show singly-linked list data structures.
- Discusss data sharing if lists are "consed on."
- Mention growable vectors for people looking for an equivalent of "lists" from
  other languages. But mention that Racket lists are fine for many applications
  and have much better library support than growable vectors.

## Location

## Macro

- Introductions/tutorials
  - [Racket Guide](https://docs.racket-lang.org/guide/macros.html)
  - [Fear of Macros](https://www.greghendershott.com/fear-of-macros/)
  - [Mythical Macros](https://soegaard.github.io/mythical-macros/)
  - [Macros and Languages in
     Racket](https://rmculpepper.github.io/malr/index.html)
- Executed at compile time
- Needed to access information that's only available at compile time, not
  runtime. Example: `assert` macro to access an expression, not just it's
  result at runtime.
- Macros have control over when their arguments (correct term?) are evaluated.
  For example, `and` must be able to control evaluation of its runtime
  arguments to implement short-circuit behavior.
- Show only relatively simple macro approaches in glossary? For example, focus
  on pattern-bases macros instead of manipulating syntax values. On the other
  hand, we don't want to hold back information on concepts that go beyond
  simple macros.

## Match

## Match transformer

## Method

## Module

## Named let

## Namespace

## Naming conventions

- Scheme and Racket allow more characters in identifiers than most other
  languages.
- Describe common conventions.
  - Name parts are usually separated by `-` ("kebap case"). Camel case and
    snake case (underscores) are almost never used.
  - Abbreviations are rare, almost everything is "spelled out". This can result
    in long names (somewhat extreme cases:
    `make-input-port/read-to-peek`,
    `write-bytes-avail/enable-break`,
    `call-with-default-reading-parameterization`,
    `file-or-directory-permissions`), but people mostly seem to be fine with
    that.
  - Suffix `?` for predicates. (Explain predicates. Do we need/want a dedicated
    glossary entry for predicates?)
  - Suffix `!` for mutating functions.
    - Link to "Functional update"
  - `/` often means "for" or "with", e.g. `for/vector`.
  - `*` suffix
    - repetition, e.g. `regexp-replace*`
    - nesting, e.g. `let*`
    - other variant of the name without `*`, e.g. `for*`, `call-with-output-file*`
  - `->` for conversion, e.g. `vector->list`
  - Type in front, e.g. `vector-ref`, auto-generated struct accessors.
  - Trailing `%` for class names.
  - `make-something` for functions that create `something` structs or objects.
    Example: `make-date`, `make-channel`.
    When used to create containers, the function tends to take a size and a
    default value. Examples: `make-list`, `make-vector`.
  - `build-something`: similar to `make-something`, but instead of a default
    value, the second argument is a function that maps an integer to a
    container item value. Examples: `build-list`, `build-string`.

- I thought [How to Program Racket: a Style
  Guide](https://docs.racket-lang.org/style/index.html) also contained
  something about naming conventions, but it doesn't seem to be the case.

## Number

## Numeric tower

## Opaque

- See "struct"

## Package

## Pair

## Parameter

## Partial application and currying

- Partial application is the act of taking a function with some number of
  arguments and creating a new function that calls the first while hard coding
  some of the arguments.

- Example:

      (define (draw-line from-x from-y to-x to-y) ...) ; a function of 4 arguments
      (define (draw-line-from-origin x y) (draw-line 0 0 x y)) ; a function of 2 arguments
      (define draw-line-from-origin (lambda (x y) (draw-line 0 0 x y)))
      (define draw-line-from-origin (curry draw-line 0 0))

  The last three lines are equivalent.

- Racket has two separate currying functions: ```curry```, which hardcodes the
  leftmost arguments, and ```curryr``` which hardcodes the rightmost arguments.

  Example:

      (define draw-line-from-origin (curry draw-line 0 0)) ; same as (lambda (x y) (draw-line 0 0 x y))
      (define draw-line-to-origin   (curryr draw-line 0 0) ; same as (lambda (x y) (draw-line x y 0 0))

- Different from Haskell, Scheme/Racket don't curry implicitly.

## Pattern (in regular expressions)

## Pattern (in macro definitions)

## Phase

## Place

## Polymorphism (rarely used, compare with other languages; see also generic code)

## Port

- Like _file objects_ in "other" languages, but "port" is the common term for
  the concept in Scheme and Racket.
- Ports don't need to belong to files, sockets are also possible. (Check this!)

## Predicate

## Print

## Procedure

## Profiling

## Prompt

## Provide

## Quasiquote

## Quote

## RnRS (as in R5RS, R6RS etc.)

## Raco

## Reader (for parsing code)

## Record

## Require

## Rule (in macros; probably other uses, which ones?)

## Safe operation

## Scheme

## Scribble

## Sequence

- Lazy evaluation, it's not necessary to build intermediate lists (compared to,
  say, `map`).
- Usually used implicitly in `for` forms.
- Explain sequences vs. streams. When to use one or the other?
- Refer to converters between sequences and streams.
- Mention generators? They're related, but maybe this goes into too much
  detail? Generators seem to be used much(?) less than sequences or streams.

## Set

## Shadowing

## Splicing

## SRFI

- "Scheme request for implementation"
- Used to standardize functionality across different Scheme implementations.
- They come with an example implementation, but such an implementation may need
  changes to run on a different Scheme implementation than they were
  implemented for.
- Racket usually doesn't use SRFI, at least not explicitly. Racket has many
  functions that are described in SRFIs, but the similarity to the SRFIs isn't
  mentioned in the documentation.

## Standard library

## Stream

- Overlap with sequences (see also there).
- Usually used with files.

## String (strings vs. byte strings; handling encoding)

## Struct

- Although Racket has an object (OOP) system, usually data types are
  implemented as `struct`s and functions operating on them.
- Creating a struct auto-generates accessors (by default). Mutable structs also
  have mutator accessors added.
- Avoid mutation, prefer functional updates (reference "Functional update").
  Mention `struct-copy`.
- Usually use transparent structs although opaque is the default. With transparent
  visibility,
  - Printed information is more useful.
  - Usually you want to compare struct values by values, not by identity. So using
    `equal?` with opaque struct values can be confusing.
- Field names are only available at compile time. At runtime only offsets are
  available. But maybe this is a too low-level detail for the glossary?
- Mention that inherited fields require the accessor functions of the supertype
  (with example).
- Any other gotchas?

## Symbol

## Syntactic form

## Syntax (different meanings)

## Syntax transformer

## Tail call

## Thread

## Thunk

## Transparent

- See "struct"

## Trust level

## Trusted code

## Typed Racket

## Undefined (why do we need this if we have ‘void‘?)

## Unit

## Unsafe operation

## Untrusted code

## Value (sometimes "object", but may be confused with OOP concept)

## Values (multiple values, as in ‘define-values‘ etc.)

## Vector (mention growable vectors)

## Void

## Will

## Write

## Writer

----

## Information that doesn't fit into a specific glossary entry
