# Local Setup

Each top-level directory is a [GNU Stow](https://www.gnu.org/software/stow/) package. Its contents mirror the paths under `$HOME`.

## Install

Install Apple's Command Line Tools with `xcode-select --install`, then install the
package manager for your Mac:

| Hardware | Package manager | Package list |
| --- | --- | --- |
| Intel (`x86_64`) | [MacPorts](https://www.macports.org/install.php) | `MacPortsfile` |
| Apple Silicon (`arm64`, including Rosetta shells) | [Homebrew](https://brew.sh), installed at `/opt/homebrew` | `Brewfile` |

From the repository, run:

```sh
./install.sh --dry-run  # Preview commands without changing the machine
./install.sh
```

The installer installs packages, missing oh-my-zsh plugins, and the active Stow
packages. `rake` and `rake all` use the same installer on macOS. Linux keeps the
existing Rake tasks. Stow stops on conflicting local files; move or remove those
files and rerun instead of adopting them into the repo.

### Intel Macs

Homebrew no longer publishes new Intel bottles. The Intel installer uses
`sudo port -N -b install` for each port: [binary-only mode](https://man.macports.org/port.1.html)
refuses a package if it or a dependency has no matching archive. The installer
records each failure and continues with the other ports. Tahoe Intel binary
coverage is incomplete, so an archive being available for a top-level tool does
not guarantee that its entire dependency tree is available. There is no automatic
fallback to a source build. The installer continues with configuration and
available tools, then exits nonzero and reports failed commands if anything was
unavailable. Review the MacPorts output for the specific missing archives.
The MacPorts installer and package operations may
require your administrator password.

`MacPortsfile` lists CLI tools rather than Homebrew's exported dependency libraries;
MacPorts resolves its own libraries. Port versions can differ from Homebrew's.
Python 3.13 and Ruby 3.4 are selected as defaults, and Node 24 provides the Node
runtime. Python CLI tools use `uv tool install`; npm tools use `~/.local` and
Corepack supplies Yarn. These language package managers have their own download
and build behavior; MacPorts' binary-only flag applies to the ports themselves.

Per-project Node versions use `fnm`. A project pins its version in a `.node-version`
file, and `.zshrc` runs `fnm env --use-on-cd`, so entering the directory switches
Node. Run `fnm install` once in a project to download its version. Shells that skip
`.zshrc` (scripts) use the MacPorts `nodejs24` on `PATH`; keep its major version
equal to the one projects pin. Scheduled jobs call `fnm exec` themselves.

The following Brewfile tools have no equivalent port in this manifest and need
separate installation if you use them: `tgenv`, Atlassian CLI (`acli`), Azure
Functions Core Tools, IWE, and the Mole Mac cleanup utility. MacPorts' `mole`
is an unrelated SSH tunneling tool and must not be substituted for it.
The obsolete OpenSSL 1.1 and PostgreSQL 13 entries
are not carried over. GUI apps and vendor CLIs distributed as Homebrew casks
are also outside `MacPortsfile`; use Intel-compatible vendor installers.

The shell puts `/opt/local/bin` and `/opt/local/sbin` before an existing Intel
Homebrew installation. It does not run Intel Homebrew's `shellenv`. The existing
Homebrew installation is not removed.

### Apple Silicon

The installer runs native ARM Homebrew with `brew bundle --file=Brewfile`.
Rosetta is detected so an Intel shell cannot accidentally choose Intel Homebrew.
Corepack supplies Yarn on both architectures, avoiding a conflicting standalone
Yarn installation. PostgreSQL 13 is omitted because Homebrew disabled it; choose
a supported database version separately when needed. The removed OpenSSL 1.1
formula and retired cask-fonts tap are also omitted; fonts come from Homebrew Cask.
To refresh the ARM package list, run `brew bundle dump --file=Brewfile --force`
on an Apple Silicon Mac. Keep Intel CLI choices in `MacPortsfile` separately.

### Bootstrap checks

```sh
python3 -m unittest discover -s tests
bash -n install.sh
zsh -n zsh/.zshrc
```

## Active packages

| Package   | Tool                                                      | Target                                   |
| --------- | --------------------------------------------------------- | ---------------------------------------- |
| `zsh`     | zsh with oh-my-zsh                         | `~/.zshrc`                               |
| `oh-my-posh` | [oh-my-posh](https://ohmyposh.dev) prompt theme | `~/.config/oh-my-posh` |
| `git`     | git with delta, git-town, SSH signing, global hooks       | `~/.gitconfig`, `~/.config/git/hooks`    |
| `nvim`    | Neovim with lazy.nvim                                     | `~/.config/nvim`                         |
| `lazygit` | [lazygit](https://github.com/jesseduffield/lazygit) (`lg`) | `~/.config/lazygit`                      |
| `zed`     | [Zed](https://zed.dev)                                    | `~/.config/zed`                          |
| `gh-dash` | [gh-dash](https://github.com/dlvhdr/gh-dash)              | `~/.config/gh-dash`                      |

## Apps outside Homebrew

- iTerm2 is the terminal. Its settings are not in this repo.
- Alfred, 1Password, Docker Desktop, Visual Studio Code, Obsidian and DBeaver.
