#lang scribble/manual

@(require
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

@subsection{Box}

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

@subsection{Call}

@level-basic

See @secref["Procedure"
            #:doc '(lib "racket-glossary/scribblings/glossary.scrbl")]

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

@subsection{Higher-order function}

@subsection{Hygiene}

@subsection{Identifier (differences to identifiers in other languages)}

@subsection{Identity (also refer to `eq?`)}

@subsection{Impersonator}

@subsection{Inexact number → Exact number}

@subsection{Inspector}

@subsection{Interface (API)}

@subsection{Interface (OOP)}

@subsection{Keyword arguments (positional and keyword args are separate)}

@subsection{Lambda}

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

@subsection{Lang (as in `#lang`)}

@subsection{Language-oriented programming}

@subsection{Let}

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
