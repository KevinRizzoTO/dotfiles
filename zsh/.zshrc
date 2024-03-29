# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  nvm
  zsh-z
  zsh-vi-mode
  fzf-tab
  fast-syntax-highlighting
  zsh-autosuggestions
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

# https://github.com/ranger/ranger/wiki/Integration-with-other-programs#changing-directories
function ra {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )

    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$PWD" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -s "/Users/kevinrizzo/.gvm/scripts/gvm" ]] && source "/Users/kevinrizzo/.gvm/scripts/gvm"
test -e /Users/krizzo/.iterm2_shell_integration.zsh && source /Users/krizzo/.iterm2_shell_integration.zsh || true

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
if [ -e /Users/kevinrizzo/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/kevinrizzo/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }

[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)
[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"

# Default to nvim for vim
if command -v nvim &> /dev/null; then
  alias vim='nvim'
fi

if command -v kitty &> /dev/null; then
  kitty + complete setup zsh | source /dev/stdin
fi

alias lg="lazygit -ucf $HOME/.config/lazygit/config.yml"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX, read background from defaults
  local background=$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo "dark" || echo "light")
elif [[ "$OSTYPE" == "linux-gnu"* ]] then
  local background=$(cat $HOME/.background)
fi

# Cat alias/bat config

alias cat="bat"

function set_theme {
  if [[ "$1" == "dark" ]]; then
    local bat_theme="gruvbox-dark"
    local kitty_conf_name="gruvbox_dark"
  else
    local bat_theme="gruvbox-light"
    local kitty_conf_name="gruvbox_light"
  fi

  export BAT_THEME=$bat_theme
  export FZF_DEFAULT_OPTS="--color=$1 --bind ctrl-a:select-all"

  kitty @ --to unix:/tmp/mykitty set-colors --all --configured ~/.config/kitty/$kitty_conf_name.conf

  echo $1 >| ~/.background
}

set_theme $background

function tdm {
  dark-mode

  local dm_status=$(dark-mode status)

  if [[ "$dm_status" == "on"* ]]; then
    set_theme "dark"
  else
    set_theme "light"
  fi
}

# nvm bootstrapping

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#
#python bootstrapping
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

export PIPENV_PYTHON=$PYENV_ROOT/shims/python
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"

# openssl

export PATH="$(brew --prefix openssl)/bin:$PATH"
export LIBRARY_PATH=$LIBRARY_PATH:$(brew --prefix openssl)/lib/

# FZF

export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l "" -g "!{.git,node_modules,vendor,.idea,.direnv,.vim,dist,target,sorbet}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Define an init function and append to zvm_after_init_commands
# https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
function my_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

zvm_after_init_commands+=(my_init)

