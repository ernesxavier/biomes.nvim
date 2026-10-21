-- https://github.com/lewis6991/gitsigns.nvim
---@type minecraft.PluginGroups
return function(c)
  return {
    GitSignsAdd    = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },
  }
end
