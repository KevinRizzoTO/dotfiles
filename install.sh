wait_for_lock() {
  while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
     sleep 1
  done
}

# oh my zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# powerlevel10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# oh my zsh plugins

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
git clone https://github.com/softmoth/zsh-vim-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vim-mode
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

if [ $SPIN ]; then

  wget https://github.com/dandavison/delta/releases/download/0.9.1/git-delta-musl_0.9.1_amd64.deb
  wait_for_lock && sudo dpkg -i git-delta-musl_0.9.1_amd64.deb

  wait_for_lock && sudo add-apt-repository ppa:neovim-ppa/unstable -y
  wait_for_lock && sudo add-apt-repository ppa:longsleep/golang-backports -y

  wget https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb
  wait_for_lock && sudo dpkg -i bat_0.18.3_amd64.deb 

  wget https://github.com/jesseduffield/lazygit/releases/download/v0.30.1/lazygit_0.30.1_Linux_x86_64.tar.gz
  mkdir /tmp/lazygit
  tar -xzvf lazygit_0.30.1_Linux_x86_64.tar.gz -C /tmp/lazygit/
  sudo mv /tmp/lazygit/lazygit /usr/bin/lazygit

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all

  wait_for_lock && sudo apt-get update -y
  wait_for_lock && sudo apt-get install -y ranger caca-utils highlight atool poppler-utils mediainfo ripgrep stow neovim golang-go --fix-missing

  stow nvim
  stow p10k

  rm ~/.zshrc
  stow zsh

  stow tmux
  stow ranger
  stow lazygit

  echo 'AddressFamily inet' | sudo tee -a /etc/ssh/sshd_config
  sudo service ssh restart

else
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

  brew install obsidian

  brew install saulpw/vd/visidata

  brew install ranger

  brew install spotify

  brew install docker

fi

# install ranger plugins

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# install neovim plugins

nvim --headless -u NONE -c 'autocmd User PackerComplete quitall' -c 'lua require("plugins")'
nvim --headless -c "LspInstall --sync solargraph tsserver efm rust_analyzer" -c "q"
