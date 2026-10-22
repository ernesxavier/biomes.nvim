-- https://github.com/lukas-reineke/indent-blankline.nvim
---@type minecraft.PluginGroups
return function(c, _, u)
  return {
    IblIndent     = { fg = u.soft(c.fg, 0.1), nocombine = true },
    IblWhitespace = { fg = u.soft(c.fg, 0.1), nocombine = true },
    IblScope      = { fg = c.border, nocombine = true },
  }
end
