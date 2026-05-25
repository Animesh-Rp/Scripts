# PowerShell scripts

`.ps1` files that run on **PowerShell 7+** (cross-platform: macOS, Linux, Windows).

If a script uses Windows-only APIs (registry, COM, `Get-WmiObject`), note it in the script header. If you accumulate enough of those, split into `powershell-windows/`.

**Belongs here:** single-file utilities. No external modules that need `Install-Module` to be useful — if it does, make it its own repo.
