# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

alias ntop='nvitop'

# -----------------------------------------------------
# Better commands
# -----------------------------------------------------
# eza -> ls (some are defined by omz plugin)
if command -v eza &>/dev/null; then
  alias lt='eza -T --icons'
  alias lta='eza -T -A --icons'
  alias lla='eza -l --git -A --icons --header'
fi

# bat -> cat
if command -v bat &>/dev/null; then
  alias cat='bat'
fi

# zoxide -> cd
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# gomi -> rm
if command -v gomi &>/dev/null; then
  alias rm='gomi'
  alias rb='gomi -b'
fi

# vim -> nvim
alias vim='nvim'
alias v='nvim'

# grep
alias grep='grep --color'

# cp -i -> cp; mv -i -> mv
# 交互模式 -i 可以防止在复制过程中意外覆盖文件。
alias cp='cp -i'
alias mv='mv -i'

# scp中断续传
alias scp='rsync -avP --partial'

# cd ..
alias ..='cd ..'
alias ...='cd ../..'

# better yazi
function yi() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  \rm -f -- "$tmp"
}

# better tldr (tealdeer as implementation)
alias tldr='tldr --color always'
alias tl='tldr'

# 利用 bat 加强 fzf
export FZF_DEFAULT_OPTS="--height 60% --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
# 再利用加强后的 fzf 加强 cd nvim git_branch
alias fnv='nvim "$(find . -type f | fzf --border)"'
alias fcd='cd   "$(find . -type d | fzf --border --preview="eza -la {}")"'
# alias gcb='git branch | fzf --border --height 60% | cut -c 3- | xargs git checkout'

# nvidia-smi
alias smi='watch -n 2 -d nvidia-smi'


# -----------------------------------------------------
# Because of laziness
# -----------------------------------------------------
alias zshrc="nvim ~/.config/zsh/"
alias echo_path='echo $PATH | tr ":" "\n"'
alias c='clear'

# git
alias gconf='git config user.name "loyage";git config user.email "792058350@qq.com"'
alias ggconf='git config --global user.name "loyage";git config --global user.email "792058350@qq.com"'
alias gs='git status'

# zellij
alias zli='zellij'
alias za='zellij a'

# lazygit, lazyjj
alias lg='lazygit'
alias lj='lazyjj'
alias lsh='lazyssh'

# conda
alias act="conda activate"
alias deact="conda deactivate"
alias conrem="conda remove -n --all"

# for ssh in kitty
if [ "$TERM" = "xterm-kitty" ]; then
  alias ssh="kitten ssh"
fi

# 快速创建 ssh 密钥
gensshkey() {
    if [ -z "$1" ]; then
        echo "Usage:"
        echo "  ssh-ck server-<server_name>   # Generate key for connecting to a specific server"
        echo "  ssh-ck github-<github_account> # Generate key for connecting to a GitHub account"
        return 1  # Exit with an error code to indicate incorrect usage
    fi

    user_host=$(whoami)@$(hostname)
    ssh-keygen -f "$HOME/.ssh/$1" -t rsa -N '' -C "$user_host to $1"
}

# fastfetch
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'

# yadm
if command -v yadm &>/dev/null; then
  alias y='yadm'
  alias ys='yadm status'
  alias ya='yadm add'
  alias yau='yadm add -u && ys' # update tracked files
  alias yc='yadm commit -m'
  alias ypush='yadm push && ys'
  alias ypull='yadm pull && ysj'
  alias yls='yadm ls-files'
  alias ylog='yadm log --oneline --graph --decorate --all'
fi

# -----------------------------------------------------
# For Arch Linux
# -----------------------------------------------------
if [ "$(uname -s)" = "Linux" ]; then
  # Arch Linux
  alias pacs="sudo pacman -S"
  alias pacr="sudo pacman -Rs"
  alias parus="paru -S"
  alias parur="paru -Rs"
  alias mirrorlist="sudo nvim /etc/pacman.d/mirrorlist"
fi
