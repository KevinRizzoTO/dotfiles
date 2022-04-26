# frozen_string_literal: true

require 'rbconfig'

def sh_swallow(cmd)
  sh(cmd) do |ok, res|
    return [ok, res]
  end
end

task default: 'all'

namespace 'zsh' do
  task all: %i[oh_my_zsh zsh_autosuggestions zsh_syntax_highlighting zsh_z zsh_vim_mode fzf_tab p10k]

  def download_zsh_plugin(clone_args, name)
    sh_swallow("git clone #{clone_args} ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/#{name}")
  end

  task :oh_my_zsh do
    sh_swallow('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
  end

  task zsh_autosuggestions: :oh_my_zsh do
    download_zsh_plugin('https://github.com/zsh-users/zsh-autosuggestions', 'zsh-autosuggestions')
  end

  task zsh_syntax_highlighting: :oh_my_zsh do
    download_zsh_plugin('https://github.com/zsh-users/zsh-syntax-highlighting.git', 'zsh-syntax-highlighting')
  end

  task zsh_z: :oh_my_zsh do
    download_zsh_plugin('https://github.com/agkozak/zsh-z', 'zsh-z')
  end

  task zsh_vim_mode: :oh_my_zsh do
    download_zsh_plugin('https://github.com/softmoth/zsh-vim-mode', 'zsh-vim-mode')
  end

  task fzf_tab: :oh_my_zsh do
    download_zsh_plugin('https://github.com/Aloxaf/fzf-tab', 'fzf-tab')
  end

  task p10k: :oh_my_zsh do
    sh_swallow('git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k')
  end
end

namespace 'packages' do
  def deb(deb_url)
    sh_swallow("wget #{deb_url} -P /tmp && sudo apt -o DPkg::Lock::Timeout=10000 install /tmp/#{deb_url.split('/').last}")
  end

  task all: %i[lazygit delta bat fzf add_apt_repos apt_get_install nvim golang]

  task :delta do
    deb('https://github.com/dandavison/delta/releases/download/0.9.1/git-delta-musl_0.9.1_amd64.deb')
  end

  task :bat do
    deb('https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb')
  end

  task :lazygit do
    sh_swallow('wget https://github.com/jesseduffield/lazygit/releases/download/v0.30.1/lazygit_0.30.1_Linux_x86_64.tar.gz && mkdir /tmp/lazygit && tar -xzvf lazygit_0.30.1_Linux_x86_64.tar.gz -C /tmp/lazygit/ && sudo mv /tmp/lazygit/lazygit /usr/bin/lazygit')
  end

  task :fzf do
    sh_swallow('git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all')
  end

  task nvim: :add_apt_repos do
    sh_swallow('sudo apt-get -o DPkg::Lock::Timeout=10000 install -y neovim')
  end

  task golang: :add_apt_repos do
    sh_swallow('sudo apt-get -o DPkg::Lock::Timeout=10000 install -y golang-go')
  end

  task :add_apt_repos do
    sh_swallow('sudo add-apt-repository ppa:neovim-ppa/stable -y && sudo add-apt-repository ppa:longsleep/golang-backports -y && sudo apt-get -o DPkg::Lock::Timeout=10000 -y update')
  end

  task apt_get_install: :nvim do
    sh_swallow('sudo apt-get -o DPkg::Lock::Timeout=10000 install -y ranger caca-utils highlight atool poppler-utils mediainfo ripgrep stow --fix-missing')
  end
end

namespace 'symlink' do
  def stow(folder)
    sh_swallow("stow -t $HOME #{folder}")
  end

  task all: %i[nvim p10k zsh tmux ranger lazygit]

  task :nvim do
    stow('nvim')
  end

  task :p10k do
    stow('p10k')
  end

  task :zsh do
    sh_swallow('rm ~/.zshrc')
    stow('zsh')
  end

  task :tmux do
    stow('tmux')
  end

  task :ranger do
    stow('ranger')
  end


  task :lazygit do
    stow('lazygit')
  end
end

namespace 'ranger_plugins' do
  def dl_plugin(url)
    sh_swallow("git clone #{url} ~/.config/ranger/plugins/#{url.split('/').last}")
  end

  task all: %i[devicons]

  task devicons: 'symlink:ranger' do
    dl_plugin('https://github.com/alexanderjeurissen/ranger_devicons')
  end
end

namespace 'nvim' do
  task all: %i[install_plugins install_ts_parsers install_lsps]

  task install_plugins: 'packages:nvim' do
    sh_swallow(%q[nvim --headless -u NONE -c 'autocmd User PackerComplete quitall' -c 'lua require("plugins")' -c 'PackerSync'])
  end

  task install_ts_parsers: %w[packages:nvim install_plugins] do
    sh_swallow('nvim --headless -c "TSInstallSync all" -c "quitall"')
  end

  task install_lsps: %w[packages:nvim packages:golang install_plugins] do
    sh_swallow('nvim --headless -c "LspInstall --sync solargraph tsserver efm rust_analyzer" -c "quitall"')
  end
end

task all: %w[zsh:all packages:all symlink:all ranger_plugins:all nvim:all]
