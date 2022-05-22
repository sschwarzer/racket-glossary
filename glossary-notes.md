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

## Cell

## Channel

## Chaperone

## Class

## Closure

## Collection

## Combinator

## Comprehension

## Cons cell

## Continuation

## Contract

## Core form

## Currying

- Currying is the act of taking a function with some number of arguments and
  creating a new function that calls the first while hard coding some of the
  arguments.

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

## Number

## Numeric tower

## Opaque

## Package

## Pair

## Parameter

## Pattern (in regular expressions)

## Pattern (in macro definitions)

## Phase

## Place

## Polymorphism (rarely used, compare with other languages; see also generic code)

## Port

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

## Set

## Shadowing

## Splicing

## SRFI

## Standard library

## Stream

## String (strings vs. byte strings; handling encoding)

## Struct

## Symbol

## Syntactic form

## Syntax (different meanings)

## Syntax transformer

## Tail call

## Thread

## Thunk

## Transparent

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
