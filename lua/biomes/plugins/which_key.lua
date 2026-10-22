-- https://github.com/folke/which-key.nvim
---@type biomes.PluginGroups
return function(c, _, u)
  return {
    WhichKey          = { fg = c.cyan },
    WhichKeyGroup     = { fg = c.purple },
    WhichKeyDesc      = { fg = c.fg },
    WhichKeySeparator = { fg = c.comment },
    WhichKeyValue     = { fg = c.comment },
    WhichKeyNormal    = { bg = u.float_bg },
    WhichKeyBorder    = { fg = c.border, bg = u.float_bg },
    WhichKeyTitle     = { fg = c.yellow, bg = u.float_bg, bold = true },
  }
end
