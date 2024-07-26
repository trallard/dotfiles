# ------------------------------------------------------------------------------
# Personal ZSH configuration.
# @trallard
# ------------------------------------------------------------------------------
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
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# add openssl to the path -> needed for SQL
export PATH="/usr/local/opt/openssl/bin:$PATH"

# Add Visual Studio Code (code) to path
export PATH="$PATH:$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# ensure we can find the docker host
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

# ------------------------------------------------------------------------------
# Zsh theme
# ------------------------------------------------------------------------------

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

# Use powerlevel10K
ZSH_THEME="powerlevel10k/powerlevel10k"

# This is trallard's customised powerlevel10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------------------------------------------------------
# User settings
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
    git docker kubectl colorize pip colored-man-pages alias-finder brew gatsby httpie kops tmux tmuxinator copypath gh
)

ZSH_DISABLE_COMPFIX="true"

# sourcing ZSH stuff
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
export BAT_THEME="ansi"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion


# ------------------------------------------------------------------------------
# Custom functions
# ------------------------------------------------------------------------------

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
# source $envdir/bin/activate  # commented out by conda initialize
    export PYTHONPATH=`pwd`
    echo -e "\x1b[38;5;2m📦 - Activated virtualenv at $envdir\x1b[0m"
    python --version
}

# lazy open dir in code
coded(){
    cd "$1" && code .
}

# makedir and touch
mtouch() {
    if [ $# -lt 1 ]; then
        echo "Missing argument";
        return 1;
    fi

    for f in "$@"; do
        mkdir -p -- "$(dirname -- "$f")"
        touch -- "$f"
    done
}

killproc() {
    if [ -z "$1" ]; then
        echo "Usage: killproc <pid>"
        return 1
    fi
    kill -9 $1
    echo "Process $1 has been killed."
}

# ------------------------------------------------------------------------------
# Initialisations and misc loads
# ------------------------------------------------------------------------------

autoload -U +X bashcompinit && bashcompinit

# For compilers to find zlib
export LDFLAGS="-L/opt/homebrew/opt/zlib/lib"
export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"

# add fuzzy finder
source <(fzf --zsh)
# add zoxide
eval "$(zoxide init zsh)"
# autocomplete kubectl
source <(kubectl completion zsh)
# mcfly command
eval "$(mcfly init zsh)"

# Ensure we can find sockets for secretive
export SSH_AUTH_SOCK=/Users/trallard/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# Add broot
source /Users/trallard/.config/broot/launcher/bash/br

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/trallard/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/trallard/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/trallard/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/trallard/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/trallard/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/trallard/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<


# add pixi completions
eval "$(pixi completion --shell zsh)"
