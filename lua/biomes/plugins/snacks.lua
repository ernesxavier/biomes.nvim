-- https://github.com/folke/snacks.nvim
---@type biomes.PluginGroups
return function(c, _, u)
  local float_bg = u.float_bg
  return {
    -- dashboard
    SnacksDashboardHeader  = { fg = c.accent },
    SnacksDashboardIcon    = { fg = c.cyan },
    SnacksDashboardKey     = { fg = c.orange, bold = true },
    SnacksDashboardDesc    = { fg = c.fg },
    SnacksDashboardFooter  = { fg = c.comment, italic = true },
    SnacksDashboardSpecial = { fg = c.purple },
    SnacksDashboardDir     = { fg = c.comment },
    SnacksDashboardFile    = { fg = c.fg },

    -- picker / explorer
    SnacksPicker           = { fg = c.fg, bg = float_bg },
    SnacksPickerBorder     = { fg = c.border, bg = float_bg },
    SnacksPickerTitle      = { fg = c.bg, bg = c.accent, bold = true },
    SnacksPickerPrompt     = { fg = c.orange },
    SnacksPickerMatch      = { fg = c.cyan, bold = true },
    SnacksPickerDir        = { fg = c.comment },
    SnacksPickerSelected   = { fg = c.orange },
    SnacksPickerTree       = { fg = c.line_nr },
    SnacksPickerGitStatusAdded     = { fg = c.green },
    SnacksPickerGitStatusModified  = { fg = c.yellow },
    SnacksPickerGitStatusDeleted   = { fg = c.red },
    SnacksPickerGitStatusUntracked = { fg = c.comment },

    -- indent
    SnacksIndent      = { fg = u.soft(c.fg, 0.1) },
    SnacksIndentScope = { fg = c.border },

    -- notifier
    SnacksNotifierError       = { fg = c.fg, bg = float_bg },
    SnacksNotifierWarn        = { fg = c.fg, bg = float_bg },
    SnacksNotifierInfo        = { fg = c.fg, bg = float_bg },
    SnacksNotifierDebug       = { fg = c.fg, bg = float_bg },
    SnacksNotifierTrace       = { fg = c.fg, bg = float_bg },
    SnacksNotifierBorderError = { fg = c.red, bg = float_bg },
    SnacksNotifierBorderWarn  = { fg = c.yellow, bg = float_bg },
    SnacksNotifierBorderInfo  = { fg = c.blue, bg = float_bg },
    SnacksNotifierBorderDebug = { fg = c.comment, bg = float_bg },
    SnacksNotifierBorderTrace = { fg = c.purple, bg = float_bg },
    SnacksNotifierTitleError  = { fg = c.red, bold = true },
    SnacksNotifierTitleWarn   = { fg = c.yellow, bold = true },
    SnacksNotifierTitleInfo   = { fg = c.blue, bold = true },
    SnacksNotifierIconError   = { fg = c.red },
    SnacksNotifierIconWarn    = { fg = c.yellow },
    SnacksNotifierIconInfo    = { fg = c.blue },
  }
end
