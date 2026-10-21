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
- Treesitter, LSP diagnostics, diff and gitsigns support
- Optional transparent background
- Written in Lua, no dependencies

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

## ⚙️ Configuration

Default options:

```lua
require("minecraft").setup({
  variant = "overworld",  -- "overworld" | "nether" | "end"
  transparent = false,    -- don't set a background color
  italic_comments = true,
})
```

The palette of any variant is available for your own highlights or statusline:

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
groups in [`lua/minecraft/highlights.lua`](lua/minecraft/highlights.lua).

## 📄 License

[MIT](LICENSE)

*Not an official Minecraft product. Not approved by or associated with Mojang or Microsoft.*
