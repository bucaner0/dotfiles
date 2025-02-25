#!/usr/bin/env bash

# Thanks to Mathias Bynens!
# ~/.macos — https://github.com/driesvints/dotfiles/blob/main/.macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################
# Jump's to the spot that's clicked on the scroll bar
defaults read-type -globalDomain AppleScrollerPagingBehavior -int 1

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Trackpad                                                                    #
###############################################################################
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
killall Finder

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Decrease the keyboard delay until repeat to min
# https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x/83923#83923
defaults write -globalDomain InitialKeyRepeat -int 20 # normal minimum is 15 (225 ms)

# Increase the keyboard repeat rate to max
# https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x/83923#83923
defaults write -globalDomain KeyRepeat -int 5 # normal minimum is 2 (30 ms)

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Set up hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
defaults write com.apple.dock wvous-tr-corner -int 0   # Top left screen corner → none
defaults write com.apple.dock wvous-tr-modifier -int 0 # Top left screen corner modifier → none
defaults write com.apple.dock wvous-tl-corner -int 0   # Top right screen corner → none
defaults write com.apple.dock wvous-tl-modifier -int 0 # Top right screen corner modifier → none
defaults write com.apple.dock wvous-br-corner -int 0   # Bottom left screen corner → none
defaults write com.apple.dock wvous-br-modifier -int 0 # Bottom left screen corner modifier → none
defaults write com.apple.dock wvous-bl-corner -int 4   # Bottom right screen corner → Desktop
defaults write com.apple.dock wvous-bl-modifier -int 4 # Bottom right screen corner modifier → Desktop

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Increase the dock magnification size
defaults write com.apple.dock largesize -float 110

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use List view in all Finder windows by default
# Four-letter codes for all the views: Icons (icnv), List (nlsv), Columns (clmv), and Gallery (glyv) - https://krypted.com/mac-os-x/change-default-finder-views-using-defaults/
defaults write com.apple.finder FXPreferredViewStyle -string "nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Set Documents as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
# defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Documents/"

###############################################################################
# Energy saving                                                               #
###############################################################################

# Sleep the display after 5 minutes - https://www.dssw.co.uk/reference/pmset/
sudo pmset -a displaysleep 5

# Set machine sleep to 5 minutes on battery
sudo pmset -b sleep 5

# Set low power mode to 'never'
sudo pmset -a lowpowermode 0

# Show battery percentage
defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true

# Show keyboard brightness
defaults -currentHost write com.apple.controlcenter.plist KeyboardBrightness -bool true

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set Flip clock as screen saver

# Activate night shift from sunset to sunrise

# Save screenshots
mkdir "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture location "${HOME}/Desktop/Screenshots"
killall SystemUIServer

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome Canary" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "Terminal" \
    "iCal"; do
    killall "${app}" &>/dev/null
done
echo "Done. Note that some of these of macos file changes require a logout/restart to take effect."
