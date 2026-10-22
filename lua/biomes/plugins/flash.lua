-- https://github.com/folke/flash.nvim
---@type biomes.PluginGroups
return function(c)
  return {
    FlashBackdrop = { fg = c.comment },
    FlashMatch    = { fg = c.fg, bg = c.selection },
    FlashCurrent  = { fg = c.bg, bg = c.orange, bold = true },
    FlashLabel    = { fg = c.bg, bg = c.red, bold = true },
  }
end
