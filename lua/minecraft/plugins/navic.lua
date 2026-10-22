-- https://github.com/SmiteshP/nvim-navic
---@type minecraft.PluginGroups
return function(c, _, u)
  local groups = {
    NavicText      = { fg = c.fg_dim },
    NavicSeparator = { fg = c.comment },
  }
  return u.link_kinds(groups, "NavicIcons%s")
end
