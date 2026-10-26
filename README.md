# Local Setup

Each top-level directory is a [GNU Stow](https://www.gnu.org/software/stow/) package. Its contents mirror the paths under `$HOME`.

## Install

1. Install [Homebrew](https://brew.sh).
2. Install the packages: `brew bundle --file=Brewfile`
3. Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh).
4. Link the active packages: `stow -t ~ zsh p10k git nvim lazygit zed gh-dash`

To refresh the package list, run `brew bundle dump --file=Brewfile --force`.

## Active packages

| Package   | Tool                                                      | Target                                   |
| --------- | --------------------------------------------------------- | ---------------------------------------- |
| `zsh`     | zsh with oh-my-zsh and oh-my-posh                         | `~/.zshrc`                               |
| `p10k`    | powerlevel10k prompt                                      | `~/.p10k.zsh`                            |
| `git`     | git with delta, git-town, SSH signing, global hooks       | `~/.gitconfig`, `~/.config/git/hooks`    |
| `nvim`    | Neovim with lazy.nvim                                     | `~/.config/nvim`                         |
| `lazygit` | [lazygit](https://github.com/jesseduffield/lazygit) (`lg`) | `~/.config/lazygit`                      |
| `zed`     | [Zed](https://zed.dev)                                    | `~/.config/zed`                          |
| `gh-dash` | [gh-dash](https://github.com/dlvhdr/gh-dash)              | `~/.config/gh-dash`                      |

## Apps outside Homebrew

- iTerm2 is the terminal. Its settings are not in this repo.
- Alfred, 1Password, Docker Desktop, Visual Studio Code, Obsidian and DBeaver.
