# ------------------------------------------------------------------------------
# aliases
# ------------------------------------------------------------------------------

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# enable colours using the command ls, since using coreutils this is gls
alias lss="gls --color=always"

# I prefer eza so replace ls here so that eza is the default
alias ls="ezal"

# Enable coloured output
alias grep='grep --color=auto'

# jupyter alias
alias lab="jupyter lab"

# eza aliases
alias ezal='eza --long -h'                     # long with header
alias ezat='eza --long --tree'                 # long plus tree
alias ezaa='eza --all'                         # show all hidden files
alias ezag='eza --git-ignore'                  # ignore files in the gitignore
alias ezas='eza --long --git -h'               # show status
alias ezam='eza -m --long -h'                  # long with modified
alias ezamods='eza --long --sort modified -r'  # sort by last modified
alias ezacrs='eza --long -U --sort created -r' # sort by last created
alias ezala='eza --long -h -a'                 # show long and . files

# docker aliases
alias dk='docker'         # default docker command
alias dki='docker images' # docker images
alias dkr='docker rmi'    # docker rmi
alias dk-clean-u='docker system prune --all --force --volumes'
alias dk-clean-all='docker stop $(docker container ls -a -q) && docker system prune -a -f --volumes'
alias dk-prune='docker system prune --all'
alias dk-ca='docker container ls --all | jq -C'

# npm
alias npm-list='npm list -g --depth=0'
alias npm-update='npm install -g npm'

# shortcuts to some folders
alias ch-gh='cd Documents/github'
alias ch-gh-tr='cd Documents/github/trallard'
alias ch-gh-qs='cd Documents/github/quansight'
alias ch-gh-qsc='cd Documents/github/quansight-clients'

# cat is bat
alias cat='bat'

# fd aliases
alias fd='fd … -X bat'

# gitkraken
alias kraken='open -na "GitKraken" --args -p $(git rev-parse --show-toplevel)'

# Rstudio
alias rstudio='open -na "Rstudio"'

# code lazy aliases
alias codeh='code .'
alias coder='code ~/.'

# gitmoji
alias gitm='gitmoji -c'

# pyenv
alias pyenv-env='ls ~/.pyenv/versions'

# because yoink! fetch and merge master
alias yoink='git checkout master && git fetch upstream master && git merge upstream/master'
alias yoinkk='git checkout main && git fetch upstream main && git merge upstream/main'

# brew stuff
alias brewu='brew update && brew upgrade && brew cleanup'

# gcal - I use this for google calendar see .gcalcli for config
alias gcal='gcalcli'
alias gagenda='gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda --nostarted'
alias gwk='gcalcli --cal "🦄  Tania Allard" calw --monday --noweekend'
alias g24='now=`date` && tomorrow=`date -v+1d` &&  gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda --nostarted $now $tomorrow --details end --override-color'
alias g24now='now=`date` && tomorrow=`date -v+1d` &&  gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda $now $tomorrow --details end --color-now-marker brightblue'
alias gurl='now=`date` && tomorrow=`date -v+1H` &&  gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda --nostarted $now $tomorrow --details 'conference' --override-color --details end'
alias gurld='now=`date` && tomorrow=`date -v+3H` &&  gcalcli --cal "🦄  Tania Allard" --lineart "fancy" agenda $now $tomorrow --details 'conference' --override-color --details end --details description'

# Tree view of current dir - might remove as can use ezat
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# show files
alias show-all='defaults write com.apple.finder AppleShowAllFiles true && killall Finder'
alias show-some='defaults write com.apple.Finder AppleShowAllFiles false && killall Finder'

# open files in vscode
alias -s {md, py, ipynb}=code

# pnpm
alias pn=pnpm

# lakefs lakeclt
alias lkc='lakectl'
alias lkc-nb='lakectl branch create'
alias lkc-ch='lakectl local checkout'
alias lkc-cim='lakectl local commit . -m'

# fancy readme
alias fancyrm='pipx run hatch-fancy-pypi-readme | pipx run rich-cli --markdown --hyperlinks -'

# colima
alias colima-s='colima start'
alias colima-sb='colima start --cpu 4 --memory 8'
