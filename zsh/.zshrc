# ------------------------------------------------------------------------------
# Personal ZSH configuration.
# @trallard ------------------------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# ------------------------------------------------------------------------------
# Adding stuff to PATH
# ------------------------------------------------------------------------------
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/tania/.oh-my-zsh"

# ensure tmux is in path
export PATH="$HOME/opt/homebrew/bin:$PATH"

# add openssl to the path -> needed for SQL
export PATH="/usr/local/opt/openssl/bin:$PATH"

# needed for ruby
export PATH="/Users/tania/.rbenv/bin:$PATH"
export PATH="/Users/tania/.rbenv/shims:$PATH"

# terraform
export PATH="$PATH:/Users/tania/Documents/github/sources"

# poetry add to path
export PATH="$PATH:$HOME/.poetry/env"

# needed for pyenv
# echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi'
# Created by `userpath` on 2020-05-04 10:35:50
export PATH="$PATH:/Users/tania/.local/bin"

# add homebrew to path

if [ -d "$HOME/opt/homebrew" ]; then
    export PATH="$HOME/opt/homebrew/bin:$PATH"
    export MANPATH="$HOME/opt/homebrew/share/man:$MANPATH"
fi

# using coreutils
if [ -d "$HOME/opt/homebrew/opt/coreutils" ]; then
    export PATH="$HOME/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="$HOME/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# Add Visual Studio Code (code) to path
export PATH="$PATH:/Users/tania/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# add fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ------------------------------------------------------------------------------
# Zsh theme
# ------------------------------------------------------------------------------

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

# I am using Unicorn theme here - which is my own theme
ZSH_THEME="unicorn-theme"
ZSH_THEME="cute-theme"
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt edit ~/.p10k.zsh.
# This replaces the old setting in this file
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------------------------------------------------------
# user settings
# ------------------------------------------------------------------------------

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    git docker kubectl colorize pip colored-man-pages alias-finder brew gatsby httpie kops tmux tmuxinator autoswitch_virtualenv
)

ZSH_DISABLE_COMPFIX="true"

# sourcing ZSH stuff
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# autocomplete kubectl
source <(kubectl completion zsh)

# ensure I use 256 colours
export TERM="xterm-256color"

# make sure the locale is set
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# Set preferred pager...
export PAGER='less'
# ... and enable colour output (output ANSI "color" escape sequences)

# Set colors for less. Borrowed from https://wiki.archlinux.org/index.php/Color_output_in_console#less .
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# bat https://github.com/sharkdp/bat
# BAT_THEME="ansi"
BAT_THEME="Nord"

# Ruby
eval "$(rbenv init -)"
export PATH="$HOME/.gem/ruby/2.7.2/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# ------------------------------------------------------------------------------
# Custom functions
# ------------------------------------------------------------------------------

# activate pipenv venv
pv_activate() {
    activate_file=$(pipenv --venv)/bin/activate
    if [ -e "$activate_file" ]; then
        . $activate_file

        # the pipenv shell normally enables these as well
        export PYTHONDONTWRITEBYTECODE=1
        export PIPENV_ACTIVE=1

        if [ -f "${VIRTUAL_ENV}/.project" ]; then
            cd $(cat "${VIRTUAL_ENV}/.project")
        fi
        return
    fi
}

# activate venv
venv_activate(){    
    default_venv_dir=".venv"
    envdir=$(1:=$default_venv_dir)

    if [! -d $envdir ]; then
        echo "No venv found at $envdir - setting now 🧱"
        python -m venev $envdir
        echo -e "\x1b[38;5;2m📦 - Created virtualenv at $envdir\x1b[0m"
        return
    fi
    source $envdir/bin/activate
    export PYTHONPATH=`pwd`
    echo -e "\x1b[38;5;2m📦 - Activated virtualenv at $envdir\x1b[0m"
    python --version
}

# ------------------------------------------------------------------------------

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/tania/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/tania/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/tania/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/tania/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
