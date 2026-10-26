# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# Skip checks that add latency to every interactive shell.
DISABLE_AUTO_UPDATE=true
ZSH_DISABLE_COMPFIX=true

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_DIR="$HOME/.nvm"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-z
  zsh-vi-mode
  fzf-tab
  fast-syntax-highlighting
  zsh-autosuggestions
  evalcache
  docker
  docker-compose
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Add homebrew ruby to path
export PATH="/usr/local/opt/ruby/bin:$PATH"

export EDITOR="nvim"

if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX=/usr/local
fi

oh_my_posh_theme_path="$HOMEBREW_PREFIX/opt/oh-my-posh/themes/gruvbox.omp.json"

eval "$(oh-my-posh --init --shell zsh --config $oh_my_posh_theme_path)"

test -e /Users/krizzo/.iterm2_shell_integration.zsh && source /Users/krizzo/.iterm2_shell_integration.zsh || true

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }

[[ -x /usr/local/bin/brew ]] && _evalcache /usr/local/bin/brew shellenv
[[ -x /opt/homebrew/bin/brew ]] && _evalcache /opt/homebrew/bin/brew shellenv

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"

# Default to nvim for vim
if command -v nvim &> /dev/null; then
  alias vim='nvim'
fi


alias lg="lazygit -ucf $HOME/.config/lazygit/config.yml"

is_dark_mode=$(defaults read -g AppleInterfaceStyle 2> /dev/null)
if [ "$is_dark_mode" = "Dark" ]; then
  bat_theme='gruvbox-dark'
  fzf_theme='dark'
else
  bat_theme='gruvbox-light'
  fzf_theme='light'
fi

export BAT_THEME="$bat_theme"
export FZF_DEFAULT_OPTS="--color=$fzf_theme"

alias cat="bat"

#python bootstrapping
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if (( $+commands[pyenv] )); then _evalcache pyenv init -; fi

if (( $+commands[fnm] )); then _evalcache fnm env; fi

export PIPENV_PYTHON=$PYENV_ROOT/shims/python
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"

# openssl

export PATH="$HOMEBREW_PREFIX/opt/openssl@3/bin:$PATH"
export LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$HOMEBREW_PREFIX/opt/openssl@3/lib"

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:$PATH"

# FZF

export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l "" -g "!{.git,node_modules,vendor,.idea,.direnv,.vim,dist,target,sorbet}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Define an init function and append to zvm_after_init_commands
# https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
function my_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

zvm_after_init_commands+=(my_init)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kevinrizzo/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kevinrizzo/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kevinrizzo/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kevinrizzo/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export LESS="-SRXF"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/kevinrizzo/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.local/bin:$PATH"

# Default notebook for zk commands invoked outside the notes directory.
export ZK_NOTEBOOK_DIR="$HOME/dev/zk-notes"
