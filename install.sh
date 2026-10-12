#!/usr/bin/env bash
# Symlink the tools into ~/.local/bin (or $PREFIX/bin) and check dependencies.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="${PREFIX:-$HOME/.local}/bin"
mkdir -p "$dest"
for f in tt git-dash tmux-git-status; do
  chmod +x "$here/bin/$f"
  ln -sf "$here/bin/$f" "$dest/$f"
  echo "linked $dest/$f"
done
case ":$PATH:" in *":$dest:"*) ;; *) echo "note: add $dest to your PATH";; esac
for dep in python3 tmux fzf lazygit; do
  command -v "$dep" >/dev/null || echo "missing: $dep  (brew install $dep)"
done
echo "tmux: add 'source-file $here/tmux/tatr-mac.tmux' to ~/.tmux.conf"
