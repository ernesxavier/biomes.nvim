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

  -- Un color por tipo de completado
  local kinds = {
    Text = c.fg_dim, Method = c.cyan, Function = c.cyan, Constructor = c.yellow,
    Field = c.blue, Variable = c.fg, Property = c.blue, Class = c.yellow,
    Interface = c.yellow, Struct = c.yellow, Module = c.yellow, Unit = c.orange,
    Value = c.orange, Enum = c.yellow, EnumMember = c.orange, Keyword = c.purple,
    Constant = c.orange, Snippet = c.emerald, Color = c.red, File = c.blue,
    Reference = c.red, Folder = c.blue, Event = c.purple, Operator = c.fg_dim,
    TypeParameter = c.brown, Copilot = c.emerald,
  }
  for kind, color in pairs(kinds) do
    groups["BlinkCmpKind" .. kind] = { fg = color }
  end
  return groups
end
