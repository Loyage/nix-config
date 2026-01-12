# -----------------------------------------------------
# PATHs
# -----------------------------------------------------
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH" # For npm in nix
export PATH="/usr/lib/ccache/bin:$PATH"

# -----------------------------------------------------
# Exports
# -----------------------------------------------------
export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"

# -----------------------------------------------------
# LS_COLORS
# -----------------------------------------------------
if command -v vivid &>/dev/null; then
  export LS_COLORS=$(vivid generate dracula)
  # themes=$(vivid themes)
fi

