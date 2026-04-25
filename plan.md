# Dotfiles Architecture Cleanup — Plan

## Context

Repo `~/.dotfiles` je dobro zasnovan za osebno uporabo (XDG-compliant, modularen Zsh, lazy-loading, idempotenten install), ampak ima **več strukturnih nedoslednosti** in odprtih repov, ki nakazujejo, da arhitektura ni bila do konca premišljena: install flow je fragilen, nekateri configi obstajajo a niso symlinkani, README ne ustreza dejanski strukturi, Neovim installer obide symlink sistem itd.

Cilj tega plana: **predlog konkretnih sprememb** za čistejšo, bolj standardno strukturo, brez uvajanja čezmerne kompleksnosti. Implementacijo naredimo v ločenih korakih po potrditvi.

---

## Trenutno stanje (kratek povzetek)

```
~/.dotfiles
├── install.sh                  # entry point (kliče installerje + symlinks)
├── README.md                   # ⚠️ vsebuje napačne poti (scripts/linux/...)
├── bin/                        # 4 utility skripti (backup, lsports, mini-fetch, pycheck)
├── config/                     # XDG configi (git, tmux, neovim, nvm, pyenv, vscode, zinit)
├── docs/ZBOOK.md               # WSL2 setup guide (GIT.md + POSTGRES.md staged za delete)
├── scripts/
│   ├── apt-packages.txt
│   ├── symlinks.txt            # samo 4 vnosi (zshrc, p10k, tmux, git)
│   ├── install/                # apt, neovim, nvm, pyenv, zinit, fzf
│   └── setup/                  # default-zsh, symlinks
├── zsh/                        # modularen config (.zshrc + 6 modulov + p10k tema)
└── .claude/                    # globalna Claude Code konfiguracija (orthogonal!)
```

**Git stanje:**
- `main` ahead 1 commit
- staged delete: `docs/GIT.md`, `docs/POSTGRES.md`
- modified (not staged): `.claude/settings.json`, `zsh/.zshrc`

---

## Ugotovljene težave & predlogi

### 1. README ↔ realnost drift  ⚠️ HIGH

**Problem:** `README.md:57-67` referencira `scripts/linux/apt-packages.txt`, `scripts/linux/install/`, `scripts/linux/symlinks.txt` — **ti pati ne obstajajo**. Pravo: `scripts/{install,setup,symlinks.txt,apt-packages.txt}`.

**Predlog:** Posodobi README, da ujema dejansko strukturo. Dodaj sekcijo "Maintenance" (kako updatat orodja, kam dodati novo orodje, kako re-runnati samo symlinks).

---

### 2. Neovim installer obide symlink sistem  ⚠️ HIGH

**Problem:** `scripts/install/neovim.sh:24`:
```bash
mkdir -p ~/.config/nvim && cp ./config/neovim/init.lua ~/.config/nvim/init.lua
```
Kopira namesto symlinka — edits v `~/.config/nvim/init.lua` se ne propagirajo nazaj v repo. Vsi ostali tooli gredo skozi `symlinks.txt`.

**Predlog:**
- Odstrani `cp` line iz `neovim.sh` (installer naj samo namesti binary).
- Dodaj v `scripts/symlinks.txt`:
  ```
  config/neovim/init.lua => ~/.config/nvim/init.lua
  ```
- Razmisli o nadgradnji configa (lazy.nvim, LSP, keymaps) ali ga eksplicitno označi kot "minimal".

---

### 3. VSCode config je orphan  ⚠️ HIGH

**Problem:** `config/vscode/{keybindings.json, settings-remote.json, settings-user.json}` obstajajo, ampak **ni vnosa v `symlinks.txt`** in nikjer ni dokumentirano, kako se sync-ajo. V WSL2 VSCode default lokacija je na Windows strani (`%APPDATA%\Code\User`).

**Predlog:** Bodisi:
- (a) odstrani iz repa, če se ne uporabljajo;
- (b) dodaj `docs/VSCODE.md` z navodili za ročni sync (ker auto-symlink čez WSL boundary ni smiseln);
- (c) preimenuj na `settings.json` / `keybindings.json` in dodaj v symlinks.txt **samo** za primer, ko se zaganja `code` server v Linuxu.

Odločitev je tvoja — ampak trenutno stanje (datoteke obstajajo, ne počnejo nič) je najslabše.

---

### 4. `install.sh` je fragilen  ⚠️ HIGH

**Problemi v `install.sh`:**
- Relativne poti (`scripts/install/apt.sh`) — če zaženeš iz drugega CWD, se sesuje (line 33–35).
- Ni preverbe za `curl`, `git`, `sudo`.
- `set -e` je nastavljen, ampak ni `pipefail`, ni `nounset`.
- Logging helperji (`error`, `warning`, `info`...) so definirani inline — **podvojeni** so v `symlinks.sh`.

**Predlog:**
1. V vrhu skripte:
   ```bash
   set -euo pipefail
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   cd "$SCRIPT_DIR"
   ```
2. Ustvari `scripts/lib/log.sh` z helperji (`error`, `info`, `success`, `step`) in source-aj povsod, kjer je dropi.
3. Dodaj na začetek `scripts/lib/preflight.sh`, ki preveri: `curl`, `git`, `sudo` (če ne root), internet.
4. Razmisli o flag-ih: `--skip-apt`, `--only-symlinks`, `--dry-run` (uporabno za re-run brez sudo).

---

### 5. `symlinks.txt` je preozek  🟡 MEDIUM

**Problem:** Zajema samo 4 datoteke (zshrc, p10k.zsh, tmux.conf, git/config). Manjka:
- `config/neovim/init.lua` (točka 2)
- VSCode (točka 3, če se odločiš za auto-link)
- Bin scripts? (trenutno PATH dodaja `$DOTFILES/bin` — ne rabiš symlink)
- `.claude/` global config — kaj je workflow? (točka 9)

**Predlog:** Eno mesto resnice za vse symlinke. Po točkah 2 in 3 razširi.

---

### 6. `.zshrc` ima hardcoded uporabniški path  🟡 MEDIUM

**Problem:** `zsh/.zshrc:27`:
```bash
export PATH="/home/mlinmiha/.local/bin:$PATH"
```
Ni portabilen (drug user, drug host) in line 26 že uporablja `$HOME` semantiko (`$DOTFILES/bin`).

**Predlog:**
```bash
export PATH="$HOME/.local/bin:$PATH"
```

WSLg env vars (`DISPLAY`, `WAYLAND_DISPLAY`, ...) v line 18–22 so OK, ampak razmisli, da jih premakneš v `zsh/local.zsh` ali pogojno: `[[ -d /mnt/wslg ]] && { ... }`.

---

### 7. `environments.txt` v configu — namen nejasen  🟡 MEDIUM

**Problem:** `config/nvm/environments.txt` in `config/pyenv/environments.txt` obstajajo, ampak nista v `symlinks.txt`. Verjetno ju bere installer (preveri v `scripts/install/{nvm,pyenv}.sh`).

**Predlog:** Če je to seznam verzij za autoinstall, preimenuj v `versions.txt` (jasnejše ime) in dokumentiraj v komentarju installerja: "reads versions.txt and runs `nvm install <v>` for each line".

---

### 8. `docs/` v limbu  🟡 MEDIUM

**Problem:** `git status` kaže staged delete `docs/GIT.md` in `docs/POSTGRES.md`. Namera ali prevent? Ostal je samo `docs/ZBOOK.md` (WSL2 setup).

**Predlog:**
- Odloči se: bodisi commit-aj delete (po reviewu), bodisi `git restore --staged` + `git checkout` (če sta še uporabna).
- Razmisli o strukturi: `docs/setup/` (ZBOOK, future per-OS), `docs/notes/` (per-tool tips, če rabiš).

---

### 9. `.claude/` v dotfiles je arhitekturno čudno  🟡 MEDIUM

**Problem:** `.claude/` v dotfiles repu je **globalna Claude Code konfiguracija** (`~/.claude` symlink target). To ni "dotfile za WSL dev environment" v istem smislu kot zshrc — drugačno orodje, drugačen lifecycle, ima svoj `install.sh` in `README.md`.

**Predlog (izbira):**
- **(a) Status quo + jasno označi**: dodaj v `.claude/README.md` opombo "deployed via root install.sh through scripts/symlinks.txt" — in **dodaj** symlink mapping v `symlinks.txt` (`.claude => ~/.claude`).
- **(b) Loči** v svoj sub-repo (git submodule ali ločen repo) — bolj clean separation.

Trenutno stanje (`.claude/install.sh` paralelno z root `install.sh`, brez integracije v `symlinks.txt`) je najslabše.

---

### 10. Manjkajoče standardne datoteke  🟢 LOW

**Predlog dodati:**
- `.gitignore` — vsaj: `*.swp`, `.DS_Store`, `bak/`, `*.local`, `.localrc`. Trenutno ga ni.
- `.editorconfig` — za konzistentne tab/space/EOL nastavitve cross-tool.
- `LICENSE` — če bo kadarkoli javen repo.
- `CONTRIBUTING.md` ali sekcija v README — kako dodati nov tool (zelo kratka recept-style navodila).

---

### 11. Razdelitev odgovornosti `install.sh`  🟢 LOW

**Trenutno:** ena skripta = APT + tools + zsh-default + symlinks + launch zsh.

**Predlog (idealno):** Tri faze z eksplicitnimi entry-pointi:
```
make bootstrap   # apt-packages + zsh shell
make install     # neovim, nvm, pyenv, zinit, fzf (tool installers)
make link        # samo symlinks (re-runnabilno brez sudo)
```
ali pa flag-i v obstoječem `install.sh` (`--bootstrap`, `--install`, `--link`).

To je nice-to-have; zahteva več dela. Lahko počaka.

---

### 12. `scripts/install/neovim.sh` ima mrtvo logging kodo  🟢 LOW

**Problem:** Definira `error/warning/info/success`, ampak jih nikoli ne uporabi (uporablja `echo`). Skupna helper lib (točka 4.2) bi to rešila.

---

## Predlagana ciljna struktura (po izvedenih spremembah)

```
~/.dotfiles
├── README.md                # posodobljen (točka 1)
├── CONTRIBUTING.md          # opcijsko (točka 10)
├── .gitignore               # NOVO (točka 10)
├── .editorconfig            # NOVO (točka 10)
├── install.sh               # robusten (točka 4)
├── bin/                     # nespremenjen
├── config/                  # nespremenjen + jasen status VSCode (točka 3)
├── docs/                    # cleanup po točki 8
├── scripts/
│   ├── lib/                 # NOVO: log.sh, preflight.sh
│   ├── install/             # nespremenjen (- mrtva koda iz neovim.sh)
│   ├── setup/               # nespremenjen
│   ├── symlinks.txt         # razširjen (točki 2, 3, 9)
│   └── apt-packages.txt
├── zsh/                     # .zshrc fix (točka 6)
└── .claude/                 # dokumentirano (točka 9)
```

---

## Kritični datoteki za spremembe (referenca)

| File | Razlog | Točka |
|------|--------|-------|
| `README.md` | Napačne poti `scripts/linux/...` | #1 |
| `scripts/install/neovim.sh:24` | `cp` namesto symlinka | #2 |
| `scripts/symlinks.txt` | Manjkajo neovim, vscode, .claude | #2,#3,#5,#9 |
| `install.sh:33-35` | Relativne poti, mrtvi helperji | #4 |
| `zsh/.zshrc:27` | Hardcoded user path | #6 |
| `config/vscode/*` | Orphan datoteke | #3 |
| `config/{nvm,pyenv}/environments.txt` | Nejasen namen | #7 |

---

## Verifikacija (kako preveriš rezultate)

Po vsaki implementirani spremembi:

1. **Symlinks integriteta** — preveri vse:
   ```bash
   while read line; do [[ "$line" =~ ^# || -z "$line" ]] && continue; \
     target=$(echo "$line" | awk -F'=>' '{print $2}' | xargs); \
     target="${target/#\~/$HOME}"; \
     [[ -L "$target" ]] && echo "OK: $target" || echo "MISS: $target"; \
   done < scripts/symlinks.txt
   ```

2. **Shell startup** — meri čas:
   ```bash
   for i in 1 2 3; do time zsh -i -c exit; done
   # cilj: <300ms
   ```

3. **Install flow dry-run** — če se odločiš za točko 11, dodaj `--dry-run` mode. Sicer testiraj v Docker/clean WSL.

4. **`shellcheck` clean** — preveri vse skripte:
   ```bash
   shellcheck install.sh scripts/install/*.sh scripts/setup/*.sh bin/*
   ```

---

## Predlog vrstnega reda izvedbe

Ko potrdiš plan, predlagam izvedbo v tem vrstnem redu (vsaka točka = svoj commit):

1. **Cleanup** (točka 8): odloči o `docs/GIT.md` + `docs/POSTGRES.md`, commit ali revert.
2. **README fix** (točka 1) — najmanj invazivno, največ vrednosti.
3. **Neovim symlink fix** (točka 2).
4. **VSCode odločitev** (točka 3).
5. **`.zshrc` portability** (točka 6).
6. **install.sh hardening** (točka 4) + `scripts/lib/log.sh`.
7. **`environments.txt` rename** (točka 7).
8. **`.claude/` integracija** (točka 9).
9. **Standard files** (točka 10).
10. **Optional: faznost install.sh** (točka 11) — če sploh.

Vsak korak je ločen in reverzibilen. Točke 1–5 so HIGH/MEDIUM in dajo največ vrednosti za najmanj truda.
