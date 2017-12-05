# preferences for command line
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[38;5;127m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

# Added by Anaconda3 4.4.0 installer
export PATH="/Users/tania/anaconda3/bin:$PATH"

# rbenv
# echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.profile
# source ~/.profile

# Nikola env
export DYLD_LIBRARY_PATH=${HOME}/anaconda/envs/nikola/lib/

# Git-subrepo
source ~/Documents/Git_Repos/git-subrepo/.rc

# Tree view of current dir
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"



##
# Your previous /Users/tania/.bash_profile file was backed up as /Users/tania/.bash_profile.macports-saved_2017-11-23_at_12:47:37
##

# MacPorts Installer addition on 2017-11-23_at_12:47:37: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2017-11-23_at_12:47:37: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH="/opt/local/share/man:$MANPATH"
# Finished adapting your MANPATH environment variable for use with MacPorts.

