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
echo "Note that this highly customised to fit my needs"

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
reset=`tput sgr0`

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

# prompts the user to confir the changes 
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
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##############################
# Prerequisite: Install Brew #
##############################

cecho "🍻 Installing brew..." $magenta

if test ! $(which brew)
then
	## Don't prompt for confirmation when installing homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
fi

# Latest brew, install brew cask
brew doctor
brew upgrade
brew update
brew tap caskroom/cask


###############################
# Prerequisite: Install xcode #
###############################
xcode-select --install

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
ssh-keygen -t rsa -b 4096 -C "$useremail"  # will prompt for password
eval "$(ssh-agent -s)"

# Now that sshconfig is synced add key to ssh-agent and
# store passphrase in keychain
ssh-add -K ~/.ssh/id_rsa

# If you're using macOS Sierra 10.12.2 or later, you will need to modify your ~/.ssh/config file to 
# automatically load keys into the ssh-agent and store passphrases in your keychain.

if [ -e ~/.ssh/config ]
then
    echo "ssh config already exists. Skipping adding osx specific settings... "
else
	echo "Writing osx specific settings to ssh config... "
   cat <<EOT >> ~/.ssh/config
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
SSH_KEY=`cat ~/.ssh/id_rsa.pub`

for ((i=0; i<retries; i++)); do
      read -p 'GitHub username: ' ghusername
      read -p 'Machine name: ' ghtitle
      read -sp 'GitHub personal token: ' ghtoken

      gh_status_code=$(curl -o /dev/null -s -w "%{http_code}\n" -u "$ghusername:$ghtoken" -d '{"title":"'$ghtitle'","key":"'"$SSH_KEY"'"}' 'https://api.github.com/user/keys')

      if (( $gh_status_code -eq == 201))
      then
          echo "GitHub ssh key added successfully!"
          break
      else
			echo "😔 Something went wrong. Enter your credentials and try again..."
     		echo -n "Status code returned: "
     		echo $gh_status_code
      fi
done

[[ $retries -eq i ]] && echo "Adding ssh-key to GitHub failed! Try again later."

##############################
# Install via Brew           #
##############################

cecho "🍺 Starting brew app install..." $magenta
cecho "this might take a while" $cyan

# Todo: Try Divvy, sizeup and spectacles in the future

### Developer Tools
brew cask install iterm2
brew cask install dash
brew install ispell
brew install httpie 
brew install bat
brew install fd

### Development
brew cask install docker
brew install make autoconf automake 
brew install kubernetes-cli
brew install kubernetes-helm

### Command line tools - install new ones, update others to latest version
brew install git  # upgrade to latest
brew install git-lfs # track large files in git https://github.com/git-lfs/git-lfs
brew install wget
brew install zsh # zshell
brew install tmux
brew install tree
brew link curl --force
brew install grep --with-default-names
brew install trash  # move to osx trash instead of rm
brew install less
brew install cat 
brew install exa
brew install bat
brew install fd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
brew install ctop

### Dev Editors 
brew cask install visual-studio-code
brew cask install pycharm

### Writing
brew cask install evernote


### Conferences, Blogging, Screencasts
# brew cask install deckset
brew cask install ImageOptim  # for optimizing images
# brew cask install screenflow

### Productivity
brew cask install wavebox
brew cask install google-chrome
# brew cask install alfred
brew cask install dropbox


# brew cask install timing  # time and project tracker
brew cask install keycastr  # show key presses on screen (for gifs & screencasts)
brew cask install betterzip
brew cask install caffeine  # keep computer from sleeping
brew cask install skitch  # app to annotate screenshots
brew cask install muzzle  # silence notifications
brew cask install flux    # red light

### Chat / Video Conference
brew cask install slack
# brew cask install microsoft-teams
brew cask install zoomus


## Music
brew cask install spotify

### Run Brew Cleanup
brew cleanup


#############################################
### Fonts
#############################################

echo "Installing fonts..."

brew tap caskroom/fonts

### programming fonts
brew cask install \
  font-fira-mono-for-powerline \ 
  brew cask install font-fira-code \
  font-pt-mono \
  font-fontawesome \
  font-ibm-plex

### SourceCodePro + Powerline + Awesome Regular (for powerlevel 9k terminal icons)
cd ~/Library/Fonts && { curl -O 'https://github.com/Falkor/dotfiles/blob/master/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf?raw=true' ; cd -; }
cd ~/Library/Fonts && { curl -O 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete.ttf?raw=true' ; cd -; }

### Run Brew Cleanup
brew cleanup


#############################################
### Set OSX Preferences - Borrowed from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#############################################

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