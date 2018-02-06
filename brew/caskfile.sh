install_casks() {
    # tap cask versions
    brew tap caskroom/cask
    brew tap caskroom/versions

    # applications, ensure they are linked in the /Applications dir
    brew cask install --appdir="/Applications" appcleaner
    brew cask install --appdir="/Applications" dropbox
    brew cask install --appdir="/Applications" transmission
    brew cask install --appdir="/Applications" gitup
    brew cask install --appdir="/Applications" gpg-suite-beta

    # clean
    brew cask cleanup
}
