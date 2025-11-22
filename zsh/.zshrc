# shortcut to this dotfiles path is $ZSH
export ZSH=$HOME/.dotfiles

# your project folder that we can `c [tab]` to
export PROJECTS=~/Code

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
[[ -a ~/.localrc ]] && source ~/.localrc

# all of our zsh files
typeset -U config_files
config_files=($ZSH/**/*.zsh)

# Load path files first (pyenv, nvm, zinit, etc.)
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# Load other config files (functions, aliases, etc.) except path & completion
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source $file
done

# Initialize autocomplete
autoload -U compinit
compinit

# Load completion scripts last
for file in ${(M)config_files:#*/completion.zsh}; do
  source $file
done

# Clean up
unset config_files
