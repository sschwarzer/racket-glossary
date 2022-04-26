#lang scribble/manual

@require[@for-label[racket/base]]

@(define level-basic        @elem{@bold{Level:} basic})
@(define level-intermediate @elem{@bold{Level:} intermediate})
@(define level-advanced     @elem{@bold{Level:} advanced})

@title{Glossary of Racket terms and concepts}
@author{Stefan Schwarzer}

@;{A glossary entry might contain information that falls into multiple categories.
   For example, basic macro stuff could be classified as "intermediate" and more
   complex uses as "advanced."}

The glossary entries are categorized in three "levels":
@itemlist[
  @item{@bold{basic:} These are basic concepts you should know to write Racket
    libraries and programs. If you're starting to learn Racket, focus on these
    concepts.}
  @item{@bold{intermediate:} You can write most Racket software without these
    features, but you may need them depending on your problem. One example
    would be threads to execute different tasks concurrently.}
  @item{@bold{advanced:} Likely you won't need these features, but they can
    improve your software. Look into this if you're comfortable with the
    concepts from the "basic" and "intermediate" category.}]

@; Below are the terms I'd like to explain in the glossary.

@section{Assignment}

@level-basic


binding

boolean

box

call → procedure application

cell

channel

chaperone

class

closure

collection

combinator

comprehension

cons cell → pair

continuation

contract

core form

currying

custodian

debugging

definition

display

DrRacket

DSL

environment

exact number

exception

expression (always lvalue? may result in one or more values)

field

fixnum

flonum

form

formatting (`format`, `~a` etc.)

function → procedure

functional programming (FP)

functional update

future

generator

generic API

GUI programming

hash

hygiene

identifier (differences to identifiers in other languages)

identity (also refer to `eq?`)

impersonator

inexact number → exact number

inspector

interface (API)

interface (OOP)

keyword arguments (positional and keyword args are separate)

lang (as in `#lang`)

language-oriented programming

let over lambda

list (linked list, explain differences to arrays in other languages)

macro

match

match transformer

method

module

named let

namespace

naming conventions

number

numeric tower

opaque

package

pair

parameter

pattern (in regular expressions)

pattern (in macro definitions)

phase

place

polymorphism (rarely used, compare with other languages; see also generic code)

port

predicate

print → display

procedure

procedure application

profiling

quasiquote

quote

RnRS (as in R5RS, R6RS etc.)

raco

reader (for parsing code)

record → struct

rule (in macros; probably other uses, which ones?)

safe operation → unsafe operation

Scheme

Scribble

sequence

set

shadowing

splicing

SRFI

standard library

stream

string (strings vs. byte strings; handling encoding)

struct

symbol

syntactic form → form

syntax (different meanings)

syntax transformer

tail call

thread

thunk

transparent → opaque

trust level

trusted code

Typed Racket

undefined (why do we need this if we have `void`?)

unit

unsafe operation

untrusted code → trusted code

value (sometimes "object", but may be confused with OOP concept)

values (multiple values, as in `define-values` etc.)

vector (mention growable vectors)

void

write → display

writer
