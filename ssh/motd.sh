#!/bin/sh

HOSTNAME=`uname -n`

# Colorize

# Set the colours you can use
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Resets the style
reset=`tput sgr0`

# Color-echo.
cecho() {
    echo "${2}${1}${reset}"
    return
}

# * ASCII head
cat << "EOF"
                __                             __                              
 _      _____  / /________  ____ ___  ___     / /_  __  ______ ___  ____ _____ 
| | /| / / _ \/ / ___/ __ \/ __ `__ \/ _ \   / __ \/ / / / __ `__ \/ __ `/ __ \
| |/ |/ /  __/ / /__/ /_/ / / / / / /  __/  / / / / /_/ / / / / / / /_/ / / / /
|__/|__/\___/_/\___/\____/_/ /_/ /_/\___/  /_/ /_/\__,_/_/ /_/ /_/\__,_/_/ /_/ 
                                                                               
EOF


cecho "Welcome $USER to $HOSTNAME" $magenta

echo ""
echo ""

# * Print Output

cecho "::::::::::::::::::::::::::::::::::-RULES-::::::::::::::::::::::::::::::::::" $green
cecho "This is a private system that you are not to give out access to anyone" $green
cecho "without permission from the admin." $green
cecho "No illegal files or activity." $green
cecho "Stay in your home directory, keep the system clean," $green
cecho "and push to GitLab frequently." $green
cecho "Remember to do pip install --user if you need to install anything" $blue

echo ""
echo ""
cecho "Report any unexpected behaviour to ******* " $cyan
