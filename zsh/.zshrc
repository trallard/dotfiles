# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/tania.allard/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="cute-theme"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git docker
)

ZSH_DISABLE_COMPFIX="true"

source $ZSH/oh-my-zsh.sh

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
alias lab="jupyter lab"


if [ -d "$HOME/opt/homebrew" ]; then
    export PATH="$HOME/opt/homebrew/bin:$PATH"
    export MANPATH="$HOME/opt/homebrew/share/man:$MANPATH"
fi


if [ -d "$HOME/opt/homebrew/opt/coreutils" ]; then
    export PATH="$HOME/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="$HOME/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# added by Anaconda3 5.2.0 installer
export PATH="/anaconda3/bin:$PATH"


# Add Visual Studio Code (code)
export PATH="$PATH:/Users/tania.allard/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Add Atom editor
alias atom='sh /Users/tania.allard/Applications/Atom.app/Contents/Resources/app/atom.sh'

# Tree view of current dir
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# ensure I use 256 colours
export TERM="xterm-256color"

# My own icon
BULLETTRAIN_PROMPT_CHAR="🦄 "

# make sure the locale is set
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# activate pienv venv
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
alias ls="gls --color=always"

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