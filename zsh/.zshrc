# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# ensure tmux is in path
export PATH="$HOME/opt/homebrew/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/Users/tania/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

# I am using Unicorn theme here - which is my own theme @trallard
ZSH_THEME="unicorn-theme"
ZSH_THEME="powerlevel10k/powerlevel10k"

# prompt elements
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git docker tmux tmuxinator kubectl colorize pip colored-man-pages
)

ZSH_DISABLE_COMPFIX="true"

# need to source zsh stuff
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_GB.UTF-8

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# add homebrew to path

if [ -d "$HOME/opt/homebrew" ]; then
    export PATH="$HOME/opt/homebrew/bin:$PATH"
    export MANPATH="$HOME/opt/homebrew/share/man:$MANPATH"
fi


if [ -d "$HOME/opt/homebrew/opt/coreutils" ]; then
    export PATH="$HOME/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="$HOME/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# Add Visual Studio Code (code) to path
export PATH="$PATH:/Users/tania/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Tree view of current dir
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# ensure I use 256 colours
export TERM="xterm-256color"

# make sure the locale is set
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

###########################
# Custom functions
###########################

# activate pipenv venv
pv_activate(){
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

# enable colours using the command ls, since using coreutils this is gls
alias lss="gls --color=always"
alias ls="exal"

# Enable coloured output
alias grep='grep --color=auto'

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
BAT_THEME="ansi-dark"

###########################
# Aliases
###########################

# jupyter alias
alias lab="jupyter lab"

# exa aliases
alias exal='exa --long -h'      # long with header
alias exat='exa --long --tree'  # long plus tree
alias exaa='exa --all'          # show all hidden files
alias exag='exa --git-ignore'   # ignore files in the gitignore
alias exas='exa --long --git -h'# show status
alias exam='exa -m --long -h'   # long with modified
alias examods='exa --long --sort modified -r' # sort by last modified
alias exacrs='exa --long -U --sort created -r' # sort by last created
alias exala='exa --long -h -a'  # show long and . files

# docker aliases
alias dk='docker'           # default docker command
alias dki='docker images'   # docker images
alias dkr='docker rmi'      # docker rmi
alias dk-clean-u='docker system prune --all --force --volumes'
alias dk-clean-all='docker stop $(docker container ls -a -q) && docker system prune -a -f --volumes'

# npm
alias npm-list='npm install -g npm'

# shortcuts to some folders
alias ch-gh='cd Documents/github'
alias ch-gh-tr='cd Documents/github/trallard'
alias ch-gh-qs='cd Documents/github/quansight'

# autocomplete kubectl
source <(kubectl completion zsh)

# cat is bat
alias cat='bat'

# gitkraken 
alias kraken='open -na "GitKraken" --args -p $(git rev-parse --show-toplevel)'

# Rstudio
alias rstudio='open -na "Rstudio"'

# code lazy
alias codeh='code .'
alias coder='code ~/.'
alias cdco='cd "$1" && code .'

# gitmoji
alias gitm='gitmoji -c'

# pyenv
alias pyenv-env='ls ~/.pyenv/versions'

# because yoink! fetch and merge master
alias yoink='git checkout master && git fetch upstream master && git merge upstream/master'

# brew stuff
alias brewu='brew update && brew upgrade && brew cleanup'

# gcal
alias gcal='gcalcli'
alias gagenda='gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda --nostarted'
alias gwk='gcalcli --cal "🦄  Tania Allard" calw --monday --noweekend'
alias g24='now=`date` && tomorrow=`date -v+1d` &&  gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda --nostarted $now $tomorrow --details end --override-color'
alias g24now='now=`date` && tomorrow=`date -v+1d` &&  gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda $now $tomorrow --details end --color-now-marker brightblue'
alias gurl='now=`date` && tomorrow=`date -v+1H` &&  gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda --nostarted $now $tomorrow --details 'conference' --override-color --details end'
alias gurld='now=`date` && tomorrow=`date -v+3H` &&  gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda $now $tomorrow --details 'conference' --override-color --details end --details description'


###########################
# Misc source and exports
###########################

# make sure to source bash (so that conda works)
# source ~/.bash_profile 

# source subrepo
source ~/Documents/github/sources/git-subrepo/.rc

# add openssl to the path -> needed for SQL
export PATH="/usr/local/opt/openssl/bin:$PATH"

# needed for ruby
export PATH="/Users/tania/.rbenv/shims:${PATH}" 

# terraform
export PATH="$PATH:/Users/tania/Documents/github/sources"

# poetry add to path
export PATH="$PATH:$HOME/.poetry/env"

# needed for pyenv 
# echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi'
# Created by `userpath` on 2020-05-04 10:35:50
export PATH="$PATH:/Users/tania/.local/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/tania/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/tania/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/tania/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/tania/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

