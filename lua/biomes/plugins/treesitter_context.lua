-- https://github.com/nvim-treesitter/nvim-treesitter-context
---@type biomes.PluginGroups
return function(c)
  return {
    TreesitterContext           = { bg = c.bg_alt },
    TreesitterContextLineNumber = { fg = c.comment, bg = c.bg_alt },
    TreesitterContextBottom     = { sp = c.border, underline = true },
  }
end
