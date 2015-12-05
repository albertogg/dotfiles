install_casks() {

    # tap cask versions
    brew tap caskroom/versions

    # applications
    brew cask install dropbox
    brew cask install transmission
    brew cask install rowanj-gitx
    brew cask install virtualbox

    # clean
    brew cask cleanup
}
