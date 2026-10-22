-- https://github.com/Saghen/blink.cmp
---@type minecraft.PluginGroups
return function(c, _, u)
  local float_bg = u.float_bg
  local groups = {
    BlinkCmpMenu             = { fg = c.fg, bg = float_bg },
    BlinkCmpMenuBorder       = { fg = c.border, bg = float_bg },
    BlinkCmpMenuSelection    = { bg = c.selection, bold = true },
    BlinkCmpLabelMatch       = { fg = c.cyan, bold = true },
    BlinkCmpLabelDeprecated  = { fg = c.comment, strikethrough = true },
    BlinkCmpLabelDetail      = { fg = c.comment },
    BlinkCmpLabelDescription = { fg = c.comment },
    BlinkCmpSource           = { fg = c.comment },
    BlinkCmpGhostText        = { fg = c.comment, italic = true },
    BlinkCmpDoc              = { fg = c.fg, bg = float_bg },
    BlinkCmpDocBorder        = { fg = c.border, bg = float_bg },
    BlinkCmpSignatureHelp    = { fg = c.fg, bg = float_bg },
    BlinkCmpSignatureHelpBorder = { fg = c.border, bg = float_bg },
    BlinkCmpKind             = { fg = c.purple },
  }
  u.link_kinds(groups, "BlinkCmpKind%s")
  groups.BlinkCmpKindCopilot = { fg = c.emerald }
  return groups
end
