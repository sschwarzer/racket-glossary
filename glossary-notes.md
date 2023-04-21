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

## Arity

Done

## Assignment

Done

## Binding

Done

## Boolean

Done

## Box

Done

## Call

-> Procedure

## Channel

## Chaperone

## Class

- Classes and objects aren't as important in Racket as in OOP languages.
- Typically structs and operations on them are used
- -> Struct
- Read more about the object system
- Recommended object creation is with `new`:
  [New vs instantiate vs make-object](https://racket.discourse.group/t/new-vs-instantiate-vs-make-object/1230/1)

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
- Similar: https://docs.racket-lang.org/reference/dicts.html
- Mention https://alex-hhh.github.io/2019/02/racket-data-structures.html ?
- Maybe take some inspiration from
  https://docs.racket-lang.org/rebellion/Collections.html
- https://github.com/racket/racket/wiki/Choosing-a-data-structure

## Combinator

## Comprehension

- `for` forms that return a value.
- `for` alone is only for side effects.
- Similar to Python (list, dict, set) comprehensions, but can be extended to
  other data types.
- `for/list`, `for/vector` etc.
- Forms without `*` iterate in parallel.
- Forms with `*` nest loops.
- `for/and` etc. aren't comprehensions. They return only one value from the
  last executed iteration.
- `for` forms support a lot of keywords. Possible approach: Remember only the
  most frequently used keywords and otherwise use `map`, `filter` and named
  `let`.
- Example showing the same functionality with different forms/approaches?

## Cons cell

-> Pair

## Continuation

## Contract

## Core form

## Custodian

## Debugging

- Debugging code that uses immutable values (pure functions) is often easier
  than debugging in imperative languages with state changes.
- Displayln is always possible
- Tracing: <https://docs.racket-lang.org/reference/debugging.html>
- No command line debugger, but see
  <https://docs.racket-lang.org/debug/index.html#%28part._debug-repl%29>
- Debugging in DrRacket
- Research libraries
  - <https://docs.racket-lang.org/debug/index.html>
  - <https://docs.racket-lang.org/mischief/Structured_Debugging.html>

## Definition

- `define`
  - Define name/value binding
  - Define functions (syntactic sugar for `define` name/value and `lambda`)
- But also a multitude of other definion forms. Maybe only mention some without
  a real explanation?
- Or maybe there are a few definition forms that stand out and/or are often
  useful?

## Display

- I don't know yet if "Display" and "Format" should be separate entries or if
  "Display" should be a reference to "Format", where everything is explained.
- For now collect bullet points under "Format" until I have a better
  understanding of the relationships.

-> Format

## DrRacket

- The closest thing to a Racket GUI
- Describe a few features
- Give an idea about what is possible

## DSL (domain-specific language)

## Environment

- Names/values that can be accessed in a scope
- Is this the usual definition or are there other meanings of "environment"?
- Relationship to "namespace"?

## Equality

- At least three different equality predicates. Explain them, at least
  superficially.
  - `equal?`
  - `eq?`
  - `eqv?`
- `=` is for numbers only.
- Custom equality comparisons typically have the form `type=?`, e.g. `string=?`.
- But often `equal?` works well, for example for nested lists or structs.
- See also <https://racket.discourse.group/t/custom-equality-predicate/1086>
- Caveats:
  - Struct comparisons depends on whether a struct is transparent.
  - Integer numbers may compare equal with `eq?`, even if they appear to be
    different objects. Don't rely on comparing numbers with `eq?`. Again, `eq?`
    is usually irrelevant for immutable objects. You should rather use `=`,
    `equal?` or `eqv?`.
- `eq?` is like Python's `is` operator.

## Exact number

- Scheme has a distinction between exact and inexact numbers.
- Check definition / read documentation

## Executor

## Exception

## Expression

- Code that can be evaluated to a result (even if the result is `void` or
  `undefined`)
- Examples:
  - Literals, e.g. 3, "foo", 'bar
  - Functions, e.g. `+`, `map`, `filter`, `sort`
  - Function application, e.g. `(+ 2 3)`
  - Forms that have a result, e.g. `(and #t #f)`, `(if condition? 1 2)`
- Some forms don't have result, e.g. `(define foo (define bar 2))` gives
  `define: not allowed in an expression context`. Show Racket example.
- To check whether something is an expression, you can assign it with `define`:
  `(define foo presumable-expression)`.
  - Or not. This has lots of caveats. If you get an error message here, it
    could be because of many other reasons.
- Safer: use a predicate that accepts any value, e.g. `number?`
- Although most expressions result in exactly one value, an expression can
  result in more than one value. See `Values` entry.
- See also <https://docs.racket-lang.org/reference/eval-model.html>

## Field

- Struct field
- Just refer to "Struct"?
- Or are there other definitions of "field"?

## Fixnum

- "Machine" integer value, typically 64 bit
- But not in Racket, see
  <https://docs.racket-lang.org/guide/performance.html#%28tech._fixnum%29> and
  <https://docs.racket-lang.org/reference/fixnums.html>

## Flat contract

## Flonum

- "Machine" float value, typically 64 bit, IEEE 754

## Fold

- Take a list (or generally sequence) and combine ("fold") it into a single
  result.
- Example: Sum list items, return the sum.
- Mention `foldl`, `foldr`
- There are other functions or forms that do folding, e.g. `for/fold`,
  `for/and`, `for/or`, `fold-files`, `sequence-fold`. (Probably not worth it to
  mention all of these, though.)
- https://en.wikipedia.org/wiki/Fold_(higher-order_function)

## Form

## Formatting and output

- https://docs.racket-lang.org/guide/read-write.html has a comparison of
  `print`, `write` and `display` with examples.
  - `print` shows data as in the REPL ("only" by default?)
    - corresponds to `~v`
  - `write` shows data in a way that can be read back into Racket
    - However, `(write 'foo)` emits `foo`. Shouldn't it emit `'foo`, since this
      is the format the reader would read?
    - corresponds to `~s`
  - `display` shows data for end users. For example, quotes around strings are
    omitted.
    - corresponds to `~a`
- Under "Language Model"
  - https://docs.racket-lang.org/reference/reader.html
    (since reading and writing are quite related)
  - https://docs.racket-lang.org/reference/printing.html
- Under "Input and output"
  - https://docs.racket-lang.org/reference/Reading.html
  - https://docs.racket-lang.org/reference/Writing.html
- https://docs.racket-lang.org/reference/strings.html#%28mod-path._racket%2Fformat%29
  discusses the _functions_ `~a`, `~v` etc.
- Use `display`/`~a` for end-user output
- `print` is only available in Racket, `display` and `write` also in Scheme.
- In the REPL, it's helpful to have data printed as it's written in code, for
  example to distinguish the string `"foo"` from the symbol `'foo`. `display`
  generates the same output for both the string and the symbol.
- Mention pretty-printing. Include one or more examples.
- Explain difference between the _placeholders_ (like `~a`) and the _function_
  with the same name. Even better: `display` vs. function `~a` vs. placeholder
  `~a`.
- Organize some of the information in one or more tables.
- Questions
  - Why doesn't `(write 'foo)` show `'foo`?
  - What are "quoting depth" and "quotable"? The paragraph at
    https://docs.racket-lang.org/reference/printing.html#%28tech._quoting._depth%29
    isn't really helpful. What's the meaning/purpose of these concepts or the
    values 0 or 1 for the quoting depth?

    I experimented with different settings of the quoting depth in `print`, but
    didn't see a difference. Are there examples to see the effect of the
    quoting depth and what "quotable" means?
  - Why are there so many parameters for reading and writing? See the
    parameters listed under
    https://docs.racket-lang.org/reference/Reading.html#%28def._%28%28quote._~23~25kernel%29._read-case-sensitive%29%29
    and
    https://docs.racket-lang.org/reference/Writing.html#%28def._%28%28quote._~23~25kernel%29._print-pair-curly-braces%29%29
    Having so many parameters looks overengineered.

## Function

-> Procedure

## Functional programming (FP)

- Explain core ideas
  - Mathematical functions (inputs -> outputs, no side effects)
  - Expressions, not statements (example: `if`)
- Separate pure and impure functions (procedures) to gain FP advantages, i.e.
  easier reasoning and testing
- Recursion instead of loops
  - Big stack sizes
  - Tail call optimization
- Show some "typical idioms"
  - Idea: Show how to do things "functionally" instead of "imperatively", so
    newcomers don't try to program imperatively in Racket
  - Recursion (`map` function)
  - Higher-order functions (`map`, `filter`, `fold`)
  - Comprehensions (for forms)
  - Build an immutable hash
  - Use an immutable hash as cache by passing it as argument

## Functional update

- Don't mutate a value (e.g. hash) in-place
- Instead leave the argument value unchanged and return a changed copy
- Mutation in-place typically has an `!` at the end of the name.
- For example, explain `hash-set` vs. `hash-set!`, with example code

## Future

## Generator

## Generic API

## GUI programming

## Hash

- Also called hash table, hash map, map, dictionary
- Map key to value
- Keys and values can be arbitrary values.
- Three "dimensions", i.e. 3x2x2=12 combinations
  - Equality (equal?, eq?, eqv?, see Equality)
  - Mutability (immutable, mutable)
  - Strength (strong/weak/ephemerons)
  - Emphasize what's usually needed:
    `equal?`, `eq?` (symbol keys), immutable, mutable, strong
- Different constructor types
  - Keys and values one after another
  - "Assocs"
- Show examples
  - Maybe: How to build an immutable hash (folding, e.g. for/fold)
- See also Collection, Equality, Functional update

## Higher-order function

- Function that takes a function as an argument and/or returns a function
- Very typical for FP languages
- Examples: `map`, `filter`, `sort` (comparison procedure), `compose`.

## Hygiene

## Identifier

- Name of a binding
- Differences to identifiers in other languages
- Many more different characters allowed, e.g. all in `!@$%^&*-=+.<>/?`
- -> "Binding", "Naming conventions"

## Identity

- one and the same object
- can be checked with `eq?`
- important when the object(s) in question are mutable (example: vectors)

## Impersonator

## Inexact number

-> Exact number

## Inspector

## Interface (API)

## Interface (OOP)

## Keyword arguments (positional and keyword args are separate)

- Be careful with the terminology, "parameter" (in signature) vs. "argument"
  (in call). Racket only uses "keyword", I think, not "keyword argument."
  -> Check this in the Racket documentation.
- Functions can take keyword arguments.
- Keywords look like `#:keyword argument-name`.
- The argument name can be different from the keyword name, but typically
  they're the same. (Using different names just would be mental overhead.)
  Having different names for keywords and arguments also means that the
  keyword names are part of the API, but parameter names aren't.
- In procedure applications, keywords/value pairs can be listed in any order;
  and they can be mixed with positional arguments (but positional arguments are
  assigned in the same order as in the parameters in the function signature.
  (Show examples.)
- Keyword arguments are completely separate from positional arguments.
  There's no way pass an argument declared as positional argument with
  a keyword. Conversely, there's no way to pass a keyword argument without
  the keyword.
- Therefore, keyword arguments and argument defaults are separate concepts.
  You can have positional arguments with defaults and keyword arguments without
  defaults. (But defaults for keyword arguments are much more common than for
  positional arguments.)
- Other languages: compare with Python
  - (Unless `/` and `*` are used) arguments can be passed as positional or
    keyword arguments and vice versa.
  - When passing a keyword argument, the key is the same as the argument name,
    whereas in Racket the keyword name and argument name are unrelated.
  - Careful: Don't write _too_ much about how Racket differs from Python. If
    Python's semantics is explained in too much detail, readers may later
    confuse Python's and Racket's semantics!

## Lambda

Done

## Lang (as in ‘\#lang‘)

## Language-oriented programming

## Let

- Different forms
  - `let`
    - Bindings can't reference others
  - `let*`
    - Bindings _can_ reference other bindings.
    - Think `let*` as nested `let` forms.
  - `letrec`
  - "named let" - has its own entry. Or maybe it _should_ be explained in the
    "Let" entry? I'm not sure yet inhowfar "named let" is "fundamentally
    different" enough to have its dedicated entry. At least "named let" is more
    complicated than the other forms.
    - Compromise: Explain "named let" in the "Let" entry and make "Named let" a
      cross reference to "Let".
- Different coding styles
  - Prefer `let` forms over internal `define`
    - Makes scope more explicit
    - But can make code look more convoluted
  vs.
  - Prefer internal `define` over `let` forms (recommended by [Racket coding
    conventions](https://docs.racket-lang.org/style/index.html)).
    - Scopes are less explicit
    - Usually looks cleaner though
- `let` forms in the Racket guide:
  <https://docs.racket-lang.org/guide/let.html>
- `let` forms in the Racket reference:
  <https://docs.racket-lang.org/reference/let.html>
- Explain/mention `let-values` etc.? I think that's too specialized for the
  glossary.

## Let over lambda

-
  ```scribble
  "Let over lambda is a nickname given to a lexical closure." - Doug Hoyte, in
  @hyperlink["https://letoverlambda.com/textmode.cl/guest/chap2.html#sec_5doc"]{Let
  over Lambda}
  ```

## List

- Show singly-linked list data structures.
- Discusss data sharing if lists are "consed on."
- Mention growable vectors for people looking for an equivalent of "lists" from
  other languages. But mention that Racket lists are fine for many applications
  and have much better library support than growable vectors.

## Location

Done

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
- A macro question, with several solutions:
  [Macro Template Syntax Quasi-Quote with
  Ellipses](https://racket.discourse.group/t/macro-template-syntax-quasi-quote-with-ellipses/1179/4)
- From Racket Slack:
  sorawee
    I think a good practice for Racket macros is syntax/parse, and there are
    two styles:

    - Auto-adding #' variant: use define-syntax-parse-rule
    - Explicit #' variant: use define-syntax + syntax-parse

    I usually default to auto-adding #', since you can escape from the syntax
    template back to Racket world with #:with anyway

    ```
    #lang racket

    (require syntax/parse/define)

    (define xs (list 1 2 3))

    (define-syntax-parse-rule (uncons (var rest) body ...)
      #:with ooo (quote-syntax ...)
        (match xs
            [(list var rest ooo) body ...]))

            (uncons (1 a) 42)
    ```

## Match

## Match transformer

## Method

## Module

## Named let

-> Let

## Namespace

- Relationship to "environment"?

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

- Confusing: "integer" can mean something like 123456789 (no decimal point),
  but it may also refer to the `integer?` predicate result. So in a way, 2.0
  may not be an integer even though `(integer? 2.0)` is `#t`!

  What about real numbers vs. `real?`? "Real" literals are typically called
  float, but there's potential for confusion because in the context of other
  languages (and perhaps even in the context of Scheme and Racket?) "float" and
  "real" may be used synonymously.

  It's a mess. :-/
- Number data types (Should we actually call these "data types"? See above.)
  - integer
  - rational
  - real
  - complex
  - As far as predicates like `integer?`, `rational?`, `real?` and `complex?`
    go, if a predicate gives `#t` for a given number, the predicates further
    down also give `#t` for the same number. (I suppose that's the "numeric
    tower" thing at work.)
- Suggestion from Philip McGrath on Slack: Treat fixnums only as implementation
  detail. → Don't discuss them in the Numbers entry.
- Number predicates don't check just the machine type!
  - For example, `(integer? 2.0)` is `#t`!
  - However, `fixnum?` and `flonum?` _do_ react to the type.
- As I understand <https://docs.racket-lang.org/reference/numbers.html>,
  a complex number isn't a flonum, but its real/imaginary _parts_ may be.
- Behavior of different equality functions (`eq?`, `equal?`, `eqv?`, `=`)?
  Only use `=` (and `>`, `>=` etc.) for numerical comparisons.
- Depending on exactness, operations can have different results. Examples:
  - `(real? 1.0+0i)` returns `#t`, but `(real? 1.0+0.0i)` returns `#f`.
  - `(/ 1 0)` raises an exception, but `(/ 1 0.0)` returns `+inf.0`. Yikes!
  - `(/ 0.0 0)` raises an exception, but `(/ 0.0 0.0)` returns `+nan.0`.
- Other (potentially) surprising behavior:
  - `(inexact->exact 1.2)` doesn't round or gives an exception, but tries to
    approximate with a rational number and returns
    5404319552844595/4503599627370496. This _kind of_ makes sense, but may not
    be what a user expects.
  - A fixnum doesn't necessarily fit in 32 or 64 bits (because some bits are
    used as flags).
- I posted a related message on the Racket Discourse:
  <https://racket.discourse.group/t/number-oddities/1171>
- Instead of explaining everything (types, exactness, fixnums, flonums) in
  detail, "just" give practical tips?
  - Ensure that input data is converted to the exactness you want the result to
    have. See my example in the Discourse post
    <https://racket.discourse.group/t/number-oddities/1171/5>.
- See also:
  - Numeric tower
  - Exact/inexact
  - Fixnum/flonum

## Numeric tower

- Types "including" other types.
- For example, `rational` includes `integer` and `real` includes `rational`.
- `complex` includes every "mathematical" number type.
- [Wikipedia article](https://en.wikipedia.org/wiki/Numerical_tower)

## Opaque

- See "struct"

## Package

## Pair

Done

## Parameter

- Thread-local variable
- Define with `(make-parameter parameter-name)`
- Set with `(parameter-name new-value)`
- Query with `(parameter-name)`
- Use `parameterize` to temporarily set a parameter
- `parameterize` is somewhat similar to the `let` forms
- Typical examples (often starting with `current-`):
  - `current-output-port`
  - `current-command-line-arguments`
  - `current-directory`
  - `current-environment-variables`

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

- Racket has two separate currying functions: `curry`, which hardcodes the
  leftmost arguments, and `curryr` which hardcodes the rightmost arguments.

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

- Procedure taking one argument and returning `#t` or `#f`.
- Typically used to make a decision on values.
- Examples:
  - [filter](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Fprivate%2Flist..rkt%29._filter%29%29)
  - [takef](https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._takef%29%29)
- See also:
  - Procedure

## Print

## Procedure

- Describe synonym "function"
  - Often a direct synonym
  - Sometimes a procedure without side effects, a "pure function"

## Profiling

## Prompt

## Provide

## Quasiquote and unquote

- `quasiquote` = backtick
- `unquote` = `,`
- `unquote` is only valid inside `quasiquote`

## Quote

- Quoting causes the quoted content to be "taken literally."
- Syntax `(quote ...)` looks less "special," but `'content` is _much_ more
  common.
- Careful with "double quoting", e.g. `'(1 2 'a)`.
- Frequent uses:
  - Symbols `'foo`
  - List of literal values, e.g. numbers or strings
- Mention quasiquoting and splice quoting? Maybe only mention it, so that
  readers know where to look when they come across those concepts/syntaxes.

See also
- List
- Symbol

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

- Can be used as a generic term, see
  <https://docs.racket-lang.org/reference/sets.html>
- Or specifically in the sense of "hash set" (similar to hash tables), see
  <https://docs.racket-lang.org/reference/sets.html#%28part._.Hash_.Sets%29>

## Shadowing

- Binding with the same name shadows a binding with the same name in an
  enclosing scope.
- Show example with `let`

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

- Everything installed by the official installers and explained in the Racket
  Reference.
- "Package `base`? See <https://pkgs.racket-lang.org/package/base>
- Discussion at
  <https://racket.discourse.group/t/whats-official-racket-and-whats-not/1447>
  The thread refers to a ticket that lists the contents of the main
  distribution here:
  <https://pkgs.racket-lang.org/package/main-distribution>

## Stream

- Overlap with sequences (see also there).
- Usually used with files.

## String / byte string / character

- Don't go into too much detail! What would be especially of interest for a new
  user of Racket? What _tasks_ are interesting?
  - Creating strings
  - Printing strings
  - Convert strings between encodings? Or assume UTF-8 by default?
- Semantics
  - Strings for most processing of human-readable strings
  - Characters as units of strings. Characters correspond to code points.
  - Byte strings as encoded representation of strings.
    "Other languagges": Different from, say, Python, bytes aren't used for
    arbitrary binary data.
- Input syntax for strings, byte strings and characters
  - `"foo"` for strings. Backslash-escaping for `"` and some special
    characters, say, `"\n"`.
  - `#"foo"` for byte strings, quoting as for strings.
  - `#\A` (character), `#\007` (octal), `#\u1234` (hex) or `#\U12345678` (hex)
    for characters
- String positions correspond to code points, not necessarily graphemes
  ("characters"). A string position/code point is only identical to a grapheme
  if the code points itself has a grapheme representation.
- Unicode normalization functions in the standard library, e.g.
  <https://docs.racket-lang.org/reference/strings.html#%28def._%28%28quote._~23~25kernel%29._string-normalize-nfd%29%29>
- Strings and byte strings can be mutable or immutable
- String and byte string literals are immutable
- Strings and characters are encoding-agnostic (since they only store code
  points).
- Encoding handling
- `string-ref` uses 0-based indexing, as other "ref functions" on containers.

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

- Not usually found in other programming languages
- Symbols are often used for enumerations, for example in `open-output-file`,
  <https://docs.racket-lang.org/reference/file-ports.html#%28def._%28%28lib._racket%2Fprivate%2Fbase..rkt%29._open-output-file%29%29>.
- Used to process code as data, e.g. `'(map pred? a-list)` is a list of
  symbols. (Note the quote character `'`.)
- _By default_, symbols are interned. This means the same symbol literal refers
  to the same object. `(eq? 'foo 'foo)` -> `#t`.
- It's possible to convert between strings and symbols with `string->symbol`
  and `symbol->string`.
- Since the "same" symbols compare `eq?`, hashes with symbols as keys are usually
  created with `hasheq` and variants, so the lookup is faster (it's just a
  pointer comparison).

## Syntactic form

## Syntax (different meanings)

## Syntax transformer

## Tail call

- Related:
  - Tail position
  - Tail call optimization

## Tail position

## Thread

- [Recommended Approach to Locks](https://racket.discourse.group/t/recommended-approach-to-locks/1228)
  especially Simon's post

## Thunk

- Technically, a function without arguments
- Control (e.g. delay/prevent) the execution of some code conditionally
  - Relationship to higher-order functions?
- Example uses:
  - <https://docs.racket-lang.org/reference/file-ports.html#%28def._%28%28lib._racket%2Fprivate%2Fbase..rkt%29._with-input-from-file%29%29>
  - <https://docs.racket-lang.org/reference/file-ports.html#%28def._%28%28lib._racket%2Fprivate%2Fbase..rkt%29._with-input-from-file%29%29>
- See also:
  - <https://en.wikipedia.org/wiki/Thunk>
  - <https://stackoverflow.com/questions/925365/>
  - <https://www.cs.rhodes.edu/~kirlinp/rhodes/proglang/s13/360-lect12-slides.pdf>
  - <https://academic.udayton.edu/saverioperugini/courses/cps343/lecture_notes/lazyevaluation.html>
  - <https://www.scheme.com/tspl4/start.html> (search for "thunk")

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

- Typically, expressions evaluate to a single value.
- However, expressions can evaluate to multiple values.
- Show examples of functions that return multiple values.
  - `values`
  - others
- Show tools to work with multiple values
  - `define-values`
  - `let-values`
  - `match`?
  - others?
- The concept isn't present in most languages. In most languages, "multiple
  values" means a single value (e.g. tuple or list) with multiple items.
  Put this under "Other languages."

## Vector

- Fixed size
- Items at adjacent memory locations
- Mutable and immutable vectors
- Access at random positions takes constant time.
- Mention growable vectors

## Void

- See <https://docs.racket-lang.org/reference/void.html>
- Special value that is returned in cases where there's no interesting
  result (procedures with side effects).
- Also default result if no `cond` or `case` clause matches.
- Can be created with `(void)`.
- Can be a useful "not set" value if `#f` is a valid value.
- Since the `#<void>` value isn't printed, `(void expression)` can be useful if
  you want to evaluate an expression on the top level without showing its
  result.

## Will

## Write

## Writer

----

## Information that doesn't fit into a specific glossary entry
