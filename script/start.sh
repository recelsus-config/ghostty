#!/bin/bash

SYSTEM_INFO="$(uname -sm)"

case "$SYSTEM_INFO" in
  *Linux*)
    APP_PATH="/usr/bin/tmux"
    SHELL_PATH="/usr/bin/bash"
    ;;
  *Darwin*) 
    APP_PATH="/opt/homebrew/bin/tmux"
    SHELL_PATH="/opt/homebrew/bin/bash"
    ;;
esac

if [ -f "$APP_PATH" ]; then
  $APP_PATH
elif [ -f "$SHELL_PATH" ]; then
  $SHELL_PATH
fi
