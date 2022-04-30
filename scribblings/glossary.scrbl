#lang scribble/manual

@require[@for-label[racket/base]]

@(define level-basic        @elem{@bold{Level:} basic})
@(define level-intermediate @elem{@bold{Level:} intermediate})
@(define level-advanced     @elem{@bold{Level:} advanced})

@title{Glossary of Racket terms and concepts}
@author{Stefan Schwarzer}

@section{Usage notes}

@;{A glossary entry might contain information that falls into multiple categories.
   For example, basic macro stuff could be classified as "intermediate" and more
   complex uses as "advanced."}

@;{Can we reduce the terms used? Using "terms", "concepts", "features" for
   essentially the same meaning may be confusing.}

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

@section{Entries}

@subsection{Assignment}

@level-basic


@subsection{Binding}

@subsection{Boolean}

@subsection{Box}

@subsection{Call → Procedure application}

@subsection{Cell}

@subsection{Channel}

@subsection{Chaperone}

@subsection{Class}

@subsection{Closure}

@subsection{Collection}

@subsection{Combinator}

@subsection{Comprehension}

@subsection{Cons cell → Pair}

@subsection{Continuation}

@subsection{Contract}

@subsection{Core form}

@subsection{Currying}

@subsection{Custodian}

@subsection{Debugging}

@subsection{Definition}

@subsection{Display}

@subsection{DrRacket}

@subsection{DSL}

@subsection{Environment}

@subsection{Equality}

@subsection{Exact number}

@subsection{Executor}

@subsection{Exception}

@subsection{Expression (always lvalue? may result in one or more values)}

@subsection{Field}

@subsection{Fixnum}

@subsection{Flat contract}

@subsection{Flonum}

@subsection{Form}

@subsection{Formatting (`format`, `~a` etc.)}

@subsection{Function → Procedure}

@subsection{Functional programming (FP)}

@subsection{Functional update}

@subsection{Future}

@subsection{Generator}

@subsection{Generic API}

@subsection{GUI programming}

@subsection{Hash}

@subsection{Hygiene}

@subsection{Identifier (differences to identifiers in other languages)}

@subsection{Identity (also refer to `eq?`)}

@subsection{Impersonator}

@subsection{Inexact number → Exact number}

@subsection{Inspector}

@subsection{Interface (API)}

@subsection{Interface (OOP)}

@subsection{Keyword arguments (positional and keyword args are separate)}

@subsection{Lang (as in `#lang`)}

@subsection{Language-oriented programming}

@subsection{Let over lambda}

@subsection{List (linked list, explain differences to arrays in other languages)}

@subsection{Macro}

@subsection{Match}

@subsection{Match transformer}

@subsection{Method}

@subsection{Module}

@subsection{Named let}

@subsection{Namespace}

@subsection{Naming conventions}

@subsection{Number}

@subsection{Numeric tower}

@subsection{Opaque}

@subsection{Package}

@subsection{Pair}

@subsection{Parameter}

@subsection{Pattern (in regular expressions)}

@subsection{Pattern (in macro definitions)}

@subsection{Phase}

@subsection{Place}

@subsection{Polymorphism (rarely used, compare with other languages; see also generic code)}

@subsection{Port}

@subsection{Predicate}

@subsection{Print → Display}

@subsection{Procedure}

@subsection{Procedure application}

@subsection{Profiling}

@subsection{Prompt}

@subsection{Provide}

@subsection{Quasiquote}

@subsection{Quote}

@subsection{RnRS (as in R5RS, R6RS etc.)}

@subsection{Raco}

@subsection{Reader (for parsing code)}

@subsection{Record → Struct}

@subsection{Require}

@subsection{Rule (in macros; probably other uses, which ones?)}

@subsection{Safe operation → unsafe operation}

@subsection{Scheme}

@subsection{Scribble}

@subsection{Sequence}

@subsection{Set}

@subsection{Shadowing}

@subsection{Splicing}

@subsection{SRFI}

@subsection{Standard library}

@subsection{Stream}

@subsection{String (strings vs. byte strings; handling encoding)}

@subsection{Struct}

@subsection{Symbol}

@subsection{Syntactic form → Form}

@subsection{Syntax (different meanings)}

@subsection{Syntax transformer}

@subsection{Tail call}

@subsection{Thread}

@subsection{Thunk}

@subsection{Transparent → Opaque}

@subsection{Trust level}

@subsection{Trusted code}

@subsection{Typed Racket}

@subsection{Undefined (why do we need this if we have `void`?)}

@subsection{Unit}

@subsection{Unsafe operation}

@subsection{Untrusted code → trusted code}

@subsection{Value (sometimes "object", but may be confused with OOP concept)}

@subsection{Values (multiple values, as in `define-values` etc.)}

@subsection{Vector (mention growable vectors)}

@subsection{Void}

@subsection{Will}

@subsection{Write → display}

@subsection{Writer}
