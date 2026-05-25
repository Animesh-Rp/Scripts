# Adding a script to this repo

## First: does it belong here at all?

This repo is a **junk drawer for single-file utilities**. A new script belongs here if **all** of these are true:

- **It's one file.** No sidecar config files, no second module, no data directory.
- **Deps live inside the script**, not at the repo level. Allowed: PowerShell built-ins, userscript `@require`, PEP 723 inline-deps for Python (`uv run --script`). Not allowed: a `pyproject.toml` / `requirements.txt` / `package.json` at the repo root, a checked-in `.venv/`, anything that says "build step."
- **No tests, no modules, no growth plan.** If you can see a future where this gets a `src/` layout, start it as a project instead.

If any of those is false, it's a **project**, not a script. Scaffold it at `~/Projects/personal/<name>/` from the personal-framework template at `~/Projects/guides/templates/personal/`.

## Where it goes

| Script type | Folder |
|---|---|
| PowerShell (PS7, cross-platform) | `powershell/` |
| Tampermonkey / Greasemonkey | `userscripts/` |
| Portable shell (`sh`/`bash`/`zsh`) | `shell/` |
| Python (stdlib or inline-deps via uv) | `python/` |

If it doesn't fit any folder, **ask first whether you're really adding a category or really starting a project.** Then make a new top-level folder with its own `README.md`.

## The ritual

1. Drop the file in the right folder.
2. Top of the file: one-line header — `# <name> — <what it does in <=10 words>`.
3. If it's platform-specific within its folder (e.g. a Windows-only `.ps1`), note that in the header too.
4. Make sure the per-folder `README.md` still tells the truth about what belongs there.
5. Add a one-line bullet to the root `README.md` index.
6. Commit: `git commit -m "add <folder>/<name>: <one-line description>"`.

No tests, no CI, no PR. The value of this repo is being low-friction.
