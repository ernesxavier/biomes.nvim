-- https://github.com/folke/trouble.nvim
---@type minecraft.PluginGroups
return function(c, o)
  local bg = o.transparent and "NONE" or c.bg_alt
  return {
    TroubleNormal   = { fg = c.fg, bg = bg },
    TroubleNormalNC = { fg = c.fg, bg = bg },
    TroubleText     = { fg = c.fg },
    TroubleCount    = { fg = c.purple, bg = c.selection },
  }
end
