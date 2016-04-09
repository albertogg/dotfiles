install_casks() {
    # tap cask versions
    brew tap caskroom/cask
    brew tap caskroom/versions

    # applications
    brew cask install dropbox
    brew cask install transmission
    brew cask install gitup

    # clean
    brew cask cleanup
}
