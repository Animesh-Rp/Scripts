# yt-dl.py — usage guide

A `uv run --script` wrapper around `yt-dlp`. Downloads a YouTube video, playlist, or channel with sensible defaults.

## Prereqs

- `uv` — `brew install uv` (macOS) / `curl -LsSf https://astral.sh/uv/install.sh | sh` (Linux)
- `ffmpeg` — `brew install ffmpeg` / `apt install ffmpeg` / `winget install ffmpeg`

First run is ~5s slower while `uv` builds the cached env for `yt-dlp`. After that it's instant. Run `shell/setup-yt-dl.sh` once to prime the cache and verify prereqs.

## Synopsis

```
./python/yt-dl.py [-o OUTDIR] [-q 480|720|1080|2160|best] [-a] [--archive FILE]
                  [-c N] [--playlist-items RANGE] URL
```

Output template: `<OUTDIR>/<uploader>/<title> [<id>].<ext>` — metadata and thumbnail embedded.

## Common recipes

**Single video, defaults (1080p mp4 into `./downloads`):**
```bash
./python/yt-dl.py "https://www.youtube.com/watch?v=VIDEO_ID"
```

**Playlist — resumable (recommended). The archive file remembers what's done, so re-runs skip them:**
```bash
./python/yt-dl.py -o ~/Movies/youtube \
  --archive ~/Movies/youtube/.archive \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

**Audio-only (mp3, 192kbps):**
```bash
./python/yt-dl.py -a -o ~/Music/youtube "URL"
```

**Best available quality (no cap — can be huge):**
```bash
./python/yt-dl.py -q best "URL"
```

**Channel — same as playlist; pass the channel URL and an archive file:**
```bash
./python/yt-dl.py -o ~/Movies/youtube \
  --archive ~/Movies/youtube/.archive \
  "https://www.youtube.com/@CHANNEL/videos"
```

## Flag reference

| Flag | Default | When to use |
|---|---|---|
| `-o, --out DIR` | `./downloads` | Fixed library location (e.g. `~/Movies/youtube`) |
| `-q, --quality` | `1080` | Cap height: `480`, `720`, `1080`, `2160`, or `best` |
| `-a, --audio` | off | mp3 extraction, skip video |
| `--archive FILE` | none | Playlists/channels — skip already-downloaded items |
| `-c, --concurrent` | `4` | Parallel fragment downloads per video (speeds up DASH-fragmented streams) |
| `--playlist-items` | all | Subset like `1-24` or `1,3,5` — used to split a playlist across parallel processes |

## Parallelism — two layers

**Layer 1: per-video fragment concurrency (built-in, on by default).**
`yt-dlp` downloads DASH fragments in parallel within a single video. Controlled by `-c N`; default is 4. Raise to 8–16 on fast connections, drop to 1–2 if YouTube starts rate-limiting (HTTP 429).

**Layer 2: multi-video parallelism (run several processes).**
`yt-dlp` itself is sequential across videos in a playlist. To download many videos at once, split the playlist into ranges with `--playlist-items` and launch one process per range. They can safely share one `--archive` file.

Example — split a 94-video playlist across 4 processes:

```bash
URL="https://www.youtube.com/playlist?list=PLAYLIST_ID"
OUT=~/Movies/youtube
ARCH=~/Movies/youtube/.archive

for range in "1-24" "25-48" "49-72" "73-94"; do
  ./python/yt-dl.py -q best -o "$OUT" --archive "$ARCH" \
    --playlist-items "$range" "$URL" \
    > "/tmp/yt-dl-$range.log" 2>&1 &
done
wait
```

Tail any log with `tail -f /tmp/yt-dl-1-24.log`. Total parallelism = (processes) × (`-c` per process); 4 × 4 = 16 connections is a reasonable upper bound on a single home connection. Beyond that, you'll usually saturate bandwidth or hit YouTube throttling rather than gain speed.

## Tips

- **One `--archive` per library**, not per playlist. Point every run at the same file and yt-dlp tracks IDs globally — re-runs across overlapping playlists/channels won't re-download.
- **Bad video in a playlist?** `ignoreerrors` is on; one failure won't kill the run.
- **Need a feature this doesn't expose** (subtitles, sponsor-block, specific format)? Use `yt-dlp` directly — `uv tool run yt-dlp <flags> URL`. The script is intentionally minimal; if you find yourself extending it past a few flags, that's a signal to use raw `yt-dlp` instead.
