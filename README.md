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

basic        |■■■■■■■■■■■■■■■■■■■·······························|  22 of  59 done
intermediate |■■■···············································|   2 of  34 done
advanced     |··················································|   0 of  25 done

total        |■■■■■■■■■■········································|  24 of 118 done
```

## Contributions

I'll surely need some feedback, especially on the intermediate and advanced
entries. There are several contribution channels:

- [Send feedback](mailto:~sschwarzer/racket-glossary@lists.sr.ht) to the
  [mailing list](https://lists.sr.ht/~sschwarzer/racket-glossary) (no list
  subscription necessary).

If you want to send commits, you can:

- Send diffs (for example, created with `git diff`) to the mailing list (see
  above).

- Send a URL for a public repository of yours to the mailing list (see
  above). I'll pull from there and contact you with feedback, if necessary.

- Enter a [pull request](https://github.com/sschwarzer/racket-glossary) on
  Github.

I recommend that you, at least for now, make contributions to the
[glossary-notes.md file](./glossary-notes.md). See the beginning of that file
for information on what to add there.

Although not strictly necessary, I'd appreciate it if you wrote commit messages
according to [these rules](https://cbea.ms/git-commit/#seven-rules).

## License

See the file [LICENSE](./LICENSE).
