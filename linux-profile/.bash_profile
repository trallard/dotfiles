# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,bash_prompt,functions,aliases,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# exit early if not interactive
[ -z "$PS1" ] && return

# makes less work on things like tarballs and images
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ $(command -v dircolors) ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if [[ $OSTYPE == darwin* ]]; then
    test -f ~/.git-completion.bash && source ~/.git-completion.bash
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/tania/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
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

# terraform autocomplete
complete -C /usr/local/bin/terraform terraform
