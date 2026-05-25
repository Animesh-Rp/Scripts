# Scripts

Single-file utilities I've collected over time. Each script is self-contained and runnable.

If something needs a venv, lock file, or build step, it doesn't belong here — it gets its own repo at `~/Projects/personal/<name>/` from the personal-framework template. See `CONTRIBUTING.md`.

For Claude Code / Claude.ai working in this repo, see `CLAUDE.md`.

## Index

### `powershell/` — PowerShell 7+ (cross-platform)
- `manga-to-cbz.ps1` — pack a manga folder into a `.cbz` archive.

### `userscripts/` — browser userscripts
- `Duration_Skipper.js` — Plex/YouTube: override arrow-key seek to 5s.

### `shell/` — portable sh/bash/zsh
- `setup-yt-dl.sh` — verify `uv` + `ffmpeg` and prime the uv cache for `python/yt-dl.py`.

### `python/` — stdlib or `uv run --script` inline-deps
- `yt-dl.py` — download a YouTube video or playlist (yt-dlp wrapper with sensible defaults). See `python/yt-dl.md` for usage.

## Adding a new script

See `CONTRIBUTING.md` for the decision rule (when something stops being a script and becomes a project) and the folder-by-folder guide.
