-- https://github.com/nvim-telescope/telescope.nvim
---@type biomes.PluginGroups
return function(c, _, u)
  local float_bg = u.float_bg
  return {
    TelescopeNormal         = { fg = c.fg, bg = float_bg },
    TelescopeBorder         = { fg = c.border, bg = float_bg },
    TelescopePromptNormal   = { fg = c.fg, bg = float_bg },
    TelescopePromptBorder   = { fg = c.accent, bg = float_bg },
    TelescopePromptTitle    = { fg = c.bg, bg = c.accent, bold = true },
    TelescopePromptPrefix   = { fg = c.accent },
    TelescopeResultsTitle   = { fg = c.bg, bg = c.cyan, bold = true },
    TelescopePreviewTitle   = { fg = c.bg, bg = c.purple, bold = true },
    TelescopeSelection      = { bg = c.selection, bold = true },
    TelescopeSelectionCaret = { fg = c.orange, bg = c.selection },
    TelescopeMultiSelection = { fg = c.orange },
    TelescopeMatching       = { fg = c.cyan, bold = true },
    TelescopeResultsComment = { fg = c.comment },
  }
end
