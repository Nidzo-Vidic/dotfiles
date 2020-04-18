#!/usr/bin/env bash

export ZSH="/home/$USER/.oh-my-zsh"

export ZSH_THEME="nidzo"

export plugins=(
    colored-man-pages
    colorize
    git
    globalias
    ng
    node
    npm
    zsh-autosuggestions
)

# Ctrl + x Ctrl + e
export EDITOR=nano

# fc in cli
export FCEDIT=code

[ -d "$HOME/.dotnet/tools" ] && export PATH=~/.dotnet/tools:$PATH
[ -d "$HOME/.npm-global/bin" ] && export PATH=~/.npm-global/bin:$PATH # npm config set prefix '~/.npm-global'
[ -d "$HOME/.local/bin" ] && export PATH=~/.local/bin:$PATH
[ -d "$HOME/dev/dotfiles/scripts" ] && export PATH=$HOME/dev/dotfiles/scripts:$PATH

source "$ZSH/oh-my-zsh.sh"

# Lazy stuff
alias ai="sudo apt install"
alias alu="apt list --upgradeable"
alias aud="sudo apt update"
alias aug="sudo apt upgrade"
alias aver="apt-cache policy"
alias counthere="ls -lAh | wc -l"
alias dotfiles="code ~/dev/dotfiles"
alias zshconfig="code ~/dev/dotfiles/zsh/.zshrc"

# Internet
alias yt="youtube-dl -ic"
alias yta="youtube-dl -xic --audio-format mp3"

# PostgreSQL
if type "psql" &> /dev/null
then
    alias startpostgres="sudo service postgresql start; statuspostgres"
    alias statuspostgres="sudo service postgresql status"
    alias stoppostgres="sudo service postgresql stop; statuspostgres"
fi

# Advanced tab completion
setopt auto_menu # automatically use menu completion
zstyle ':completion:*' menu select #select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion
autoload -U compinit
compinit

##########################
# zsh-syntax-highlitning # must always be the last line
##########################
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
