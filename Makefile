# Makefile — thin entry points over install.sh and the setup scripts.
# Each target is a one-line wrapper; all orchestration logic lives in
# install.sh / scripts/setup/*.sh.

.DEFAULT_GOAL := help

.PHONY: help install stow unstow clean apt update lint

## Show this help
help:
	@awk '/^## / { desc = substr($$0, 4) } /^[a-zA-Z0-9_%-]+:/ && desc { sub(/:.*/, "", $$0); printf "  %-14s %s\n", $$0, desc; desc = "" }' $(MAKEFILE_LIST)

## Full install (apt + installers + stow + default shell)
install:
	./install.sh

## Symlink configs only (no sudo)
stow:
	./install.sh --only stow

## Remove symlinks from $HOME (reversible via `make stow`)
unstow:
	./scripts/setup/symlinks.sh --delete

## Install apt packages only
apt:
	./install.sh --only apt

## Install a single tool: nvm, uv, zinit, fzf, shell
install-%:
	./install.sh --only $*

## Re-run installers to update tools/versions (skips apt)
update:
	./install.sh --skip-apt

## Shellcheck all scripts
lint:
	shellcheck install.sh lib/*.sh $(shell find scripts -name '*.sh')
