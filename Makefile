# Makefile — thin entry points over install.sh and the setup scripts.
# Each target is a one-line wrapper; all orchestration logic lives in
# install.sh / scripts/setup/*.sh / scripts/install/*.sh.

.DEFAULT_GOAL := help

.PHONY: help install stow unstow apt shell update lint

## Show this help
help:
	@awk '/^## / { desc = substr($$0, 4) } /^[a-zA-Z0-9_%-]+:/ && desc { sub(/:.*/, "", $$0); printf "  %-14s %s\n", $$0, desc; desc = "" }' $(MAKEFILE_LIST)

## Full install (apt + stow + installers + default shell)
install:
	./install.sh

## Symlink configs only (no sudo)
stow:
	bash scripts/setup/symlinks.sh

## Remove symlinks from $HOME (reversible via `make stow`)
unstow:
	bash scripts/setup/symlinks.sh --delete

## Install apt packages only
apt:
	bash scripts/install/apt.sh

## Install a single tool: nvm, uv, zinit, fzf
install-%:
	bash scripts/install/$*.sh

## Set zsh as the default shell
shell:
	bash scripts/setup/default-zsh.sh

## Re-run installers to update tools/versions (skips apt)
update: stow install-nvm install-uv install-zinit install-fzf shell

## Shellcheck all scripts
lint:
	shellcheck -x install.sh lib/*.sh $(shell find scripts -name '*.sh')
