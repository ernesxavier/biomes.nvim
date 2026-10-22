-- https://github.com/echasnovski/mini.nvim (todos los módulos con colores propios)
---@type minecraft.PluginGroups
return function(c, o, u)
  local float_bg = u.float_bg
  local panel_bg = o.transparent and "NONE" or c.bg_alt
  local m = u.mode_colors(c)
  return {
    -- mini.icons
    MiniIconsAzure  = { fg = c.cyan },
    MiniIconsBlue   = { fg = c.blue },
    MiniIconsCyan   = { fg = c.emerald },
    MiniIconsGreen  = { fg = c.green },
    MiniIconsGrey   = { fg = c.fg_dim },
    MiniIconsOrange = { fg = c.orange },
    MiniIconsPurple = { fg = c.purple },
    MiniIconsRed    = { fg = c.red },
    MiniIconsYellow = { fg = c.yellow },

    -- mini.statusline
    MiniStatuslineModeNormal  = { fg = c.bg, bg = m.normal, bold = true },
    MiniStatuslineModeInsert  = { fg = c.bg, bg = m.insert, bold = true },
    MiniStatuslineModeVisual  = { fg = c.bg, bg = m.visual, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg, bg = m.replace, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg, bg = m.command, bold = true },
    MiniStatuslineModeOther   = { fg = c.bg, bg = m.terminal, bold = true },
    MiniStatuslineDevinfo     = { fg = c.fg_dim, bg = c.bg_float },
    MiniStatuslineFilename    = { fg = c.fg_dim, bg = panel_bg },
    MiniStatuslineFileinfo    = { fg = c.fg_dim, bg = c.bg_float },
    MiniStatuslineInactive    = { fg = c.comment, bg = panel_bg },

    -- mini.tabline
    MiniTablineCurrent         = { fg = c.fg, bg = c.bg, bold = true },
    MiniTablineVisible         = { fg = c.fg_dim, bg = panel_bg },
    MiniTablineHidden          = { fg = c.comment, bg = panel_bg },
    MiniTablineModifiedCurrent = { fg = c.orange, bg = c.bg, bold = true },
    MiniTablineModifiedVisible = { fg = c.orange, bg = panel_bg },
    MiniTablineModifiedHidden  = { fg = u.soft(c.orange, 0.7), bg = panel_bg },
    MiniTablineFill            = { bg = panel_bg },
    MiniTablineTabpagesection  = { fg = c.bg, bg = c.accent, bold = true },

    -- mini.files
    MiniFilesNormal         = { fg = c.fg, bg = float_bg },
    MiniFilesBorder         = { fg = c.border, bg = float_bg },
    MiniFilesBorderModified = { fg = c.orange, bg = float_bg },
    MiniFilesTitle          = { fg = c.comment, bg = float_bg },
    MiniFilesTitleFocused   = { fg = c.accent, bg = float_bg, bold = true },
    MiniFilesDirectory      = { fg = c.blue },
    MiniFilesFile           = { fg = c.fg },
    MiniFilesCursorLine     = { bg = c.selection },

    -- mini.pick
    MiniPickNormal        = { fg = c.fg, bg = float_bg },
    MiniPickBorder        = { fg = c.border, bg = float_bg },
    MiniPickBorderBusy    = { fg = c.orange, bg = float_bg },
    MiniPickBorderText    = { fg = c.accent, bg = float_bg, bold = true },
    MiniPickPrompt        = { fg = c.accent, bg = float_bg },
    MiniPickHeader        = { fg = c.purple, bold = true },
    MiniPickIconDirectory = { link = "Directory" },
    MiniPickIconFile      = { fg = c.fg_dim },
    MiniPickMatchCurrent  = { bg = c.selection },
    MiniPickMatchMarked   = { fg = c.orange, bg = c.selection },
    MiniPickMatchRanges   = { fg = c.cyan, bold = true },
    MiniPickPreviewLine   = { bg = c.selection },
    MiniPickPreviewRegion = { link = "IncSearch" },

    -- mini.clue
    MiniClueBorder              = { fg = c.border, bg = float_bg },
    MiniClueTitle               = { fg = c.yellow, bg = float_bg, bold = true },
    MiniClueDescGroup           = { fg = c.purple },
    MiniClueDescSingle          = { fg = c.fg },
    MiniClueNextKey             = { fg = c.cyan, bold = true },
    MiniClueNextKeyWithPostkeys = { fg = c.red, bold = true },
    MiniClueSeparator           = { fg = c.comment },

    -- mini.notify
    MiniNotifyNormal = { fg = c.fg, bg = float_bg },
    MiniNotifyBorder = { fg = c.border, bg = float_bg },
    MiniNotifyTitle  = { fg = c.yellow, bg = float_bg, bold = true },

    -- mini.starter
    MiniStarterHeader     = { fg = c.accent },
    MiniStarterFooter     = { fg = c.comment, italic = true },
    MiniStarterSection    = { fg = c.purple, bold = true },
    MiniStarterItem       = { fg = c.fg },
    MiniStarterItemBullet = { fg = c.border },
    MiniStarterItemPrefix = { fg = c.orange, bold = true },
    MiniStarterCurrent    = { bold = true },
    MiniStarterInactive   = { fg = c.comment },
    MiniStarterQuery      = { fg = c.cyan, bold = true },

    -- mini.diff
    MiniDiffSignAdd     = { fg = c.green },
    MiniDiffSignChange  = { fg = c.yellow },
    MiniDiffSignDelete  = { fg = c.red },
    MiniDiffOverAdd     = { link = "DiffAdd" },
    MiniDiffOverChange  = { link = "DiffText" },
    MiniDiffOverContext = { link = "DiffChange" },
    MiniDiffOverDelete  = { link = "DiffDelete" },

    -- mini.hipatterns
    MiniHipatternsFixme = { fg = c.bg, bg = c.red, bold = true },
    MiniHipatternsHack  = { fg = c.bg, bg = c.orange, bold = true },
    MiniHipatternsTodo  = { fg = c.bg, bg = c.yellow, bold = true },
    MiniHipatternsNote  = { fg = c.bg, bg = c.blue, bold = true },

    -- mini.indentscope, mini.cursorword, mini.jump, mini.surround, mini.trailspace
    MiniIndentscopeSymbol = { fg = c.border, nocombine = true },
    MiniIndentscopePrefix = { nocombine = true },
    MiniCursorword        = { bg = c.selection },
    MiniCursorwordCurrent = { bg = c.selection },
    MiniJump              = { fg = c.bg, bg = c.orange },
    MiniJump2dSpot        = { fg = c.red, bold = true, nocombine = true },
    MiniSurround          = { link = "IncSearch" },
    MiniTrailspace        = { bg = c.red },
  }
end
