# fzf-plugin-manager.nvim

A fuzzy-finder UI for Neovim 0.12+'s native built-in package manager (`vim.pack`). Browse, update, delete, and open the source of your installed plugins — all from an fzf-lua picker.

## Requirements

- **Neovim 0.12+** (uses the native `vim.pack` API)
- **[fzf-lua](https://github.com/ibhagwan/fzf-lua)**

## Features

- List all plugins installed via Neovim's native package manager
- Update a plugin in-place with `<C-U>`
- Delete a plugin with `<C-D>`
- Open the plugin's source URL in your browser with `<Enter>`
- Cross-platform URL opener (macOS, Linux, Windows)

## Install

Using Neovim 0.12's native package manager:

```lua
vim.pack.add({
  src = "https://github.com/mat/fzf-plugin-manager.nvim",
})
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "mat/fzf-plugin-manager.nvim",
  dependencies = { "ibhagwan/fzf-lua" },
}
```

## Usage

The plugin registers a `:Plugins` command automatically on load. Run it to open the picker:

```
:Plugins
```

or call it directly from lua:
```lua
`require("fzf-plugin-manager").show_plugins()`
```

You can also bind it to a keymap:

```lua
vim.keymap.set("n", "<leader>pm", "<cmd>Plugins<cr>", { desc = "Plugin manager" })
```

### Picker keybindings

| Key | Action |
|-----|--------|
| `<Enter>` | Open the selected plugin's source URL in the browser |
| `<C-U>` | Update the selected plugin |
| `<C-D>` | Delete the selected plugin |

## API

### `require("fzf-plugin-manager").show_plugins()`

Opens the fzf-lua picker listing all plugins known to `vim.pack.get()`.

