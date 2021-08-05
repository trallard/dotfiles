#!/bin/bash
# All in one bash script to install a new computer
#
#   ______        _______.___   ___     __  .__   __.      _______.___________.    ___       __       __
#  /  __  \      /       |\  \ /  /    |  | |  \ |  |     /       |           |   /   \     |  |     |  |
# |  |  |  |    |   (----` \  V  /     |  | |   \|  |    |   (----`---|  |----`  /  ^  \    |  |     |  |
# |  |  |  |     \   \      >   <      |  | |  . `  |     \   \       |  |      /  /_\  \   |  |     |  |
# |  `--'  | .----)   |    /  .  \     |  | |  |\   | .----)   |      |  |     /  _____  \  |  `----.|  `----.
#  \______/  |_______/    /__/ \__\    |__| |__| \__| |_______/       |__|    /__/     \__\ |_______||_______|
#

echo "Entering 🦄  mode "
echo "Mac OS Install Setup Script"
echo "By Tania Allard"
echo "Note that this highly customised to fit my needs, do not follow this blindly"

# Some configs reused from:
# https://github.com/ruyadorno/installme-osx/
# https://gist.github.com/millermedeiros/6615994
# https://gist.github.com/brandonb927/3195465/

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
reset=$(tput sgr0)

# Color-echo.
cecho() {
  echo "${2}${1}${reset}"
  return
}

echo ""
cecho "###############################################" $red
cecho "#        DO NOT RUN THIS SCRIPT BLINDLY       #" $red
cecho "#         YOU'LL PROBABLY REGRET IT...        #" $red
cecho "#                                             #" $red
cecho "#              READ IT THOROUGHLY             #" $red
cecho "#         AND EDIT TO SUIT YOUR NEEDS         #" $red
cecho "###############################################" $red
echo ""

# Set continue to false by default.
CONTINUE=false

# prompts the user to confirm the changes
echo ""
cecho "⚠️ Have you read through the script you're about to run and " $red
cecho "understood that it will make changes to your computer? (y/n)" $red
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  cecho "Please go read the script, it only takes a few minutes" $red
  exit
fi

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

##############################
# Prerequisite: Install Brew #
##############################

cecho "🍻 Installing brew..." $magenta

if test ! $(which brew); then
  ## Don't prompt for confirmation when installing homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
fi

#############################################
### Select computer name
#############################################
cecho "🧜🏼‍♀️ Setting the computer name... beware" $magentac
read -p "How are we calling this brand new babe?:" thisname
scutil --set HostName "$thisname"
scutil --set LocalHostName "$thisname"
scutil --set ComputerName "$thisname"
dscacheutil -flushcache

####################################################################################################
### Generate ssh keys & add to ssh-agent
### See: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
####################################################################################################

cecho "🔑 Generating ssh keys, adding to ssh-agent..." $magenta
read -p 'Input email for ssh key: ' useremail

cecho "Use default ssh file location, enter a passphrase: " $magenta
ssh-keygen -t rsa -b 4096 -C "$useremail" # will prompt for password
eval "$(ssh-agent -s)"

# Now that sshconfig is synced add key to ssh-agent and
# store passphrase in keychain
ssh-add -K ~/.ssh/id_rsa

# If you're using macOS Sierra 10.12.2 or later, you will need to modify your ~/.ssh/config file to
# automatically load keys into the ssh-agent and store passphrases in your keychain.

if [ -e ~/.ssh/config ]; then
  echo "ssh config already exists. Skipping adding osx specific settings... "
else
  echo "Writing osx specific settings to ssh config... "
  cat <<EOT >>~/.ssh/config
	Host *
		AddKeysToAgent yes
		UseKeychain yes
		IdentityFile ~/.ssh/id_rsa
EOT
fi

#############################################
### Add ssh-key to GitHub via api
#############################################

cecho "🔑 Adding ssh-key to GitHub (via api)..." $magenta
cecho "Important! For this step, use a github personal token with the admin:public_key permission." $red
cecho "If you don't have one, create it here: https://github.com/settings/tokens/new" $magenta
cecho "make sure to never store your PATs in Github" $magenta

retries=3
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

for ((i = 0; i < retries; i++)); do
  read -p 'GitHub username: ' ghusername
  read -p 'Machine name: ' ghtitle
  read -sp 'GitHub personal token: ' ghtoken

  gh_status_code=$(curl -o /dev/null -s -w "%{http_code}\n" -u "$ghusername:$ghtoken" -d '{"title":"'$ghtitle'","key":"'"$SSH_KEY"'"}' 'https://api.github.com/user/keys')

  if (($gh_status_code - eq == 201)); then
    echo "GitHub ssh key added successfully!"
    break
  else
    echo "😔 Something went wrong. Enter your credentials and try again..."
    echo -n "Status code returned: "
    echo $gh_status_code
  fi
done

[[ $retries -eq i ]] && echo "Adding ssh-key to GitHub failed! Try again later."

# p10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

#############################################
### Fonts
#############################################

echo "Installing fonts..."

### SourceCodePro + Powerline + Awesome Regular (for powerlevel 10k terminal icons)
cd ~/Library/Fonts && {
  curl -O 'https://github.com/Falkor/dotfiles/blob/master/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf?raw=true'
  cd -
}
cd ~/Library/Fonts && {
  curl -O 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete.ttf?raw=true'
  cd -
}

#############################################################################
### Set OSX Preferences - Borrowed from
### https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#############################################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Disable the “Are you sure you want to open this application?” dialog
# defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Screenshots / Screen                                                        #
###############################################################################

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############
# Config git  #
###############
git config --global user.name "Tania Allard"
git config --global user.email "taniar.allard@gmail.com"

# need to install lfs
git lfs install
git lfs install --system

###############
# Pyenv       #
###############

echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >>~/.zshrc

###############
# Anaconda    #
###############

wget --output-file=/tmp/Anaconda3-2020.07-MacOSX-x86_64.sh https://repo.anaconda.com/archive/Anaconda3-2020.07-MacOSX-x86_64.pkg
shasum -a 256 /tmp/Anaconda3-2020.07-MacOSX-x86_64.sh

bash ~/tmp/Anaconda3-2020.07-MacOSX-x86_64.sh -b -p $HOME/anaconda

# eval "$(/Users/tania/anaconda/bin/conda shell.YOUR_SHELL_NAME hook)"

# conda init szh
# conda list

# conda config --set auto_activate_base False

###############
# Pipx    #
###############
pipx ensurepath

# make sure to run
# pipx completions
pipx install black
pipx install dvc
pipx install isort
pipx install jupyter-repo2docker
pipx install pipenv
pipx install poetry
pipx install gcalcli

############
# Node
############
npm install -g pa11y terminalizer gatsby-cli yo

############
# Homebrew
############

brew upgrade
brew bundle install
brew cleanup

# ------------------------------------------------------------------------------
# Miscellaneous
# ------------------------------------------------------------------------------

git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "$ZSH_CUSTOM/plugins/autoswitch_virtualenv"

