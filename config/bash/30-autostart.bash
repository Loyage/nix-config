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
  source <(carapace _carapace bash)

  # blesh wraps the `read` builtin; its wrapper corrupts the arguments of the
  # `read -r -d '' nospace data` call inside _carapace_completer, printing
  # `bash: read: "": 不是有效的标识符` on every keystroke while blesh's
  # auto-complete invokes the completer. Redefine it to use `builtin read` to
  # bypass the wrapper. When bumping carapace, re-sync this body with
  # `carapace _carapace bash` output.
  _carapace_completer() {
    export COMP_LINE
    export COMP_POINT
    export COMP_TYPE
    export COMP_WORDBREAKS

    declare -x CARAPACE_SHELL=bash
    declare -x CARAPACE_SHELL_ALIASES="$(compgen -a)"
    declare -x CARAPACE_SHELL_BUILTINS="$(compgen -b)"
    declare -x CARAPACE_SHELL_FUNCTIONS="$(compgen -A function)"
    declare -x CARAPACE_SHELL_JOBS="$(jobs 2>/dev/null | while read -r line; do [[ $line =~ \[([0-9]+)\] ]] && echo %${BASH_REMATCH[1]}; done)"
    declare -x CARAPACE_SHELL_VARIABLES="$(compgen -v)"

    local command="${COMP_WORDS[0]}" nospace data compline="${COMP_LINE:0:${COMP_POINT}}"

    data=$(echo "${compline}''" | xargs carapace "${command}" bash 2>/dev/null)
    if [ $? -eq 1 ]; then
      data=$(echo "${compline}'" | xargs carapace "${command}" bash 2>/dev/null)
      if [ $? -eq 1 ]; then
        data=$(echo "${compline}\"" | xargs carapace "${command}" bash 2>/dev/null)
      fi
    fi

    IFS=$'\001' builtin read -r -d '' nospace data <<<"${data}"
    mapfile -t COMPREPLY < <(echo "${data}")
    unset COMPREPLY[-1]

    [ "${nospace}" = true ] && compopt -o nospace
    local IFS=$'\n'
    [[ "${COMPREPLY[*]}" == "" ]] && COMPREPLY=() # fix for mapfile creating a non-empty array from empty command output
  }
fi
