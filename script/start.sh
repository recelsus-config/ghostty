#!/usr/bin/env bash
set -euo pipefail

OS="$(uname -s)"
ARCH="$(uname -m)"

find_first() {
  for p in "$@"; do
    [[ -z "${p:-}" ]] && continue
    if [[ -x "$p" ]]; then
      echo "$p"
      return 0
    fi
  done
  return 1
}

TMUX_PATH=""
BASH_PATH=""

case "$OS" in
  Linux)
    TMUX_PATH="$(find_first /usr/bin/tmux /usr/local/bin/tmux "$(command -v tmux 2>/dev/null || true)")" || true
    BASH_PATH="$(find_first /usr/bin/bash /bin/bash /usr/local/bin/bash "$(command -v bash 2>/dev/null || true)")" || true
    ;;
  Darwin)
    BREW_ARM_PREFIX=${HOMEBREW_PREFIX:-/opt/homebrew}
    BREW_INTEL_PREFIX=/usr/local

    if [[ "$ARCH" == "arm64" ]]; then
      TMUX_PATH="$(find_first \
        "$BREW_ARM_PREFIX/bin/tmux" \
        "$BREW_INTEL_PREFIX/bin/tmux" \
        "$(command -v tmux 2>/dev/null || true)")" || true
      BASH_PATH="$(find_first \
        "$BREW_ARM_PREFIX/bin/bash" \
        "$BREW_INTEL_PREFIX/bin/bash" \
        /bin/bash \
        "$(command -v bash 2>/dev/null || true)")" || true
    else # x86_64
      TMUX_PATH="$(find_first \
        "$BREW_INTEL_PREFIX/bin/tmux" \
        "$BREW_ARM_PREFIX/bin/tmux" \
        "$(command -v tmux 2>/dev/null || true)")" || true
      BASH_PATH="$(find_first \
        "$BREW_INTEL_PREFIX/bin/bash" \
        "$BREW_ARM_PREFIX/bin/bash" \
        /bin/bash \
        "$(command -v bash 2>/dev/null || true)")" || true
    fi
    ;;
  *)
    TMUX_PATH="$(command -v tmux 2>/dev/null || true)"
    BASH_PATH="$(command -v bash 2>/dev/null || true)"
    ;;
esac

if [[ -n "${TMUX_PATH:-}" && -x "$TMUX_PATH" ]]; then
  exec "$TMUX_PATH"
elif [[ -n "${BASH_PATH:-}" && -x "$BASH_PATH" ]]; then
  exec "$BASH_PATH"
else
  echo "ERROR: Not Found tmux and bash" >&2
  exit 1
fi

