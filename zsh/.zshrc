# -----------------------------
# Powerlevel10k Instant Prompt
# Must be near top of ~/.zshrc
# -----------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# -----------------------------
# Dotfiles & Project Paths
# -----------------------------
export ZSH="$HOME/.dotfiles"      # shortcut to dotfiles
export PROJECTS="$HOME/Code"      # project folder

# Load environment variables from localrc (kept out of repo)
[[ -a ~/.localrc ]] && source ~/.localrc


# -----------------------------
# Collect all ZSH config files
# -----------------------------
typeset -U config_files
config_files=($ZSH/**/*.zsh)
paths_folder="$ZSH/zsh/paths"

# Load path management scripts first (pyenv, nvm, zinit, etc.)
for file in ${(M)config_files:#$paths_folder/*.zsh}; do
  source $file
done

# Load remaining config files except path & completion
for file in ${${config_files:#$paths_folder/*.zsh}:#*/completion.zsh}; do
  source $file
done


# -----------------------------
# Zinit: Powerlevel10k & Plugins
# -----------------------------
# Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ZSH plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions


# -----------------------------
# Autocomplete & Completions
# -----------------------------
# TODO: move
# Completion styling
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ":fzf-tab:completion:*" fzf-preview 'ls --color $realpath'

# TODO: move
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
# Add in snippets for OMZ plugins
zinit snippet OMZP::git
zinit snippet OMZP::sudo

autoload -U compinit && compinit
zinit cdreplay -q

# TODO: move
# Aliases
alias ll='ls -lah'
alias ls='ls --color'

# Load completion scripts last
for file in ${(M)config_files:#*/completion.zsh}; do
  source $file
done


# -----------------------------
# Cleanup
# -----------------------------
unset config_files


# -----------------------------
# Keybindings
# -----------------------------
# bindkey -e  # Use emacs keybindings


# -----------------------------
# History Settings
# -----------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# -----------------------------
# FZF integration
# -----------------------------
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh


# -----------------------------
# Load P10k config
# -----------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
