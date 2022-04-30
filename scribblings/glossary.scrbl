#lang scribble/manual

@(require
  racket/function
  scribble/example
  (for-label racket/base))

@(define helper-eval (make-base-eval))
@examples[
  #:eval helper-eval
  #:hidden
  (require racket/pretty
           racket/string)]

@(define level-basic        @elem{@bold{Level:} basic})
@(define level-intermediate @elem{@bold{Level:} intermediate})
@(define level-advanced     @elem{@bold{Level:} advanced})
@(define in-g "in this glossary")
@(define in-rg "in the Racket Guide")
@(define in-rr "in the Racket Reference")

@(define glossary-entry (curry subsection #:style 'unnumbered))


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
  @item{@bold{advanced:} Likely you won't need these features, but they may
    improve your software. Look into these if you're comfortable with the
    entries in the "basic" and "intermediate" categories.}]

@section{Entries}

@glossary-entry{Assignment}

@level-basic


@glossary-entry{Binding}

@glossary-entry{Boolean}

@level-basic

Booleans represent truth values. In some other languages this type is called
@code{bool} or @code{boolean}. Racket has two boolean literals:
@itemlist[
  @item{@racket[#f] false}
  @item{@racket[#t] true}]

If a value is interpreted as a condition (as in @racket[if] or @racket[cond] forms),
only the constant @racket[#f] is interpreted as false, all other values are
interpreted as true.

@examples[
  #:eval helper-eval
  (for ([value '(#t 1 "false" map (void) #f)])
    (displayln (if value "true" "false")))]

See also: @secref["booleans" #:doc '(lib
"scribblings/reference/reference.scrbl")] @in-rr

@glossary-entry{Box}

@level-intermediate

A box is a container to essentially turn an immutable value into a mutable
value. Passing a box as a function argument is similar to passing a value by
reference in some other languages.

@examples[
  #:eval helper-eval
  (define (func value-box)
    (define old-value (unbox value-box))
    (set-box! value-box (add1 old-value)))

  (define a-box (box 7))
  (func a-box)
  (displayln (unbox a-box))]

As you can see, using boxes is kind of awkward compared to passing arguments by
reference in other values. However, in practice this isn't a problem since it's
unidiomatic in Racket to use mutable values. Instead you usually transform
immutable values to other immutable values.

See also: @secref["boxes" #:doc '(lib "scribblings/reference/reference.scrbl")] @in-rr

@glossary-entry{Call}

@level-basic

See @secref["Procedure"
            #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")]

@glossary-entry{Cell}

@glossary-entry{Channel}

@glossary-entry{Chaperone}

@glossary-entry{Class}

@glossary-entry{Closure}

@glossary-entry{Collection}

@glossary-entry{Combinator}

@glossary-entry{Comprehension}

@glossary-entry{Cons cell → Pair}

@glossary-entry{Continuation}

@glossary-entry{Contract}

@glossary-entry{Core form}

@glossary-entry{Currying}

@glossary-entry{Custodian}

@glossary-entry{Debugging}

@glossary-entry{Definition}

@glossary-entry{Display}

@glossary-entry{DrRacket}

@glossary-entry{DSL}

@glossary-entry{Environment}

@glossary-entry{Equality}

@glossary-entry{Exact number}

@glossary-entry{Executor}

@glossary-entry{Exception}

@glossary-entry{Expression (always lvalue? may result in one or more values)}

@glossary-entry{Field}

@glossary-entry{Fixnum}

@glossary-entry{Flat contract}

@glossary-entry{Flonum}

@glossary-entry{Form}

@glossary-entry{Formatting (`format`, `~a` etc.)}

@glossary-entry{Function → Procedure}

@glossary-entry{Functional programming (FP)}

@glossary-entry{Functional update}

@glossary-entry{Future}

@glossary-entry{Generator}

@glossary-entry{Generic API}

@glossary-entry{GUI programming}

@glossary-entry{Hash}

@glossary-entry{Higher-order function}

@glossary-entry{Hygiene}

@glossary-entry{Identifier (differences to identifiers in other languages)}

@glossary-entry{Identity (also refer to `eq?`)}

@glossary-entry{Impersonator}

@glossary-entry{Inexact number → Exact number}

@glossary-entry{Inspector}

@glossary-entry{Interface (API)}

@glossary-entry{Interface (OOP)}

@glossary-entry{Keyword arguments (positional and keyword args are separate)}

@glossary-entry{Lambda}

@level-basic

As shown in
@secref["Procedure" #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")],
a procedure can be defined with @racket[define]. However, you can also define
functions directly as values without giving them a name. This is the same function
as in the 
@secref["Procedure" #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")]
glossary entry:

@examples[
  #:eval helper-eval
  (lambda ([name "world"])
    (string-append "Hello " name "!"))
  ((lambda ([name "world"])
     (string-append "Hello " name "!"))
   "Alice")]

The second example above defines and directly calls the function.

The above examples are a bit artifical. Normally, you use a function defined
with @racket[lambda] as a function argument for a 
@secref["Higher-order_function" #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")]
or in a @secref["Let" #:doc '(lib
"racket-glossary/scribblings/glossary.scrbl")] expression.

See also:
@itemlist[
  @item{@secref["Definition" #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")]
    @in-g}
  @item{@secref["Higher-order_function"
                #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")] @in-g}
  @item{@secref["Let" #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")] @in-g}
  @item{@secref["lambda" #:doc '(lib "scribblings/guide/guide.scrbl")] @in-rg}
  @item{@secref["lambda" #:doc '(lib "scribblings/reference/reference.scrbl")] @in-rr}]

@glossary-entry{Lang (as in `#lang`)}

@glossary-entry{Language-oriented programming}

@glossary-entry{Let}

@glossary-entry{Let over lambda}

@glossary-entry{List (linked list, explain differences to arrays in other languages)}

@glossary-entry{Macro}

@glossary-entry{Match}

@glossary-entry{Match transformer}

@glossary-entry{Method}

@glossary-entry{Module}

@glossary-entry{Named let}

@glossary-entry{Namespace}

@glossary-entry{Naming conventions}

@glossary-entry{Number}

@glossary-entry{Numeric tower}

@glossary-entry{Opaque}

@glossary-entry{Package}

@glossary-entry{Pair}

@glossary-entry{Parameter}

@glossary-entry{Pattern (in regular expressions)}

@glossary-entry{Pattern (in macro definitions)}

@glossary-entry{Phase}

@glossary-entry{Place}

@glossary-entry{Polymorphism (rarely used, compare with other languages; see also generic code)}

@glossary-entry{Port}

@glossary-entry{Predicate}

@glossary-entry{Print → Display}

@glossary-entry{Procedure}

@level-basic

A procedure, also called a function, is a value that can be called at program
runtime. If a procedure is used after an opening parenthesis, it introduces a
function call. For example, @racket[add1] is a simple function that adds 1 to
its argument:

@examples[
  #:eval helper-eval
  (add1 2)]

If a function should be called without arguments, it's written @racket[(func)].
Since the parentheses cause the function call, you can't just add brackets around
expressions. For example,

@examples[
  #:eval helper-eval
  (eval:error ((add1 2)))]

calculates @racket[3] through the function call @racket[(add1 2)] and tries to
call the result @racket[3] as a function, @racket[(3)], which gives an error
saying that @racket[3] isn't callable.

On the other hand, when using a function in another position, it's just a
"passive" value:

@examples[
  #:eval helper-eval
  add1
  (procedure? add1)
  (list add1 add1)]

Depending on how a function is defined, it can take zero arguments to an almost
unlimited number of arguments (usually done with a special syntax in the
function definition).

The following function takes an optional argument and returns a string to
greet someone:

@examples[
  #:eval helper-eval
  (define (greeting [name "world"])
    (string-append "Hello " name "!"))
  (greeting)
  (greeting "Bob")]

See also:
@itemlist[
  @item{@secref["Lambda" #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")] @in-g}
  @item{@secref["syntax-overview" #:doc '(lib "scribblings/guide/guide.scrbl")] @in-rg}
  @item{@secref["define" #:doc '(lib "scribblings/reference/reference.scrbl")] @in-rr}]

@glossary-entry{Profiling}

@glossary-entry{Prompt}

@glossary-entry{Provide}

@glossary-entry{Quasiquote}

@glossary-entry{Quote}

@glossary-entry{RnRS (as in R5RS, R6RS etc.)}

@glossary-entry{Raco}

@glossary-entry{Reader (for parsing code)}

@glossary-entry{Record → Struct}

@glossary-entry{Require}

@glossary-entry{Rule (in macros; probably other uses, which ones?)}

@glossary-entry{Safe operation → unsafe operation}

@glossary-entry{Scheme}

@glossary-entry{Scribble}

@glossary-entry{Sequence}

@glossary-entry{Set}

@glossary-entry{Shadowing}

@glossary-entry{Splicing}

@glossary-entry{SRFI}

@glossary-entry{Standard library}

@glossary-entry{Stream}

@glossary-entry{String (strings vs. byte strings; handling encoding)}

@glossary-entry{Struct}

@glossary-entry{Symbol}

@glossary-entry{Syntactic form → Form}

@glossary-entry{Syntax (different meanings)}

@glossary-entry{Syntax transformer}

@glossary-entry{Tail call}

@glossary-entry{Thread}

@glossary-entry{Thunk}

@glossary-entry{Transparent → Opaque}

@glossary-entry{Trust level}

@glossary-entry{Trusted code}

@glossary-entry{Typed Racket}

@glossary-entry{Undefined (why do we need this if we have `void`?)}

@glossary-entry{Unit}

@glossary-entry{Unsafe operation}

@glossary-entry{Untrusted code → trusted code}

@glossary-entry{Value (sometimes "object", but may be confused with OOP concept)}

@glossary-entry{Values (multiple values, as in `define-values` etc.)}

@glossary-entry{Vector (mention growable vectors)}

@glossary-entry{Void}

@glossary-entry{Will}

@glossary-entry{Write → display}

@glossary-entry{Writer}
