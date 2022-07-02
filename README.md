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

- Provide context. Most entries have more content than you'd usually expect
  from a glossary.

## Preview

You can see the current state of the glossary on the [Racket package
server](https://docs.racket-lang.org/racket-glossary/).

At the moment, the completion state (generated with the
[glossary-stats.rkt](./glossary-stats.rkt) script) is:

```text
Completion stats, ignoring cross references:

basic        |■■■■■■■■■■■■······································|  15 of  60 done
intermediate |■■■···············································|   2 of  33 done
advanced     |··················································|   0 of  25 done

total        |■■■■■■■···········································|  17 of 118 done
```

## Contributions

I'm still experimenting with the writing approach and want to write more
glossary entries myself before I settle.

I'll surely need some feedback, especially on the intermediate and advanced
entries. I recommend that you, at least for now, make contributions as [pull
requests](https://github.com/sschwarzer/racket-glossary) to the
[glossary-notes.md file](./glossary-notes.md). See the beginning of that file
for information on what to add there.

Although not strictly necessary, I'd appreciate it if you wrote commit messages
according to [these rules](https://cbea.ms/git-commit/#seven-rules).

## License

See the file [LICENSE](./LICENSE).
