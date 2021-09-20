# install Homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew all the things

brew install stow

brew install alfred

brew install insomnia

brew install rectangle

brew install fzf

brew install bat

brew install rg

brew install yarn

brew install tmuxinator

brew install git-delta

brew install lazygit

brew install kitty

brew install font-clear-sans

brew install font-consolas-for-powerline

brew install font-dejavu-sans-mono-for-powerline

brew install font-fira-code

brew install font-fira-mono-for-powerline

brew install font-inconsolata

brew install font-inconsolata-for-powerline

brew install font-liberation-mono-for-powerline

brew install font-menlo-for-powerline

brew install font-roboto

brew install visual-studio-code

brew install --HEAD neovim

brew install direnv

# oh my zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# nvm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

# powerlevel10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# oh my zsh plugins

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
git clone https://github.com/softmoth/zsh-vim-mode $ZSH_CUSTOM/plugins/zsh-vim-mode
