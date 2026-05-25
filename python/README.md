# Python scripts

**Strict rule: stdlib-only OR `uv run --script` inline-deps (PEP 723).** No `requirements.txt`, no `pyproject.toml`, no `.venv/` in this repo.

If you find yourself wanting any of those, the script has outgrown this repo — promote it to its own project at `~/Projects/personal/<name>/` using the personal-framework template.

## Inline-deps pattern

Put a PEP 723 header at the top of the file:

```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["requests", "rich"]
# ///
import requests
from rich import print
...
```

Then `chmod +x yourscript.py` and run it directly. `uv` builds and caches the env; nothing leaks into this repo. Works the same on Mac, Windows (via WSL or PowerShell + `uv`), and Linux.
