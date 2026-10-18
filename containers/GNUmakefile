SHELL = /bin/sh
.SHELLFLAGS := -ec
.ONESHELL:
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

IMAGE_NAME ?= localhost/crystal-crypto-samples:latest
CONTAINER_NAME ?= crystal-crypto-samples
PODMAN ?= podman

.DEFAULT_GOAL := build
.PHONY: all build run stop clean help

all: build

build: ## Build rootless container image with Podman
	$(PODMAN) build -t $(IMAGE_NAME) -f Containerfile ..

run: ## Run containerized sample suite with Podman
	$(PODMAN) run --rm --read-only --security-opt=no-new-privileges --cap-drop=ALL --userns=keep-id:uid=10001,gid=10001 --name $(CONTAINER_NAME) $(IMAGE_NAME)

stop: ## Stop active container
	$(PODMAN) stop -t 2 $(CONTAINER_NAME) 2>/dev/null || true

clean: ## Remove container image
	$(PODMAN) rmi -f $(IMAGE_NAME) 2>/dev/null || true

help: ## Display available container targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
