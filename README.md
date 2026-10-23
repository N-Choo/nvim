# Neovim Configuration

A fast, feature-rich Neovim config built with [Lazy.nvim](https://github.com/folke/lazy.nvim).

## Features

- **Fuzzy Finding**: Telescope + Snacks picker
- **Git Integration**: Gitsigns + Neo-tree git status
- **LSP**: Built-in LSP with mason for automatic LSP/server installation
- **Autocomplete**: nvim-cmp with LSP + Snippets
- **Treesitter**: Syntax highlighting and indentation
- **UI**: Neo-tree, Bufferline, Lualine, Snacks dashboard
- **Copilot**: AI code completion

## Requirements

For the manual install:

- Neovim >= 0.9.0
- Git
- ripgrep (for Telescope live grep)
- A Nerd Font (optional, for icons)

With Nix, only Nix with flakes enabled is required. The flake provides Neovim,
git, ripgrep, fd, and a C toolchain; Mason and lazy.nvim still need network
access on first run.

## Installation

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/n-choo/nvim.git ~/.config/nvim
nvim
```

## Run with Nix

Run the config on any machine with Nix (flakes enabled), without installing it:

```bash
nix run github:n-choo/nvim
```

The first launch clones `lazy.nvim` and installs plugins into
`~/.local/share/nvim-nix` (network + git required). To install it as a command:

```bash
nix profile install github:n-choo/nvim
```

### HPC / nix-portable

If `nix` is provided by [nix-portable](https://github.com/DavHau/nix-portable)
(the store is under `~/.nix-portable`), its default runtime may fail with
`setting up a private mount namespace: Operation not permitted`. Select a
different runtime before invoking Nix:

```bash
export NP_RUNTIME=bwrap   # or: NP_RUNTIME=proot
nix run github:n-choo/nvim
```

This must be set in the shell that calls `nix`; a flake cannot change the
runtime of the Nix process that evaluates it.

## Keymaps

The leader key is `<Space>`.

- Press `<Space>` and pause — [which-key](https://github.com/folke/which-key.nvim) shows the available shortcuts.
- `<Space>sk` opens a searchable list of every keymap.
- `:WhichKey` shows all keymaps.
- `:map` lists all mappings (`:nmap`, `:vmap`, `:imap` for a specific mode).

## Plugins

| Plugin                                                                | Description                        |
| --------------------------------------------------------------------- | ---------------------------------- |
| [lazy.nvim](https://github.com/folke/lazy.nvim)                       | Plugin manager                     |
| [snacks.nvim](https://github.com/folke/snacks.nvim)                   | UI enhancements, picker, dashboard |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)    | Fuzzy finder                       |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)       | File explorer                      |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)            | LSP client                         |
| [mason.nvim](https://github.com/williamboman/mason.nvim)              | LSP server installer               |
| [rustaceanvim](https://github.com/mrcjkb/rustaceanvim)                | Rust enhancements                  |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                       | Autocomplete                       |
| [luasnip](https://github.com/L3MON4D3/LuaSnip)                        | Snippets                           |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)           | Git integration                    |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting                |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)         | Buffer tabs                        |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)          | Statusline                         |
| [copilot.vim](https://github.com/github/copilot.vim)                  | GitHub Copilot                     |
| [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) | AI chat                            |
| [which-key.nvim](https://github.com/folke/which-key.nvim)             | Keymap hints                       |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs)            | Auto pairs                         |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)     | TODO highlights                    |

## LSP Servers

Automatically installed via Mason:

- rust_analyzer
- ts_ls (TypeScript)
- ruff, pylsp, pyright (Python)
- lua_ls (Lua)
- html, cssls, jsonls
- terraformls
- sqlls

## Troubleshooting

### Check Plugins

```vim
:Lazy
```

### Update Plugins

```vim
:Lazy update
```

### Check Health

```vim
:checkhealth
```

### Reload Config

```vim
:source ~/.config/nvim/init.lua
```
