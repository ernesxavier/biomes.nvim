-- https://github.com/nvim-tree/nvim-tree.lua
---@type minecraft.PluginGroups
return function(c, o)
  local bg = o.transparent and "NONE" or c.bg_alt
  return {
    NvimTreeNormal         = { fg = c.fg, bg = bg },
    NvimTreeNormalNC       = { fg = c.fg, bg = bg },
    NvimTreeWinSeparator   = { fg = c.bg, bg = bg },
    NvimTreeRootFolder     = { fg = c.green, bold = true },
    NvimTreeFolderName     = { fg = c.blue },
    NvimTreeFolderIcon     = { fg = c.blue },
    NvimTreeOpenedFolderName = { fg = c.blue, bold = true },
    NvimTreeOpenedFile     = { fg = c.orange },
    NvimTreeSpecialFile    = { fg = c.purple, underline = true },
    NvimTreeImageFile      = { fg = c.fg_dim },
    NvimTreeSymlink        = { fg = c.cyan },
    NvimTreeIndentMarker   = { fg = c.line_nr },
    NvimTreeGitNew         = { fg = c.green },
    NvimTreeGitDirty       = { fg = c.yellow },
    NvimTreeGitDeleted     = { fg = c.red },
    NvimTreeGitStaged      = { fg = c.emerald },
    NvimTreeGitIgnored     = { fg = c.comment },
  }
end
