# -----------------------------------------------------
# OH MY ZSH
# -----------------------------------------------------

# -----------------------------------------------------
# Theme: Prompt 使用跨 shell 通用的 oh-my-posh 替代
# -----------------------------------------------------
# ZSH_THEME="robbyrussell"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# -----------------------------------------------------
# ohmyposh Prompt
# -----------------------------------------------------
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/EDM115-newline.omp.json)"

# -----------------------------------------------------
# omz 默认配置项
# -----------------------------------------------------
# Auto update settings
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 60

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# -----------------------------------------------------
# plugins
# -----------------------------------------------------
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# # 插件列表和具体说明可见：
# # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
# plugins=(
#   ## aliases: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
#   git
#   brew
#   eza
#   conda
#   archlinux
#
#   # auto suggestions
#   zsh-autosuggestions
#   # highlights
#   zsh-syntax-highlighting
#   fast-syntax-highlighting
#   # <Esc> twice to add 'sudo' before the last command
#   sudo
#   # load autojump, which can 'j' to frequently used folders
#   autojump
#   # zsh's vim mode
#   # zsh-vi-mode
#   # web_search google xxx
#   web-search
#   # <Alt> + ↑↓←→
#   dirhistory
#   # if alias exists, suggest it: https://github.com/MichaelAquilina/zsh-you-should-use
#   you-should-use
# )
export YSU_MESSAGE_POSITION="after"

zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'dirs-first' yes

# Don't load Oh My Zsh on Linux TTYs
# [[ -z "$OMZ_LOAD" && $TTY = /dev/tty* && $OSTYPE = linux* ]] || source "$ZSH/oh-my-zsh.sh"

# -----------------------------------------------------
# Set-up zsh-vi-mode 设置不同模式不同光标
# -----------------------------------------------------
export VI_MODE_SET_CURSOR=true

# -----------------------------------------------------
# Set-up zsh-autosuggestions
# -----------------------------------------------------
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^L' autosuggest-accept
# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# -----------------------------------------------------
# Set-up FZF key bindings (CTRL R for fuzzy history finder)
# -----------------------------------------------------
source <(fzf --zsh)

# -----------------------------------------------------
# Set-up LANG
# -----------------------------------------------------
export LANG=zh_CN.UTF-8

