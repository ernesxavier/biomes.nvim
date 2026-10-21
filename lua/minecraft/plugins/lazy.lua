-- https://github.com/folke/lazy.nvim
---@type minecraft.PluginGroups
return function(c)
  return {
    LazyButtonActive = { fg = c.bg, bg = c.green, bold = true },
    LazyH1           = { fg = c.bg, bg = c.green, bold = true },
  }
end
