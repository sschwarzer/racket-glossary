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

## Preview

This Racket glossary isn't available on the [Racket package
server](https://pkgs.racket-lang.org/) yet. I plan to publish the glossary as a
package when the "basic" category is about complete.

In the meantime, you can preview the current glossary version as rendered HTML
with:

1. [Download and install Racket](https://pkgs.racket-lang.org/) (if not done
   already)

2. Install the glossary package

       raco pkg install git+https://github.com/sschwarzer/racket-glossary

3. Open the HTML version of the glossary

       raco docs racket-glossary

You can update the package with

    raco pkg update git+https://github.com/sschwarzer/racket-glossary

If you want to remove the package, use

    raco pkg remove racket-glossary

## Contributions

I'm still experimenting with the writing approach and want to write more
glossary entries myself before I settle.

I'll surely need some feedback, especially on the intermediate and advanced
entries. I recommend that you, at least for now, make contributions as pull
requests to the [glossary-notes.md file](./glossary-notes.md). See the
beginning of that file for information on what to add there.

Although not strictly necessary, I'd appreciate it if you wrote commit messages
according to [these rules](https://cbea.ms/git-commit/#seven-rules).

## License

See the file [LICENSE](./LICENSE).
