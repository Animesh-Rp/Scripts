#!/usr/bin/env bash
# setup-yt-dl — verify prereqs for python/yt-dl.py and prime the uv cache.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
YT_DL="$SCRIPT_DIR/python/yt-dl.py"

ok()   { printf "  \033[32mok\033[0m   %s\n" "$1"; }
warn() { printf "  \033[33mwarn\033[0m %s\n" "$1"; }
fail() { printf "  \033[31mfail\033[0m %s\n" "$1"; }

install_hint() {
  case "$(uname -s)" in
    Darwin) echo "       brew install $1" ;;
    Linux)  echo "       apt install $1   # or your distro's equivalent" ;;
    *)      echo "       install '$1' for your platform" ;;
  esac
}

echo "Checking prereqs for yt-dl.py..."

if command -v uv >/dev/null 2>&1; then
  ok "uv ($(uv --version))"
else
  fail "uv not found"
  case "$(uname -s)" in
    Darwin) echo "       brew install uv" ;;
    *)      echo "       curl -LsSf https://astral.sh/uv/install.sh | sh" ;;
  esac
  exit 1
fi

if command -v ffmpeg >/dev/null 2>&1; then
  ok "ffmpeg ($(ffmpeg -version | head -1 | awk '{print $3}'))"
else
  fail "ffmpeg not found"
  install_hint ffmpeg
  exit 1
fi

if [[ ! -f "$YT_DL" ]]; then
  fail "yt-dl.py not found at $YT_DL"
  exit 1
fi

if [[ ! -x "$YT_DL" ]]; then
  chmod +x "$YT_DL"
  ok "made yt-dl.py executable"
else
  ok "yt-dl.py is executable"
fi

echo
echo "Priming uv cache for yt-dlp (first time only, ~10s)..."
if "$YT_DL" --help >/dev/null 2>&1; then
  ok "yt-dlp env built and cached"
else
  fail "uv could not build the script env — try running '$YT_DL --help' to see the error"
  exit 1
fi

echo
echo "Ready. Try:"
echo "  $YT_DL \"https://www.youtube.com/watch?v=...\""
echo "See python/yt-dl.md for more recipes."
