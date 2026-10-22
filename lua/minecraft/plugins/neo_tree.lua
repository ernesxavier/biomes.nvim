-- https://github.com/nvim-neo-tree/neo-tree.nvim
---@type minecraft.PluginGroups
return function(c, _, u)
  local bg = u.sidebar_bg
  -- Con fondo propio el cambio de color ya marca el borde; si no, separador normal
  local separator = (bg ~= c.bg and bg ~= "NONE") and { fg = c.bg, bg = bg } or { link = "WinSeparator" }
  return {
    NeoTreeNormal        = { fg = c.fg, bg = bg },
    NeoTreeNormalNC      = { fg = c.fg, bg = bg },
    NeoTreeWinSeparator  = separator,
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
