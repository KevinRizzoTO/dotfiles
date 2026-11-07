#!/bin/bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")" && pwd)
cd "$repo_dir"

if [[ $(uname -s) != Darwin ]]; then
  exec rake -m "$@"
fi

dry_run=false
case ${1:-} in
  --dry-run) dry_run=true ;;
  --help|-h)
    echo 'Usage: ./install.sh [--dry-run]'
    echo 'Intel macOS: MacPorts binaries. Apple Silicon: Homebrew (including Rosetta).'
    exit 0 ;;
  '') ;;
  *) echo "Unknown option: $1" >&2; exit 2 ;;
esac
if (( $# > 1 )); then
  echo 'Usage: ./install.sh [--dry-run]' >&2
  exit 2
fi

failures=()
source "$repo_dir/scripts/bootstrap-commands.sh"

machine=$(uname -m)
if [[ $machine == x86_64 ]] && [[ $(sysctl -in sysctl.proc_translated 2>/dev/null || true) == 1 ]]; then
  machine=arm64
fi

case $machine in
  arm64)
    echo 'Apple Silicon: installing packages with Homebrew.'
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/bin:$PATH"
    if [[ $dry_run == false && ! -x /opt/homebrew/bin/brew ]]; then
      echo 'Install native Apple Silicon Homebrew from https://brew.sh, then rerun ./install.sh.' >&2
      exit 1
    fi
    # A shell started under Rosetta must still run the ARM Homebrew installation.
    run arch -arm64 /opt/homebrew/bin/brew bundle --file="$repo_dir/Brewfile"
    run mkdir -p "$HOME/.local/bin"
    run corepack enable yarn --install-directory "$HOME/.local/bin"
    ;;
  x86_64)
    echo 'Intel Mac: installing packages with MacPorts in binary-only mode.'
    export PATH="/opt/local/bin:/opt/local/sbin:$HOME/.local/bin:$PATH"
    if [[ $dry_run == false && ! -x /opt/local/bin/port ]]; then
      echo 'Install the MacPorts package for your macOS version from https://www.macports.org/install.php, then rerun ./install.sh.' >&2
      exit 1
    fi
    ports=()
    while IFS= read -r line || [[ -n $line ]]; do
      line=${line%%#*}
      read -r port_name extra <<< "$line"
      [[ -n $port_name ]] || continue
      if [[ -n $extra || ! $port_name =~ ^[a-zA-Z0-9][a-zA-Z0-9_.+-]*$ ]]; then
        echo "Invalid MacPortsfile entry: $line" >&2
        exit 1
      fi
      ports+=("$port_name")
    done < "$repo_dir/MacPortsfile"
    if (( ${#ports[@]} == 0 )); then
      echo 'MacPortsfile contains no packages.' >&2
      exit 1
    fi
    run sudo /opt/local/bin/port -N sync
    install_macports_packages "${ports[@]}"
    attempt sudo /opt/local/bin/port select --set python3 python313
    attempt sudo /opt/local/bin/port select --set ruby ruby34
    attempt sudo /opt/local/bin/port select --set ansible py314-ansible
    attempt uv tool install pipenv
    attempt uv tool install visidata
    attempt uv tool install --with dbt-duckdb dbt-core
    attempt uv tool install termaid
    run mkdir -p "$HOME/.local/bin"
    attempt env npm_config_prefix="$HOME/.local" npm install --global corepack typescript wrangler
    # Corepack supplies the yarn command; installing yarn separately collides.
    attempt corepack enable yarn --install-directory "$HOME/.local/bin"
    ;;
  *) echo "Unsupported macOS architecture: $machine" >&2; exit 1 ;;
esac

# Install only missing shell dependencies; keep existing checkouts on reruns.
zsh_dir=${ZSH:-$HOME/.oh-my-zsh}
custom_dir=${ZSH_CUSTOM:-$zsh_dir/custom}
if [[ ! -f $zsh_dir/oh-my-zsh.sh ]]; then
  run git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$zsh_dir"
fi
run mkdir -p "$custom_dir/plugins"
while read -r name url; do
  if [[ ! -d $custom_dir/plugins/$name ]]; then
    run git clone --depth=1 "$url" "$custom_dir/plugins/$name"
  fi
done <<'PLUGINS'
zsh-z https://github.com/agkozak/zsh-z.git
zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode.git
fzf-tab https://github.com/Aloxaf/fzf-tab.git
fast-syntax-highlighting https://github.com/zdharma-continuum/fast-syntax-highlighting.git
zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
evalcache https://github.com/mroth/evalcache.git
PLUGINS

# Stow refuses conflicting regular files rather than adopting local contents.
run stow -t "$HOME" zsh oh-my-posh git nvim lazygit zed gh-dash
if [[ $dry_run == true ]]; then
  echo 'Preview complete. No changes made.'
elif (( ${#failures[@]} > 0 )); then
  printf '\nBootstrap finished with errors. The following commands failed:\n' >&2
  printf '  %s\n' "${failures[@]}" >&2
  echo 'Available ports and configuration links were installed. Review the errors above and rerun after resolving missing archives or tools.' >&2
  exit 1
else
  echo 'Bootstrap complete. Open a new terminal to load the configuration.'
fi
