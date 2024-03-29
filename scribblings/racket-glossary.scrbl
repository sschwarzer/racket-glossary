#lang scribble/manual

@(require
  racket/format
  racket/function
  racket/list
  racket/match
  racket/runtime-path
  racket/stream
  scribble/core
  scribble/example
  scribble/html-properties
  (for-label
    racket/base
    racket/file
    racket/format
    racket/function
    racket/generator
    racket/list
    racket/runtime-path
    racket/serialize
    racket/string
    racket/stream
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
    racket/generator
    racket/list
    racket/pretty
    racket/stream
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

@(define center-style
   (make-style
     #f
     (list (attributes '((style . "display: block;
                                   text-align: center;"))))))

@(define table-style-properties
   (attributes '((style . "border-color: gray;"))))

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
       (paragraph
         plain
         (elem (bold "Level: ")
         (symbol->string level)))
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

@; The string can contain more than one number, e.g. `@note-number{1, 2}`.
@(define (note-number numbers-string)
   (smaller "(" numbers-string ")"))

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
@itemlist[
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

To change a value via assignment, you need a name (@inline-link["Binding"]) and
a storage @inline-link["Location"] for it. Usually, the binding and location
are created with @racket[define], but they can also be created by one of the
@racket[let] forms.

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
  @item{@secref*['("Binding" "Definition") 'glossary] @in-g}
  @item{@secref*["Definitions" 'guide] @in-rg}
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
  (for ([value (list #t 1 0 "false" '() map (void) #f)])
    (displayln (if value "true" "false")))]

See also:
@itemlist[
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

In Racket, using boxes is kind of awkward compared to passing arguments by
reference in other languages. However, in practice this isn't a problem since
it's unidiomatic in Racket to use mutable values. Instead you usually transform
immutable values to other immutable values.

See also:
@itemlist[
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

A closure combines a @inline-link["Procedure"]{function} with
@inline-link["Environment"] data from a @inline-link["Scope"] outside the
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
@itemlist[
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
@code{for} forms that create sequences, like @inline-link["List"]s or
@inline-link["Vector"]s.

For example, here's a simple list comprehension:
@examples[
  #:eval helper-eval
  #:label #f
  (for/list ([i (in-range 5)])
    (* 2 i))]

The comprehension forms can be classified by two criteria:
@itemlist[
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
@itemlist[
  @item{There are a lot of
  @inline-link["Sequence_stream_generator"]{sequences} that can be iterated
    over, for example, @inline-link["String, character, byte string"]{string}s
    (iterating over characters) or @inline-link["Port"]s (iterating over
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
@itemlist[
  @item{@secref*['("Form" "Sequence_stream_generator") 'glossary] @in-g}
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

A definition binds an @inline-link["Expression"] result to a new name. In other
words, a definition creates a @inline-link["Binding"].

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
creates a @inline-link["Procedure"] with the name @racketvarfont{name},
arguments @racketvarfont{arguments} and the code to execute,
@racketvarfont{body}.
@examples[
  #:eval helper-eval
  #:label "Example:"
  (define (hello who)
    (displayln (string-append "Hello, " who "!")))
  (hello "Mike")]

Apart from those two definition forms, there are many more. Here are a few
examples:
@itemlist[
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
@itemlist[
  @item{@secref*['("Assignment" "Binding" "Form" "Let" "Procedure" "Struct" "Values")
                 'glossary] @in-g}
  @item{@secref*["define" 'guide] @in-rg}
  @item{@secref*["define" 'reference] @in-rr}]
}

@glossary-entry["Display" 'basic #:cross-reference? #t]{

  See @secref*["Formatting_and_output" 'glossary]
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
@itemlist[
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
  @item{@racket[eq?] checks object @inline-link["Identity"], i.e. @racket[eq?]
    only returns @racket[#t] if the two compared values are one and the same
    object. This is especically important for mutable objects. For immutable
    values object identity is less relevant. @examples[ #:eval helper-eval
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
@itemlist[
  @item{The name makes it clear what's compared, without looking at surrounding
    code.}
  @item{Functions of this form provided by Racket check that the arguments
    have the correct type, e.g. string for @racket[string=?].}]

There's no @tt{==} function in Racket, but you could define a function with
this name. (But probably you shouldn't.)

@other-languages{
The @racket[eq?] function behaves like the @tt{is} operator in Python.}

See also:
@itemlist[
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
@itemlist[
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
@itemlist[
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
@itemlist[
  @item{@secref*["Number" 'glossary] @in-g}
  @item{@secref*["fixnums+flonums" 'guide] @in-rg}
  @item{@secref*["flonums" 'reference] @in-rr}]
}

@glossary-entry["Fold" 'basic]{

Folding means taking a data structure and combining its elements into a new
value.

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
@itemlist[
  @item{@secref*["Comprehension" 'glossary] @in-g}
  @item{@racket[foldl], @racket[foldr] and @racket[for/fold] @in-rr}]
}

@; Naming: Although "form" and "macro" IMHO are synonyms, "form" is
@; mostly used when describing pre-existing forms (`if` etc.), while
@; "macros" is more often used in the context of writing your own
@; macros.
@glossary-entry["Form" 'basic #:stub? #t]{
}

@glossary-entry["Formatting and output" 'basic]{

@entry-subsection{Basics}

You can print a string (or other data) with @racket[display]:
@examples[
  #:eval helper-eval
  #:label #f
  (display "Hello world!")]

A line break can be added with a following @racket[newline] call. The function
@racket[displayln] combines @racket[display] and @racket[newline], that is, it
prints the string and then a line break.

All of these functions take an additional optional argument, which is the
@inline-link{port} the string or newline should be sent to. By default, this
is standard output.

@entry-subsection{Formatting}

A string argument for @racket[display] or @racket[displayln] can be built
with any string functions, but often it's convenient to use the @racket[format]
function. It takes a string template with placeholders and the values that
should be inserted for these placeholders. Additionally, a few special
placeholders, like @tt{~n} for a newline, are supported. The values after the
template don't have to be strings.
@examples[
  #:eval helper-eval
  (format "Hello world!")
  (format "Hello ~a!~n" "world")
  (format "First line~nSecond line~n")
  (format "~a plus ~a is ~a" 2.5 3 5.5)
  (code:comment "~x, ~o and ~b can only be used with exact numbers.")
  (format "decimal: ~a, hexadecimal: ~x, octal: ~o, binary: ~b" 12 -12 13/10 12/7)]

Note that using @tt{~n} is different from using the string @racketvalfont{"\n"}
in that @tt{~n} will result in the character combination @racketvalfont{"\r\n"}
on Windows.

There are two placeholders, @tt{~v} and @tt{~s}, which are similar to @tt{~a},
but behave differently for strings and compound data.

The placeholder @tt{~v} formats values as if they would be output in an
interactive interpreter (REPL).

@examples[
  #:eval helper-eval
  (format "~v" 2)
  (format "~v" 'abc)
  (format "~v" "abc")
  (format "~v" (list 1 2 3))
  (format "~v" map)]

On the other hand, the placeholder @tt{~s} is the counterpart of the
@racket[read] function, which converts a string of Racket code, usually to an
atomic value or a list of symbols. The following examples use a helper function
@code{roundtrip} that uses the @tt{~v} placeholder from the previous paragraph
to show the data returned by the @racket[read] function. The function
@racket[open-input-string] is explained in the @secref*["Port" 'glossary]
glossary entry.

@examples[
  #:eval helper-eval
  (define (roundtrip str)
    (define read-data
      (read (open-input-string str)))
    (displayln (format "~v" read-data))
    (format "~s" read-data))
  (roundtrip "2")
  (roundtrip "map")
  (roundtrip "\"abc\"")
  (roundtrip "(+ 1 2)")]

Note that the argument of @code{roundtrip} and the result from @racket[format]
in the helper function are the same.

Apart from using @racket[format], there's another approach to format values,
the @italic{functions} @racket[~a], @racket[~v] and @racket[~s]. There's also a
function @racket[~r] for detailed formatting of numbers. The first three
functions can take multiple arguments, but the behavior may be surprising if
used with keyword arguments for width and alignment (see below).

@examples[
  #:eval helper-eval
  (code:comment "Use ~a, ~v and ~s on different types of values.")
  (~a 2)
  (~v 2)
  (~s 2)
  (~a "abc")
  (~v "abc")
  (~s "abc")
  (~a '(+ 2 3))
  (~v '(+ 2 3))
  (~s '(+ 2 3))
  (~a map)
  (~v map)
  (~s map)
  (code:comment "`~a` doesn't insert spaces on its own, so you need to add them.")
  (~a 2.5 " plus " 3 " is " 5.5)
  (code:comment "Use keywords for alignment.")
  (~a 1.23 #:width 10 #:align 'right)
  (code:comment "But keywords are _not_ applied to _each_ of the arguments.")
  (~a 1 2 3 #:width 10 #:align 'right)
  (code:comment "Number formatting.")
  (~r 12.3456 #:notation 'exponential #:precision 2 #:min-width 10)]

@entry-subsection{Output}

So far, we've only used @racket[display] and @racket[displayln] to actually
output something as we'd do it in a program. Other outputs in the examples were
formatted strings in the examples' REPL.

Here are the functions @racket[printf], @racket[print] and @racket[write] that
format @italic{and} output data:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "`printf` is like `display` and `format`.")
  (display (format "~a and ~v" "foo" "foo"))
  (printf "~a and ~v" "foo" "foo")
  (code:comment "`print` is like `display` and `format` with ~v formatting.")
  (display (format "~v" '(1 2 3)))
  (display (~v '(1 2 3)))
  (print '(1 2 3))
  (code:comment "`write` is like `display` and `format` with ~s formatting.")
  (display (format "~s" '(1 2 3)))
  (display (~s '(1 2 3)))
  (write '(1 2 3))]

All of @racket[display], @racket[print], @racket[write] and their variants with
an @tt{ln} suffix accept an optional @inline-link["Port"] argument, so you can
write the data to a file or network socket, for example. There's also a
function @racket[fprintf], which is like @racket[printf] but takes a port as
@italic{first} argument.

@entry-subsection{Serialization and deserialization}

If you want to save a data structure and restore it later, you can use
@racket[serialize] and @racket[write] to save the data and @racket[read] and
@racket[deserialize] to restore it.

@entry-subsection{Pretty-printing}

Sometimes you may want to output a nested data structure for
@inline-link["Debugging"]. You can use @racket[pretty-print] for this:
@examples[
  #:eval helper-eval
  #:label #f
  (define data
    '("This is an example line"
      "Here's another one"
      "And some nested data"
      '(1 2 3)
      "And some more text"))
  (pretty-print data)]

However, for ``short'' data, @racket[pretty-print] may insert fewer line breaks
than you'd like, or none at all:
@examples[
  #:eval helper-eval
  #:label #f
  (define data
    '("foo"
      '(1 2 3)
      "bar"))
  (pretty-print data)]

A workaround is to reduce the line width by setting the
@racket[pretty-print-columns] @inline-link["Parameter"]:
@examples[
  #:eval helper-eval
  #:label #f
  (define data
    '("foo"
      '(1 2 3)
      "bar"))
  (parameterize ([pretty-print-columns 10])
    (pretty-print data))]

In particular, setting @racket[pretty-print-columns] to 1 prints all items on
individual lines:
@examples[
  #:eval helper-eval
  #:label #f
  (define data
    '("foo"
      '(1 2 3)
      "bar"))
  (parameterize ([pretty-print-columns 1])
    (pretty-print data))]

@entry-subsection{Summary}

The following table summarizes some of the previous information:

@tabular[#:sep @hspace[1]
         #:cell-properties '((baseline))
         #:row-properties `((top-border bottom-border ,table-style-properties))
  (list
    (list @bold{Main purposes}
          @bold{@racket[format]/@racket[printf] placeholder}
          @bold{Formatting function}
          @bold{Output functions})
    (list @elem{Human-readable output, formatted string output}
          @tt{~a}
          @racket[~a]
          @elem{@racket[display], @racket[displayln]})
    (list @elem{REPL, debugging}
          @tt{~v}
          @racket[~v]
          @elem{@racket[print], @racket[println]})
    (list @elem{Processing Racket code (usually used with @racket[read])}
          @tt{~s}
          @racket[~s]
          @elem{@racket[write], @racket[writeln]})
    (list @elem{Number formatting}
          @elem{--}
          @racket[~r]
          @elem{--}))]

As shown above, there are a lot of -- often redundant -- ways to format and
output values. For a minimal and in most cases appropriate toolset, use
@itemlist[
  @item{@racket[display] and @racket[displayln] and either the @racket[format]
    function or the @racket[~a], @racket[~v], @racket[~s] and @racket[~r]
    functions}
  @item{@racket[printf]}]

@examples[
  #:eval helper-eval
  (define first-name "Bilbo")
  (define last-name "Baggins")
  (displayln (format "~a ~a" first-name last-name))
  (displayln (~a first-name " " last-name))
  (printf "~a ~a~n" first-name last-name)]

If the placeholder handling in @racket[format] and @racket[printf] isn't
enough, you can get more control over the formatting with the @racket[~a],
@racket[~v], @racket[~s] and @racket[~r] functions, for example to set a width
or alignment.

See also:
@itemlist[
  @item{@secref*['("Debugging" "Parameter" "Port" "Stream"
                   "String_character_byte_string") 'glossary] @in-g}
  @item{@secref*["read-write" 'guide] @in-rg}
  @item{@secref*['("Reading" "Writing" "Additional_String_Functions" "serialization"
                   "pretty-print" "reader" "printing") 'reference] @in-rr}]
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
  (define condition #t)
  (define my-function
    (if condition
        (lambda (x) (+ x 2))
        (lambda (x) (- x 3))))
  (my-function 3)]

See also:
@itemlist[
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
With an imperative update, every piece of code that has a
@inline-link["Binding"] to the hash will ``see'' any changes to the hash.
Depending on your design, this can be good or bad. In any case you have to be
careful that all locations where the hash is used are prepared for a change
``under their feet.''

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
@itemlist[
  @item{@secref*['("Binding" "Functional_programming_FP_" "Hash" "Naming_conventions")
                 'glossary] @in-g}]
}

@glossary-entry["Future" 'advanced #:stub? #t]{
}

@glossary-entry["Generator" 'intermediate]{

  See @secref*["Sequence_stream_generator" 'glossary]
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
data structures like @inline-link["List"]s and @inline-link["vector"]s. Hashes
can differ in the following criteria; all of the combinations are possible:
@itemlist[
  @item{Comparison for keys: @racket[equal?], @racket[eq?], @racket[eqv?]}
  @item{Mutability: immutable, mutable@linebreak{}
    Mutability applies to the hash as a whole, not to the mutability of the
    keys or the values.}
  @item{Strength: strong, weak, ephemerons@linebreak{}
    This influences when hash entries can be garbage-collected.}]
These are 3×2×3 = 18 combinations, but in practice you can almost always get by
with these four combinations:
@itemlist[
  @item{Comparison for keys: @racket[equal?], @racket[eq?]}
  @item{Mutability: immutable, mutable}
  @item{Strength: strong}]

Here's an overview of the most important APIs for these four
equality/mutability combinations:
@tabular[#:sep @hspace[1]
         #:cell-properties '((baseline))
         #:row-properties `((top-border bottom-border ,table-style-properties))
  (list
    (list @bold{Combination}
          @nonbreaking{@bold{Construction} @note-number{1, 2}}
          @nonbreaking{@bold{Set or update value} @note-number{3}}
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

@note-number{1} You can create empty hashes by calling the constructor without
arguments. For example, @racket[(hash)] creates an empty immutable hash with
@racket[equal?] key comparison.

@note-number{2} A @italic{pair} here is a regular Scheme/Racket pair, for
example @racket[(cons 1 'a)]. Pairs that contain only literals can also be
written as @racket['(1 . a)].

@note-number{3} Setting or updating a value in an immutable hash may sound
contradictory. The solution is that @racket[hash-set] causes a so-called
@inline-link["Functional update"]. That is, it returns a new hash with the
modification applied and leaves the @ti{hash} @italic{argument} unchanged. This
is the same principle that @racket[cons] or @racket[struct-copy] use.

@bold{Warnings:}
@itemlist[
  @item{If a hash entry has a mutable key (for example a vector) don't change
    the key in-place.}
  @item{Don't change a hash while iterating over it.}]

See also:
@itemlist[
  @item{@secref*['("Collection" "Equality" "Functional_update" "List" "Pair"
                   "Struct" "Vector") 'glossary] @in-g}
  @item{@secref*["hash-tables" 'guide] @in-rg}
  @item{@secref*["hashtables" 'reference] @in-rr}]
}

@glossary-entry["Higher-order function" 'basic]{

A higher-order function is a @inline-link["Procedure"]{function} that takes a
function as an argument and/or returns a function. This approach is very common
in functional programming.

Here are a few examples of higher-order functions:
@itemlist[
  @item{@racket[map] takes a function that transforms a list item to another
    item for the result list.}
  @item{@racket[filter] takes a predicate function that determines which list
    items should be included in the returned list.}
  @item{@racket[sort] takes a comparison function that determines the sort order
    of the returned list.}
  @item{@racket[compose] takes one or more functions and returns a function that
    applies the functions one after another.}]

See also:
@itemlist[
  @item{@secref*['("Function" "Functional_programming_FP_" "Predicate" "Procedure")
                 'glossary] @in-g}]
}

@glossary-entry["Hygiene" 'intermediate #:stub? #t]{
}

@glossary-entry["Identifier" 'basic]{

As in other programming languages, an identifier is a name assigned to a
@inline-link["Value"] (or a @inline-link["Form"]). Compared to most languages,
identifiers can contain a lot more characters. In Racket, all of the following
identifier names are valid:
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
@itemlist[
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

@inline-link["Procedure"]{Procedure}s can be defined and then called with
positional arguments, but also with keyword arguments.

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
    return f"Hello {name}{suffix}"

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
expression is the return value of the function call that started the recursion.

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
@itemlist[
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
@itemlist[
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

Here, @racket[let] creates the outer @inline-link["Environment"] whereas
@racket[lambda] defines the function using that environment.

See also:
@itemlist[
  @item{@secref*['("Environment" "Procedure" "Lambda" "Closure") 'glossary] @in-g}]
}

@glossary-entry["List" 'basic]{

Lists are the most widely used data structure in many functional programming
languages, including Scheme and Racket.

Scheme and Racket lists are implemented as singly-linked lists (with the
exception of the empty list, which is an atomic value). Singly-linked lists
consist of @inline-link["Pair"]s where the first value of a pair is a list item
and the second value of the pair points to the next pair. The end of the list
is denoted by an empty list as the second value of the last pair.

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
@itemlist[
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
         #:cell-properties '((baseline))
         #:row-properties `((top-border bottom-border ,table-style-properties))
  (list
    (list @bold{Pattern}
          @bold{Meaning}
          @bold{Examples})
    (list @tt{@ti{name}?}
          @elem{Predicate @note-number{1}}
          @elem{@racket[string?], @racket[null?]})
    (list @tt{@ti{name}=?}
          @elem{Comparison predicate @note-number{1}}
          @racket[string=?])
    (list @tt{@ti{name}/c}
          @elem{Contract predicate @note-number{1}}
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
          @elem{``for'' or ``with''}
          @elem{@racket[call/cc], @racket[define/match],@linebreak[]
                @racket[for/fold/derived]})
    (list @tt{@ti{type}->@ti{other-type}}
          "Conversion"
          @racket[vector->list])
    (list @tt{make-@ti{type}}
          "Create new value of type"
          @elem{@racket[make-base-namespace], @racket[make-channel]}))]

@note-number{1} Since the @tt{?} or @tt{/c} suffix already identifies a
predicate, using prefixes like ``is-'', ``has-'' etc. is redundant.

See also:
@itemlist[
  @item{@secref*['("Contract" "Functional_update" "Predicate" "Struct") 'glossary] @in-g}
  @item{@hyperlink["https://docs.racket-lang.org/style/"]{Racket Style Guide}
  for other Racket coding conventions}]
}

@glossary-entry["Number" 'basic]{

Racket and most Scheme implementations have the following number types:
@itemlist[
  @item{integer}
  @item{rational}
  @item{real}
  @item{complex}]
However, these names can mean different things in different contexts. To
understand the differences, it's useful to view the number types under a
``technical'' and a ``mathematical'' aspect.

@entry-subsection{``Technical'' number types}

@itemlist[
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

Racket and many Scheme implementations have the @inline-link["Predicate"]s
@itemlist[
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
         #:cell-properties '((baseline))
         #:row-properties `((top-border bottom-border ,table-style-properties))
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

@itemlist[
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
      (code:comment "6 times 1/6 should be 1, but it isn't, due to rounding errors.")
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
@itemlist[
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
@itemlist[
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

Apart from the meaning in @inline-link["Procedure"]{function} definitions, a
Racket parameter is a @inline-link["Thread"]-local variable. A few examples are
@racket[current-output-port],
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

Partial application takes a @inline-link["Procedure"]{function} with some
number of arguments and creates a new function that calls the original function
while hard-coding some of the arguments.

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

@glossary-entry["Port" 'basic]{

@entry-subsection{Basics}

A port represents an input or output channel; ports correspond to file handles
or file objects in other programming languages.

Using a port typically involves three steps:
@itemlist[
  @item{Create a port for input or output.}
  @item{Read data from the port or write data to the port, depending on whether
    the port was created for input or output. You can read or write data as
    strings, characters or bytes or a mixture of them, regardless of how you
    created the port.}
  @item{Close the port.}
  #:style 'ordered]

The ports for standard input, standard output or standard error already exist
on program start, so there's no need to create them. Also, you shouldn't close
any of these ports.

How do you use these special ports? Normally, you don't need to specify them
since they're the default port arguments of functions like @racket[display] or
@racket[read-line].

Here are a few useful applications of the above three steps:

@itemlist[
  @item{To read data from a file in one go, you can use
    @codeblock{
    (define input-port (open-input-port "data.txt"))
    (define content (port->string input-port))
    (close-input-port)}}
  @item{If the file is large and therefore you want to read line by
    line, use
    @codeblock{
    (define input-port (open-input-port "data.txt"))
    (for [line (in-lines input-port)]
      (work-with line))
    (close-input-port)}}
  @item{To write a string to a file, use
    @codeblock{
    (define output-port (open-output-port "data.txt"))
    (display content output-port)
    (close-output-port)}}]

The examples above describe only the basic use cases. Racket has many
more functions to read and write data as
@inline-link["String_character_byte_string" "strings, characters or bytes"].
More on that below.

There are also a few functions that close the port implicitly. For
example, the first code snippet could be written as
@codeblock{
(call-with-input-file*
  "data.txt"
  (lambda (input-port)
    (port->string input-port)))}
The function @racket[call-with-input-file*] implicitly closes the
input port, even if an exception occurs in the @racket[lambda].

@entry-subsection{Port types}

The most important port types are
@itemlist[
  @item{@bold{File ports}. Created by functions like
    @racket[open-input-file] and @racket[open-output-file].}
  @item{@bold{String ports}. Created by @racket[open-input-string] and
    @racket[open-output-string]. They're useful if an API requires a
    port, but you already have the data in memory (instead of, say, a
    file). You can read the data accumulated in the output string with
    @racket[get-output-string].}
  @item{@bold{TCP connections}. Used for network connections. For
    example, @racket[tcp-connect] connects to a host and port and
    returns an input port and an output port.}
  @item{@bold{Process pipes}. For example, the @racket[subprocess]
    function can create ports for communication with its launched
    process.}]

You might also see the term ``file stream ports.'' It refers to both
file ports and process pipes.

@entry-subsection{Port parameters}

Racket provides the @inline-link["Parameter"]{parameters}
@racket[current-input-port], @racket[current-output-port] and
@racket[current-error-port]. At program start, these parameters
correspond to standard input, standard output and standard error,
respectively.

As usual with parameters, you can change them temporarily with
@racket[parameterize], so the following example would write the output
to an output file instead of to the terminal:
@codeblock{
(parameterize ([current-output-port (open-output-port "data.txt")])
  (displayln "This goes to the file."))}
This works because @racket[displayln] outputs to
@racket[current-output-port] by default.

@entry-subsection{Function overview}

Here are some Racket functions that work with input and output ports.

@bold{Creating ports}

@tabular[#:sep @hspace[1]
         #:cell-properties '((baseline))
         #:row-properties `((top-border bottom-border ,table-style-properties))
  (list
    (list @bold{Port type}
          @bold{Input}
          @bold{Output})
    (list "File"
          @racket[open-input-file]
          @racket[open-output-file])
    (list ""
          @elem[#:style center-style]{@racket[open-input-output-file]}
          'cont)
    (list ""
          @elem{@racket[call-with-input-file*] @note-number{1}}
          @elem{@racket[call-with-output-file*] @note-number{1}})
    (list ""
          @elem{@racket[with-input-from-file] @note-number{2}}
          @elem{@racket[with-output-to-file] @note-number{3}})
    (list "String port"
          @racket[open-input-string]
          @elem{@racket[open-output-string] @note-number{4}})
    (list "TCP connection"
          @elem[#:style center-style]{@racket[tcp-connect] @note-number{5}}
          'cont)
    (list ""
          @elem[#:style center-style]{@racket[tcp-accept] @note-number{6}}
          'cont)
    (list "Process pipe"
          @elem[#:style center-style]{@racket[subprocess] @note-number{7}}
          'cont))]

@note-number{1} The created port is passed to the @code{proc} argument.
After executing @code{proc}, the file is closed, even if there was an exception
in the @code{proc}.

@note-number{2} The created port is installed as @racket[current-input-port].
After executing the thunk argument, the file is closed, even if there was an
exception in the thunk.

@note-number{3} The created port is installed as @racket[current-output-port].
After executing the thunk argument, the file is closed, even if there was an
exception in the thunk.

@note-number{4} The current string value can be queried with
@racket[get-output-string].

@note-number{5} For network clients. Returns an input port and an output port
as two values.

@note-number{6} For network servers. Returns an input port and an output port
as two values. Used with @racket[tcp-listen].

@note-number{7} If the arguments @code{stdin}, @code{stdout} and @code{stderr}
are passed as @racket[#f], @racket[subprocess] creates and returns new
corresponding input and output ports.

@bold{Reading from and writing to ports}

@tabular[#:sep @hspace[1]
         #:cell-properties '((baseline))
         #:row-properties `((top-border bottom-border ,table-style-properties))
  (list
    (list @bold{Data type}
          @bold{Input}
          @bold{Output})
    (list "String"
          @racket[read-string]
          @racket[write-string])
    (list ""
          @racket[read-line]
          @racket[displayln])
    (list ""
          @elem{@racket[in-lines] @note-number{1}}
          "")
    (list ""
          @racket[port->string]
          "")
    (list ""
          @racket[port->lines]
          "")
    (list "Char"
          @racket[read-char]
          @racket[write-char])
    (list "Byte string"
          @racket[read-bytes-line]
          @racket[write-bytes])
    (list ""
          @elem{@racket[in-bytes-lines] @note-number{2}}
          "")
    (list "Byte"
          @racket[read-byte]
          @racket[write-byte]))]

@note-number{1} Generates a sequence of strings (see
@secref*["Comprehension" 'glossary])

@note-number{2} Generates a sequence of byte strings (see
@secref*["Comprehension" 'glossary])

@bold{Closing ports}

@tabular[#:sep @hspace[1]
         #:cell-properties '((baseline))
         #:row-properties `((top-border bottom-border ,table-style-properties))
  (list
    (list @bold{Input}
          @bold{Output})
    (list @racket[close-input-port]
          @racket[close-output-port]))]

@entry-subsection{Tips and gotchas}

@itemlist[
  @item{You can read strings, chars, byte strings and bytes, but most
    of the time, you want to process the contents as strings.}
  @item{If you're sure that a file is small, you can use
    @racket[port->string] or @racket[port->lines] to read it in one
    go. If the file may be larger, read and process it line by line so
    you don't need to keep the whole content in memory.}
  @item{If an input port runs out of data, read operations return the
    special value @racket[eof], which you can check with
    @racket[eof-object?].}
  @item{If you try to open a file for writing and the file already
    exists, you'll get an exception. Use the @code{#:exists} keyword
    to deal with this situation.}
  @item{The @code{#:exists} values @racketvalfont{'truncate} and
    @racketvalfont{'update} seem very similar. However, there's an
    important difference: @racketvalfont{'truncate'} removes all data
    from the existing file. On the other hand, @racketvalfont{'update}
    overwrites existing content in the file, but leaves everything
    outside the new content intact. Hence you could accidentally keep
    data you thought to be overwritten. So if in doubt, use
    @racketvalfont{'truncate}.}
  @item{Functions like @racket[with-input-from-file] and
    @racket[with-output-to-file] implicitly close the ports they create, even
    in case of an exception. Therefore, such functions are more robust and
    hence preferable over explicit calls of @racket[close-input-port] and
    @racket[close-output-port].}
  @item{Usually, you don't want to close @racket[current-output-port]
    or @racket[current-error-port] if they refer to a terminal. You
    can use the @inline-link["Predicate"]{predicates}
    @racket[output-port?] and @racket[terminal-port?] to check for
    this situation.}
  @item{You can use @racket[copy-port] to copy data from one port
    to another.}
  @item{This glossary entry lists a lot of APIs, but they're still
    only a small part of the existing port-related APIs. So if you
    miss something, check the
    @hyperlink["https://docs.racket-lang.org/reference/"]{Racket
    Reference}.}]

See also:
@itemlist[
  @item{@secref*['("Formatting_and_output" "Parameter" "Stream"
                   "String_character_byte_string" "Thunk" "Values") 'glossary] @in-g}
  @item{@secref*["i/o" 'guide] @in-rg}
  @item{@secref*['("input-and-output" "os") 'reference] @in-rr}]
}

@glossary-entry["Predicate" 'basic]{

A predicate is a @inline-link["Procedure"] that takes one argument and returns
a boolean.

Examples:
@itemlist[
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

  See @secref*["Formatting_and_output" 'glossary]
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
  @item{@secref*['("Arity" "Keyword" "Lambda") 'glossary] @in-g}
  @item{@secref*["syntax-overview" 'guide] @in-rg}
  @item{@secref*["define" 'reference] @in-rr}]
}

@glossary-entry["Profiling" 'intermediate #:stub? #t]{
}

@glossary-entry["Prompt" 'advanced #:stub? #t]{
}

@glossary-entry["Provide" 'intermediate #:cross-reference? #t]{

  See @secref*["Module" 'glossary]
}

@glossary-entry["Quasiquote and unquote" 'intermediate]{

A variant of @racket[quote] is @racket[quasiquote], usually written as a
backtick (@literal{`}). At first sight, @racket[quasiquote] behaves exactly as
@racket[quote]:
@examples[
  #:eval helper-eval
  #:label #f
  '(+ 3 4)
  `(+ 3 4)
  'map
  `map]

However, different from @racket[quote], you can use @racket[unquote], usually
written as a comma (@tt{,}) inside @racket[quasiquote] to ``escape'' the
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

Typical use cases for quoting are writing @inline-link["Symbol"]s and lists of
literals:
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

@glossary-entry["Require" 'basic #:cross-reference? #t]{

  See @secref*["Module" 'glossary]
}

@glossary-entry["Rule (in macros; probably other uses, which ones?)" 'intermediate #:stub? #t]{
}

@glossary-entry["Safe operation" 'intermediate #:cross-reference? #t]{

  See @secref*["Unsafe_operation" 'glossary]
}

@glossary-entry["Scheme" 'basic #:stub? #t]{
}

@glossary-entry["Scope" 'basic #:stub? #t]{
}

@glossary-entry["Scribble" 'intermediate #:stub? #t]{
}

@glossary-entry["Sequence, stream, generator" 'intermediate]{

@entry-subsection{Sequences}

A sequence is a value that can be iterated over in a
@inline-link["Comprehension"] (or other @code{for} @inline-link["Form"]). For
example, @inline-link["List"]s and @inline-link["Hash"]es are sequences:
@examples[
  #:eval helper-eval
  #:label #f
  (for/list ([item '(1 2 3)])
    item)
  (for/list ([(key value) (hash 'a 1 'b 2)])
    (cons key value))]

Sequences don't have to be fixed-size containers. It's also possible to create
values on the fly, like with @racket[in-range],
@examples[
  #:eval helper-eval
  #:label #f
  (for/list ([item (in-range 2 5)])
    item)]
and even create values infinitely, like with @racket[in-naturals]:
@examples[
  #:eval helper-eval
  #:label #f
  (code:comment "Limit the iterated-over values with a sequence of limited length,")
  (code:comment "otherwise `for/list` would never finish.")
  (for/list ([unused '(a b c d e)]
             [item (in-naturals)])
    item)]

You can use @racket[sequence?] to check whether a value is a sequence:
@examples[
  #:eval helper-eval
  #:label #f
  (sequence? '(1 2 3))
  (sequence? (hash 'a 1 'b 2))
  (sequence? (in-range 2 5))
  (sequence? (in-naturals))
  (code:comment "An integer n is equivalent to `(in-range n)`")
  (sequence? 5)]

A useful feature of sequences as used in @code{for} forms, is that they're
@; Is "visible" an appropriate word here?
evaluated on demand (``lazily''). This is especially visible in
@racket[in-naturals], which would never finish if it was fully evaluated and
@emph{then} iterated over. (The iteration would never happen because the
evaluation would take infinite time.)

@entry-subsection{Streams}

In case you want to implement a lazy or even infinite sequence, the easiest
approach often is a stream.

Stream operations are very similar to list operations:
@tabular[#:sep @hspace[1]
         #:cell-properties '((baseline))
         #:row-properties `((top-border bottom-border ,table-style-properties))
  (list
    (list @bold{List operation}
          @bold{Stream operation}
          @bold{Purpose of stream operation})
    (list @racket[list]
          @racket[stream]
          @elem{Create stream from the given items (which aren't evaluated by default)})
    (list @elem{@racket['()] = @racket[null] = @racket[empty]}
          @racket[empty-stream]
          @elem{Create empty stream})
    (list @elem{@racket[null?] = @racket[empty?]}
          @racket[stream-empty?]
          @elem{Check if stream is empty})
    (list @racket[cons]
          @racket[stream-cons]
          @elem{Create stream from first item and another stream})
    (list @elem{@racket[car] = @racket[first]}
          @racket[stream-first]
          @elem{Evaluate and return first item of stream})
    (list @elem{@racket[cdr] = @racket[rest]}
          @racket[stream-rest]
          @elem{Return stream with all items but the first})
    (list @elem{@racket[map], @racket[filter], ...}
          @elem{@racket[stream-map], @racket[stream-filter], ...}
          @elem{Higher-level operations (not all list operations
                have a corresponding stream operation)}))]

The functions @racket[stream] and @racket[stream-cons] are lazy, that is,
they don't evaluate their arguments immediately. The evaluation only happens
when individual items are retrieved from the stream:
@examples[
  #:eval helper-eval
  #:label #f
  (define a-stream
    (stream
      (begin (displayln "one") 1)
      (begin (displayln "two") 2)
      (begin (displayln "three") 3)))
  (code:comment "Implicit evaluation by `stream-first`")
  (stream-first a-stream)
  (code:comment "No evaluation by `stream-rest`")
  (stream-rest a-stream)
  (code:comment "The result of an evaluation is cached, so this call")
  (code:comment "does _not_ display \"one\".")
  (stream-first a-stream)]

Since stream APIs are very similar to list APIs, you can easily convert many
list algorithms to corresponding stream algorithms. For example, assume we
want a function that returns an infinite stream of the squares of the natural
numbers. Let's start with a function that returns a @emph{list} of squares.
@examples[
  #:eval helper-eval
  #:label #f
  (define (squares-list)
    (let loop ([i 0])
      (if (> i 10)
          '()
          (cons (* i i) (loop (add1 i))))))
  (squares-list)]
Note that we use a hardcoded upper limit. We'll remove it later, but if we
didn't have the check in this list algorithm, @code{squares-list} would never
finish.

Now change @racket['()] to @racket[empty-stream] and @racket[cons] to
@racket[stream-cons]. These are the only list functions to convert in this
example.
@examples[
  #:eval helper-eval
  #:label #f
  (define (squares-stream)
    (let loop ([i 0])
      (if (> i 10)
          empty-stream
          (stream-cons (* i i) (loop (add1 i))))))
  (squares-stream)
  (stream->list (squares-stream))]

Since we want an infinite stream, remove the condition:
@examples[
  #:eval helper-eval
  #:label #f
  (define (squares-stream)
    (let loop ([i 0])
      (stream-cons (* i i) (loop (add1 i)))))
  (squares-stream)
  (code:comment "Since the stream is infinite, use `stream-take` to limit")
  (code:comment "the evaluation to the first 11 items.")
  (stream->list (stream-take (squares-stream) 11))]

Streams are also sequences, so they can be used as-is in comprehensions:
@examples[
  #:eval helper-eval
  #:label #f
  (sequence? (squares-stream))
  (code:comment "Use a parallel `in-range` to limit the generated items.")
  (for/list ([unused (in-range 11)]
             [item (squares-stream)])
    item)]

@entry-subsection{Generators}

Generators are another way to create lazy and potentially infinite sequences.
A generator definition looks similar to a @racket[lambda] definition, but a
@racket[yield] call in a generator yields an item to the caller of the
generator. When the next item is requested, the generator continues the
execution after the latest @racket[yield]. There can be any number of
@racket[yield]s in a generator.
@examples[
  #:eval helper-eval
  #:label "Example:"
  (define a-generator
    (generator ()
      (yield 1)
      (yield 2)
      (yield 3)))
  (code:comment "Three items from the `yield`s.")
  (a-generator)
  (a-generator)
  (a-generator)
  (code:comment "After that, the generator yields `(values)`.")
  (a-generator)
  (a-generator)
  (code:comment "This can be checked with `call-with-values`.")
  (call-with-values a-generator list)]

If you want to base a sequence on a generator, you can return a stop value
after the @racket[yield]s and use @racket[in-producer]:
@examples[
  #:eval helper-eval
  #:label #f
  (define a-generator
    (generator ()
      (yield 1)
      (yield 2)
      (yield 3)
      (code:comment "Stop signal")
      #f))
  (for/list ([item (in-producer a-generator #f)])
    item)]

Similarly, for our infinite squares sequence we could use
@examples[
  #:eval helper-eval
  #:label #f
  (define squares-generator
    (generator ()
      (for ([i (in-naturals)])
        (yield (* i i)))))
  (sequence? (in-producer squares-generator #f))
  (code:comment "Use a parallel `in-range` to limit the generated items.")
  (for/list ([unused (in-range 11)]
             (code:comment "No stop value since we want an infinite sequence")
             [item (in-producer squares-generator)])
    item)]

@other-languages{
  @itemlist[
    @item{Some Scheme implementations also have stream and/or sequence
      concepts, but the APIs and semantics may differ from Racket's.}
    @item{Racket generators are similar to Python's generator functions, but
      there are a few differences. See the section
      @secref*["Generators" 'reference] @in-rr for details.}]}

See also:
@itemlist[
  @item{@secref*['("Comprehension" "Form" "Hash" "Lambda" "Values") 'glossary] @in-g}
  @item{@secref*["sequences" 'guide] @in-rg}
  @item{@secref*["sequences+streams" 'reference] @in-rr}
  @item{Structure and interpretation of computer programs,
        @hyperlink["https://sarabander.github.io/sicp/html/3_002e5.xhtml#g_t3_002e5"]{section ``Streams''}}]
}

@glossary-entry["Set" 'intermediate #:stub? #t]{
}

@glossary-entry["Shadowing" 'basic]{

Shadowing means that a @inline-link["Binding"] prevents access to another
binding with the same name in an enclosing @inline-link["Scope"].

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
  @item{@secref*['("Binding" "Scope") 'glossary] @in-g}]
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

@glossary-entry["Stream" 'intermediate]{

  See @secref*["Sequence_stream_generator" 'glossary]
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
@itemlist[
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
@itemlist[
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
  @item{@secref*['("Formatting_and_output" "Port") 'glossary] @in-g}
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

Creating a struct like above creates several @inline-link["Binding"]s. One is
for the name of the struct, which can be used to create instances of the
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
@itemlist[
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

@glossary-entry["Testing" 'basic #:stub? #t]{
}

@glossary-entry["Thread" 'intermediate #:stub? #t]{
}

@glossary-entry["Thunk" 'basic]{

A thunk is a @inline-link["Procedure"]{function} that takes no arguments.
Thunks are typically used to evaluate some code conditionally or at a later
time (``lazily''). For example, assume that we want a variant of the
@racket[if] form that prints whether it evaluates the first or the second
branch. Defining @code{verbose-if} like

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

Different from most other languages, a @inline-link["Procedure"]{function} in
Scheme and Racket can return multiple values. The most basic function that can
do this is @racket[values]:
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
@itemlist[
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
@itemlist[
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
@itemlist[
  @item{@secref*["Boolean" 'glossary] @in-g}
  @item{@secref*["void" 'reference] @in-rr}]
}

@glossary-entry["Will" 'advanced #:stub? #t]{
}

@glossary-entry["Write" 'basic #:cross-reference? #t]{

  See @secref*["Formatting_and_output" 'glossary]
}

@glossary-entry["Writer" 'advanced #:stub? #t]{
}
