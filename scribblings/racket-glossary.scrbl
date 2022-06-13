#lang scribble/manual

@(require
  racket/function
  racket/list
  racket/match
  scribble/example
  (for-label
    racket/base
    racket/function))

@(define helper-eval (make-base-eval))
@examples[
  #:eval helper-eval
  #:hidden
  (require
    racket/function
    racket/pretty
    racket/string)]

@(define level-basic        @elem{@bold{Level:} basic})
@(define level-intermediate @elem{@bold{Level:} intermediate})
@(define level-advanced     @elem{@bold{Level:} advanced})
@(define in-g "in this glossary")
@(define in-rg "in the Racket Guide")
@(define in-rr "in the Racket Reference")

@(define glossary-entry (curry subsection #:style 'unnumbered))

@(define (secref* term-or-terms document)
  (define terms
    (if (list? term-or-terms)
        term-or-terms
        (list term-or-terms)))
  (define url
    (match document
      ['glossary  "racket-glossary/scribblings/racket-glossary.scrbl"]
      ['guide     "scribblings/guide/guide.scrbl"]
      ['reference "scribblings/reference/reference.scrbl"]
      [_          (raise-user-error (format "invalid document type ~v" document))]))
  (add-between
    (for/list ([term terms])
      (secref term #:doc (list 'lib url)))
    ", "))

@; ----------------------------------------------------------------------

@title{Glossary of Racket concepts}
@author{Stefan Schwarzer}

@section{Introduction}

The Racket documentation describes a lot, often very abstract concepts. For someone
starting with the language, it's often not clear which concepts are widely used
and which aren't. It's quite easy to lose one's way by getting distracted by
relatively obscure concepts.

This led to a @(hyperlink
"https://racket.discourse.group/t/learning-racket-scheme-how-do-you-get-to-the-practicing-stage/901"
"discussion") on the Racket forum and during this discussion to the plan to
start this glossary. The intention is to list many concepts, even the obscure
ones, together with their importance, given by these levels:
@itemlist[
  @item{@bold{basic:} These are basic concepts you should know to write Racket
    libraries and programs. If you're starting to learn Racket, focus on these
    concepts.}
  @item{@bold{intermediate:} You can write most Racket software without these
    features, but you may need them depending on your problem. One example
    would be threads to execute different tasks concurrently.}
  @item{@bold{advanced:} Likely you won't need these features, but they may
    improve your software. Look into these if you're comfortable with the
    entries in the ``basic'' and ``intermediate'' categories.}]

@; TODO: Improve wording.
Not all Racket users will agree on this categorization and the assigned levels
for individual terms, but the categorization should give you a rough idea
which concepts are more foundational than others.

@section{Entries}

@glossary-entry{Assignment}

  @level-basic

@; Binding vs. location?

Assigning means the same as in most programming languages: changing the value
of a variable. To change the value of a variable, use @racket[set!]:
@examples[
  #:eval helper-eval
  (define my-variable 2)
  (displayln my-variable)
  (set! my-variable 5)
  (displayln my-variable)
]

However, in Racket and other functional languages, assignment is used much less
than in imperative languages. The ``normal'' approach in functional languages
is to transform immutable values to other immutable values.

To change a value via assignment, you need a name (binding) and a storage
location for it. Usually, the binding and location are created with
@racket[define], but they can also be created by one of the @racket[let] forms.

See also:
@itemlist[
  @item{@secref*['("Binding" "Let" "Location") 'glossary] @in-g}
  @item{@secref*["set!" 'guide] @in-rg}
  @item{@secref*["set!" 'reference] @in-rr}]

@glossary-entry{Binding}

  @level-basic

A binding makes a value accessible via a name. Typically, bindings are created
with the @racket[define] form:
@examples[
  #:eval helper-eval
  (define x (+ 2 3))]
binds the name @racket[x] to the value @racket[5].

Note that the bound value is the @italic{result} of the expression, not the
expression itself.

See also:
@itemlist[
  @item{@secref*["Binding" 'glossary] @in-rg}
  @item{@secref*["id-model" 'reference] @in-rr}]

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
  (for ([value '(#t 1 0 "false" '() map (void) #f)])
    (displayln (if value "true" "false")))]

See also: @secref*["booleans" 'reference] @in-rr

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
reference in other languages. However, in practice this isn't a problem since
it's unidiomatic in Racket to use mutable values. Instead you usually transform
immutable values to other immutable values.

See also: @secref*["boxes" 'reference] @in-rr

@glossary-entry{Call}

  @level-basic

See @secref*["Procedure" 'glossary]

@glossary-entry{Channel}

  @level-intermediate

@glossary-entry{Chaperone}

  @level-intermediate

@glossary-entry{Class}

  @level-intermediate

@glossary-entry{Closure}

  @level-basic

@glossary-entry{Collection}

  @level-basic

@glossary-entry{Combinator}

  @level-intermediate

@glossary-entry{Comprehension}

  @level-basic

@glossary-entry{Cons cell}

  @level-basic

See @secref*["Pair" 'glossary]

@glossary-entry{Continuation}

  @level-advanced

@glossary-entry{Contract}

  @level-intermediate

@glossary-entry{Core form}

  @level-advanced

@glossary-entry{Currying}

  @level-basic

Currying takes a function with some number of arguments and creates a
new function that calls the original function while hard-coding some
of the arguments.

The following example defines a function @racket[draw-line] and a curried
version @racket[draw-line-from-origin], which hard-codes the @racket[from-x] and
@racket[from-y] arguments:

@examples[
  #:eval helper-eval
  #:label #f
  (define (draw-line from-x from-y to-x to-y)
    (code:comment "Keep it simple; just print a string instead of drawing a line.")
    (displayln (format "Drawing a line from (~a, ~a) to (~a, ~a)"
                       from-x from-y to-x to-y)))
  (draw-line 1 2 3 4)
  (code:comment "Hard-code the first two arguments of `draw-line`.")
  (define (draw-line-from-origin to-x to-y)
    (draw-line 0 0 to-x to-y))
  (draw-line-from-origin 2 3)]

If the arguments to hard-code are all at the start of the function arguments,
you can use the @racket[curry] function:

@examples[
  #:eval helper-eval
  #:label #f
  (require racket/function)
  (code:comment "Hard-code the first two arguments of `draw-line`.")
  (define draw-line-from-origin (curry draw-line 0 0))
  (draw-line-from-origin 2 3)]

The result of @racket[curry] already is the curried function. To hard-code
arguments all on the right of an argument list, there's @racket[curryr].

Unlike Haskell, Scheme/Racket doesn't have implicit currying, so the following
code raises an exception:
@examples[
  #:eval helper-eval
  #:label #f
  (eval:error
    (define draw-line-from-origin (draw-line 0 0)))]

See also:
@itemlist[
  @item{@secref*["Procedure" 'glossary] @in-g}
  @item{@racket[curry] and @racket[curryr] @in-rr}]

@glossary-entry{Custodian}

  @level-advanced

@glossary-entry{Debugging}

  @level-basic

@glossary-entry{Definition}

  @level-basic

@glossary-entry{Display}

  @level-basic

@glossary-entry{DrRacket}

  @level-basic

@glossary-entry{DSL (domain-specific language)}

  @level-advanced

@glossary-entry{Environment}

  @level-intermediate

@glossary-entry{Equality}

  @level-basic

@glossary-entry{Exact number}

  @level-basic

@glossary-entry{Executor}

  @level-advanced

@glossary-entry{Exception}

@; Or basic?
  @level-intermediate

@glossary-entry{Expression (always lvalue? may result in one or more values)}

  @level-basic

@glossary-entry{Field}

  @level-basic

@glossary-entry{Fixnum}

  @level-basic

@glossary-entry{Flat contract}

  @level-advanced

@glossary-entry{Flonum}

  @level-basic

@glossary-entry{Form}

  @level-basic

@glossary-entry{Formatting (`format`, `~a` etc.)}

  @level-basic

  @level-intermediate

@glossary-entry{Function}

  @level-basic

See @secref*["Procedure" 'glossary]

@glossary-entry{Functional programming (FP)}

  @level-basic

@glossary-entry{Functional update}

  @level-basic

@glossary-entry{Future}

  @level-advanced

@glossary-entry{Generator}

  @level-advanced

@glossary-entry{Generic API}

  @level-advanced

@glossary-entry{GUI programming}

  @level-intermediate

@glossary-entry{Hash}

  @level-basic

@glossary-entry{Higher-order function}

  @level-basic

@glossary-entry{Hygiene}

  @level-intermediate

@glossary-entry{Identifier (differences to identifiers in other languages)}

  @level-basic

@glossary-entry{Identity (also refer to `eq?`)}

  @level-basic

@glossary-entry{Impersonator}

@; May be important though. Maybe better "intermediate"?
  @level-advanced

@glossary-entry{Inexact number → Exact number}

  @level-basic

@glossary-entry{Inspector}

  @level-advanced

@glossary-entry{Interface (API)}

  @level-basic

@glossary-entry{Interface (OOP)}

@; Or "advanced"?
  @level-intermediate

@glossary-entry{Keyword arguments (positional and keyword args are separate)}

  @level-basic

@glossary-entry{Lambda}

  @level-basic

As shown in the @secref*["Procedure" 'glossary] entry, a procedure can be
defined with @racket[define]. However, you can also define functions directly
as values without giving them a name. This is the same function as in the
@secref*["Procedure" 'glossary] glossary entry:

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
@secref*["Higher-order_function" 'glossary] or in a @secref*["Let" 'glossary]
expression.

See also:
@itemlist[
  @item{@secref*['("Definition" "Higher-order_function" "Let") 'glossary] @in-g}
  @item{@secref*["lambda" 'guide] @in-rg}
  @item{@secref*["lambda" 'reference] @in-rr}]

@glossary-entry{Lang (as in `#lang`)}

  @level-advanced

@glossary-entry{Language-oriented programming}

  @level-advanced

@glossary-entry{Let}

  @level-basic

@glossary-entry{Let over lambda}

  @level-intermediate

@glossary-entry{List}

(linked list, explain differences to arrays in other languages)

  @level-basic

@glossary-entry{Location}

  @level-basic

@glossary-entry{Macro}

  @level-intermediate

  @level-advanced

@glossary-entry{Match}

  @level-intermediate

@glossary-entry{Match transformer}

  @level-advanced

@glossary-entry{Method}

  @level-intermediate

@glossary-entry{Module}

  @level-basic

@glossary-entry{Named let}

  @level-intermediate

@glossary-entry{Namespace}

  @; Relationship to "environment"? How much has a "normal" user to know about
  @; this outside of `eval`?
  @level-intermediate

@glossary-entry{Naming conventions}

  @level-basic

@glossary-entry{Number}

  @level-basic

@glossary-entry{Numeric tower}

  @level-basic

@glossary-entry{Opaque}

  @level-intermediate

See @secref*["Struct" 'glossary] @in-g

@glossary-entry{Package}

  @level-intermediate

@glossary-entry{Pair}

  @level-basic

Pairs are the building blocks of Scheme/Racket lists, but are also often used
for combining any two values.

Usually a pair is created with @racket[cons]:
@examples[
  #:eval helper-eval
  (cons 1 "one")]

Once a pair is created, you can access the first and second value of the pair with
@racket[car] and @racket[cdr]:
@examples[
  #:eval helper-eval
  (define a-pair (cons 1 "one"))
  (car a-pair)
  (cdr a-pair)]

See also:
@itemlist[
  @item{@secref*["List" 'glossary] @in-g}
  @item{@secref*["pairs" 'guide] @in-rg}
  @item{@secref*["pairs" 'reference] @in-rr}]

@glossary-entry{Parameter}

  @level-basic

@glossary-entry{Pattern (in regular expressions)}

  @level-basic

@glossary-entry{Pattern (in macro definitions)}

  @level-intermediate

@glossary-entry{Phase}

  @level-advanced

@glossary-entry{Place}

  @level-advanced

@glossary-entry{Polymorphism (rarely used, compare with other languages; see also generic code)}

  @level-intermediate

@glossary-entry{Port}

  @level-basic

@glossary-entry{Predicate}

  @level-basic

@glossary-entry{Print}

  @level-basic

See @secref*["Display" 'glossary]

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
``passive'' value:

@examples[
  #:eval helper-eval
  add1
  (procedure? add1)
  (list add1 add1)]

As using too many brackets, using too few can lead to problems, although they
tend to be less obvious:

@examples[
  #:eval helper-eval
  (define (foo)
    add1 2)
  (foo)]

You might have expected @racket[3] as the result of calling @racket[foo].
However, since the parentheses around @code{add1 2} were missing and the result
of a function is the value of the last expression, the function returned
@racket[2].

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
  @item{@secref*["Lambda" 'glossary] @in-g}
  @item{@secref*["syntax-overview" 'guide] @in-rg}
  @item{@secref*["define" 'reference] @in-rr}]

@glossary-entry{Profiling}

  @level-intermediate

@glossary-entry{Prompt}

  @level-advanced

@glossary-entry{Provide}

  @level-intermediate

@glossary-entry{Quasiquote}

  @level-intermediate

@glossary-entry{Quote}

  @level-basic

@glossary-entry{RnRS (as in R5RS, R6RS etc.)}

  @level-intermediate

@glossary-entry{Raco}

  @level-basic

@glossary-entry{Reader (for parsing code)}

  @level-advanced

@glossary-entry{Record}

  @level-basic

See @secref*["Struct" 'glossary]

@glossary-entry{Require}

  @level-basic

@glossary-entry{Rule (in macros; probably other uses, which ones?)}

  @level-intermediate

@glossary-entry{Safe operation}

  @level-intermediate

See @secref*["Unsafe_operation" 'glossary]

@glossary-entry{Scheme}

  @level-basic

@glossary-entry{Scribble}

  @level-intermediate

@glossary-entry{Sequence}

  @level-intermediate

@glossary-entry{Set}

  @level-basic

@glossary-entry{Shadowing}

  @level-basic

@glossary-entry{Splicing}

  @level-basic

@glossary-entry{SRFI}

  @level-intermediate

@glossary-entry{Standard library}

  @level-basic

@glossary-entry{Stream}

  @level-basic

@glossary-entry{String (strings vs. byte strings; handling encoding)}

  @level-basic

@glossary-entry{Struct}

  @level-basic

Although Racket has an OOP system, the primary way to group information for a
type is using a @racket[struct] and functions related to it.

@examples[
  #:eval helper-eval
  (struct person (name age))]

Here, @racket[person] is the name of the struct and @racket[name] and
@racket[age] are the @deftech{fields} of the struct.

Creating a struct like above creates several bindings. One is for the
name of the struct, which can be used to create instances of the
struct:

@examples[
  #:eval helper-eval
  #:label #f
  (define bilbo (person "Bilbo Baggins" 111))
  bilbo]

Moreover, each field results in a binding named
@italic{@racketidfont{struct-name-field-name}} to access the value of
each field in a given struct instance:

@examples[
  #:eval helper-eval
  #:label #f
  (person-name bilbo)
  (person-age bilbo)]

It's also possible to declare a struct as @deftech{mutable} by adding
a @racketkeywordfont{#:mutable} keyword. This creates additional accessor
functions to set values in a struct instance. However, you usually should
avoid mutation in Racket. Instead, use @racket[struct-copy] to create
a new struct instance based on another instance:

@examples[
  #:eval helper-eval
  #:label #f
  (define younger-bilbo (struct-copy person bilbo [age 100]))
  (person-name younger-bilbo)
  (person-age younger-bilbo)]

See also @secref*["Functional_update" 'glossary]. You can use more
than one field name/value pair.

By default, structs are created as @deftech{opaque}. This means that
printing a struct instance doesn't show the values. More important is
the gotcha that comparing opaque struct instances with @racket[equal?]
compares by @italic{identity} (like @racket[eq?]), @italic{not} by
@italic{field values}!

@examples[
  #:eval helper-eval
  #:label "Example:"
  (define bilbo2 (person "Bilbo Baggins" 111))
  (equal? (person-name bilbo) (person-name bilbo2))
  (equal? (person-age bilbo) (person-age bilbo2))
  (equal? bilbo bilbo2)]

Adding the @racketkeywordfont{#:transparent} keyword to the struct
definition avoids this problem:

@examples[
  #:eval helper-eval
  #:label #f
  (struct person (name age)
    #:transparent)
  (define frodo (person "Frodo Baggins" 33))
  frodo
  (define frodo2 (person "Frodo Baggins" 33))
  (equal? (person-name frodo) (person-name frodo2))
  (equal? (person-age frodo) (person-age frodo2))
  (equal? frodo frodo2)]

Note two things:
@itemlist[
  @item{Printing @racket[frodo] shows the struct values, not just
    @tt{#<person>}.}
  @item{Comparing two struct instances of the same
    @italic{transparent} struct type with the same values with
    @racket[equal?] gives @racket[#t].}]

The latter is not only more intuitive, but it's also very useful when
comparing calculated and expected struct instances in automated tests.

That said, values of @italic{different} struct types compare as
@racket[#f], even if the field names are the same.

Although Racket uses opaque structs for stronger encapsulation and
backward-compatibility, many Racket users nowadays think that defining
structs as transparent usually gives the better tradeoff.

Note that field names are only known at compile time, not at
runtime. This means that a function like Python's
@hyperlink["https://docs.python.org/3/library/functions.html#getattr"]{@tt{getattr}}
doesn't exist in Racket.

See also:
@itemlist[
  @item{@secref*['("Binding" "Functional_update") 'glossary] @in-g}
  @item{@secref*['("define-struct" "classes") 'guide] @in-rg}
  @item{@secref*['("define-struct" "mzlib:class") 'reference] @in-rr}]

@glossary-entry{Symbol}

  @level-basic

@glossary-entry{Syntactic form}

  @level-basic

See @secref*["Form" 'glossary]

@glossary-entry{Syntax (different meanings)}

  @level-intermediate

@glossary-entry{Syntax transformer}

  @level-intermediate

See also: @secref*["Macro" 'glossary] @in-g

@glossary-entry{Tail call}

  @level-basic

@glossary-entry{Thread}

  @level-intermediate

@glossary-entry{Thunk}

  @level-basic

@glossary-entry{Transparent}

  @level-basic

See @secref*["Struct" 'glossary]

@glossary-entry{Trust level}

  @level-advanced

@glossary-entry{Trusted code}

  @level-advanced

See @secref*["Untrusted_code" 'glossary]

@glossary-entry{Typed Racket}

  @level-advanced

@glossary-entry{Undefined (why do we need this if we have `void`?)}

  @level-advanced

@glossary-entry{Unit}

  @level-advanced

@glossary-entry{Unsafe operation}

  @level-intermediate

@glossary-entry{Untrusted code}

  @level-advanced

@glossary-entry{Value (sometimes "object", but may be confused with OOP concept)}

  @level-basic

@glossary-entry{Values (multiple values, as in `define-values` etc.)}

  @level-basic

@glossary-entry{Vector (mention growable vectors)}

  @level-basic

@glossary-entry{Void}

  @level-basic

@glossary-entry{Will}

  @level-advanced

@glossary-entry{Write}

  @level-basic

See @secref*["Display" 'glossary]

@glossary-entry{Writer}

  @level-advanced
