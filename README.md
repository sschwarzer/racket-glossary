# Racket Glossary

This project hopefully will result in a glossary to be included in the
[Racket](https://racket-lang.org/) documentation to help primarily Racket
beginners and intermediate users understand Racket concepts and interactions
between them.

## Purpose

- Give definitions of terms used in Racket and Scheme in general.

- Help beginning and intermediate users understand terms encountered in the
  Racket documentation. Assume that readers are familiar with imperative
  programming, but not with functional programming, Scheme and Racket.
  Therefore, some entries may contain comparisons with related features in
  other programming languages.

- Provide context. So some entries may have more content than you'd usually
  expect from a glossary.

## Format

I'd like to see this glossary end up in the Racket documentation, so eventually
it needs to be converted to Racket's documentation language
[Scribble](https://docs.racket-lang.org/scribble/). On the other hand, I think
we should use a simpler format like Markdown for easier contributions until the
content is good enough to be included in the Racket documentation.

Ideally, it would be great if there was a tool to convert Markdown to Scribble
automatically. I haven't found one yet. The open source go-to tool for text
format conversions is [Pandoc](https://pandoc.org/), but while it supports
different Markdown dialects as input formats, it currently doesn't support
Scribble as output format. However, it should be possible to write a [custom
Pandoc writer](https://pandoc.org/custom-writers.html) to support Scribble as
an output format. That's something for a different project though. ;-)

## Contributions

At the moment, the file `glossary.md` contains only a list of terms to be
included in the glossary.

My current plan to build the glossary is:

1. Get feedback on the selection of the terms. For example, is something
   missing?
2. Convert the terms to headings and add some of my thoughts as stubs to build
   upon.
3. Wait for contributors to offer pull requests. :-)

I suggest doing step 1 on the [Racket
Discourse](https://racket.discourse.group/) instance.

## License

See the file [LICENSE](./LICENSE).
