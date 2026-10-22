-- https://github.com/folke/noice.nvim
---@type minecraft.PluginGroups
return function(c, _, u)
  local float_bg = u.float_bg
  return {
    NoiceCmdlinePopup             = { fg = c.fg, bg = float_bg },
    NoiceCmdlinePopupBorder       = { fg = c.accent, bg = float_bg },
    NoiceCmdlinePopupTitle        = { fg = c.accent, bg = float_bg, bold = true },
    NoiceCmdlineIcon              = { fg = c.accent },
    NoiceCmdlinePopupBorderSearch = { fg = c.yellow, bg = float_bg },
    NoiceCmdlineIconSearch        = { fg = c.yellow },
    NoiceConfirmBorder            = { fg = c.orange, bg = float_bg },
  }
end
