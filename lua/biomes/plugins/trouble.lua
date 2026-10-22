-- https://github.com/folke/trouble.nvim
---@type biomes.PluginGroups
return function(c, _, u)
  local bg = u.sidebar_bg
  return {
    TroubleNormal   = { fg = c.fg, bg = bg },
    TroubleNormalNC = { fg = c.fg, bg = bg },
    TroubleText     = { fg = c.fg },
    TroubleCount    = { fg = c.purple, bg = c.selection },
  }
end
