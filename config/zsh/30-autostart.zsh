# -----------------------------------------------------
# AUTOSTART
# -----------------------------------------------------

# -----------------------------------------------------
# Pywal
# -----------------------------------------------------
if [ -f ~/.cache/wal/sequences ]; then
  \cat ~/.cache/wal/sequences
fi

# -----------------------------------------------------
# Fastfetch examples 好看的有：6,7 但有点大, 13但logo有点小
# -----------------------------------------------------
if [ "$(uname -s)" = "Linux" ]; then
  if [[ $(tty) == *"pts"* ]]; then
      fastfetch --config examples/13
  else
      echo
      if [ -f /bin/qtile ]; then
          echo "Start Qtile X11 with command Qtile"
      fi
      if [ -f /bin/hyprctl ]; then
          echo "Start Hyprland with command Hyprland"
      fi
  fi
elif [ "$(uname -s)" = "Darwin" ]; then
  fastfetch --config examples/13
else
  echo "这什么鬼系统？"
fi

# -----------------------------------------------------
# Carapace
# -----------------------------------------------------
if command -v carapace &>/dev/null; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
fi

