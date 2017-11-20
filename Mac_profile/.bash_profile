# Preferences for command line (changes the color and content of the prompt
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

# Added by Anaconda3 4.4.0 installer
export PATH="/Users/tania/anaconda3/bin:$PATH"

# rbenv
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.profile
source ~/.profile

# Nikola env
export DYLD_LIBRARY_PATH=${HOME}/anaconda/envs/nikola/lib/

# Git-subrepo
source ~/Documents/Git_Repos/git-subrepo/.rc

# Tree view of current dir
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
