# 40-keybindings.zsh — Emacs-mode key bindings
# Check key sequences with: cat, then press a key; exit with Ctrl+C.

# Mode
bindkey -e  # Emacs mode

# Word
bindkey '^[[1;5C' forward-word          # Ctrl+Right Arrow         move forward one word
bindkey '^[[1;5D' backward-word         # Ctrl+Left Arrow          move backward one word

# Word selection
bindkey '^H' backward-kill-word         # Ctrl+Backspace           delete the previous word
bindkey '^[[3~' delete-char            # Delete                   delete the character under the cursor

# Line navigation
bindkey '^[[H' beginning-of-line        # Home                     move to the beginning of the line
bindkey '^[[F' end-of-line              # End                      move to the end of the line
