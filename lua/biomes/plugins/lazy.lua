-- https://github.com/folke/lazy.nvim
---@type biomes.PluginGroups
return function(c)
  return {
    LazyButtonActive = { fg = c.bg, bg = c.accent, bold = true },
    LazyH1           = { fg = c.bg, bg = c.accent, bold = true },
  }
end
