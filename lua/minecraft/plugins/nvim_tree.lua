-- https://github.com/nvim-tree/nvim-tree.lua
---@type minecraft.PluginGroups
return function(c, _, u)
  local bg = u.sidebar_bg
  -- Con fondo propio el cambio de color ya marca el borde; si no, separador normal
  local separator = (bg ~= c.bg and bg ~= "NONE") and { fg = c.bg, bg = bg } or { link = "WinSeparator" }
  return {
    NvimTreeNormal         = { fg = c.fg, bg = bg },
    NvimTreeNormalNC       = { fg = c.fg, bg = bg },
    NvimTreeWinSeparator   = separator,
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
