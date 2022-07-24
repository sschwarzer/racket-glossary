#lang scribble/manual

@(require
  racket/format
  racket/function
  racket/list
  racket/match
  racket/runtime-path
  scribble/example
  "my-pict.rkt"
  (for-label
    racket/base
    racket/file
    racket/function
    racket/gui
    racket/list
    racket/string
    racket/vector
    data/gvector))

@(define helper-eval (make-base-eval))
@examples[
  #:eval helper-eval
  #:hidden
  (require
    racket/function
    racket/list
    racket/pretty
    racket/string)]

@(define level-basic        @elem{@bold{Level:} basic})
@(define level-intermediate @elem{@bold{Level:} intermediate})
@(define level-advanced     @elem{@bold{Level:} advanced})
@(define in-g "in this glossary")
@(define in-rg "in the Racket Guide")
@(define in-rr "in the Racket Reference")

@(define glossary-entry (curry subsection #:style 'unnumbered))

@; For whatever reason, `italic` deactivates an outer `tt`, so wrap the
@; argument in another `tt`.
@(define (ti value)
   (italic (tt value)))

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

@(define (other-languages . content)
   @nested[#:style 'inset]{@bold{Other languages} @linebreak[] @content})

@(define-runtime-path scribblings-directory ".")

@(define (png-image path)
   (image
     ; Since `image` uses paths relative to the current directory, this code
     ; only works if the document build is started from the root of the Git
     ; repository.
     (~a (build-path scribblings-directory path) ".png")
     ; Scale the image so that text in the image is about the same size as
     ; the regular document text. For this to work, make sure the text size
     ; is the same for all exported images.
     #:scale 0.85))

@; ----------------------------------------------------------------------

@title{Glossary of Racket concepts}
@author{Stefan Schwarzer}

This glossary is still very much work in progress. Many entries are missing.

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
    concepts.

    Note that ``basic'' here doesn't nessarily mean ``trivial.'' Don't be
    discouraged if you don't understand these glossary entries immediately.
    Experiment with the code examples or revisit the respective glossary entry
    later when you have more Racket experience.}
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

This glossary isn't a book for learning Racket, nor is it a reference. Some
information may be simplified, for example some special cases may not be
mentioned. If you want all the details, check out the
@hyperlink["https://docs.racket-lang.org/reference/"]{Racket Reference}.

@section{Entries}

@glossary-entry{Arity}

  @level-basic

The arity describes how many arguments a function can accept. Everything from
zero to infinitely many arguments is possible. Note that functions can have
optional arguments, so even for a specific function, the arity may not be a
single number.

Arity refers only to positional arguments, not keyword arguments.

See also:
@itemize[
  @item{@secref*["Procedure" 'glossary] @in-g}
  @item{@secref*["Keywords_and_Arity" 'reference] @in-rr}]

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

@glossary-entry{Byte string}

  @level-basic

See @secref*["String__character__byte_string" 'glossary]

@glossary-entry{Call}

  @level-basic

See @secref*["Procedure" 'glossary]

@glossary-entry{Channel}

  @level-intermediate

@glossary-entry{Chaperone}

  @level-intermediate

@glossary-entry{Character}

  @level-basic

See @secref*["String__character__byte_string" 'glossary]

@glossary-entry{Class}

  @level-intermediate

@glossary-entry{Closure}

  @level-basic

A closure combines a function with environment data from a scope outside the
function.

@examples[
  #:eval helper-eval
  #:label "Example:"
  (define (make-incrementer increment)
    (lambda (value)
      (+ value increment)))
  (define add3 (make-incrementer 3))
  (add3 5)]

The return value of @racket[make-incrementer] is the closure. The
@racket[lambda] expression doesn't define the increment; the value is taken
from the scope outside the lambda expression.

See also:
@itemize[
  @item{@secref*["Let_over_lambda" 'glossary] @in-g}
  @item{@hyperlink["https://en.wikipedia.org/wiki/Closure_(computer_programming)"]{Closure}
    Wikipedia entry}]

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

See @secref*["Partial_application_and_currying" 'glossary]

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

Scheme and Racket have three generic functions to determine if two values are
equal:
@itemize[
  @item{@racket[equal?] checks for value equality. Most of the time, this is the
    function you want. @racket[equal?] can also compare recursively, as long as
    the participating types support @racket[equal?] comparisons. Examples:
    @examples[
      #:eval helper-eval
      #:label #f
      (equal? (+ 2 3) 5)
      (equal? "foo" "foo")
      (equal? "foo" "fox")
      (equal? '(1 2 3) '(1 2 3))
      (equal? '(1 2 ("foo" 3)) '(1 2 ("foo" 3)))
      (equal? '(1 2 ("foo" 3)) '(1 2 ("bar" 3)))]}
  @item{@racket[eq?] checks object identity, i.e. @racket[eq?] only returns
    @racket[#t] if the two compared values are one and the same object. This is
    especically important for mutable objects. For immutable values object
    identity is less relevant. Examples:
    @examples[
      #:eval helper-eval
      #:label #f
      (code:comment "There's only one `#t` constant.")
      (eq? #t #t)
      (code:comment "Compare with the same list object.")
      (define a-list '(1 2))
      (eq? a-list a-list)
      (code:comment "Two different list objects")
      (eq? '(1 2) '(1 2))]}
  @item{@racket[eqv?] behaves mostly like @racket[eq?], with the exception of
    types that have a different implementation. This mainly applies to numbers,
    but then you probably want to use @racket[=] anyway.}]

Unless you need to distinguish between different number types, use @racket[=]
instead of the three functions described above.

The Racket standard library also has many functions of the form
@racketidfont{@italic{type}=?}, for example @racket[string=?]. Often these
functions are equivalent to @racket[equal?] for the same arguments. However,
using the @racketidfont{@italic{type}=?} functions has two advantages:
@itemize[
  @item{The name makes it clear what's compared, without looking at surrounding
    code.}
  @item{Functions of this form provided by Racket check that the arguments
    have the correct type, e.g. string for @racket[string=?].}]

There's no @tt{==} function in Racket, but you could define a function with
this name. (But probably you shouldn't.)

@other-languages{
The @racket[eq?] function behaves like the @tt{is} operator in Python.}

See also:
@itemize[
  @item{@secref*["Procedure" 'glossary] @in-g}
  @item{@secref*["Equality" 'reference] @in-rr}]

@glossary-entry{Exact number}

  @level-basic

@glossary-entry{Executor}

  @level-advanced

@glossary-entry{Exception}

  @; Or basic?
  @level-intermediate

@glossary-entry{Expression (always rvalue? may result in one or more values)}

  @level-basic

@glossary-entry{Field}

  @level-basic

See @secref*["Struct" 'glossary]

@glossary-entry{Fixnum}

  @level-basic

@glossary-entry{Flat contract}

  @level-advanced

@glossary-entry{Flonum}

  @level-basic

@glossary-entry{Fold}

  @level-basic

@glossary-entry{Form}

  @level-basic

@glossary-entry{Formatting}

  @level-basic

  @level-intermediate

(`format`, `~a` etc.

@glossary-entry{Function}

  @level-basic

See @secref*["Procedure" 'glossary]

@glossary-entry{Functional programming (FP)}

  @level-basic

@glossary-entry{Functional update}

  @level-basic

Compared to an ``imperative update,'' as used in many programming languages, a
``functional update'' doesn't modifiy a value in place, but instead returns a
modified copy.

Here's an example of an imperative update:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Create a hash table for imperative updates.")
  (define imperative-hash (make-hash '((1 . a) (2 . b))))
  imperative-hash
  (code:comment "Modify the hash by storing another pair in it.")
  (code:comment "The exclamation point at the end of `hash-set!` means")
  (code:comment "that the hash is modified in-place.")
  (hash-set! imperative-hash 3 'c)
  imperative-hash]
With an imperative update, every piece of code that has a binding to the hash
will see any changes to the hash. Depending on your design, this can be good or
bad. In any case you have to be careful that all locations where the hash is used
are prepared for a change ``under their feet.''

On the other hand, here's a corresponding functional update:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Create a hash table for functional updates.")
  (define functional-hash (make-immutable-hash '((1 . a) (2 . b))))
  functional-hash
  (code:comment "Return a modified copy of the hash.")
  (define new-hash (hash-set functional-hash 3 'c))
  (code:comment "The original hash is unchanged.")
  functional-hash
  (code:comment "The change is only visible in the new value.")
  new-hash
  (code:comment "Besides, immutable hashes don't allow imperative changes")
  (code:comment "(as you probably expected).")
  (eval:error (hash-set! functional-hash 4 'd))]
A functional update has the advantage that you can more easily control which
code ``sees'' which value.

The concept of functional updates doesn't only apply to hashes, but is very
common in Functional Programming in general.

See also:
@itemize[
  @item{@secref*['("Binding" "Functional_programming__FP_" "Hash" "Naming_conventions")
                 'glossary] @in-g}]

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

Hashes, also called hash tables, hash maps or dictionaries, map keys to values.
For example, the following hash table maps numbers to symbols:
@examples[
  #:eval helper-eval
  #:label #f
  (define my-hash
    (hash 1 'a
          2 'b
          3 'c))
  (code:comment "Look up the value for the key 2.")
  (hash-ref my-hash 2)]
Keys and values can be arbitrary values:
@examples[
  #:eval helper-eval
  #:label #f
  (define my-hash
    (hash #(1 2 3) '(a b c)
          '(1 2)   #t
          #f       map))
  (hash-ref my-hash #(1 2 3))
  (hash-ref my-hash '(1 2))
  (hash-ref my-hash #f)]
However, usually all keys are of the same type and all values are of the same
type.

The API for hashes in Racket is more complicated than for the other compound
data structures like lists and vectors. Hashes can differ in the following
criteria; all of the combinations are possible:
@itemize[
  @item{Comparison for keys: @racket[equal?], @racket[eq?], @racket[eqv?]}
  @item{Mutability: immutable, mutable@linebreak{}
    Mutability applies to the hash as a whole, not to the mutability of the
    keys or the values.}
  @item{Strength: strong, weak, ephemerons@linebreak{}
    This influences when hash entries can be garbage-collected.}]
These are 3×2×3 = 18 combinations, but in practice you can almost always get by
with this list of just four combinations:
@itemize[
  @item{Comparison for keys: @racket[equal?], @racket[eq?]}
  @item{Mutability: immutable, mutable}
  @item{Strength: strong}]

Here's an overview of the most important APIs for these four
equality/mutability combinations:
@tabular[#:sep @hspace[1]
         #:cell-properties '((baseline))
  (list
    (list @bold{Combination}
          @nonbreaking{@bold{Construction} @smaller{(1, 2)}}
          @nonbreaking{@bold{Set or update value} @smaller{(3)}}
          @bold{Get value})
    (list @elem{@racket[equal?]/immutable}
          @elem{@tt{(@racket[hash] @ti{key1 value1 key2 value2} ...)}
                @linebreak{}or@linebreak{}
                @tt{(@racket[make-immutable-hash] @ti{pair1 pair2} ...)}}
          @tt{(@racket[hash-set] @ti{hash key value})}
          @tt{(@racket[hash-ref] @ti{hash key})})
    (list @elem{@racket[eq?]/immutable}
          @elem{@tt{(@racket[hasheq] @ti{key1 value1 key2 value2} ...)}
                @linebreak{}or@linebreak{}
                @tt{(@racket[make-immutable-hasheq] @ti{pair1 pair2} ...)}}
          @tt{(@racket[hash-set] @ti{hash key value})}
          @tt{(@racket[hash-ref] @ti{hash key})})
    (list @elem{@racket[equal?]/mutable}
          @tt{(@racket[make-hash] @ti{pair1 pair2} ...)}
          @tt{(@racket[hash-set!] @ti{hash key value})}
          @tt{(@racket[hash-ref] @ti{hash key})})
    (list @elem{@racket[eq?]/mutable}
          @tt{(@racket[make-hasheq] @ti{pair1 pair2} ...)}
          @tt{(@racket[hash-set!] @ti{hash key value})}
          @tt{(@racket[hash-ref] @ti{hash key})}))]

@smaller{(1)} You can create empty hashes by calling the constructor without
arguments. For example, @racket[(hash)] creates an empty immutable hash with
@racket[equal?] key comparison.

@smaller{(2)} A @italic{pair} here is a regular Scheme/Racket pair, for example
@racket[(cons 1 'a)]. Pairs that contain only literals can also be written as
@racket['(1 . a)].

@smaller{(3)} Setting or updating a value in an immutable hash may sound
contradictory. The solution is that @racket[hash-set] causes a so-called
functional update. That is, it returns a new hash with the modification applied
and leaves the @ti{hash} @italic{argument} unchanged. This is the same
principle that @racket[cons] or @racket[struct-copy] use.

@bold{Warnings:}
@itemize[
  @item{If a hash entry has a mutable key (for example a vector) don't change
    the key in-place.}
  @item{Don't change a hash while iterating over it.}]

See also:
@itemize[
  @item{@secref*['("Collection" "Equality" "Functional_update" "List" "Pair"
                   "Struct" "Vector") 'glossary] @in-g}
  @item{@secref*["hash-tables" 'guide] @in-rg}
  @item{@secref*["hashtables" 'reference] @in-rr}]

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

``Let over lambda'' describes a common idiom to create a closure. The following
example is similar to the one in the @secref*["Closure" 'glossary] entry:
@examples[
  #:eval helper-eval
  #:label #f
  (define add3
    (let ([increment 3])
      (lambda (value)
        (+ value increment))))
  (add3 5)]

Here, @racket[let] creates the outer environent whereas @racket[lambda] defines
the function using that environment.

See also: @secref*['("Procedure" "Lambda" "Closure") 'glossary] @in-g

@glossary-entry{List}

  @level-basic

Lists are the most widely used data structure in many functional programming
languages, including Scheme and Racket.

Scheme and Racket lists are implemented as singly-linked lists (with the
exception of the empty list, which is an atomic value). Singly-linked lists
consist of pairs where the first value of a pair is a list item and the second
value of the pair points to the next pair. The end of the list is denoted by an
empty list as the second value of the last pair.

For example, the list @racket['(1 2 3 4)] can be drawn as

@png-image{list-1234}

This data structure looks much more complicated than an array, where items are
stored in adjacent memory locations. A singly-linked list also has the
disadvantage that accessing list items by index requires traversing the list
until the pair with the given index is found.

The reason why lists are still so widely used is that they make it easy to
prepend items without changing the lists other references ``see.''
For example, the code
@examples[
  #:eval helper-eval
  #:label #f
  (define list1 '(1 2 3))
  (define list2 (cons 'a list1))
  (define list3 (cons 'b (cdr list1)))]
creates the following data structures:

@png-image{list-3-lists}

or, in one picture,

@png-image{list-3-lists-combined}

So each of the lists looks as you would expect, but it's not necessary to make
any copies of the list data. Instead the lists share some data, without this
being visible to code that uses these lists. (An exception is if list items are
changeable values, e.g. vectors, and are actually changed in-place. In that
case, all lists that share this changed data ``see'' the change. But usually
you should avoid mutating data, partly for this reason.)

Changing lists with @racket[cons] maximizes the data that can be shared between
lists. The situation is different if you change data ``further down'' the list.
In this case, it may be necessary to copy a part of the list data.

@examples[
  #:eval helper-eval
  #:label "Example:"
  (define list1 '(1 2 3 4))
  (define list2 (remove 2 list1))]
creates the following structure:

@png-image{list-remove}

Note that structure sharing depends only on the used list algorithms (e.g. in
@racket[remove] above). There's no sophisticated algorithm that tries to
``de-duplicate'' common data. For example,
@examples[
  #:eval helper-eval
  #:label #f
  (define list1 '(1 2 3))
  (define list2 '(1 2 3))]
creates two separate list data structures.

@other-languages{
Note that Scheme/Racket lists are different from ``lists'' in many other
programming languages. Typically those lists store data in adjacent memory
locations and have a fast append operation. Racket lists, on the other hand,
are singly-linked lists and have a fast @italic{prepend} operation
(@racket[cons]), but @italic{appending} items is rather slow because it has to
iterate through the whole list and make a copy. The closest equivalent in
Racket to the above-mentioned lists in some languages are called growable
vectors (see @racket[gvector]). However, Racket lists are the idiomatic
approach for most list processing, so use them if you can.}

See also:
@itemize[
  @item{@secref*['("Collection" "Functional_update" "Pair") 'glossary] @in-g}
  @item{@secref*["pairs" 'guide] @in-rg}
  @item{@secref*["pairs" 'reference] @in-rr}]

@glossary-entry{Location}

  @level-basic

A location is an implicitly created memory location. For example, this happens
in @racket[define] or @racket[let] forms. A consequence of creating a location
is that it can be modified with @racket[set!] or other mutating functions.

@examples[
  #:eval helper-eval
  (define (change-argument arg)
    (displayln arg)
    (set! arg 5)
    (displayln arg))
  (change-argument 3)

  (let ([v (vector 1 2 3)])
    (displayln v)
    (vector-set! v 2 5)
    (displayln v))]

However, usually you should avoid mutation in functional programming.

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

  @level-intermediate

@; Relationship to "environment"? How much has a "normal" user to know about
@; this outside of `eval`?

@glossary-entry{Naming conventions}

  @level-basic

As usual for programming languages, Racket code uses some conventions. As with
all conventions, there's no law enforcing them, but you should follow them if
you want your code style to look familiar to other Racket programmers. :-)

Parts of identifiers are separated by hypens (kebap case, e.g.
@racket[vector-length]). Snake case (@tt{vector_length}) or camel case
(@tt{vectorLength}) are @italic{not} used. Sometimes module-level constants are
in all uppercase, for example @racket[(define GRID-ROW-COUNT 10)]. Other names
are all lowercase.

Abbreviations are rare; almost everything is ``spelled out.'' This can result
in rather long names like @racket[make-input-port/read-to-peek] or
@racket[call-with-default-reading-parameterization]. Most names turn out
reasonably short, though.

If a name describes a type and an operation on it, the type usually goes first,
as in @racket[vector-ref] or @racket[string-copy]. The accessor functions
generated by @racket[struct] also follow this pattern.

Additionally, there are some widely-used naming patterns:
@tabular[#:sep @hspace[1]
  (list
    (list @bold{Pattern}
          @bold{Meaning}
          @bold{Examples})
    (list @tt{@italic{@tt{name}}?}
          @elem{Predicate @smaller{(1)}}
          @elem{@racket[string?], @racket[null?]})
    (list @tt{@italic{@tt{name}}=?}
          @elem{Comparison predicate @smaller{(1)}}
          @racket[string=?])
    (list @tt{@italic{@tt{name}}!}
          "Mutation"
          @elem{@racket[set!], @racket[vector-set!]})
    (list @tt{@ti{name}*}
          "Repetition"
          @elem{@racket[regexp-replace*] vs. @racket[regexp-replace]})
    (list @tt{@ti{name}*}
          "Nesting"
          @elem{@racket[for*] vs. @racket[for]})
    (list @tt{@italic{@tt{name}}*}
          "Other variant"
          @elem{@racket[vector*-length] vs. @racket[vector-length]})
    (list @tt{@italic{@tt{name}}%}
          "Class name"
          @racket[frame%])
    (list @tt{@italic{@tt{part}}/@italic{@tt{part}}}
          @elem{``for`` or ``with``}
          @elem{@racket[call/cc], @racket[define/match],@linebreak[]
                @racket[for/fold/derived]})
    (list @tt{@italic{@tt{type}}->@italic{@tt{other-type}}}
          "Conversion"
          @racket[vector->list])
    (list @tt{@tt{make}-@ti{type}}
          "Create new value of type"
          @elem{@racket[make-base-namespace], @racket[make-channel]}))]

@smaller{(1)} Since the question mark already identifies a predicate, using
prefixes like ``is-'', ``has-'' etc. is redundant.

See also:
@itemize[
  @item{@secref*['("Functional_update" "Predicate" "Struct") 'glossary] @in-g}
  @item{@hyperlink["https://docs.racket-lang.org/style/"]{Racket Style Guide}
  for other Racket coding conventions}]

@glossary-entry{Number}

  @level-basic

@glossary-entry{Numeric tower}

  @level-basic

@glossary-entry{Opaque}

  @level-intermediate

See @secref*["Struct" 'glossary]

@glossary-entry{Package}

  @level-intermediate

@glossary-entry{Pair}

  @level-basic

Pairs, also called cons cells, are the building blocks of Scheme/Racket lists,
but are also often used for combining any two values.

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

@glossary-entry{Partial application and currying}

  @level-basic

Partial application takes a function with some number of arguments and creates
a new function that calls the original function while hard-coding some of the
arguments.

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

Currying is similar, but it hard-codes only one argument and, as long as the
arguments aren't complete, returns a function that @italic{also} takes only one
argument.

For example, if you have a function @tt{curry} that does the initial currying,
the @racket[draw-line] example above could become
@examples[
  #:eval helper-eval
  #:label #f
  (curry draw-line 1)
  ((curry draw-line 1) 2)
  (((curry draw-line 1) 2) 3)
  ((((curry draw-line 1) 2) 3) 4)]

Racket has a function @racket[curry], which supports both partial application
and currying at the same time.
@examples[
  #:eval helper-eval
  #:label #f
  (curry draw-line 1)
  ((curry draw-line 1) 2)
  (((curry draw-line 1) 2) 3 4)]

Note that the last call passes @italic{two} arguments, @racket[3] and
@racket[4].

There's also a function @racket[curryr], which hard-codes arguments from the right
instead of the left of the argument list.

@other-languages{
Unlike Haskell, Scheme/Racket doesn't have implicit currying, so the following
code raises an exception:
@examples[
  #:eval helper-eval
  #:label #f
  (eval:error
    (define draw-line-from-origin (draw-line 0 0)))]}

See also:
@itemlist[
  @item{@secref*["Procedure" 'glossary] @in-g}
  @item{@racket[curry] and @racket[curryr] @in-rr}]

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

A predicate is a procedure that takes one argument and returns a boolean.

Examples:
@itemize[
  @item{Checking for a type: @racket[procedure?], @racket[string?],
    @racket[symbol?], ...}
  @item{Checking properties: @racket[even?], @racket[immutable?],
    @racket[char-lower-case?], ...}
  @item{Others: @racket[directory-exists?], @racket[file-exists?], ...}]

Predicates can be used on their own or as arguments for higher-order functions
like @racket[filter] or @racket[takef]:
@examples[
  #:eval helper-eval
  #:label #f
  (filter string? '(2 "foo" bar 7))
  (takef '(2 6 -4 3 5 4) even?)]

If you have a procedure that's ``almost'' a predicate, you can use partial
application to turn it into a predicate.
@examples[
  #:eval helper-eval
  #:label "Example:"
  (define (greater-than-two? number)
    (> number 2))
  (filter greater-than-two? '(1 3 -1 5 2))
  (code:comment "Equivalent: define an anonymous procedure.")
  (filter
    (lambda (number)
      (> number 2))
    '(1 3 -1 5 2))]

See also:
@itemlist[
  @item{@secref*['("Lambda" "Partial_application_and_currying" "Procedure") 'glossary]
        @in-g}]

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

  @level-intermediate

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

@glossary-entry{String, character, byte string}

  @level-basic

The string, byte string and character data types are used for text processing.

Strings represent human-readable text; they're what you likely want if you do
text processing.
@examples[
  #:eval helper-eval
  (code:comment "String content enclosed in quotes")
  "a string"
  (string? "a string")
  (code:comment "A quote inside a string literal can be escaped with a backslash.")
  "a string \"with\" quotes"
  (string-length "\"foo\"")
  (code:comment "Use `display` or `displayln` to output a string for human readers.")
  (code:comment "`displayln` adds a newline.")
  (displayln "a string \"with\" quotes")
  (code:comment "Concatenate strings with `string-append`.")
  (string-append "Hello " "world" "!")
  (code:comment "Strings can contain non-ASCII characters.")
  "Michael Müller"
  (string-length "Michael Müller")]

A string consists of characters, which represent unicode code points:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "You can get individual characters with `string-ref`.")
  (string-ref "Müller" 1)
  (char? #\ü)
  (code:comment "Convert a string to a character list and back.")
  (string->list "Müller")
  (list->string '(#\M #\ü #\l #\l #\e #\r))]
That said, usually you don't need to deal with individual characters. Most
string processing works on substrings rather than characters.

To convert a string to bytes that can be written to a file or sent over a
network socket, the string needs to be encoded to a byte string:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Not the only encoding function in the standard library")
  (define encoded-string (string->bytes/utf-8 "Müller"))
  (code:comment "ü has been encoded to two bytes.")
  encoded-string
  (bytes? encoded-string)]
Conversely, byte strings can be decoded to strings:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Not the only decoding function in the standard library")
  (bytes->string/utf-8 encoded-string)]

Fortunately, as long as the content is in UTF-8 encoding, you don't need to
encode or decode it yourself. For example, @racket[file->string] decodes the
file contents implicitly.

A byte string consists of bytes. ``Byte'' isn't a ``real'' data type, but
just means integers from 0 to 255. You can see the bytes/integers in a byte
string more clearly with @racket[bytes->list]:
@examples[
  #:eval helper-eval
  #:label #f
  (bytes->list encoded-string)]

The following diagram shows the relationships between the types:

@png-image{string-types}

Both strings and byte strings come in mutable and immutable versions. Literals,
e.g. @racket["foo"] or @racket[#"foo"], are immutable.

The previous paragraphs explained how the string and character data types in
Racket are related. However, for most text processing you'll be fine with
functions that operate on strings. Here are a few of these functions (but also
check out the others in @secref*["strings" 'reference] @in-rr).
@itemize[
  @item{@racket[string-length]}
  @item{@racket[string-ref]}
  @item{@racket[substring]}
  @item{@racket[string-append]}
  @item{@racket[string-join]}
  @item{@racket[string-replace]}
  @item{@racket[string-split]}
  @item{@secref*["String_Comparisons" 'reference]}
]

As mentioned above, strings consist of unicode code points. Unicode is rather
complex and subtle, so the following caveats are shared by programming
languages whose strings consist of code points:
@itemize[
  @item{The term ``character'' is ambiguous in the unicode context. It can
    mean a code point (as in Racket), but also a symbol on the screen that's
    perceived as self-contained. The second meaning is sometimes called a
    ``grapheme`` or ``grapheme cluster.''}
  @item{The distinction between the meanings of ``character'' are important
    because not all grapheme clusters can be expressed in a single code point.
    For example, the German flag
    🇩🇪
    consists of @italic{two} code points:
    @examples[
      #:eval helper-eval
      #:label #f
      (string->list "🇩🇪")]}
  @item{In some cases, the same grapheme cluster can be expressed in different
    code point combinations. For example, the string @racket["ü"] from above
    can be expressed in a single code point, but alternatively in two code
    points, where the first is for the letter @racket["u"] and the second for
    the diacritic (the dots above the u). So two strings that @italic{look} the
    same on the screen may not be the same according to Racket's
    @racket[string=?] function, which works on code point sequences.

    The
    @hyperlink["https://docs.racket-lang.org/reference/strings.html#%28def._%28%28quote._~23~25kernel%29._string-normalize-nfd%29%29"]{normalization
    functions} can convert strings so that they have the ``combined'' or the
    ``separate'' code points and can be meaningfully compared with
    @racket[string=?].}]
The above list may sound intimidating, but it isn't as long as you don't rely on
wrong assumptions (e.g. that the same ``character'' is always expressed by the
same code points). For example, you can safely split a string at newline
characters or other ASCII separators like colons without applying any of the
normalizations.

See also:
@itemlist[
  @item{@secref*['("Formatting" "Port") 'glossary] @in-g}
  @item{@secref*['("strings" "bytestrings") 'guide] @in-rg}
  @item{@secref*['("strings" "bytestrings" "characters" "encodings") 'reference] @in-rr}
  @item{@hyperlink["https://unicode.org/faq/normalization.html"]{Unicode normalization FAQ}}
  @item{@hyperlink["https://manishearth.github.io/blog/2017/01/14/stop-ascribing-meaning-to-unicode-code-points/"]{Let's stop ascribing meaning to code points}}]

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

@other-languages{
Note that field names are only known at compile time, not at runtime. This
means that a function like Python's
@hyperlink["https://docs.python.org/3/library/functions.html#getattr"]{@tt{getattr}}
doesn't exist in Racket.}

See also:
@itemlist[
  @item{@secref*['("Binding" "Functional_update") 'glossary] @in-g}
  @item{@secref*['("define-struct" "classes") 'guide] @in-rg}
  @item{@secref*['("define-struct" "mzlib:class") 'reference] @in-rr}]

@glossary-entry{Symbol}

  @level-basic

Symbols are a data type that doesn't exist in most programming languages.
Symbols are similar to strings:
@examples[
  #:eval helper-eval
  #:label #f
  "a-string"
  'a-symbol]

There are several differences, though:
@itemize[
  @item{Symbols are idiomatically used for enumeration values. See the
    @racket[open-output-file] function for an example, which uses symbols for
    the @racketkeywordfont{mode} and @racketkeywordfont{exists} keyword
    arguments.}
  @item{By default, symbols are interned, while there's no such guarantee for
    strings. Interning has the consequence that two ``same'' symbols compare
    equal with @racket[eq?], not just with @racket[equal?]. Therefore, hashes
    that have symbols as keys can use the @racket[eq?] variants, which speeds
    up the hash operations.}
  @item{Because of the different uses of strings and symbols, the standard
    library has no APIs to search in symbols or concatenate them. If you need
    such functionality, you can convert between symbols and strings with
    @racket[symbol->string] and @racket[string->symbol].}]

Symbols occur naturally when processing Racket code as data.
@examples[
  #:eval helper-eval
  #:label "Example:"
  (define expr1 (+ 3 4))
  expr1
  (code:comment "Note the quote character, '")
  (define expr2 '(+ 3 4))
  (code:comment "A list with the `+` symbol, 3 and 4.")
  expr2
  (symbol? (car expr2))]

See also:
@itemlist[
  @item{@secref*['("Equality" "Hash" "Quote" "String__character__byte_string") 'glossary]
        @in-g}
  @item{@secref*["symbols" 'guide] @in-rg}
  @item{@secref*["symbols" 'reference] @in-rr}]

@glossary-entry{Syntactic form}

  @level-basic

See @secref*["Form" 'glossary]

@glossary-entry{Syntax (different meanings)}

  @level-intermediate

@glossary-entry{Syntax transformer}

  @level-intermediate

See @secref*["Macro" 'glossary]

@glossary-entry{Tail call}

  @level-intermediate

@glossary-entry{Tail position}

  @level-intermediate

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

@glossary-entry{Vector}

  @level-basic

Racket vectors are continuous arrays with indices starting at 0. An advantage
of vectors over lists is that accessing a vector item at a random index takes
constant time, i.e. is independent of the vector size and the index.

Literal vectors can be written with a @tt{#(} prefix. Items in literal vectors
are automatically quoted. The following examples use the @racket[vector-ref]
function to retrieve an item at a given index.
@examples[
  #:eval helper-eval
  (code:comment "Simple vector with some numbers.")
  #(1 2 3)]

@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Empty vector")
  #()]

@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Items are quoted. This vector does _not_ contain the `map` function.")
  (define vec1 #(map))
  (vector-ref vec1 0)]

@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Use `vector` to avoid quoting.")
  (define vec2 (vector map))
  (vector-ref vec2 0)]

Vectors can be mutable or immutable. Literal vectors and those created with
@racket[vector-immutable] are immutable. Vectors created with @racket[vector]
are mutable.
@examples[
  #:eval helper-eval
  (define vec1 #(1 2 3))
  (eval:error (vector-set! vec1 1 5))]

@examples[
  #:eval helper-eval
  #:label #f
  (define vec2 (vector-immutable 1 2 3))
  (eval:error (vector-set! vec2 1 5))]

@examples[
  #:eval helper-eval
  #:label #f
  (define vec3 (vector 1 2 3))
  (vector-set! vec3 1 5)
  vec3]

There are several vector functions (e.g. @racket[vector-map] or
@racket[vector-filter]) that correspond to similar list functions. If the
existing vector functions aren't enough, it may make sense to convert a vector
to a list with @racket[vector->list], process the list with list functions and
finally convert the list back to a vector with @racket[list->vector].

See also:
@itemize[
  @item{@secref*['("Collection" "List") 'glossary] @in-g}
  @item{@secref*["vectors" 'guide] @in-rg}
  @item{@secref*["vectors" 'reference] @in-rr}]

@glossary-entry{Void}

  @level-basic

@(define void-text @racketresultfont{#<void>})

The constant @void-text is used as a return value if there's no
other sensible value. This applies to functions that exist only for their side
effects or if no branch in a @racket[cond] or @racket[case] form matches.

Experimenting with @void-text can be confusing because the Racket REPL
(interactive interpreter) doesn't show it, but you can check the result for
being @void-text with the @racket[void?] predicate.

@examples[
  #:eval helper-eval
  (define foo 2)
  (void? (set! foo 3))
  (void? (display ""))
  (void?
    (cond
      [(= 1 2) #f]))]

Another curiosity is that you can't enter the @void-text value in source code
or the REPL. However, you can create the value with the @racket[void] function.

@other-languages{
Python has a value @tt{None}, whose semantics is similar to @elem{@void-text}.
However, while the use of @tt{None} in Python is idiomatic to denote an unset
optional argument, Scheme and Racket code typically uses @racket[#f] for
the same purpose.
@examples[
  #:eval helper-eval
  #:label "Example:"
  (define (hello [who #f])
    (string-append
      "Hello, "
      (if who who "world")
      "!"))
  (hello)
  (hello "Mike")]
Since @racket[#f] is the only value that's treated as false in conditions,
this usage normally makes sense.

That said, it's fine to use @racket[(void)] and check the argument with
@racket[void?] if @racket[#f] could be an actual value for the argument.}

See also:
@itemize[
  @item{@secref*["Boolean" 'glossary] @in-g}
  @item{@secref*["void" 'reference] @in-rr}]

@glossary-entry{Will}

  @level-advanced

@glossary-entry{Write}

  @level-basic

See @secref*["Display" 'glossary]

@glossary-entry{Writer}

  @level-advanced
