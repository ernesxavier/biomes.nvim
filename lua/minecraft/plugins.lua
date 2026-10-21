local M = {}

-- c: paleta, o: opciones, soft: fondo suave a partir de un acento
function M.get(c, o, soft)
  local float_bg = o.transparent and "NONE" or c.bg_float

  local groups = {
    -- gitsigns
    GitSignsAdd    = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },

    -- snacks: dashboard
    SnacksDashboardHeader  = { fg = c.green },
    SnacksDashboardIcon    = { fg = c.cyan },
    SnacksDashboardKey     = { fg = c.orange, bold = true },
    SnacksDashboardDesc    = { fg = c.fg },
    SnacksDashboardFooter  = { fg = c.comment, italic = true },
    SnacksDashboardSpecial = { fg = c.purple },
    SnacksDashboardDir     = { fg = c.comment },
    SnacksDashboardFile    = { fg = c.fg },

    -- snacks: picker / explorer
    SnacksPicker           = { fg = c.fg, bg = float_bg },
    SnacksPickerBorder     = { fg = c.border, bg = float_bg },
    SnacksPickerTitle      = { fg = c.bg, bg = c.green, bold = true },
    SnacksPickerPrompt     = { fg = c.orange },
    SnacksPickerMatch      = { fg = c.cyan, bold = true },
    SnacksPickerDir        = { fg = c.comment },
    SnacksPickerSelected   = { fg = c.orange },
    SnacksPickerTree       = { fg = c.line_nr },
    SnacksPickerGitStatusAdded     = { fg = c.green },
    SnacksPickerGitStatusModified  = { fg = c.yellow },
    SnacksPickerGitStatusDeleted   = { fg = c.red },
    SnacksPickerGitStatusUntracked = { fg = c.comment },

    -- snacks: indent
    SnacksIndent      = { fg = soft(c.fg, 0.1) },
    SnacksIndentScope = { fg = c.border },

    -- snacks: notifier
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

    -- blink.cmp
    BlinkCmpMenu           = { fg = c.fg, bg = float_bg },
    BlinkCmpMenuBorder     = { fg = c.border, bg = float_bg },
    BlinkCmpMenuSelection  = { bg = c.selection, bold = true },
    BlinkCmpLabelMatch     = { fg = c.cyan, bold = true },
    BlinkCmpLabelDeprecated = { fg = c.comment, strikethrough = true },
    BlinkCmpLabelDetail    = { fg = c.comment },
    BlinkCmpLabelDescription = { fg = c.comment },
    BlinkCmpSource         = { fg = c.comment },
    BlinkCmpGhostText      = { fg = c.comment, italic = true },
    BlinkCmpDoc            = { fg = c.fg, bg = float_bg },
    BlinkCmpDocBorder      = { fg = c.border, bg = float_bg },
    BlinkCmpSignatureHelp  = { fg = c.fg, bg = float_bg },
    BlinkCmpSignatureHelpBorder = { fg = c.border, bg = float_bg },
    BlinkCmpKind           = { fg = c.purple },

    -- which-key
    WhichKey          = { fg = c.cyan },
    WhichKeyGroup     = { fg = c.purple },
    WhichKeyDesc      = { fg = c.fg },
    WhichKeySeparator = { fg = c.comment },
    WhichKeyValue     = { fg = c.comment },
    WhichKeyNormal    = { bg = float_bg },
    WhichKeyBorder    = { fg = c.border, bg = float_bg },
    WhichKeyTitle     = { fg = c.yellow, bg = float_bg, bold = true },

    -- noice
    NoiceCmdlinePopup             = { fg = c.fg, bg = float_bg },
    NoiceCmdlinePopupBorder       = { fg = c.green, bg = float_bg },
    NoiceCmdlinePopupTitle        = { fg = c.green, bg = float_bg, bold = true },
    NoiceCmdlineIcon              = { fg = c.green },
    NoiceCmdlinePopupBorderSearch = { fg = c.yellow, bg = float_bg },
    NoiceCmdlineIconSearch        = { fg = c.yellow },
    NoiceConfirmBorder            = { fg = c.orange, bg = float_bg },

    -- flash
    FlashBackdrop = { fg = c.comment },
    FlashMatch    = { fg = c.fg, bg = c.selection },
    FlashCurrent  = { fg = c.bg, bg = c.orange, bold = true },
    FlashLabel    = { fg = c.bg, bg = c.red, bold = true },

    -- trouble
    TroubleNormal   = { fg = c.fg, bg = o.transparent and "NONE" or c.bg_alt },
    TroubleNormalNC = { fg = c.fg, bg = o.transparent and "NONE" or c.bg_alt },
    TroubleText     = { fg = c.fg },
    TroubleCount    = { fg = c.purple, bg = c.selection },

    -- bufferline
    BufferLineIndicatorSelected = { fg = c.green },

    -- render-markdown
    RenderMarkdownH1Bg = { bg = soft(c.red) },
    RenderMarkdownH2Bg = { bg = soft(c.orange) },
    RenderMarkdownH3Bg = { bg = soft(c.yellow) },
    RenderMarkdownH4Bg = { bg = soft(c.green) },
    RenderMarkdownH5Bg = { bg = soft(c.blue) },
    RenderMarkdownH6Bg = { bg = soft(c.purple) },
    RenderMarkdownCode       = { bg = c.bg_alt },
    RenderMarkdownCodeInline = { fg = c.green, bg = c.bg_alt },
    RenderMarkdownBullet     = { fg = c.orange },
    RenderMarkdownQuote      = { fg = c.comment },
    RenderMarkdownDash       = { fg = c.border },
    RenderMarkdownTableHead  = { fg = c.purple },
    RenderMarkdownTableRow   = { fg = c.border },

    -- vimtex
    texCmd          = { fg = c.purple },
    texCmdEnv       = { fg = c.red },
    texEnvArgName   = { fg = c.yellow },
    texPartArgTitle = { fg = c.yellow, bold = true },
    texMathZone     = { fg = c.cyan },
    texMathCmd      = { fg = c.blue },
    texMathDelim    = { fg = c.emerald },
    texRefArg       = { fg = c.orange },
    texFileArg      = { fg = c.green },

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

    -- lazy.nvim
    LazyButtonActive = { fg = c.bg, bg = c.green, bold = true },
    LazyH1           = { fg = c.bg, bg = c.green, bold = true },
  }

  -- Colores de los tipos de completado (blink.cmp)
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

return M
