# Personal Claude preferences

These are MY preferences, applied to every project unless the project's own
CLAUDE.md says otherwise.

## Communication
- Bodi direkten. Brez "Great question!", brez nepotrebnih intro-jev.
- Slovenščina za pogovor, angleščina za kodo, commit messages, tehnične izraze.
- Če nečesa ne veš, povej "ne vem" — ne ugibaj.
- Ko si negotov o pristopu, vprašaj PREDEN pišeš kodo, ne potem.
- Brevity > thoroughness za enostavne stvari. Detail za arhitekturne odločitve.

## Working with code
- **Najprej preberi obstoječe.** Pred pisanjem nove kode preveri strukturo
  projekta (package manager, naming, kje so testi). Sledim obstoječim konvencijam.
- **Ne dodajaj dependencies brez vprašanja.** Vedno vprašaj PREDEN dodaš novo.
- **Manjši koraki.** Pri spremembah >50 vrstic kode mi najprej pokaži plan.
- **Brez "fix forward"-a pri zlomljenih testih.** Če teste pokvariš, takoj revertaj,
  ne poskušaj popravljati naprej.
- **Brez komentarjev, ki ponavljajo kodo.** Komentar razloži ZAKAJ, ne KAJ.

## Code defaults (override v projektnem CLAUDE.md če rabi drugače)
- TypeScript: strict mode, named exports, brez `any`, Zod za validacijo na meji.
- Python: type hints, ruff formatter, pytest.
- Bash: `set -euo pipefail`, shellcheck-clean.
- SQL: eksplicitne kolone v SELECT, brez `SELECT *` v aplikacijski kodi.

## Git — JAZ commitam, ti ne
- **Ne poganjaj `git add`, `git commit`, `git push`, `git checkout -b` sam od sebe.**
  Tudi če se zdi naravni naslednji korak. Commite delam jaz.
- Ko končaš logično enoto dela, povej "ready to commit" + predlagaj
  conventional commit message (`feat:`, `fix:`, `refactor:`, `chore:`, `docs:`).
- Lahko poganjaš `git status`, `git diff`, `git log`, `git branch`, `git show` —
  za orientacijo in pregled. Te ukaze imam tudi v `allow` listi.
- Če te eksplicitno prosim za git akcijo ("naredi commit", "push to branch"),
  šele takrat izvedi.

## Security guardrails
- Brez hardcodanih secretov, API keyev, credentials. Vedno env variables.
- Pred kakršnim koli predlogom commita preveri, da v diff-u ni nič kot
  `sk-...`, `ghp_...`, `AKIA...`, `-----BEGIN ... PRIVATE KEY-----`.
- Brez `eval`, brez `exec` z user inputom.

## Tools I use
- Editor: VSCode (`EDITOR=code --wait`)
- Terminal: zsh
- Notes per project: docs/notes/ (symlink v vault)

## When I say...
- "ready to commit?" → preglej spremembe, predlagaj commit message, čakaj name
- "naredi commit" → šele zdaj smeš pognati `git add` + `git commit`
- "naredi PR" → šele zdaj branch + commits + push, ampak NE odpri PR-ja preden rečem
- "fix" → najprej reproduciraj problem, šele potem popravi
- "refactor" → najprej teste, potem refactor, behaviorja NE smeš spremeniti
