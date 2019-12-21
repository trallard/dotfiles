if [ -d "$HOME/opt/homebrew" ]; then
    export PATH="$HOME/opt/homebrew/bin:$PATH"
    export MANPATH="$HOME/opt/homebrew/share/man:$MANPATH"
fi


if [ -d "$HOME/opt/homebrew/opt/coreutils" ]; then
    export PATH="$HOME/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="$HOME/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
fi


source /Users/tania/perl5/perlbrew/etc/bashrc
