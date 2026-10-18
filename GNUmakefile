SHELL := /usr/bin/bash
.SHELLFLAGS := -euo pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

CRYSTAL ?= crystal
SHARDS ?= shards
CRSTLINT ?= crstlint
PREFIX ?= /usr/local
DESTDIR ?=
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
DOCDIR ?= $(DATADIR)/doc/crystal-crypto-samples

SRCS := $(shell find src -name '*.cr' 2>/dev/null)
SPECS := $(shell find spec -name '*.cr' 2>/dev/null)
RST_FILES := $(wildcard *.rst) $(shell find docs -type f -name '*.rst' 2>/dev/null)

.DEFAULT_GOAL := all
.PHONY: all build test spec check lint doc-check format docs install uninstall clean distclean help

all: lint test build ## Run linters, test suite, and build sample binary

bin:
	mkdir -p $@

lib: shard.yml
	$(SHARDS) install
	rm -f shard.lock
	touch $@

bin/ameba: | lib bin
	@if [ ! -x $@ ] && [ -f lib/ameba/src/cli.cr ]; then \
		$(CRYSTAL) build lib/ameba/src/cli.cr -o $@; \
	fi

bin/flaw: | lib bin
	@if [ ! -x $@ ] && [ -f lib/flaw/src/cli.cr ]; then \
		$(CRYSTAL) build lib/flaw/src/cli.cr -o $@; \
	fi

bin/crystal-crypto-samples: $(SRCS) | lib bin
	$(CRYSTAL) build src/crystal_crypto_samples.cr -o $@

build: bin/crystal-crypto-samples ## Build the crystal-crypto-samples executable

test: spec ## Execute the Crystal spec suite

spec: | lib
	$(CRYSTAL) spec --error-trace

check: lint test doc-check ## Run linters, test suite, and documentation validation

lint: bin/ameba bin/flaw ## Run Ameba (--all) and Flaw static analyzers
	$(CRYSTAL) tool format --check src spec
	./bin/ameba --all
	./bin/flaw scan .

doc-check: ## Validate RST documentation with crstlint and rstcheck
	@if command -v $(CRSTLINT) >/dev/null 2>&1; then $(CRSTLINT) -r .; fi
	@if command -v rstcheck >/dev/null 2>&1; then rstcheck $(RST_FILES); fi

format: ## Format Crystal source and spec files
	$(CRYSTAL) tool format src spec

docs: | lib ## Generate Crystal API documentation and Sphinx dirhtml portal
	$(CRYSTAL) docs --output=docs/technical/api
	@if command -v sphinx-build >/dev/null 2>&1; then $(MAKE) -C docs dirhtml; fi

install: bin/crystal-crypto-samples docs ## Install binary and documentation
	install -d $(DESTDIR)$(BINDIR)
	install -m 0755 bin/crystal-crypto-samples $(DESTDIR)$(BINDIR)/crystal-crypto-samples
	install -d $(DESTDIR)$(DOCDIR)
	cp -r docs/* $(DESTDIR)$(DOCDIR)/

uninstall: ## Remove installed binary and documentation
	rm -f $(DESTDIR)$(BINDIR)/crystal-crypto-samples
	rm -rf $(DESTDIR)$(DOCDIR)

clean: ## Remove build artifacts and generated documentation
	rm -rf docs/technical/api docs/build public .crystal bin shard.lock

distclean: clean ## Remove all build outputs and installed shard dependencies
	rm -rf lib .shards

help: ## Display available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
