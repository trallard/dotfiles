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
echo "Note that this highly customised to fit my needs, do not follow this as is"

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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
fi

#############################################
### Select computer name
#############################################
echo ""
echo "🦄 Would you like to set your computer name (as done via System Preferences >> Sharing)?  (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "What are we naming this babe?"
  read COMPUTER_NAME
  sudo scutil --set ComputerName $COMPUTER_NAME
  sudo scutil --set HostName $COMPUTER_NAME
  sudo scutil --set LocalHostName $COMPUTER_NAME
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
fi

####################################################################################################
### Generate ssh keys & add to ssh-agent
### See: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
####################################################################################################

cecho "🔑 Generating ssh keys, adding to ssh-agent. Type the email you want to use:" $magenta
read -p 'Input email for ssh key: ' useremail

cecho "Use default ssh file location, enter a passphrase: " $magenta
ssh-keygen -t ed25519 -C "$useremail" # will prompt for password
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
		IdentityFile ~/.ssh/id_ed25519
EOT
fi

# #############################################
# ### Add ssh-key to GitHub via api
# #############################################

cecho "🔑 Adding ssh-key to GitHub (via api)..." $magenta
cecho "Important! For this step, use a github personal token with the admin:public_key permission." $red
cecho "If you don't have one, create it here: https://github.com/settings/tokens/new" $magenta
cecho "make sure to never store your PATs in Github" $magenta

retries=3
SSH_KEY=$(cat ~/.ssh/id_ed25519.pub)

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

echo ""
echo "Save to Disk not to iCloud by default"
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

echo ""
echo "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo 'Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.'
  sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
fi

echo ""
echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo ""
echo "Removing duplicates in the 'Open With' menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################

echo ""
echo "Increasing sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo ""
echo "Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo ""
echo "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo ""
echo "Disable keyboard from automatically adjusting backlight brightness in low light? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool false
fi

###############################################################################
# Screenshots / Screen                                                        #
###############################################################################

echo ""
echo "Where do you want screenshots to be stored? (hit ENTER if you want ~/Desktop as default)"
read screenshot_location
echo ""
if [ -z "${screenshot_location}" ]; then
  # If nothing specified, we default to ~/Desktop
  screenshot_location="${HOME}/Desktop"
else
  # Otherwise we use input
  if [[ "${screenshot_location:0:1}" != "/" ]]; then
    # If input doesn't start with /, assume it's relative to home
    screenshot_location="${HOME}/${screenshot_location}"
  fi
fi
echo "Setting location to ${screenshot_location}"
defaults write com.apple.screencapture location -string "${screenshot_location}"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder
###############################################################################

echo ""
echo "Show icons for hard drives, servers, and removable media on the desktop? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
fi

echo ""
echo "Show hidden files in Finder by default? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.Finder AppleShowAllFiles -bool true
fi

echo ""
echo "Show dotfiles in Finder by default? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.finder AppleShowAllFiles TRUE
fi

echo ""
echo "Show all filename extensions in Finder by default? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
fi

echo ""
echo "Display full POSIX path as Finder window title? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
fi

###############################################################################
# Dock & Mission Control
###############################################################################

echo "Wipe all (default) app icons from the Dock? (y/n)"
echo "(This is only really useful when setting up a new Mac, or if you don't use the Dock to launch apps.)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.dock persistent-apps -array
fi

###############################################################################
# Time Machine
###############################################################################

echo ""
echo "Prevent Time Machine from prompting to use new hard drives as backup volume? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
fi

echo ""
echo "Disable local Time Machine backups? (This can take up a ton of SSD space on <128GB SSDs) (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  hash tmutil &>/dev/null && sudo tmutil disablelocal
fi

###############
# Config git  #
###############
git config --global user.name "Tania Allard"
git config --global user.email "taniar.allard@gmail.com"
git config --global github.user "trallard"

# need to install lfs
git lfs install
git lfs install --system

###############
# conda/mamba    #
###############

# install miniforge
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh

###############
# Pipx    #
###############
pipx ensurepath

# make sure to run
# pipx completions
pipx install black
pipx install blast-radius
pipx install dvc
pipx install gcalcli
pipx install github-activity
pipx install hatch
pipx install isort
pipx install nox
pipx install pdm
pipx install pre-commit
pipx install ruff
pipx install tox
pipx install twine
pipx install deptree
pipx install interrogate
pipx install uv

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

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
