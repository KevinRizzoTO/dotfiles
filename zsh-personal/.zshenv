# Read by every zsh, including scripts and tools that skip .zshrc. fnm's default
# alias is a stable symlink, so this follows `fnm default`. Interactive shells then
# prepend fnm's per-shell directory in .zshrc, so a project's .node-version wins.
[[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/fnm/aliases/default/bin ]] &&
  export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/fnm/aliases/default/bin:$PATH"
