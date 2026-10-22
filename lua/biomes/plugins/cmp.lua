-- https://github.com/hrsh7th/nvim-cmp
---@type biomes.PluginGroups
return function(c, _, u)
  local groups = {
    CmpItemAbbr            = { fg = c.fg },
    CmpItemAbbrDeprecated  = { fg = c.comment, strikethrough = true },
    CmpItemAbbrMatch       = { fg = c.cyan, bold = true },
    CmpItemAbbrMatchFuzzy  = { fg = c.cyan },
    CmpItemMenu            = { fg = c.comment },
    CmpItemKindDefault     = { fg = c.fg_dim },
    CmpGhostText           = { fg = c.comment, italic = true },
    CmpDocumentation       = { fg = c.fg, bg = u.float_bg },
    CmpDocumentationBorder = { fg = c.border, bg = u.float_bg },
  }
  u.link_kinds(groups, "CmpItemKind%s")
  groups.CmpItemKindCopilot = { fg = c.emerald }
  groups.CmpItemKindCodeium = { fg = c.emerald }
  return groups
end
