# CLAUDE.md

This repo is a **junk drawer for single-file utility scripts**. It is NOT a project in the personal-framework sense — there is no app, no schema, no deploy. Calibrate accordingly.

## What this repo is — and isn't

- **Is:** **one-file utilities.** PowerShell, userscripts, shell, single-file Python. Deps are fine when they live *inside the script* (PowerShell built-ins, userscript `@require`, PEP 723 inline-deps via `uv run --script`).
- **Isn't:** anything with **structure beyond one file** — a `pyproject.toml` / `requirements.txt` / `package.json` at the repo level, a `.venv/`, a `src/` layout, multiple importable modules, a test suite, a config file the script reads, persistent state, or a build step. Those get their own repo at `~/Projects/personal/<name>/` using the personal-framework template.

The line is *structure*, not *dependencies*. A 60-line Python script that imports `yt-dlp` via inline-deps is a script. A 60-line Python script that reads a YAML config from a sibling file is a project (the config is the second file).

If the user asks to add something that crosses that line, **say so**, propose a new repo instead, and offer to scaffold it from the personal-framework template.

## User profile

- Works across **macOS, Windows, and Linux** — never assume one platform.
- Comfortable in the shell. Prefers **terse responses for stacks they're confident in**, and **learner-mode (what + why, then commands) for less-familiar territory** (e.g. CV / OCR / ML stacks).
- Has a personal framework at `~/Projects/guides/` — defer to it for project-vs-script decisions.

## Folder layout

```
Scripts/
├── CLAUDE.md         ← this file
├── CONTRIBUTING.md   ← decision rule: when a script becomes a project
├── README.md         ← index of what's here
├── powershell/       ← .ps1, PS7 cross-platform
├── userscripts/      ← Tampermonkey / Greasemonkey
├── shell/            ← portable sh/bash/zsh
└── python/           ← stdlib OR `uv run --script` inline-deps only
```

Each folder has its own `README.md` describing what belongs there. Read the relevant one before adding a file.

## Workflow — adding a new script

1. **Decide where it goes** using the table in `CONTRIBUTING.md`. If unsure, ask the user one question; don't guess.
2. **Check the platform-specific rule.** Examples:
   - PowerShell scripts using Windows-only cmdlets (`Get-WmiObject`, registry) need a header note.
   - Shell scripts using macOS-only tools (`pbcopy`, `osascript`, `defaults`) need `mac-` prefix and a header note. Same for Linux-only (`apt`, systemd, etc).
   - Python: prefer stdlib. If a dep is needed, use PEP 723 inline-deps — never add a `requirements.txt` to this repo.
3. **Write the script** with a one-line header: `# <name> — <what it does in <=10 words>`.
4. **Update the root `README.md`** index with a one-line bullet under the right folder.
5. **Commit** with `git commit -m "add <folder>/<name>: <description>"`.

Don't push without an explicit ask. Don't open a PR.

## Python specifics

Python scripts in `python/` MUST be runnable directly. The user has no global Python — every script declares its own interpreter and deps via `uv`. Two valid shapes only:

**Shape A — stdlib only:**
```python
#!/usr/bin/env python3
# <name> — <description>
import argparse, json, ...
```

**Shape B — uv inline-deps (PEP 723):**
```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["requests", "rich"]
# ///
# <name> — <description>
import requests
```

If a script needs anything beyond `uv run --script` can handle (data files, multiple modules, a config file, persistent state, tests), it's outgrown this repo — promote it.

## PowerShell specifics

- Target PowerShell 7+ syntax. Don't use Windows PowerShell 5.1-only features unless the script is explicitly Windows-only.
- Use `param()` blocks with types — they double as documentation.
- Prefer built-ins (`Compress-Archive`, `Invoke-WebRequest`, `ConvertFrom-Json`) over external modules.

## Shell specifics

- Start every script with `#!/usr/bin/env bash` (or `sh` if truly portable POSIX) and `set -euo pipefail`.
- Test mentally on both macOS (BSD utils) and Linux (GNU utils) — they diverge on `sed`, `date`, `readlink`, `grep -P`. When they do, prefer the portable form or note the constraint.

## Operating mode

The user has granted permission for **reversible, local changes** without confirmation: editing files, running scripts to test them, `git add`, `git commit` (no push).

**Pause and confirm before:**
- `git push` or anything that touches the remote.
- Anything that installs system-level tools (Homebrew, apt, system Python changes).
- Network calls in test runs that hit non-trivial APIs (rate limits, billing, scraping at scale).
- Adding any project-style artifacts to this repo (`requirements.txt`, `pyproject.toml`, `.venv/`, `package.json`, lock files) — these signal the script has outgrown this repo; recommend promoting it instead.
- Renaming or removing folders that already contain scripts.

## Communication style

Default terse. Skip preamble for simple tasks ("add a Python script that does X" → write the script, update the README, commit, done).

Switch to learner-mode (one sentence on *what*, one on *why*, then the action) when:
- The user explicitly asks "explain what you're doing."
- The script touches a stack the user is less familiar with (CV/OCR/ML pipelines, low-level system stuff).
- A non-obvious choice is being made (e.g. "I'm using `uv run --script` here instead of stdlib because we need `requests` — the alternative would be promoting this to its own repo").

When pausing for a risky action: state what's about to happen, the risk, and the smallest reversible alternative.
