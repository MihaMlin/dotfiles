# Makefile — thin entry points over install.sh and the setup scripts.
# Each target is a one-line wrapper; all orchestration logic lives in
# install.sh / scripts/setup/*.sh / scripts/install/*.sh.

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z0-9_%-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-14s %s\n", $$1, $$2}'

.PHONY: install
install: ## Full install (apt + stow + installers + default shell)
	./install.sh

.PHONY: stow
stow: ## Symlink configs only (no sudo)
	bash scripts/setup/symlinks.sh

.PHONY: unstow
unstow: ## Remove symlinks from $HOME (reversible via `make stow`)
	bash scripts/setup/symlinks.sh --delete

.PHONY: apt
apt: ## Install apt packages only
	bash scripts/install/apt.sh

install-%: ## Install a single tool: nvm, uv, zinit, fzf
	bash scripts/install/$*.sh

.PHONY: shell
shell: ## Set zsh as the default shell
	bash scripts/setup/default-zsh.sh

.PHONY: update
update: stow install-nvm install-uv install-zinit install-fzf shell ## Re-run installers to update tools/versions (skips apt)

.PHONY: lint
lint: ## Shellcheck all scripts
	shellcheck -x install.sh lib/*.sh $(shell find scripts -name '*.sh')
