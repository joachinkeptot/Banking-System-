# Changes — Setup & Environment Fixes

## Problem
The project could not be run out of the box on most machines. Modern macOS (Homebrew Python) blocks system-wide `pip install`, so `start.sh` would fail before installing any dependencies. MySQL errors were silently swallowed, making debugging difficult.

## What Changed

### `start.sh` — Rewritten for reliability
- **Virtual environment**: Automatically creates and activates a `venv/` so pip installs work on all systems without `--break-system-packages`.
- **MySQL auto-start**: Detects if MySQL is running and attempts to start it via `brew services` (macOS) or `systemctl` (Linux).
- **Error handling**: Added `set -e` and replaced silent `2>/dev/null` redirects with proper error messages and exit codes, so failures are visible.
- **Cross-platform**: Browser open now falls back to `xdg-open` on Linux.

### `.env.example` — Fixed default password
- Changed `DB_PASSWORD=yourpassword` to `DB_PASSWORD=` (empty). Most local MySQL installs have no root password, so the old default caused immediate connection failures.

### `.gitignore` — Added
- Prevents `venv/`, `__pycache__/`, `.env`, and `*.pyc` from being committed. The `.env` file contains local credentials and should not be in version control.

## How to Run
```bash
git clone <repo-url>
cd Banking-System-
./start.sh
```
That's it — the script handles the rest.
