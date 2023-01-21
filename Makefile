# Environment variables
SHELL=/bin/bash
.DEFAULT_GOAL=help

PRE_COMMIT_BINARY := $(shell command -v pre-commit 2>/dev/null)
AG_BINARY := $(shell command -v ag 2>/dev/null)
ENTR_BINARY := $(shell command -v entr 2>/dev/null)

YARN_BINARY := $(shell command -v yarn 2>/dev/null)

init: .git/hooks/pre-commit

watch:
ifndef ENTR_BINARY
	$(warning entr not found. Please install entr https://eradman.com/entrproject/)
else
ifndef AG_BINARY
	$(warning ag not found.  Please install Silver Searcher https://geoff.greer.fm/ag/)
else
	$(AG_BINARY) -l | $(ENTR_BINARY) make -s pre-commit
endif
endif

.git/hooks/pre-commit:
	$(PRE_COMMIT_BINARY) install --install-hooks -t pre-commit -t commit-msg

pre-commit: .git/hooks/pre-commit
	$(PRE_COMMIT_BINARY) run --all-files

.PHONY: help ## Displays help for make targets
help:
	@grep -E \
		'^.PHONY: .*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ".PHONY: |## "}; {printf "\033[36m%-16s\033[0m %s\n", $$2, $$3}'

build:
	./build_ngx_suite.sh

push:
	./push_ngx_suite.sh