#lang scribble/manual

@(require
  racket/format
  racket/function
  racket/list
  racket/match
  racket/runtime-path
  scribble/core
  scribble/example
  scribble/html-properties
  (for-label
    racket/base
    racket/file
    racket/format
    racket/function
    racket/gui
    racket/list
    racket/runtime-path
    racket/string
    racket/undefined
    racket/vector
    rackunit
    data/gvector))

@(provide
  LEVELS
  entries
  entry-cross-reference?
  entry-level
  entry-stub?
  entry-title)

@(define helper-eval (make-base-eval))
@examples[
  #:eval helper-eval
  #:hidden
  (require
    racket/format
    racket/function
    racket/list
    racket/pretty
    racket/string)]

@(define in-g "in this glossary")
@(define in-rg "in the Racket Guide")
@(define in-rr "in the Racket Reference")

@(define entry-subsection-style
   (make-style
     #f
     (list ; 'unnumbered
           (alt-tag "h5")
           (attributes '((style . "border: none;
                                   padding-top: 0px;
                                   margin-top: 1em;
                                   font-size: 1.4rem;"))))))

@(define stats-hash (make-hash))
@(define (entries)
   (hash-values stats-hash))

@(struct entry (title level cross-reference? stub?) #:transparent)

@(define LEVELS '(basic intermediate advanced))

@(define omit-stub-entries?
   (string=? (or (getenv "OMIT_STUB_ENTRIES") "") "1"))

@(define (title->tag title)
   (regexp-replace* #px"[^A-Za-z0-9]+" title "_"))

@; If the environment variable `OMIT_STUB_ENTRIES` is set to "1", only register
@; the glossary entry, but don't typeset it. If the environment variable isn't
@; "1", register and typeset the entry.
@(define (glossary-entry #:cross-reference? [cross-reference? #f]
                         #:stub? [stub? #f]
                         title-text
                         level
                         . text)
   (when (not (index-of LEVELS level))
     (raise-argument-error
       'glossary-entry "one of 'basic, 'intermediate, 'advanced" level))
   ; Store entry data for `glossary-stats.rkt` script.
   (hash-set! stats-hash title-text (entry title-text level cross-reference? stub?))
   (when (not (and omit-stub-entries? stub?))
     (list
       (subsection
         #:tag (title->tag title-text)
         #:style 'unnumbered title-text)
       (paragraph plain (elem (bold "Level: ") (symbol->string level)))
       text)))

@(define (entry-subsection text)
   (elem #:style entry-subsection-style text))

@; For whatever reason, `italic` deactivates an outer `tt`, so put the `tt`
@; application inside the `italic` application.
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

@; Return a link to a glossary entry `term`, using the link text `text`. If
@; `text` isn't given, use `term` with the first character in lowercase.
@(define (glossary-inline-link term [text #f])
   (define url (string-append
                 "#(part._."
                 (title->tag term)
                 ")"))
   (define link-text
     (or text
         (let ([first (substring term 0 1)]
               [rest  (substring term 1)])
           (string-append (string-downcase first) rest))))
   (hyperlink url link-text))

@; Less clear, but shorter.
@(define inline-link glossary-inline-link)

@(define (other-languages . content)
   @nested[#:style 'inset]{@paragraph[plain @bold{Other languages}] @content})

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

@; See comments in `png-image`.
@(define (svg-image path)
   (image
     (~a (build-path scribblings-directory path) ".svg")
     #:scale 4))

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

@glossary-entry["Arity" 'basic]{

The arity describes how many arguments a function can accept. Everything from
zero to infinitely many arguments is possible. Note that functions can have
optional arguments, so even for a specific function, the arity may not be a
single number.

Arity refers only to positional arguments, not keyword arguments.

See also:
@itemize[
  @item{@secref*["Procedure" 'glossary] @in-g}
  @item{@secref*["Keywords_and_Arity" 'reference] @in-rr}]
}

@glossary-entry["Assignment" 'basic]{

@; Binding vs. location?

Assigning means the same as in most programming languages: changing the value
of a variable. To change the value of a variable, use @racket[set!]:
@examples[
  #:eval helper-eval
  #:label #f
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
}

@glossary-entry["Binding" 'basic]{

A binding makes a value accessible via a name. Typically, bindings are created
with the @racket[define] form:
@examples[
  #:eval helper-eval
  #:label #f
  (define x (+ 2 3))]
binds the name @racket[x] to the value @racket[5].

Note that the bound value is the @italic{result} of the expression, not the
expression itself.

See also:
@itemlist[
  @item{@secref*["Binding" 'glossary] @in-rg}
  @item{@secref*["id-model" 'reference] @in-rr}]
}

@glossary-entry["Boolean" 'basic]{

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

See also:
@itemize[
  @item{@secref*["booleans" 'reference] @in-rr}]
}

@glossary-entry["Box" 'intermediate]{

A box is a container to essentially turn an immutable value into a mutable
value. Passing a box as a function argument is similar to passing a value by
reference in some other languages.

@examples[
  #:eval helper-eval
  #:label "Example:"
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

See also:
@itemize[
  @item{@secref*["boxes" 'reference] @in-rr}]
}

@glossary-entry["Byte string" 'basic #:cross-reference? #t]{

See @secref*["String_character_byte_string" 'glossary]
}

@glossary-entry["Call" 'basic #:cross-reference? #t]{

See @secref*["Procedure" 'glossary]
}

@glossary-entry["Channel" 'intermediate #:stub? #t]{
}

@glossary-entry["Chaperone" 'intermediate #:stub? #t]{
}

@glossary-entry["Character" 'basic #:cross-reference? #t]{

See @secref*["String_character_byte_string" 'glossary]
}

@glossary-entry["Class" 'intermediate #:stub? #t]{
}

@glossary-entry["Closure" 'basic]{

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
    Wikipedia article}]
}

@glossary-entry["Collection" 'basic #:stub? #t]{
}

@glossary-entry["Combinator" 'intermediate #:stub? #t]{
}

@glossary-entry["Comprehension" 'basic]{

In Racket, a comprehension is a form that maps one or more sequences to another
sequence as described by an expression. Typically, this definition means the
@code{for} forms that create sequences, like lists or vectors.

For example, here's a simple list comprehension:
@examples[
  #:eval helper-eval
  #:label #f
  (for/list ([i (in-range 5)])
    (* 2 i))]

The comprehension forms can be classified by two criteria:
@itemize[
  @item{@bold{Type of the generated sequence}. For example, @racket[for/list]
    creates a list and @racket[for/vector] creates a vector.}
  @item{@bold{Parallel or nested iteration}. This is only relevant if the
    form uses more than one input sequence. The @code{for} forms iterate in
    parallel; the @code{for*} forms iterate in a nested fashion.}]

Here are two more examples to illustrate these criteria:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Parallel iteration creating a list.")
  (for/list ([index (in-range 1 4)]
             [word '("one" "two" "three")])
    (format "~a/~a" index word))
  (code:comment "Nested iteration creating a vector. Note the `*` in `for*/vector`.")
  (for*/vector ([color '("green" "red")]
                [fruit '("apple" "berry")])
    (format "~a ~a" color fruit))]

A few more details:
@itemize[
  @item{There are a lot of sequences that can be iterated over,
    for example, strings (iterating over characters) or ports (iterating over
    characters, bytes or lines).}
  @item{The ``loop body'' doesn't have to be single expression. See the examples
    in the Racket Guide.}
  @item{If sequences are iterated over in parallel, the @emph{shortest} input
    sequence determines the elements used for the comprehension.}
  @item{The @code{for} forms support several keyword arguments. For example,
    @code{#:when} makes it possible to include only certain elements in the
    result sequence.}
  @item{Forms like @racket[for], @racket[for/fold] or @racket[for/and] may not
    be considered comprehensions because they don't map input elements to
    output elements but only create a single element. But of course these forms
    can be useful, too.}
]

See also:
@itemize[
  @item{@secref*['("Form" "Sequence") 'glossary] @in-g}
  @item{@secref*["for" 'guide] @in-rg}
  @item{@secref*["for" 'reference] @in-rr}]
}

@glossary-entry["Cons cell" 'basic #:cross-reference? #t]{

See @secref*["Pair" 'glossary]
}

@glossary-entry["Continuation" 'advanced #:stub? #t]{
}

@glossary-entry["Contract" 'intermediate #:stub? #t]{
}

@glossary-entry["Core form" 'advanced #:stub? #t]{
}

@glossary-entry["Currying" 'basic #:cross-reference? #t]{

See @secref*["Partial_application_and_currying" 'glossary]
}

@glossary-entry["Custodian" 'advanced #:stub? #t]{
}

@glossary-entry["Debugging" 'basic #:stub? #t]{
}

@glossary-entry["Definition" 'basic]{

A definition binds an expression result to a new name. In other words, a
definition creates a binding.

By far the two most used ways to define something use @racket[define], but in
different ways.

First,
@specform[(define name expression)]{}
evaluates the @racketvarfont{expression} and binds it to @racketvarfont{name}:
@examples[
  #:eval helper-eval
  #:label #f
  (define two 2)
  two
  (define six (* 3 two))
  six]

Second,
@specform[(define (name arguments) body)]{}
creates a procedure with the name @racketvarfont{name}, arguments
@racketvarfont{arguments} and the code to execute, @racketvarfont{body}.
@examples[
  #:eval helper-eval
  #:label "Example:"
  (define (hello who)
    (displayln (string-append "Hello, " who "!")))
  (hello "Mike")]
See the @secref*["Procedure" 'glossary] entry for more.

Apart from those two definition forms, there are many more. Here are a few
examples:
@itemize[
  @item{@racket[define-values] is similar to the first @racket[define] form
    above, but it can create several bindings at the same time in case a
    procedure returns more than one value.}
  @item{@racket[define-syntax] defines macros (forms). (But there are many more
    ways to define macros.)}
  @item{@racket[define-check] defines custom checks for automated tests.}
  @item{@racket[define-runtime-path] defines runtime paths.}
  @item{@racket[define/public] defines a public method for a class.}]

Although many names of definition forms start with @tt{define-} or
@tt{define/}, this isn't required. In a loose sense you could consider anything
that creates a new binding as a definition. For example, @racket[struct]
creates not only a constructor, but also accessor functions:
@examples[
  #:eval helper-eval
  #:label #f
  (struct point (x y))
  point-x
  point-y]

See also:
@itemize[
  @item{@secref*['("Assignment" "Binding" "Form" "Let" "Procedure" "Struct" "Values")
                 'glossary] @in-g}
  @item{@secref*["define" 'guide] @in-rg}
  @item{@secref*["define" 'reference] @in-rr}]
}

@glossary-entry["Display" 'basic #:stub? #t]{
}

@glossary-entry["DrRacket" 'basic #:stub? #t]{
}

@glossary-entry["DSL (domain-specific language)" 'advanced #:stub? #t]{
}

@glossary-entry["Environment" 'intermediate #:stub? #t]{
}

@glossary-entry["Equality" 'basic]{

Scheme and Racket have three generic functions to determine if two values are
equal:
@itemize[
  @item{@racket[equal?] checks for value equality. Most of the time, this is the
    function you want. @racket[equal?] can also compare recursively, as long as
    the participating types support @racket[equal?] comparisons.
    @examples[
      #:eval helper-eval
      (equal? (+ 2 3) 5)
      (equal? "foo" "foo")
      (equal? "foo" "fox")
      (equal? '(1 2 3) '(1 2 3))
      (equal? '(1 2 ("foo" 3)) '(1 2 ("foo" 3)))
      (equal? '(1 2 ("foo" 3)) '(1 2 ("bar" 3)))]}
  @item{@racket[eq?] checks object identity, i.e. @racket[eq?] only returns
    @racket[#t] if the two compared values are one and the same object. This is
    especically important for mutable objects. For immutable values object
    identity is less relevant.
    @examples[
      #:eval helper-eval
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
}

@glossary-entry["Exact number" 'basic #:cross-reference? #t]{

See @secref*["Number" 'glossary]
}

@glossary-entry["Executor" 'advanced #:stub? #t]{
}

@; Or basic?
@glossary-entry["Exception" 'intermediate #:stub? #t]{
}

@glossary-entry["Expression" 'basic]{

As in other languages, a Racket expression is code that can be evaluated to a
result. The result may be @racketresultfont{#<void>} or @racket[undefined], but
that's still a result. Different from other languages, an expression may
evaluate to more than one value. See the @secref*["Values" 'glossary] entry
for more information on this.

Examples of expressions are:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Literal values")
  3
  "foo"
  (code:comment "A name bound to a value")
  (define foo 3)
  foo
  (code:comment "Functions are just a special case of this.")
  +
  map
  (code:comment "Function application")
  (+ 2 3)
  (even? 6)
  (code:comment "Macro applications that evaluate to a value")
  (or #t #f)
  (if (> 5 2) "foo" "bar")
  (code:comment "Combinations")
  (* (+ 2 3) (- 7 3))
  (map even? '(1 2 3))]

A way to test if something is an expression is to feed it to a function that
accepts an expression regardless of its type. If you don't get an exception,
the argument is an expression. We don't care about the return value of the
function for the test.

Here we use @racket[number?] as an example of such a function:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Actual expressions")
  (number? 2)
  (number? "foo")
  (number? map)
  (number? (or #t #f))
  (code:comment "No expressions")
  (eval:error (number? if))
  (eval:error (number? (define foo 3)))]

However, the opposite isn't necessarily true. You can get an exception even for
an expression:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "The expression itself raises an exception.")
  (eval:error (number? (/ 1 0)))
  (code:comment "The expression returns multiple values.")
  (eval:error (number? (values 3 4)))]

Note: Although many expressions don't have a side effect, some do. Therefore,
don't evaluate expressions if they may have ``dangerous'' side effects, like
deleting a file (unless that's what you want, of course).

See also:
@itemize[
  @item{@secref*['("Form" "Values") 'glossary] @in-g}
  @item{@secref*["eval-model" 'reference] @in-rr}]
}

@glossary-entry["Field" 'basic #:cross-reference? #t]{

See @secref*["Struct" 'glossary]
}

@glossary-entry["Fixnum" 'intermediate]{

A fixnum is a ``small'' integer that can be processed with CPU instructions
for integers.

Note that fixnums in various Scheme implementations or in Racket @italic{can't}
store 32 or 64 bits. Some of the bits are used as flags that distinguish
fixnums from other values. Even for the same Racket version, different
platforms may have a different number of available fixnum bits.

Usually, you should use regular integers and consider the existence of fixnums
an implementation detail. That said, using fixnum-specific operations can help
with runtime optimizations. Then again, don't optimize anything until you have
profiled your software and therefore are sure that the specific integer
calculation is an actual bottleneck.

@other-languages{Especially statically-typed languages often have integer types
corresponding to 8, 16, 32 and 64@|~|bits. However, in Racket you can't expect
that all bits of a machine integer (for example with 64@|~|bits) are available
for calculations (see above).}

See also:
@itemize[
  @item{@secref*["Number" 'glossary] @in-g}
  @item{@secref*["fixnums+flonums" 'guide] @in-rg}
  @item{@secref*["fixnums" 'reference] @in-rr}]
}

@glossary-entry["Flat contract" 'advanced #:stub? #t]{
}

@glossary-entry["Flonum" 'intermediate]{

A flonum is an IEEE 754 floating point value. In Racket, this is a value of the
``technical'' float type (see the @secref*["Number" 'glossary] entry).

See also:
@itemize[
  @item{@secref*["Number" 'glossary] @in-g}
  @item{@secref*["fixnums+flonums" 'guide] @in-rg}
  @item{@secref*["flonums" 'reference] @in-rr}]
}

@glossary-entry["Fold" 'basic]{

Folding means taking a sequence and combining its elements into a new value.

Racket provides the @racket[foldl] and @racket[foldr] functions for this. In
Scheme implementations, these functions may be called differently. Both
@code{fold} variants take a function, an initial value and one or more lists.
To keep things simple, let's discuss the case of @racket[foldl] with a single
list argument first.

The provided function is first called with the first list item and the initial
value and must return an accumulated value for these arguments. For each
subsequent item from the input list the provided function is called again with
the list item and the so-far accumulated value.

Here's an example for calculating the sum from a list of numbers:
@examples[
  #:eval helper-eval
  #:label #f
  (foldl + 0 '(1 2 3 4 5))]
which corresponds to
@examples[
  #:eval helper-eval
  #:label #f
  (+ 5 (+ 4 (+ 3 (+ 2 (+ 1 0)))))]

The difference between @racket[foldl] and @racket[foldr] is that for
@racket[foldl] the input list is processed from left to right and for
@racket[foldr] from right to left.

This difference doesn't matter for summing numbers as above, but it does for
creating a new list:
@examples[
  #:eval helper-eval
  #:label #f
  (foldl cons '() '(1 2 3 4 5))
  (foldr cons '() '(1 2 3 4 5))]

The fold functions are quite general. For example, the functions @racket[map]
and @racket[filter] can be expressed in terms of @racket[foldr]:
@examples[
  #:eval helper-eval
  #:label #f
  (define (map-foldr func lst)
    (foldr
      (lambda (item current-list)
        (cons (func item) current-list))
      '()
      lst))
  (map-foldr add1 '(1 2 3 4 5))]

@examples[
  #:eval helper-eval
  #:label #f
  (define (filter-foldr pred? lst)
    (foldr
      (lambda (item current-list)
        (if (pred? item)
            (cons item current-list)
            current-list))
      '()
      lst))
  (filter-foldr even? '(1 2 3 4 5))]

If @racket[foldl] or @racket[foldr] get multiple list arguments, they're
iterated over in parallel and the provided function receives corresponding
items from the lists:
@examples[
  #:eval helper-eval
  #:label #f
  (foldr
    (lambda (item1 item2 current-list)
      (cons (+ item1 item2) current-list))
    '()
    '(1 2 3 4 5)
    '(1 3 5 7 9))]

Racket also has a @racket[for/fold] form which often is easier to use. For
example, @racket[map] could be implemented as
@examples[
  #:eval helper-eval
  #:label #f
  (define (map-for/fold func lst)
    (for/fold ([current-list '()])
              ([item (reverse lst)])
      (cons (func item) current-list)))
  (map-for/fold add1 '(1 2 3 4 5))]
Note the @racket[reverse] call because the list is iterated over from left to
right, as in @racket[foldl].

See also:
@itemize[
  @item{@secref*["Comprehension" 'glossary] @in-g}
  @item{@racket[foldl], @racket[foldr] and @racket[for/fold] @in-rr}]
}

@; Naming: Although "form" and "macro" IMHO are synonyms, "form" is
@; mostly used when describing pre-existing forms (`if` etc.), while
@; "macros" is more often used in the context of writing your own
@; macros.
@glossary-entry["Form" 'basic #:stub? #t]{
}

@glossary-entry["Formatting" 'basic #:stub? #t]{

(`format`, `~a` etc.)
}

@glossary-entry["Function" 'basic #:cross-reference? #t]{

See @secref*["Procedure" 'glossary]
}

@glossary-entry["Functional programming (FP)" 'basic]{

The core idea of functional programming is that a program should behave like a
mathematical function. That is, a program consists of nested expressions that
are evaluated to get a result, instead of changing state as in imperative
programming.

For example, this is imperative code to set a variable depending on a condition:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "The actual value of `condition` doesn't matter for the example.")
  (define condition #t)
  (define number 0)
  (if condition
      (set! number 1)
      (set! number 2))
  number]

However, this is very atypical code for a functional programming language. In
Scheme or Racket you'd write this code more like this:
@examples[
  #:eval helper-eval
  #:label #f
  (define number
    (if condition
        1
        2))
  number]
In the second example, the value of @code{number} is only set once.

In imperative languages, loops typically update one or more values during
each loop iteration. On the other hand, in functional programming languages,
it's typical to use recursion, as in this factorial function:
@examples[
  #:eval helper-eval
  #:label #f
  (define (factorial n)
    (if (= n 0)
        1
        (* n (factorial (sub1 n)))))
  (factorial 10)]
Note that this code doesn't use any variables. The @racket[if] form calculates
an expression and this is also the return value of the function. (Note: You can
often avoid explicit recursion by using higher-order functions and
comprehensions; see the cross references.)

A desired property of a function is that it's ``pure'', that is, it always
returns the same result if it's called with the same arguments, and the
function doesn't have any side effects (like I/O). That way, it's easier to
reason about and test the code. However, since a program that doesn't have any
effects on the outside world is useless, some side effects are needed. To still
make the most of pure functions, try to put as much code as possible into pure
functions and use them from the code with side effects.

Another feature of functional programming languages is that functions can
be used in expressions (also without calling them). In the following example,
the @racket[if] expression evaluates to a function and this function is used to
calculate the final result.
@examples[
  #:eval helper-eval
  #:label #f
  (define my-function
    (if condition
        (lambda (x) (+ x 2))
        (lambda (x) (- x 3))))
  (my-function 3)]


See also:
@itemize[
  @item{@secref*['("Comprehension" "Fold" "Functional_update" "Higher_order_function" "Let")
                 'glossary] @in-g}
  @item{@hyperlink["https://en.wikipedia.org/wiki/Functional_programming"]{Functional
                   programming}
    Wikipedia article}]
}

@glossary-entry["Functional update" 'basic]{

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
  @item{@secref*['("Binding" "Functional_programming_FP_" "Hash" "Naming_conventions")
                 'glossary] @in-g}]
}

@glossary-entry["Future" 'advanced #:stub? #t]{
}

@glossary-entry["Generator" 'advanced #:stub? #t]{
}

@glossary-entry["Generic API" 'advanced #:stub? #t]{
}

@glossary-entry["GUI programming" 'intermediate #:stub? #t]{
}

@glossary-entry["Hash" 'basic]{

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
with these four combinations:
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
}

@glossary-entry["Higher-order function" 'basic]{

A higher-order function is a function that takes a function as an argument
and/or returns a function. This approach is very common in functional
programming.

Here are a few examples of higher-order functions:
@itemize[
  @item{@racket[map] takes a function that transforms a list item to another
    item for the result list.}
  @item{@racket[filter] takes a predicate function that determines which list
    items should be included in the returned list.}
  @item{@racket[sort] takes a comparison function that determines the sort order
    of the returned list.}
  @item{@racket[compose] takes one or more functions and returns a function that
    applies the functions one after another.}]

See also:
@itemize[
  @item{@secref*['("Function" "Functional_programming_FP_" "Predicate" "Procedure")
                 'glossary] @in-g}]
}

@glossary-entry["Hygiene" 'intermediate #:stub? #t]{
}

@glossary-entry["Identifier" 'basic]{

As in other programming languages, an identifier is a name assigned to a value
(or a form). Compared to most languages, identifiers can contain a lot more
characters. In Racket, all of the following identifier names are valid:
@examples[
  #:eval helper-eval
  #:label #f
  (define a-name 2)
  a-name
  (define predicate/with/slashes? (lambda (v) (and (even? v) (> v 4))))
  predicate/with/slashes?
  (define obscure-name-!$%^&*-_=+<.>/? "a string")
  obscure-name-!$%^&*-_=+<.>/?]

See also:
@itemize[
  @item{@secref*['("Binding" "Form" "Naming_conventions") 'glossary] @in-g}
  @item{@secref*["Identifiers" 'guide] @in-rg}]
}

@glossary-entry["Identity" 'basic]{

Two objects are identical if they're actually one and the same value. Given two
objects, you can check whether they're identical with the @racket[eq?]
function.

@examples[
  #:eval helper-eval
  (code:comment "Obviously identical")
  (define list1 '(1 2 3))
  (eq? list1 list1)
  (code:comment "`list2` refers to the same list object.")
  (define list2 list1)
  (eq? list1 list2)
  (code:comment "`list3` and `list2` are _equal_, but not identical.")
  (define list3 '(1 2 3))
  (eq? list1 list3)]

If the compared objects are immutable, it's not that important if they're
identical. However, for mutable objects, modifications via one reference become
visible in any other references to the same object:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Changes in one vector are reflected in the \"other\" vector.")
  (define vector1 (vector 1 2 3))
  (define vector2 vector1)
  (eq? vector1 vector2)
  (vector-set! vector1 0 4)
  vector1
  vector2
  (code:comment "These vectors are equal, but not identical, so changes to one")
  (code:comment "vector don't affect the other vector.")
  (define vector3 (vector 1 2 3))
  (define vector4 (vector 1 2 3))
  (eq? vector3 vector4)
  (vector-set! vector3 0 4)
  vector3
  vector4]
}

@; May be important for contracts though. Maybe better "intermediate"?
@glossary-entry["Impersonator" 'advanced #:stub? #t]{
}

@glossary-entry["Inexact number" 'basic #:cross-reference? #t]{

See @secref*["Number" 'glossary]
}

@glossary-entry["Inspector" 'advanced #:stub? #t]{
}

@glossary-entry["Interface (API)" 'basic #:stub? #t]{
}

@; Or "advanced"?
@glossary-entry["Interface (OOP)" 'intermediate #:stub? #t]{
}

@glossary-entry["Keyword" 'basic]{

Procedures can be defined and then called with positional arguments, but also
with keyword arguments.

As an example, the following procedure takes a keyword argument to control
whether an exclamation point should be added at the end of a greeting:

@examples[
  #:eval helper-eval
  #:label #f
  (define (greeting name #:exclamation? exclamation?)
    (string-append
      "Hello "
      name
      (if exclamation?
          "!"
          "")))
  (greeting "Alice" #:exclamation? #f)
  (greeting "Alice" #:exclamation? #t)]

Like positional arguments, keyword arguments can be defined as optional:

@examples[
  #:eval helper-eval
  #:label #f
  (define (greeting name #:exclamation? [exclamation? #f])
    (string-append
      "Hello "
      name
      (if exclamation?
          "!"
          "")))
  (greeting "Bob")]

It's conventional to use the same name for the keyword and the argument name,
but it's not required.

@examples[
  #:eval helper-eval
  #:label "Example:"
  (define (greeting name #:exclamation? [exclamation-flag #f])
    (string-append
      "Hello "
      name
      (if exclamation-flag
          "!"
          "")))
  (greeting "Mike")
  (greeting "Mike" #:exclamation? #t)]

Note that the call uses the keyword name (@code{#:exclamation?}), but the
function body uses the argument name (@code{exclamation-flag}).

If a function allows several keyword arguments, they can be specified in any
order, and they can be interleaved with positional arguments. For example,
consider the function @racket[~r] in the Racket standard library, which is used
for formatting numbers:

@examples[
  #:eval helper-eval
  #:label #f
  (~r 1.2345)
  (~r 1.2345 #:precision 2)
  (~r #:precision 2 1.2345)
  (~r #:precision 2 1.2345 #:min-width 10)]

That said, usually the code is easier to read if all the positional arguments
occur before all the keyword arguments:

@examples[
  #:eval helper-eval
  #:label #f
  (~r 1.2345 #:precision 2 #:min-width 10)]

Racket clearly distinguishes between positional and keyword arguments. You
can't use a positional arguments in place of a keyword argument and vice versa:

@examples[
  #:eval helper-eval
  #:label #f
  (define (greeting name #:exclamation? exclamation?)
    (string-append
      "Hello "
      name
      (if exclamation?
          "!"
          "")))
  (greeting "Bob" #:exclamation? #t)
  (eval:error (greeting "Bob" #t))
  (eval:error (greeting #:name "Bob" #:exclamation? #t))]

@other-languages{
Unlike Racket, many languages don't have a clear distinction between positional
and keyword arguments. For example, the following Python code is valid:
@verbatim{
def greeting(name, exclamation):
    suffix = "!" if exclamation else ""
    return "Hello {name}{suffix}"

greeting("Bob", exclamation=True)
}}

See also:
@itemlist[
  @item{@secref*["Procedure" 'glossary] @in-g}
  @item{@secref*["keyword-args" 'guide] @in-rg}
  @item{@secref*["keywords" 'reference] @in-rr}]
}

@glossary-entry["Lambda" 'basic]{

As shown in the @secref*["Procedure" 'glossary] entry, a procedure can be
defined with @racket[define]. However, you can also define functions directly
as values without giving them a name. This is the same function as in the
@secref*["Procedure" 'glossary] glossary entry:

@examples[
  #:eval helper-eval
  #:label #f
  (lambda ([name "world"])
    (string-append "Hello " name "!"))
  ((lambda ([name "world"])
     (string-append "Hello " name "!"))
   "Alice")]

The second example above defines and directly calls the function.

The above examples are a bit artifical. Normally, you use a function defined
with @racket[lambda] as a function argument for a
@secref*["Higher_order_function" 'glossary] or in a @secref*["Let" 'glossary]
expression.

See also:
@itemlist[
  @item{@secref*['("Definition" "Higher_order_function" "Let") 'glossary] @in-g}
  @item{@secref*["lambda" 'guide] @in-rg}
  @item{@secref*["lambda" 'reference] @in-rr}]
}

@glossary-entry["Lang (as in `#lang`)" 'advanced #:stub? #t]{
}

@glossary-entry["Language-oriented programming" 'advanced #:stub? #t]{
}

@glossary-entry["Let" 'basic]{

Scheme and Racket support a variety of @code{let} forms.

The @racket[let] form allows the definition of bindings that are valid for the
body of @racket[let]:
@examples[
  #:eval helper-eval
  #:label #f
  (let ([x 2]
        [y 3])
    (+ x y))]

However, it's @emph{not} possible to reference previous bindings as in
@codeblock{
  (let ([x 2]
        [y (add1 x)])
    (+ x y))}

On the other hand, this is possible with the @racket[let*] form:
@examples[
  #:eval helper-eval
  #:label #f
  (let* ([x 2]
         [y (add1 x)])
    (+ x y))]

You can think of @racket[let*] as nested @racket[let] forms, so the previous
@racket[let*] expression could be written as
@examples[
  #:eval helper-eval
  #:label #f
  (let ([x 2])
    (let ([y (add1 x)])
      (+ x y)))]

Still, @racket[let*] doesn't allow to access later bindings from earlier
bindings as in
@codeblock{
  (let* ([y (add1 x)]
         [x 2])
    (+ x y))}

On the other hand, this is possible with @racket[letrec]. This form can be used
to define mutually recursive functions (i.e. functions calling each other):
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "These `even?` and `odd?` functions are only valid for n >= 0")
  (letrec ([even? (lambda (n)
                    (if (= n 0)
                        #t
                        (odd? (sub1 n))))]
           [odd?  (lambda (n)
                    (if (= n 0)
                        #f
                        (even? (sub1 n))))])
    (even? 6))]

There's also a ``named let'' form which uses the name @code{let}, but has the
list of bindings prefixed with a name. Essentially, this form defines a --
usually recursive -- function and calls it. The result of the named let
expression is the return value of the outermost function call.

For example, defining and calling a recursive factorial function could look
like this:
@examples[
  #:eval helper-eval
  #:label #f
  (let factorial ([n 10])
    (if (= n 0)
        1
        (* n (factorial (sub1 n)))))]

This is equivalent to
@examples[
  #:eval helper-eval
  #:label #f
  (define (factorial n)
    (if (= n 0)
        1
        (* n (factorial (sub1 n)))))
  (factorial 10)]
with the exception that for the named let form the @code{factorial} function is
no longer accessible after the expression is calculated.

Here's a summary of the different @code{let} forms:
@itemize[
  @item{@racket[let] creates ``parallel'' bindings, i.e. the bindings can't
    refer to each other.}
  @item{@racket[let*] creates nested bindings, i.e. later bindings can refer
    to earlier bindings.}
  @item{@racket[letrec] creates bindings where all bindings can refer to all
    others (even themselves).}
  @item{A named @racket[let] defines a function and calls it. The bindings
    specify the arguments for the initial call.}]

Racket has a few more @code{let} forms, in particular for handling multiple
values. See the below sections in the Racket Guide and the Racket Reference.

See also:
@itemize[
  @item{@secref*['("Binding" "Location") 'glossary] @in-g}
  @item{@secref*["let" 'guide] @in-rg}
  @item{@secref*["let" 'reference] @in-rr}]
}

@glossary-entry["Let over lambda" 'intermediate]{

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

See also:
@itemize[
  @item{@secref*['("Procedure" "Lambda" "Closure") 'glossary] @in-g}]
}

@glossary-entry["List" 'basic]{

Lists are the most widely used data structure in many functional programming
languages, including Scheme and Racket.

Scheme and Racket lists are implemented as singly-linked lists (with the
exception of the empty list, which is an atomic value). Singly-linked lists
consist of pairs where the first value of a pair is a list item and the second
value of the pair points to the next pair. The end of the list is denoted by an
empty list as the second value of the last pair.

For example, the list @racket['(1 2 3 4)] can be drawn as

@svg-image{list-1234}

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

@svg-image{list-3-lists}

or, in one picture,

@svg-image{list-3-lists-combined}

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

@svg-image{list-remove}

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
}

@glossary-entry["Location" 'basic]{

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
}

@; Naming: Although "form" and "macro" IMHO are synonyms, "form" is
@; mostly used when describing pre-existing forms (`if` etc.), while
@; "macros" is more often used in the context of writing your own
@; macros.
@;
@; Intermediate or advanced?
@glossary-entry["Macro" 'intermediate #:cross-reference? #t]{

See @secref*["Form" 'glossary]
}

@glossary-entry["Match" 'intermediate #:stub? #t]{
}

@glossary-entry["Match transformer" 'advanced #:stub? #t]{
}

@glossary-entry["Method" 'intermediate #:stub? #t]{
}

@glossary-entry["Module" 'basic #:stub? #t]{
}

@glossary-entry["Named let" 'basic #:cross-reference? #t]{

See @secref*["Let" 'glossary]
}

@glossary-entry["Namespace" 'intermediate #:stub? #t]{

@; Relationship to "environment"? How much has a "normal" user to know about
@; this outside of `eval`?
}

@glossary-entry["Naming conventions" 'basic]{

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
    (list @tt{@ti{name}?}
          @elem{Predicate @smaller{(1)}}
          @elem{@racket[string?], @racket[null?]})
    (list @tt{@ti{name}=?}
          @elem{Comparison predicate @smaller{(1)}}
          @racket[string=?])
    (list @tt{@ti{name}/c}
          @elem{Contract predicate @smaller{(1)}}
          @elem{@racket[or/c], @racket[one-of/c]})
    (list @tt{@ti{name}!}
          "Mutation"
          @elem{@racket[set!], @racket[vector-set!]})
    (list @tt{@ti{name}*}
          "Repetition"
          @elem{@racket[regexp-replace*] vs. @racket[regexp-replace]})
    (list @tt{@ti{name}*}
          "Nesting"
          @elem{@racket[for*] vs. @racket[for]})
    (list @tt{@ti{name}*}
          "Other variant"
          @elem{@racket[vector*-length] vs. @racket[vector-length]})
    (list @tt{@ti{name}%}
          "Class name"
          @racket[frame%])
    (list @tt{@ti{part}/@ti{part}}
          @elem{``for`` or ``with``}
          @elem{@racket[call/cc], @racket[define/match],@linebreak[]
                @racket[for/fold/derived]})
    (list @tt{@ti{type}->@ti{other-type}}
          "Conversion"
          @racket[vector->list])
    (list @tt{make-@ti{type}}
          "Create new value of type"
          @elem{@racket[make-base-namespace], @racket[make-channel]}))]

@smaller{(1)} Since the @tt{?} or @tt{/c} suffix already identifies a
predicate, using prefixes like ``is-'', ``has-'' etc. is redundant.

See also:
@itemize[
  @item{@secref*['("Contract" "Functional_update" "Predicate" "Struct") 'glossary] @in-g}
  @item{@hyperlink["https://docs.racket-lang.org/style/"]{Racket Style Guide}
  for other Racket coding conventions}]
}

@glossary-entry["Number" 'basic]{

Racket and most Scheme implementations have the following number types:
@itemize[
  @item{integer}
  @item{rational}
  @item{real}
  @item{complex}]
However, these names can mean different things in different contexts. To
understand the differences, it's useful to view the number types under a
``technical'' and a ``mathematical'' aspect.

@entry-subsection{``Technical'' number types}

@itemize[
  @item{An ``integer'' is an integer number with arbitrarily many digits.
    Examples: @racket[-123], @racket[0], @racket[2], @racket[12345],
    @racket[26525285981219105863630848].}
  @item{A ``rational'' number consists of an integer nominator and a positive integer
    denominator. Examples: @racket[-123/12], @racket[-2/3],
    @racket[5854679515581645/4503599627370496].}
  @item{A ``float'' number is an (IEEE 754) floating point number. Examples:
    @racket[-12.34] (=@code{-1.234e1}=@code{0.1234e2} etc.), @racket[0.0],
    @racket[0.0123], @racket[2.0]. Float numbers also include the special
    values @racket[-inf.0] (–∞), @racket[+inf.0] (+∞), @racket[-nan.0] (–nan)
    and @racket[+nan.0] (+nan).}
  @item{A ``complex'' number has a real and an imaginary part. If one part is
    a float value, the other part must also be a float value. Otherwise the
    real and imaginary parts can be integer or rational numbers. Examples:
    @racket[1+2i], @racket[2+3/4i], @code{1.0+2i} (immediately converted to
    @racket[1.0+2.0i]).}]

Integer and rational numbers are called @bold{exact} because they can use
arbitrarily many digits for calculations and therefore aren't affected by
rounding errors (as long as operations involve only exact values, of course).
Float values are called @bold{inexact} because many float operations lead to
rounding errors.

A complex number is exact if both the real and the imaginary part are exact,
otherwise the complex number is inexact.

The following diagram shows the relationships between the technical types.

@svg-image{number-types}

@entry-subsection{``Mathematical'' number types}

Racket and many Scheme implementations have the predicates
@itemize[
  @item{@racket[integer?]}
  @item{@racket[rational?]}
  @item{@racket[real?]}
  @item{@racket[complex?]}]
However, these predicates don't test for the technical types with the same
or similarly-named types described above. Instead, the predicates work in a
mathematical sense.

@examples[
  #:eval helper-eval
  (code:comment "2.0 is the same as the integer 2.")
  (integer? 2.0)
  (code:comment "1.23 is mathematically the same as 123/100, which is a")
  (code:comment "rational (and a real) number.")
  (rational? 1.23)
  (real? 1.23)
  (code:comment "However, special values like `+inf.0` are `real?`, but not")
  (code:comment "`rational?`.")
  (rational? +inf.0)
  (real? +inf.0)
  (code:comment "All integer and real values are also complex values.")
  (complex? 2)
  (complex? 2.0)
  (complex? 1.23)
  (complex? +inf.0)
  (code:comment "Numbers with a non-zero imaginary part are obviously")
  (code:comment "complex values.")
  (complex? 1+2i)]

@entry-subsection{Type notions combined}

In Racket discussions, ``integer'' is usually understood as the technical type,
i.e. an exact integer. Use ``exact integer'' as an exact wording. ;-) For the
technical floating point type the term ``float'' avoids ambiguities with the
mathematical ``real'' type.

You can express the technical types in terms of the mathematical predicates
if necessary (@racket[v] means ``value''):

@tabular[#:sep @hspace[1]
  (list
    (list @bold{Technical type}
          @bold{Predicate combination})
    (list "integer"
          @elem{@racket[(and (exact? v) (integer? v))] = @racket[(exact-integer? v)]})
    (list "rational"
          @racket[(and (exact? v) (not (integer? v)))])
    (list "float"
          @elem{@racket[(and (inexact? v) (real? v))] = @racket[(inexact-real? v)]})
    (list "complex"
          @racket[(and (complex? v) (not (real? v)))])
    (list "exact complex"
          @racket[(and (exact? v) (complex? v) (not (real? v)))])
    (list "inexact complex"
          @racket[(and (inexact? v) (complex? v) (not (real? v)))]))]

@entry-subsection{Tips and gotchas}

@itemize[
  @item{Use exact integers for counts, or indices for lists and vectors.
    Actually, there's a special predicate @racket[exact-nonnegative-integer?]
    to check for numbers that can be used as an index.}
  @item{Use floats for physical properties like lengths, times and so on.}
  @item{Use floats for values that come from measurements or non-trivial calculations,
    especially if they involve physical properties. Such numbers are bound to
    be inexact.}
  @item{Use fractions if you want exact calculations, but exact integers
    aren't enough. Note, however, that many non-basic operations return an
    inexact result even for most exact arguments. For example, Racket evaluates
    @racket[(sin 1)] to @racket[0.8414709848078965].}
  @item{Related to the previous point, it's not always obvious when a Racket
    function will return an exact or inexact result. For example, @racket[(sin 1)],
    as shown above, is inexact, but @racket[(sin 0)] gives an exact @racket[0].}
  @item{When using floats, beware of rounding errors, including overflow and
    underflow. ``Overflow'' means that a result can't be represented as a
    ``normal'' float and becomes +∞ or –∞. ``Underflow'' means that a result
    evaluates to @racket[0.0], even if it wouldn't be zero in terms of an exact
    mathematical calculation.
    @examples[
      #:eval helper-eval
      (define one-sixth (/ 1.0 6.))
      (code:comment "6 times 1/6 should be 1.")
      @; This is supposed to be rendered as 0.9999999999999999.
      (+ one-sixth one-sixth one-sixth one-sixth one-sixth one-sixth)
      (code:comment "Overflow")
      (* 1e200 1e200)
      (code:comment "Underflow")
      (* 1e-200 1e-200)]}
  @item{The behavior of division by zero differs depending on whether the
    denominator is exact or inexact.
    @examples[
      #:eval helper-eval
      (eval:error (/ 1 0))
      (eval:error (/ 1.0 0))
      (/ 1 0.0)
      (/ 1.0 0.0)]
    Usually it's better not to rely on a particular behavior for division by
    zero. Instead test the denominator and handle zero values explicitly.}
  @item{You can use the prefixes @tt{#e} and @tt{#i} to evaluate literal numbers
    to exact and inexact values, respectively. For example, @code{#e1e3}
    is exact @racket[1000] and @code{#i5} is inexact @racket[5.0].}
  @item{To ensure that a value is exact or inexact, you can use
    @racket[inexact->exact] and @racket[exact->inexact], respectively. Despite
    the names of these functions, you can feed them any number. For example,
    @racket[(inexact->exact 1)] just returns an exact @racket[1].}
  @item{When reading numbers from a text file, you can convert them to actual
    numbers with @racket[string->number]. The function handles the same syntaxes
    that you can use in Racket code.}
  @item{In addition to the previous tip, convert input numbers to the
    types/exactness they're supposed to have. Assume you have the following
    data, where each row represents a set of input data to the same
    calculation:
@nested[#:style 'code-inset @verbatim{1  2    3
4  5.6  7}]
  Since all inputs in the first row are exact, the calculation may
  give @racket[361419657752/6547349568252]
  whereas the data from the second row may give @racket[6.468137108187422].

  If the second column is supposed to contain float values, you should ensure
  this with @racket[exact->inexact]. In some situations, you may want to signal
  an error instead of converting a number. For example, if a number is supposed
  to be an integer (for example a count), you proabably shouldn't accept a
  float instead.}]

See also:
@itemize[
  @item{@secref*['("Fixnum" "Flonum" "Numeric_tower") 'glossary] @in-g}
  @item{@secref*["numbers" 'guide] @in-rg}
  @item{@secref*["numbers" 'reference] @in-rr}]
}

@glossary-entry["Numeric tower" 'basic]{

The numeric tower, sometimes called ``numerical tower,'' is an analogy for how
the ``mathematical'' number types include each other (see @secref*["Number"
'glossary]):

@svg-image{numeric-tower}

For example, for every number for which @racket[rational?] gives @racket[#t],
@racket[real?] and @racket[complex?] also give @racket[#t].

You could add ``number'' as the bottom of the tower, but at least in Racket,
@racket[number?] is equivalent to @racket[complex?].

See also:
@itemize[
  @item{@secref*["Number" 'glossary] @in-g}
  @item{@hyperlink["https://en.wikipedia.org/wiki/Numerical_tower"]{Numerical tower}
        Wikipedia article}]
}

@glossary-entry["Opaque" 'intermediate #:cross-reference? #t]{

See @secref*["Struct" 'glossary]
}

@glossary-entry["Package" 'intermediate #:stub? #t]{
}

@glossary-entry["Pair" 'basic]{

Pairs, also called cons cells, are the building blocks of Scheme/Racket lists,
but are also often used for combining any two values.

Usually a pair is created with @racket[cons]:
@examples[
  #:eval helper-eval
  #:label #f
  (cons 1 "one")]

Once a pair is created, you can access the first and second value of the pair with
@racket[car] and @racket[cdr]:
@examples[
  #:eval helper-eval
  #:label #f
  (define a-pair (cons 1 "one"))
  (car a-pair)
  (cdr a-pair)]

See also:
@itemlist[
  @item{@secref*["List" 'glossary] @in-g}
  @item{@secref*["pairs" 'guide] @in-rg}
  @item{@secref*["pairs" 'reference] @in-rr}]
}

@glossary-entry["Parameter" 'basic]{

Apart from the meaning in function definitions, a Racket parameter is a
thread-local variable. A few examples are @racket[current-output-port],
@racket[current-command-line-arguments] and
@racket[current-environment-variables].

To create custom parameters, use the @racket[make-parameter] function. The
value of the parameter is accessible by calling the created parameter function
without arguments:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "The `make-parameter` argument is the initial value.")
  (define new-parameter (make-parameter 3))
  (new-parameter)]

You can set a parameter by calling the parameter function with an argument:
@examples[
  #:eval helper-eval
  #:label #f
  (new-parameter 4)
  (new-parameter)]

However, normally you should use the @racket[parameterize] form to change the
parameter value temporarily:
@examples[
  #:eval helper-eval
  #:label #f
  (new-parameter)
  (parameterize ([new-parameter 5])
    (new-parameter))
  (new-parameter)]
Using @racket[parameterize] makes it clearer where the parameter value is
changed. Another advantage is that the original parameter value is also
restored if the body of @racket[parameterize] raises an exception.

See also:
@itemlist[
  @item{@secref*["Thread" 'glossary] @in-g}
  @item{@secref*["parameterize" 'guide] @in-rg}
  @item{@secref*["parameters" 'reference] @in-rr}]
}

@glossary-entry["Partial application and currying" 'basic]{

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
}

@glossary-entry["Pattern (in regular expressions)" 'basic #:stub? #t]{
}

@glossary-entry["Pattern (in macro definitions)" 'intermediate #:stub? #t]{
}

@glossary-entry["Phase" 'advanced #:stub? #t]{
}

@glossary-entry["Place" 'advanced #:stub? #t]{
}

@glossary-entry["Polymorphism" 'intermediate #:stub? #t]{
@; rarely used, compare with other languages; see also generic code
}

@glossary-entry["Port" 'basic #:stub? #t]{
}

@glossary-entry["Predicate" 'basic]{

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
}

@glossary-entry["Print" 'basic #:cross-reference? #t]{

See @secref*["Display" 'glossary]
}

@glossary-entry["Procedure" 'basic]{

A procedure, also called a function, is a value that can be called at program
runtime. If a procedure is used after an opening parenthesis, it introduces a
function call. For example, @racket[add1] is a simple function that adds 1 to
its argument:

@examples[
  #:eval helper-eval
  #:label #f
  (add1 2)]

If a function should be called without arguments, it's written @racket[(func)].
Since the parentheses cause the function call, you can't just add brackets around
expressions. For example,

@examples[
  #:eval helper-eval
  #:label #f
  (eval:error ((add1 2)))]

calculates @racket[3] through the function call @racket[(add1 2)] and tries to
call the result @racket[3] as a function, @racket[(3)], which gives an error
saying that @racket[3] isn't callable.

On the other hand, when using a function in another position, it's just a
``passive'' value:

@examples[
  #:eval helper-eval
  #:label #f
  add1
  (procedure? add1)
  (list add1 add1)]

As using too many brackets, using too few can lead to problems, although they
tend to be less obvious:

@examples[
  #:eval helper-eval
  #:label #f
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
  #:label #f
  (define (greeting [name "world"])
    (string-append "Hello " name "!"))
  (greeting)
  (greeting "Bob")]

See also:
@itemlist[
  @item{@secref*['("Keyword" "Lambda") 'glossary] @in-g}
  @item{@secref*["syntax-overview" 'guide] @in-rg}
  @item{@secref*["define" 'reference] @in-rr}]
}

@glossary-entry["Profiling" 'intermediate #:stub? #t]{
}

@glossary-entry["Prompt" 'advanced #:stub? #t]{
}

@glossary-entry["Provide" 'intermediate #:stub? #t]{
}

@glossary-entry["Quasiquote and unquote" 'intermediate]{

A variant of @racket[quote] is @racket[quasiquote], usually written as a
backtick, @tt{`}. At first sight, @racket[quasiquote] behaves exactly as
@racket[quote]:
@examples[
  #:eval helper-eval
  #:label #f
  '(+ 3 4)
  `(+ 3 4)
  'map
  `map]

However, different from @racket[quote], you can use @racket[unquote], usually
written as a comma, @tt{,}, inside @racket[quasiquote] to ``escape'' the
quoting. This is useful to write lists that include literals and expressions
that should be evaluated:
@examples[
  #:eval helper-eval
  #:label #f
  `(1 2 ,(+ 1 1 1))]

See also:
@itemlist[
  @item{@secref*['("Quote") 'glossary] @in-g}
  @item{@racket[quasiquote] and @racket[unquote] @in-rr}]
}

@glossary-entry["Quote" 'basic]{

Quoting with @racket[quote] prevents a quoted expression from being evaluated.
Compare
@examples[
  #:eval helper-eval
  #:label #f
  (+ 3 4)
  (quote (+ 3 4))
  map
  (quote map)]

A single apostrophe can be used instead of spelling out @racket[quote]:
@examples[
  #:eval helper-eval
  #:label #f
  (+ 3 4)
  '(+ 3 4)
  map
  'map]

Quoted literal values like numbers, strings, characters and booleans are the
values themselves:
@examples[
  #:eval helper-eval
  #:label #f
  '123
  '"foo"
  '#\space
  '#t]

Typical use cases for quoting are writing symbols and lists of literals:
@examples[
  #:eval helper-eval
  #:label #f
  'truncate
  '(1 2 3)
  '("foo" "bar" "baz")]

Pay attention to avoid ``double quoting.'' For example, assume you've
originally written
@examples[
  #:eval helper-eval
  #:label #f
  (list 1 2 'foo)]
and try to simplify the list as
@examples[
  #:eval helper-eval
  #:label #f
  '(1 2 'foo)]

With this change, you get an expression @code{''foo}, which is @emph{not} the
same as @code{'foo}:
@examples[
  #:eval helper-eval
  #:label #f
  (define my-list '(1 2 'foo))
  (list-ref my-list 2)
  (equal? ''foo 'foo)]

Although the expression @code{''foo} looks like @code{foo} ``quoted twice,''
@hyperlink["https://racket.discourse.group/t/questions-on-quoting/1472"]{it's
more complicated}.

If you see an expression starting with two apostrophes, it's most likely a bug.

See also:
@itemlist[
  @item{@secref*['("Procedure" "Quasiquote_and_unquote" "Symbol") 'glossary] @in-g}
  @item{@secref*["quote" 'guide] @in-rg}
  @item{@secref*["quote" 'reference] @in-rr}]
}

@glossary-entry["RnRS (as in R5RS, R6RS etc.)" 'intermediate #:stub? #t]{
}

@glossary-entry["Raco" 'basic #:stub? #t]{
}

@glossary-entry["Reader (for parsing code)" 'advanced #:stub? #t]{
}

@glossary-entry["Record" 'basic #:cross-reference? #t]{

See @secref*["Struct" 'glossary]
}

@glossary-entry["Require" 'basic #:stub? #t]{
}

@glossary-entry["Rule (in macros; probably other uses, which ones?)" 'intermediate #:stub? #t]{
}

@glossary-entry["Safe operation" 'intermediate #:cross-reference? #t]{

See @secref*["Unsafe_operation" 'glossary]
}

@glossary-entry["Scheme" 'basic #:stub? #t]{
}

@glossary-entry["Scribble" 'intermediate #:stub? #t]{
}

@glossary-entry["Sequence" 'intermediate #:stub? #t]{
}

@glossary-entry["Set" 'intermediate #:stub? #t]{
}

@glossary-entry["Shadowing" 'basic]{

Shadowing means that a binding prevents access to another binding with the same
name in an enclosing scope.

For example, in
@examples[
  #:eval helper-eval
  #:label #f
  (let ([x 2])
    (displayln x)
    (let ([x 3])
      (displayln x)))]
the inner @code{x} binding (value 3) shadows the outer @code{x} binding
(value 2).

See also:
@itemlist[
  @item{@secref*["Binding" 'glossary] @in-g}]
}

@glossary-entry["Splicing" 'basic #:stub? #t]{
}

@glossary-entry["SRFI" 'intermediate #:stub? #t]{
}

@glossary-entry["Standard library" 'basic]{

Typically, everything that's installed by the Racket distributions from the
@hyperlink["https://download.racket-lang.org/"]{Racket download page} is called
the Racket standard library. Apart from what's documented in the Racket
Reference this includes, for example, the
@hyperlink["https://docs.racket-lang.org/drracket/"]{DrRacket IDE}, the
@hyperlink["https://docs.racket-lang.org/scribble/"]{Scribble documentation
tool} and the @hyperlink["https://docs.racket-lang.org/ts-guide/"]{Typed Racket
library}.

See also:
@itemlist[
  @item{@other-doc['(lib "scribblings/reference/reference.scrbl")]}
  @item{@hyperlink["https://pkgs.racket-lang.org/package/main-distribution"]{@tt{main-distribuition}
    package}}]
}

@glossary-entry["Stream" 'basic #:stub? #t]{
}

@glossary-entry["String, character, byte string" 'basic]{

The string, byte string and character data types are used for text processing.

@entry-subsection{Strings and characters}

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

@entry-subsection{Byte strings, bytes and encodings}

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

@entry-subsection{Type relationships}

The following diagram shows the relationships between the types:

@svg-image{string-types}

Both strings and byte strings come in mutable and immutable versions. Literals,
e.g. @racket["foo"] or @racket[#"foo"], are immutable.

@entry-subsection{String functions}

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

@entry-subsection{Caveats}

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
The above list may look intimidating, but it isn't, as long as you don't rely
on wrong assumptions (e.g. that the same ``character'' is always expressed by
the same code points). For example, you can safely split a string at newline
characters or other ASCII separators like colons without applying any of the
normalizations.

See also:
@itemlist[
  @item{@secref*['("Formatting" "Port") 'glossary] @in-g}
  @item{@secref*['("strings" "bytestrings") 'guide] @in-rg}
  @item{@secref*['("strings" "bytestrings" "characters" "encodings") 'reference] @in-rr}
  @item{@hyperlink["https://unicode.org/faq/normalization.html"]{Unicode normalization FAQ}}
  @item{@hyperlink["https://manishearth.github.io/blog/2017/01/14/stop-ascribing-meaning-to-unicode-code-points/"]{Let's stop ascribing meaning to code points}}]
}

@glossary-entry["Struct" 'basic]{

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
}

@glossary-entry["Symbol" 'basic]{

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
  @item{@secref*['("Equality" "Hash" "Quote" "String_character_byte_string") 'glossary]
        @in-g}
  @item{@secref*["symbols" 'guide] @in-rg}
  @item{@secref*["symbols" 'reference] @in-rr}]
}

@glossary-entry["Syntactic form" 'basic #:cross-reference? #t]{

See @secref*["Form" 'glossary]
}

@glossary-entry["Syntax (different meanings)" 'intermediate #:stub? #t]{
}

@glossary-entry["Syntax transformer" 'intermediate #:cross-reference? #t]{

See @secref*["Form" 'glossary]
}

@glossary-entry["Tail call" 'intermediate #:stub? #t]{
}

@glossary-entry["Tail position" 'intermediate #:stub? #t]{
}

@glossary-entry["Thread" 'intermediate #:stub? #t]{
}

@glossary-entry["Thunk" 'basic]{

A thunk is a function that takes no arguments. Thunks are typically used to
evaluate some code conditionally or at a later time (``lazily''). For example,
assume that we want a variant of the @racket[if] form that prints whether it
evaluates the first or the second branch. Defining @code{verbose-if} like

@examples[
  #:eval helper-eval
  #:label #f
  (define (verbose-if condition true-branch false-branch)
    (if condition
      (begin
        (displayln "condition is true")
        true-branch)
      (begin
        (displayln "condition is false")
        false-branch)))

  (verbose-if (> 5 4)
              (displayln "yes")
              (displayln "no"))]

doesn't work because in the call of @code{verbose-if} both the
@code{true-branch} and the @code{false-branch} are already evaluated before
executing the body of @code{verbose-if}.

However, you can control the execution of the @code{true-branch} and the
@code{false-branch} by turning them into thunks:

@examples[
  #:eval helper-eval
  #:label #f
  (define (verbose-if condition true-branch false-branch)
    (if condition
      (begin
        (displayln "condition is true")
        (true-branch))
      (begin
        (displayln "condition is false")
        (false-branch))))

  (verbose-if (> 5 4)
              (lambda () (displayln "yes"))
              (lambda () (displayln "no")))]

Note that you need to change both the function and the use of it.

Even if the thunks need data from the surrounding scope, you don't need to
define and pass arguments because the thunks still have access to that scope
even if they're executed in @code{verbose-if}:

@examples[
  #:eval helper-eval
  #:label #f
  (define (call-verbose-if)
    (define true-string "yes")
    (define false-string "no")
    (verbose-if (> 5 4)
                (lambda () (displayln true-string))
                (lambda () (displayln false-string))))
  (call-verbose-if)]

See also:
@itemlist[
  @item{@secref*['("Closure" "Procedure") 'glossary] @in-g}
  @item{@racket[thunk] @in-rr}]
}

@glossary-entry["Transparent" 'basic #:cross-reference? #t]{

See @secref*["Struct" 'glossary]
}

@glossary-entry["Trust level" 'advanced #:stub? #t]{
}

@glossary-entry["Trusted code" 'advanced #:cross-reference? #t]{

See @secref*["Untrusted_code" 'glossary]
}

@glossary-entry["Typed Racket" 'advanced #:stub? #t]{
}

@glossary-entry["Undefined" 'advanced #:stub? #t]{
@; why do we need this if we have `void`?
}

@glossary-entry["Unit" 'advanced #:stub? #t]{
}

@glossary-entry["Unsafe operation" 'intermediate #:stub? #t]{
}

@glossary-entry["Untrusted code" 'advanced #:stub? #t]{
}

@glossary-entry["Value" 'basic #:stub? #t]{
@; sometimes "object", but may be confused with OOP concept
}

@glossary-entry["Values" 'basic]{

Different from most other languages, a function in Scheme and Racket can return
multiple values. The most basic function that can do this is @racket[values]:
@examples[
  #:eval helper-eval
  #:label #f
  (values 1 2)]

The output here consists of two values, the values passed to @racket[values].
The result is @emph{not} a compound value like a pair or a list. Along these
lines, you can't assign multiple return values to a single name:
@examples[
  #:eval helper-eval
  #:label #f
  (eval:error (define a-name (values 1 2)))]

To assign several values at once, instead use @racket[define-values]:
@examples[
  #:eval helper-eval
  #:label #f
  (define-values (foo bar) (values 1 2))
  foo
  bar]

The equivalent @code{let} form is @racket[let-values]:
@examples[
  #:eval helper-eval
  #:label #f
  (let-values ([(foo bar) (values 1 2)])
    (+ foo bar))]

By far the most functions in the standard library return a single value. Some
functions that return multiple values, apart from @racket[values], are
@racket[split-at], @racket[drop-common-prefix] and
@racket[split-common-prefix].

If accidentally using multiple values instead of a single value somewhere,
the error message can be confusing. This is most obvious with functions that
accept an arbitrary number of arguments, for example @racket[list]:
@examples[
  #:eval helper-eval
  #:label #f
  (list)
  (list 1)
  (list 1 2)
  (eval:error (list (values 1 2)))]
Therefore, if you get an exception about an arity mismatch, it @emph{might} be
that some code passed multiple values instead of a single value.

@other-languages{Some documentation on other programming languages, for example
Python, sometimes uses the term ``multiple values'' to mean a single compound
value. This is different from the ``multiple values'' concept in Scheme and
Racket.

Here's a Python example:
@verbatim{
def return_tuple():
    return 1, 2

result = return_tuple()
print(type(result))  # tuple
print(result[0])     # 1
print(result[1])     # 2}}

See also:
@itemize[
  @item{@secref*['("Definition" "Let") 'glossary] @in-g}]
}

@glossary-entry["Vector" 'basic]{

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
}

@(define void-text @racketresultfont{#<void>})

@glossary-entry["Void" 'basic]{

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
or the REPL. However, you can create the value with @racket[(void)].

@other-languages{
Python has a value @tt{None}, whose semantics are similar to @elem{@void-text}.
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

That said, it's fine to use @racket[(void)] as default and check the argument
with @racket[void?] if @racket[#f] could be an actual value for the argument.}

See also:
@itemize[
  @item{@secref*["Boolean" 'glossary] @in-g}
  @item{@secref*["void" 'reference] @in-rr}]
}

@glossary-entry["Will" 'advanced #:stub? #t]{
}

@glossary-entry["Write" 'basic #:cross-reference? #t]{

See @secref*["Display" 'glossary]
}

@glossary-entry["Writer" 'advanced #:stub? #t]{
}
