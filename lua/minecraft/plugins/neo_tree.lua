-- https://github.com/nvim-neo-tree/neo-tree.nvim
---@type minecraft.PluginGroups
return function(c, o)
  local bg = o.transparent and "NONE" or c.bg_alt
  return {
    NeoTreeNormal        = { fg = c.fg, bg = bg },
    NeoTreeNormalNC      = { fg = c.fg, bg = bg },
    NeoTreeWinSeparator  = { fg = c.bg, bg = bg },
    NeoTreeRootName      = { fg = c.green, bold = true },
    NeoTreeDirectoryName = { fg = c.blue },
    NeoTreeDirectoryIcon = { fg = c.blue },
    NeoTreeFileName      = { fg = c.fg },
    NeoTreeFileNameOpened = { fg = c.orange },
    NeoTreeIndentMarker  = { fg = c.line_nr },
    NeoTreeExpander      = { fg = c.comment },
    NeoTreeDimText       = { fg = c.comment },
    NeoTreeSymbolicLinkTarget = { fg = c.cyan },
    NeoTreeGitAdded      = { fg = c.green },
    NeoTreeGitModified   = { fg = c.yellow },
    NeoTreeGitDeleted    = { fg = c.red },
    NeoTreeGitStaged     = { fg = c.emerald },
    NeoTreeGitUntracked  = { fg = c.purple },
    NeoTreeGitConflict   = { fg = c.red, bold = true },
    NeoTreeGitIgnored    = { fg = c.comment },
    NeoTreeTabActive     = { fg = c.fg, bg = bg, bold = true },
    NeoTreeTabInactive   = { fg = c.comment, bg = c.bg },
    NeoTreeTabSeparatorActive   = { fg = bg, bg = bg },
    NeoTreeTabSeparatorInactive = { fg = c.bg, bg = c.bg },
  }
end
