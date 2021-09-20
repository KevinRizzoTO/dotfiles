PACKAGES=(
	stow
	alfred
	iterm2
	insomnia
	rectangle
	fzf
	bat
	rg
	yarn
	tmuxinator
	git-delta
	lazygit
	kitty
	font-clear-sans
	font-consolas-for-powerline
	font-dejavu-sans-mono-for-powerline
	font-fira-code
	font-fira-mono-for-powerline
	font-inconsolata
	font-inconsolata-for-powerline
	font-liberation-mono-for-powerline
	font-menlo-for-powerline
	font-roboto
)
brew install "${PACKAGES[@]}"

# oh my zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# nvm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

# powerlevel10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# neovim (at HEAD)

brew install --HEAD neovim
