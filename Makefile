# Makefile — thin entry points over install.sh and the setup scripts.
# Each target is a one-line wrapper; all orchestration logic lives in
# install.sh / scripts/setup/*.sh.

.DEFAULT_GOAL := help

.PHONY: help install stow unstow clean update lint

help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*##"}{printf "  %-10s %s\n", $$1, $$2}'

install: ## Full install (apt + installers + stow + default shell)
	./install.sh

stow: ## Symlink configs only (no sudo)
	./install.sh --only-symlinks

unstow: ## Remove symlinks from $HOME (reversible via `make stow`)
	./scripts/setup/symlinks.sh --delete

clean: unstow

update: ## Re-run installers to update tools/versions (skips apt)
	./install.sh --skip-apt

lint: ## Shellcheck all scripts
	shellcheck install.sh $(shell find scripts -name '*.sh')
