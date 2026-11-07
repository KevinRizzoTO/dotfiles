# Neovim development setup

Requires Neovim 0.11.3 or newer, Node/npm, Python, and Go for Go development.
The configuration uses lazy.nvim and ignores legacy Packer packages.

Mason installs Pyright, Ruff, ESLint's language server, gopls, the TypeScript
language-server adapter, and Prettier. Open `:Mason` to check installation status.
On a new machine, allow the first installation to finish before using these tools.
The existing TypeScript 7 installation supplies the native language server.

## Language behavior

- Python: Pyright handles types and navigation; Ruff handles linting and import
  code actions. Ruff formats on save. A Ruff executable beside the selected
  Python interpreter takes precedence over Mason's version.
- TypeScript/JavaScript: a project-installed TypeScript 7 uses its native LSP.
  Projects with TypeScript 5 or 6 use their own tsserver through `ts_ls` instead.
  Without a local TypeScript installation, the native `tsc` on PATH is used.
  Each buffer attaches to one TypeScript server. Deno projects are excluded.
- ESLint attaches when the project has ESLint configuration. It uses the project's
  ESLint installation and rules. Use code actions for lint fixes.
- Prettier uses the project installation when available. The Mason fallback runs
  only when Prettier can find explicit configuration. Markdown is excluded from
  automatic formatting to preserve the existing writing workflow.
- Go: gopls provides navigation and diagnostics; gofmt formats on save. Go module
  and source parsers are installed alongside the Python and TypeScript parsers.

Python and JavaScript test frameworks belong in the project, rather than Mason.
Neotest supports pytest/unittest, Vitest, and Jest. Install the framework used by
that project. Standard Jest/TypeScript projects still need their usual transform
configuration; the editor does not invent one.

## Shortcuts

The leader is Space.

| Shortcut | Action |
| --- | --- |
| `Space cf` | Format the buffer or visual selection |
| `Space ca` | Code actions, including available lint/import fixes |
| `Space cd` | Put buffer diagnostics in the location list |
| `Space rn` | Rename symbol |
| `gd` / `gr` | Definition / references |
| `K` | Line diagnostics or documentation |
| `[d` / `]d` | Previous / next diagnostic |
| `Space tn` | Run nearest test |
| `Space tf` | Run the current test file |
| `Space tl` | Repeat the last test |
| `Space ts` | Toggle test summary |
| `Space to` | Open test output |
| `Space tx` | Stop the running test |

`:FormatToggle` toggles format-on-save for the current buffer. Explicit formatting
still works while automatic formatting is disabled. `:ConformInfo` reports the
selected formatter and any errors.

## Python interpreter

Pyright and Neotest share interpreter selection: a session override, then the
project's `.venv/bin/python` or `venv/bin/python`, then an active `VIRTUAL_ENV`,
then `python3` on PATH. Activate Pipenv/Poetry environments before starting Neovim,
or select their interpreter explicitly.

- `:PythonPath` shows the selected interpreter.
- `:PythonPath /absolute/path/to/bin/python` selects it for this project for the
  current Neovim session and updates attached Pyright clients and future test runs.
- `:PythonPath auto` returns to automatic selection.

## Verification

Run `python3 tests/nvim/smoke.py` from the repository root after the Mason tools
and language parsers have finished installing. It requires `nvim`, `uv`, `npm`,
`go`, and native TypeScript 7 on PATH. The test creates disposable projects,
installs their test dependencies, and exercises the real config, language-server
diagnostics, native navigation/rename, formatters, and passing/failing tests.
Dependencies download through npm and uv; no application projects are modified.

The installed native TypeScript 7.0.2 server emits an exit-code-1 warning and
`context canceled`/`EOF` messages during LSP shutdown. This also reproduces with
`nvim --clean` and a minimal client, independently of this configuration.
Diagnostics, navigation, and rename pass before shutdown.

Integrated debugging is optional and is not configured.
