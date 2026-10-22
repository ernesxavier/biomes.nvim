-- https://github.com/nvim-telescope/telescope.nvim
---@type minecraft.PluginGroups
return function(c, _, u)
  local float_bg = u.float_bg
  return {
    TelescopeNormal         = { fg = c.fg, bg = float_bg },
    TelescopeBorder         = { fg = c.border, bg = float_bg },
    TelescopePromptNormal   = { fg = c.fg, bg = float_bg },
    TelescopePromptBorder   = { fg = c.green, bg = float_bg },
    TelescopePromptTitle    = { fg = c.bg, bg = c.green, bold = true },
    TelescopePromptPrefix   = { fg = c.green },
    TelescopeResultsTitle   = { fg = c.bg, bg = c.cyan, bold = true },
    TelescopePreviewTitle   = { fg = c.bg, bg = c.purple, bold = true },
    TelescopeSelection      = { bg = c.selection, bold = true },
    TelescopeSelectionCaret = { fg = c.orange, bg = c.selection },
    TelescopeMultiSelection = { fg = c.orange },
    TelescopeMatching       = { fg = c.cyan, bold = true },
    TelescopeResultsComment = { fg = c.comment },
  }
end
