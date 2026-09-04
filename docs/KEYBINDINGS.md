# Zsh Key Bindings

Every key binding an interactive shell from this repo ends up with: the custom
ones set in `stow/zsh/.config/zsh/40-keybindings.zsh`, the widgets fzf and the
zinit plugins install on top, and the zsh **emacs** defaults underneath.

The shell runs in emacs mode (`bindkey -e`), so `Ctrl` and `Alt` (`Meta`,
written `^[` / `\e`) sequences behave the way they do in readline.

---

## 🔍 Finding a key sequence

Terminals disagree about what they send for modified keys. To see the raw
sequence a key produces:

```sh
cat        # then press the key; Ctrl+C to exit
```

To ask zsh what a sequence is currently bound to, or to list everything:

```sh
bindkey '^[[3~'   # what does Delete do?
bindkey           # dump the whole emacs keymap
```

`^[` is `Esc`, `^I` is `Tab`, `^M` is `Enter`, `^?` is `Backspace`.

---

## ⌨️ Custom bindings

Set in `40-keybindings.zsh`. These exist because the terminal emulator sends
sequences zsh does not bind out of the box.

| Key | Widget | Action |
| --- | --- | --- |
| `Ctrl+Right` | `forward-word` | Move forward one word |
| `Ctrl+Left` | `backward-word` | Move backward one word |
| `Ctrl+Backspace` | `backward-kill-word` | Delete the previous word |
| `Delete` | `delete-char` | Delete the character under the cursor |
| `Home` | `beginning-of-line` | Move to the beginning of the line |
| `End` | `end-of-line` | Move to the end of the line |
| `Alt+C` | `capitalize-word` | Capitalize the word at the cursor * |

`Ctrl+Backspace` is bound via `^H`, which is what most terminals send for it —
the same sequence as `Ctrl+H`.

\* `Alt+C` is a reclaim, not a new binding: fzf takes it for `fzf-cd-widget`,
and this file is sourced afterwards to hand it back to zsh's default.

---

## 🔎 fzf

Installed by `source <(fzf --zsh)` in `stow/fzf/.config/fzf/path.zsh`.

| Key | Widget | Action |
| --- | --- | --- |
| `Ctrl+T` | `fzf-file-widget` | Fuzzy-pick files/dirs, paste onto the line |
| `Ctrl+R` | `fzf-history-widget` | Fuzzy-search command history |
| `Alt+C` | `fzf-cd-widget` | Fuzzy-pick a directory and `cd` into it — unbound, see above |
| `Tab` | `fzf-completion` | Fuzzy completion — but see fzf-tab below |

Inside an fzf window: `Ctrl+J`/`Ctrl+K` or the arrows move, `Enter` selects,
`Tab` multi-selects, `Ctrl+C`/`Esc` aborts.

---

## 🧩 Plugin bindings

Declared in `30-plugins.zsh`. Most load deferred (`wait'1'`, `wait'2'`), so
they take over their keys a moment after the first prompt appears.

### fzf-tab (`Aloxaf/fzf-tab`)

| Key | Widget | Action |
| --- | --- | --- |
| `Tab` | `fzf-tab-complete` | Completion menu in fzf, with a preview pane |
| `Ctrl+X` `.` | `fzf-tab-debug` | Dump completion state for debugging |

Loads after fzf, so it wins `Tab` and `fzf-completion` is effectively
unreachable. The preview command comes from `10-completion.zsh`:

```sh
zstyle ':fzf-tab:*' fzf-preview 'ls --color $realpath'
```

### zsh-autosuggestions (`zsh-users/zsh-autosuggestions`)

No keys of its own — it hooks existing widgets:

| Key | Effect |
| --- | --- |
| `End` / `Ctrl+E` / `Ctrl+F` / `Right` | Accept the whole suggestion |
| `Alt+F` / `Ctrl+Right` | Accept one word of the suggestion |

### OMZ `sudo` snippet

| Key | Action |
| --- | --- |
| `Esc` `Esc` | Toggle `sudo` at the front of the current line |

### Others

`zsh-syntax-highlighting`, `zsh-completions`, the OMZ `git` snippet and
`powerlevel10k` add no key bindings — they add colouring, completions, aliases
and the prompt respectively.

---

## 📜 Zsh emacs defaults

Everything below comes from zsh itself. Listed for reference; nothing in this
repo changes it.

### Moving

| Key | Widget |
| --- | --- |
| `Ctrl+A` / `Ctrl+E` | `beginning-of-line` / `end-of-line` |
| `Ctrl+B` / `Ctrl+F` | `backward-char` / `forward-char` |
| `Alt+B` / `Alt+F` | `backward-word` / `forward-word` |
| `Alt+<` / `Alt+>` | `beginning-of-buffer-or-history` / `end-of-buffer-or-history` |

### Editing

| Key | Widget |
| --- | --- |
| `Backspace` | `backward-delete-char` |
| `Ctrl+D` | `delete-char-or-list` — on an empty line, logs out |
| `Ctrl+K` | `kill-line` — cut to end of line |
| `Ctrl+U` | `kill-whole-line` |
| `Ctrl+W` | `backward-kill-word` |
| `Alt+D` | `kill-word` — cut forward one word |
| `Ctrl+Y` / `Alt+Y` | `yank` / `yank-pop` — paste from the kill ring |
| `Alt+T` | `transpose-words` |
| `Alt+U` / `Alt+L` / `Alt+C` | `up-case-word` / `down-case-word` / `capitalize-word` |
| `Ctrl+V` | `quoted-insert` — insert the next key literally |
| `Ctrl+_` / `Ctrl+X` `Ctrl+U` | `undo` |
| `Ctrl+@` / `Ctrl+X` `Ctrl+X` | `set-mark-command` / `exchange-point-and-mark` |

### History

| Key | Widget |
| --- | --- |
| `Ctrl+P` / `Ctrl+N` | `up-line-or-history` / `down-line-or-history` |
| `Up` / `Down` | same as above |
| `Ctrl+R` * | `history-incremental-search-backward` |
| `Ctrl+S` | `history-incremental-search-forward` |
| `Alt+P` / `Alt+N` | `history-search-backward` / `history-search-forward` |
| `Alt+.` / `Alt+_` | `insert-last-word` |
| `Alt+!` / `Alt+Space` | `expand-history` |

\* `Ctrl+R` is taken by fzf; the built-in search is still on
`Ctrl+X` `r`. `Ctrl+S` is swallowed by terminal flow control unless it is
disabled with `stty -ixon`.

History behaviour itself is configured in `00-history.zsh`: 10 000 entries in
`$XDG_STATE_HOME/zsh/history`, shared live between sessions, duplicates and
space-prefixed commands dropped.

### Completion and expansion

| Key | Widget |
| --- | --- |
| `Tab` * | `expand-or-complete` |
| `Ctrl+D` | `list-choices` on a non-empty line |
| `Ctrl+X` `a` | `_expand_alias` |
| `Ctrl+X` `e` | `_expand_word` |
| `Ctrl+X` `*` | `expand-word` |
| `Ctrl+X` `c` | `_correct_word` |
| `Ctrl+X` `h` | `_complete_help` — show what completion would apply |
| `Ctrl+X` `?` | `_complete_debug` |
| `Ctrl+X` `n` | `_next_tags` |
| `Alt+/` / `Alt+,` | `_history-complete-older` / `_history-complete-newer` |
| `Alt+S` | `spell-word` |

\* Overridden by fzf-tab.

Completion styles live in `10-completion.zsh`: case-insensitive matching,
`LS_COLORS` in the list, and the plain menu disabled in favour of fzf-tab.

### Line control

| Key | Widget |
| --- | --- |
| `Enter` / `Ctrl+J` | `accept-line` |
| `Ctrl+O` | `accept-line-and-down-history` |
| `Alt+A` | `accept-and-hold` |
| `Ctrl+Q` / `Alt+Q` | `push-line` — stash the line, restore it after the next command |
| `Ctrl+L` | `clear-screen` |
| `Ctrl+G` | `send-break` — abandon the line |
| `Alt+X` / `Alt+Z` | `execute-named-cmd` / `execute-last-named-cmd` |
| `Alt+H` | `run-help` — help for the current command |
| `Alt+?` | `which-command` |
| `Alt+0`…`Alt+9` | `digit-argument` — repeat count for the next key |
| `Alt+-` | `neg-argument` |

### Zinit

| Key | Widget |
| --- | --- |
| `Esc` `Shift+Q` | `zi-browse-symbol` — browse the symbol under the cursor |

---

## 🧭 Who wins a key

Load order decides. Within `.zshrc`, each package's `path.zsh` is sourced
first (fzf binds `Ctrl+T`/`Ctrl+R`/`Alt+C`/`Tab` there), then the numbered
modules run in order — `30-plugins.zsh` declares the plugins and
`40-keybindings.zsh` sets the custom bindings last. Deferred plugins land
after the prompt is already up, which is why fzf-tab ends up owning `Tab`.

To override anything here, add a `bindkey` line to `40-keybindings.zsh` for
eagerly-bound keys — that is how `Alt+C` is taken back from fzf. For a key a
deferred plugin claims, rebind it from that plugin's `atload'...'` ice in
`30-plugins.zsh` instead — a binding set in `40-keybindings.zsh` would be
overwritten a moment later.
