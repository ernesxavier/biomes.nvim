# ⛏️ minecraft.nvim

A soft pastel Neovim colorscheme inspired by Minecraft, with one variant for each dimension:

| Variant | Mode | Inspiration |
|---|---|---|
| 🌳 **Overworld** | ☀️ light | sand, birch, grass, redstone, gold, diamond and lapis |
| 🔥 **Nether** | 🌙 dark | blackstone, lava, glowstone, quartz, warped & crimson fungi, soul fire |
| 🌌 **End** | 🌙 dark | the void, end stone, purpur, chorus plants and ender pearls |

<!-- TODO: add screenshots of each variant -->

## ✨ Features

- Three variants with matching semantic palettes
- Sets `background` automatically (`light` for the Overworld, `dark` for the Nether and the End)
- Treesitter, LSP (semantic tokens, inlay hints, diagnostics) and diff support
- [lualine](https://github.com/nvim-lualine/lualine.nvim) theme for each variant, picked up automatically
- `:terminal` colors from the active palette
- Optional transparent background
- Written in Lua, no dependencies

## 🔌 Supported plugins

- [blink.cmp](https://github.com/Saghen/blink.cmp)
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [flash.nvim](https://github.com/folke/flash.nvim)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [mini.icons](https://github.com/echasnovski/mini.icons)
- [noice.nvim](https://github.com/folke/noice.nvim)
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim) (dashboard, picker, explorer, indent, notifier)
- [trouble.nvim](https://github.com/folke/trouble.nvim)
- [vimtex](https://github.com/lervag/vimtex)
- [which-key.nvim](https://github.com/folke/which-key.nvim)

Plugins that reuse Neovim's standard groups (such as todo-comments, grug-far or mason)
pick up the theme colors without extra configuration.

Only the groups of the plugins you have installed are loaded, detected through
lazy.nvim or `vim.pack`. Without either of them, all supported plugins are loaded.
You can override this with the `plugins` option:

```lua
plugins = {
  all = false,       -- load every supported plugin
  auto = true,       -- load only installed plugins
  snacks = false,    -- disable one (module name or "snacks.nvim")
  vimtex = true,     -- force one
}
```

## 📦 Installation

Requires Neovim 0.8+ with `termguicolors`.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "ernesxavier/minecraft.nvim",
  name = "minecraft",
  lazy = false,
  priority = 1000,
  opts = {
    variant = "overworld", -- "overworld" | "nether" | "end"
  },
  config = function(_, opts)
    require("minecraft").setup(opts)
    vim.cmd.colorscheme("minecraft")
  end,
}
```

### [LazyVim](https://www.lazyvim.org)

```lua
return {
  { "ernesxavier/minecraft.nvim", name = "minecraft", opts = { variant = "nether" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "minecraft" } },
}
```

### `vim.pack` (Neovim 0.12+)

```lua
vim.pack.add({ "https://github.com/ernesxavier/minecraft.nvim" })
vim.cmd.colorscheme("minecraft-end")
```

## 🚀 Usage

```vim
:colorscheme minecraft            " uses the variant from setup()
:colorscheme minecraft-overworld
:colorscheme minecraft-nether
:colorscheme minecraft-end
```

The theme follows `'background'`: `:set background=light` switches to the Overworld,
and `:set background=dark` goes back to the last dark dimension you used
(or `dark_variant` the first time).

## ⚙️ Configuration

Default options:

```lua
require("minecraft").setup({
  variant = "overworld",   -- "overworld" | "nether" | "end"
  dark_variant = "nether", -- used by `:set background=dark` from the Overworld
  transparent = false,     -- don't set a background color
  -- Extra attributes per element; any `:h nvim_set_hl` key works (italic, bold, underline...)
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = {},
    types = {},
    strings = {},
  },
  -- Change palette colors. Receives a copy, so edit it in place
  on_colors = function(colors, variant) end,
  -- Change highlight groups. Receives a copy, so edit it in place
  on_highlights = function(highlights, colors, variant) end,
})
```

Examples:

```lua
require("minecraft").setup({
  styles = { keywords = { italic = true } },
  on_colors = function(colors, variant)
    if variant == "nether" then
      colors.bg = "#120f10" -- darker blackstone
    end
  end,
  on_highlights = function(hl, colors)
    hl.CursorLineNr = { fg = colors.green, bold = true }
    hl.LineNr = { link = "Comment" }
  end,
})
```

The options are annotated for [lua_ls](https://github.com/LuaLS/lua-language-server),
so you get completion inside `setup()`.

The palette of any variant (with `on_colors` applied) is available for your own highlights or statusline:

```lua
local c = require("minecraft").palette("nether")
vim.api.nvim_set_hl(0, "MyGroup", { fg = c.orange, bg = c.bg_alt })
```

## 🎨 Palettes

| Role | Overworld | Nether | End |
|---|---|---|---|
| Background | `#f6f2e7` sand | `#1b1819` blackstone | `#1f1d2b` void |
| Foreground | `#4d4739` dark oak | `#f4eee8` quartz | `#ece9c9` end stone |
| Red | `#c8404c` redstone | `#f28b82` netherrack | `#f38ba8` |
| Orange | `#b8581a` copper | `#fca66b` lava | `#f9b387` |
| Yellow | `#966b00` gold | `#f9d97a` glowstone | `#f2e88a` end stone bricks |
| Green | `#3d8423` grass | `#7dd8c0` warped fungus | `#a6e39a` chorus plant |
| Cyan | `#0f7f80` diamond | `#7fdbea` soul fire | `#7ee8f0` end gateway |
| Blue | `#3a65c8` lapis | `#8fb0f7` | `#9aa5ff` |
| Purple | `#8344d0` amethyst | `#b98cf5` crying obsidian | `#cfa0f5` purpur |
| Accent | `#12854c` emerald | `#f38fb5` crimson fungus | `#7ee0c8` ender pearl |

## 🤝 Contributing

Issues and pull requests are welcome, especially support for more plugins.
Palettes live in [`lua/minecraft/palettes/`](lua/minecraft/palettes) and highlight
groups in [`lua/minecraft/highlights.lua`](lua/minecraft/highlights.lua) (core) and
[`lua/minecraft/plugins/`](lua/minecraft/plugins) (one file per plugin). To add a plugin,
create its file and register it in [`plugins/init.lua`](lua/minecraft/plugins/init.lua).

## 📄 License

[MIT](LICENSE)

*Not an official Minecraft product. Not approved by or associated with Mojang or Microsoft.*
