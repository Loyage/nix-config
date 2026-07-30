# -----------------------------------------------------
# Prompt
# -----------------------------------------------------
# oh-my-posh is cross-shell and can be enabled here if needed.
# eval "$(oh-my-posh init bash --config "$HOME/.config/ohmyposh/zen.toml")"
# eval "$(oh-my-posh init bash --config "$HOME/.config/ohmyposh/EDM115-newline.omp.json")"

# -----------------------------------------------------
# History
# -----------------------------------------------------
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend

# -----------------------------------------------------
# FZF key bindings (CTRL R for fuzzy history finder)
# -----------------------------------------------------
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash)"
fi

# -----------------------------------------------------
# LANG
# -----------------------------------------------------
export LANG=zh_CN.UTF-8
