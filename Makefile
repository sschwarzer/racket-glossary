# Makefile for `racket-glossary` work.
#
# The file assumes that the directory with the makefile is the current directory.

.PHONY: scribble
scribble:
	@# The `raco setup` command won't work unless `racket-glossary` is already
	@# installed.
	-@raco pkg install -j 1
	raco setup -j 1 --only racket-glossary

.PHONY: print-doc-url
print-doc-url:
	@echo "file://${PWD}/doc/racket-glossary/index.html"

.PHONY: stats
stats:
	racket glossary-stats.rkt

.PHONY: local-http-server
local-http-server:
	( cd doc && python -m http.server >/dev/null 2>&1 ) &
