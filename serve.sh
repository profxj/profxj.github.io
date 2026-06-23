#!/usr/bin/env bash
#
# serve.sh — preview profxj.github.io locally at http://localhost:4000
#
# Usage:
#   ./serve.sh             # native build (Ruby + Bundler + Jekyll); serves at :4000
#   ./serve.sh --watch     # also watch files for auto-rebuild + live reload
#   ./serve.sh --docker    # build/run the bundled Docker image instead
#   ./serve.sh --help
#
# Native mode is the fastest day-to-day option; it reuses the gems already
# vendored under ./vendor/bundle (see .bundle/config). Docker mode needs no Ruby
# on your machine but rebuilds the image on first run.
#
# By default the file-watcher is OFF, because on machines whose inotify instance
# limit is exhausted (common with VS Code et al.) Jekyll's watcher dies on
# startup with "Failed to initialize inotify ... user limit on the total number
# of inotify instances has been reached" -- it builds fine but then crashes
# before serving, so the browser sees nothing. Pass --watch to enable live
# reload; if it crashes, raise the limit permanently:
#     echo fs.inotify.max_user_instances=1024 | sudo tee /etc/sysctl.d/40-inotify.conf
#     sudo sysctl --system
#
# Stop the server with Ctrl-C.

set -euo pipefail

# Always run from the repo root (the directory this script lives in).
cd "$(dirname "$0")"

PORT=4000

usage() {
  sed -n '3,24p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

MODE="native"
WATCH=0
for arg in "$@"; do
  case "$arg" in
    --docker) MODE="docker" ;;
    --watch|--livereload) WATCH=1 ;;
    --no-watch) WATCH=0 ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $arg (try --help)" >&2; exit 1 ;;
  esac
done

if [ "$MODE" = "docker" ]; then
  echo "==> Starting Jekyll via Docker Compose (http://localhost:${PORT}/)"
  echo "    First run builds the image; later runs are fast. Ctrl-C to stop."
  exec docker compose up --build
fi

# ---- Native mode -----------------------------------------------------------

# The Jekyll/Bundler executables were installed with `gem install --user-install`,
# so make sure the user gem bin dir is on PATH (harmless if already present).
if command -v ruby >/dev/null 2>&1; then
  GEM_USER_BIN="$(ruby -e 'print Gem.user_dir' 2>/dev/null)/bin"
  case ":$PATH:" in
    *":$GEM_USER_BIN:"*) : ;;
    *) PATH="$GEM_USER_BIN:$PATH" ;;
  esac
fi

if ! command -v bundle >/dev/null 2>&1; then
  cat >&2 <<'EOF'
ERROR: `bundle` was not found on PATH.

Install the toolchain once with your system Ruby (3.2.x):
    gem install --user-install bundler
    bundle config set --local path vendor/bundle   # already set in .bundle/config
    bundle install

…then re-run ./serve.sh. (Or use the no-Ruby route: ./serve.sh --docker)
EOF
  exit 1
fi

# Install/sync gems only when needed (fast no-op once vendored).
if ! bundle check >/dev/null 2>&1; then
  echo "==> Installing gems into ./vendor/bundle (first run only)…"
  bundle install
fi

if [ "$WATCH" = "1" ]; then
  echo "==> Serving at http://localhost:${PORT}/  (live reload on; Ctrl-C to stop)"
  exec bundle exec jekyll serve --livereload --port "$PORT"
else
  echo "==> Serving at http://localhost:${PORT}/  (no watch; Ctrl-C to stop)"
  exec bundle exec jekyll serve --no-watch --port "$PORT"
fi
