#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["yt-dlp"]
# ///
# yt-dl — download a YouTube video or playlist via yt-dlp with sensible defaults.

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from yt_dlp import YoutubeDL


def build_opts(out_dir: Path, audio_only: bool, quality: str, archive: Path | None, concurrent: int) -> dict:
    """Return a yt-dlp options dict.

    - Saves into <out_dir>/<channel-or-playlist>/<title>.<ext>
    - Embeds metadata + thumbnail
    - Uses an archive file so re-runs skip videos already downloaded (for playlists/channels)
    """
    opts: dict = {
        "outtmpl": str(out_dir / "%(uploader)s/%(title)s [%(id)s].%(ext)s"),
        "ignoreerrors": True,        # one bad video in a playlist shouldn't kill the run
        "noplaylist": False,         # if URL is a playlist, fetch the whole thing
        "writethumbnail": True,
        "concurrent_fragment_downloads": concurrent,
        "postprocessors": [
            {"key": "FFmpegMetadata"},
            {"key": "EmbedThumbnail", "already_have_thumbnail": False},
        ],
    }

    if audio_only:
        opts["format"] = "bestaudio/best"
        opts["postprocessors"].insert(0, {
            "key": "FFmpegExtractAudio",
            "preferredcodec": "mp3",
            "preferredquality": "192",
        })
    else:
        # quality is a max-height cap like "1080", "720", "best"
        if quality == "best":
            opts["format"] = "bv*+ba/best"
        else:
            opts["format"] = f"bv*[height<={quality}]+ba/best[height<={quality}]"
        opts["merge_output_format"] = "mp4"

    if archive is not None:
        opts["download_archive"] = str(archive)

    return opts


def main() -> int:
    p = argparse.ArgumentParser(
        description="Download a YouTube video or playlist (wrapper around yt-dlp).",
    )
    p.add_argument("url", help="YouTube video or playlist URL")
    p.add_argument(
        "-o", "--out", type=Path, default=Path.cwd() / "downloads",
        help="Output directory (default: ./downloads)",
    )
    p.add_argument(
        "-a", "--audio", action="store_true",
        help="Audio only (mp3, 192kbps)",
    )
    p.add_argument(
        "-q", "--quality", default="1080",
        help="Max video height: 480, 720, 1080, 2160, or 'best' (default: 1080)",
    )
    p.add_argument(
        "--archive", type=Path, default=None,
        help="Path to a download-archive file; videos listed here are skipped. "
             "Useful for repeatedly running against a channel/playlist.",
    )
    p.add_argument(
        "-c", "--concurrent", type=int, default=4,
        help="Concurrent fragment downloads per video (default: 4). "
             "For multi-video parallelism, run several processes with --playlist-items ranges.",
    )
    p.add_argument(
        "--playlist-items", default=None,
        help="Subset of a playlist to download, e.g. '1-24' or '1,3,5'. "
             "Used to split a playlist across parallel processes.",
    )
    args = p.parse_args()

    args.out.mkdir(parents=True, exist_ok=True)
    opts = build_opts(args.out, args.audio, args.quality, args.archive, args.concurrent)
    if args.playlist_items:
        opts["playlist_items"] = args.playlist_items

    with YoutubeDL(opts) as ydl:
        return ydl.download([args.url])


if __name__ == "__main__":
    sys.exit(main())
