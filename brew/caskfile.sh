install_casks() {

    # tap cask versions
    brew tap caskroom/versions

    # Quick Look plugins
    brew cask install qlcolorcode
    brew cask install qlstephen
    brew cask install qlmarkdown
    brew cask install quicklook-json
    brew cask install quicklook-csv
    brew cask install webp-quicklook

    # applications
    brew cask install google-chrome
    brew cask install macvim
    brew cask install iterm2-nightly
    brew cask install gitx-rowanj
}
