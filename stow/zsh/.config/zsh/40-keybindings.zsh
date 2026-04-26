# 40-keybindings.zsh

bindkey -e  # Emacs mode

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey ';5C'     forward-word
bindkey ';5D'     backward-word
bindkey '^H'      backward-kill-word
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[3~'   delete-char
