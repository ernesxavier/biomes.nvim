local blend = require("minecraft.util").blend

local M = {}

-- c: paleta, o: opciones de configuración
function M.get(c, o)
  local bg = o.transparent and "NONE" or c.bg
  local float_bg = o.transparent and "NONE" or c.bg_float
  local s = o.styles

  -- Agrega los atributos configurados en styles a un grupo
  local function style(spec, extra)
    return vim.tbl_extend("force", spec, extra or {})
  end

  -- Fondos suaves derivados de los acentos
  local soft = function(color, alpha)
    return blend(color, c.bg, alpha or 0.15)
  end

  local groups = {
    -- Editor
    Normal       = { fg = c.fg, bg = bg },
    NormalNC     = { fg = c.fg, bg = bg },
    NormalFloat  = { fg = c.fg, bg = float_bg },
    FloatBorder  = { fg = c.border, bg = float_bg },
    FloatTitle   = { fg = c.yellow, bg = float_bg, bold = true },
    Cursor       = { fg = c.bg, bg = c.fg },
    lCursor      = { link = "Cursor" },
    TermCursor   = { link = "Cursor" },
    CursorLine   = { bg = c.cursorline },
    CursorColumn = { bg = c.cursorline },
    ColorColumn  = { bg = c.bg_alt },
    LineNr       = { fg = c.line_nr },
    CursorLineNr = { fg = c.yellow, bold = true },
    SignColumn   = { bg = bg },
    FoldColumn   = { fg = c.line_nr, bg = bg },
    Folded       = { fg = c.fg_dim, bg = c.bg_alt },
    VertSplit    = { fg = c.border },
    WinSeparator = { fg = c.border },
    Visual       = { bg = c.selection },
    VisualNOS    = { link = "Visual" },
    Search       = { fg = c.on_search, bg = c.search },
    IncSearch    = { fg = c.bg, bg = c.orange },
    CurSearch    = { fg = c.bg, bg = c.orange },
    Substitute   = { fg = c.bg, bg = c.red },
    MatchParen   = { fg = c.cyan, bold = true, underline = true },
    NonText      = { fg = c.line_nr },
    Whitespace   = { fg = c.line_nr },
    SpecialKey   = { fg = c.line_nr },
    EndOfBuffer  = { fg = c.bg },
    Conceal      = { fg = c.comment },
    QuickFixLine = { bg = c.selection, bold = true },
    Pmenu        = { fg = c.fg, bg = c.bg_float },
    PmenuSel     = { fg = c.bg, bg = c.green, bold = true },
    PmenuSbar    = { bg = c.bg_alt },
    PmenuThumb   = { bg = c.border },
    PmenuMatch   = { fg = c.cyan, bold = true },
    StatusLine   = { fg = c.fg, bg = c.bg_alt },
    StatusLineNC = { fg = c.fg_dim, bg = c.bg_alt },
    WinBar       = { fg = c.fg_dim, bg = bg },
    WinBarNC     = { fg = c.comment, bg = bg },
    TabLine      = { fg = c.fg_dim, bg = c.bg_alt },
    TabLineSel   = { fg = c.bg, bg = c.green, bold = true },
    TabLineFill  = { bg = c.bg_alt },
    Title        = { fg = c.yellow, bold = true },
    Directory    = { fg = c.blue },
    ErrorMsg     = { fg = c.red },
    WarningMsg   = { fg = c.yellow },
    ModeMsg      = { fg = c.fg, bold = true },
    MoreMsg      = { fg = c.green },
    Question     = { fg = c.cyan },
    WildMenu     = { fg = c.bg, bg = c.green },
    SpellBad     = { sp = c.red, undercurl = true },
    SpellCap     = { sp = c.yellow, undercurl = true },
    SpellLocal   = { sp = c.blue, undercurl = true },
    SpellRare    = { sp = c.purple, undercurl = true },

    -- Sintaxis clásica
    Comment      = style({ fg = c.comment }, s.comments),
    Constant     = { fg = c.orange },
    String       = style({ fg = c.green }, s.strings),
    Character    = style({ fg = c.green }, s.strings),
    Number       = { fg = c.orange },
    Boolean      = { fg = c.orange, bold = true },
    Float        = { fg = c.orange },
    Identifier   = style({ fg = c.fg }, s.variables),
    Function     = style({ fg = c.cyan }, s.functions),
    Statement    = style({ fg = c.purple }, s.keywords),
    Conditional  = style({ fg = c.purple }, s.keywords),
    Repeat       = style({ fg = c.purple }, s.keywords),
    Label        = { fg = c.purple },
    Operator     = { fg = c.fg_dim },
    Keyword      = style({ fg = c.purple }, s.keywords),
    Exception    = { fg = c.red },
    PreProc      = { fg = c.red },
    Include      = { fg = c.red },
    Define       = { fg = c.red },
    Macro        = { fg = c.red },
    Type         = style({ fg = c.yellow }, s.types),
    StorageClass = style({ fg = c.yellow }, s.types),
    Structure    = style({ fg = c.yellow }, s.types),
    Typedef      = style({ fg = c.yellow }, s.types),
    Special      = { fg = c.emerald },
    SpecialChar  = { fg = c.emerald },
    Delimiter    = { fg = c.fg_dim },
    Underlined   = { underline = true },
    Error        = { fg = c.red },
    Todo         = { fg = c.bg, bg = c.yellow, bold = true },

    -- Treesitter
    ["@variable"]           = style({ fg = c.fg }, s.variables),
    ["@variable.builtin"]   = { fg = c.red, italic = true },
    ["@variable.parameter"] = { fg = c.brown },
    ["@variable.member"]    = { fg = c.blue },
    ["@property"]           = { fg = c.blue },
    ["@constant.builtin"]   = { fg = c.orange, bold = true },
    ["@module"]             = { fg = c.yellow },
    ["@string.escape"]      = { fg = c.emerald },
    ["@string.regexp"]      = { fg = c.emerald },
    ["@string.special"]     = { fg = c.emerald },
    ["@character.special"]  = { fg = c.emerald },
    ["@type.builtin"]       = style({ fg = c.yellow, italic = true }, s.types),
    ["@attribute"]          = { fg = c.emerald },
    ["@function.builtin"]   = style({ fg = c.cyan, italic = true }, s.functions),
    ["@function.method"]    = style({ fg = c.cyan }, s.functions),
    ["@constructor"]        = { fg = c.yellow },
    ["@keyword.return"]     = style({ fg = c.red }, s.keywords),
    ["@keyword.import"]     = style({ fg = c.red }, s.keywords),
    ["@keyword.operator"]   = style({ fg = c.purple }, s.keywords),
    ["@punctuation"]        = { fg = c.fg_dim },
    ["@punctuation.special"] = { fg = c.emerald },
    ["@tag"]                = { fg = c.red },
    ["@tag.attribute"]      = { fg = c.yellow },
    ["@tag.delimiter"]      = { fg = c.fg_dim },
    ["@comment.error"]      = { fg = c.bg, bg = c.red, bold = true },
    ["@comment.warning"]    = { fg = c.bg, bg = c.orange, bold = true },
    ["@comment.todo"]       = { fg = c.bg, bg = c.yellow, bold = true },
    ["@comment.note"]       = { fg = c.bg, bg = c.blue, bold = true },
    ["@diff.plus"]          = { fg = c.green },
    ["@diff.minus"]         = { fg = c.red },
    ["@diff.delta"]         = { fg = c.yellow },

    -- Markup (markdown, LaTeX, etc.)
    ["@markup.heading"]     = { fg = c.yellow, bold = true },
    ["@markup.heading.1"]   = { fg = c.red, bold = true },
    ["@markup.heading.2"]   = { fg = c.orange, bold = true },
    ["@markup.heading.3"]   = { fg = c.yellow, bold = true },
    ["@markup.heading.4"]   = { fg = c.green, bold = true },
    ["@markup.heading.5"]   = { fg = c.blue, bold = true },
    ["@markup.heading.6"]   = { fg = c.purple, bold = true },
    ["@markup.strong"]      = { bold = true },
    ["@markup.italic"]      = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"]   = { underline = true },
    ["@markup.quote"]       = { fg = c.fg_dim, italic = true },
    ["@markup.math"]        = { fg = c.cyan },
    ["@markup.link"]        = { fg = c.blue },
    ["@markup.link.url"]    = { fg = c.blue, underline = true },
    ["@markup.link.label"]  = { fg = c.purple },
    ["@markup.raw"]         = { fg = c.green },
    ["@markup.list"]        = { fg = c.orange },
    ["@markup.list.checked"]   = { fg = c.green },
    ["@markup.list.unchecked"] = { fg = c.comment },

    -- LSP
    LspReferenceText  = { bg = c.selection },
    LspReferenceRead  = { bg = c.selection },
    LspReferenceWrite = { bg = c.selection, underline = true },
    LspInlayHint      = { fg = c.comment, bg = soft(c.comment, 0.12), italic = true },
    LspSignatureActiveParameter = { fg = c.orange, bold = true },
    LspCodeLens       = { fg = c.comment },
    ["@lsp.type.namespace"]  = { link = "@module" },
    ["@lsp.type.parameter"]  = { link = "@variable.parameter" },
    ["@lsp.type.property"]   = { link = "@property" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.macro"]      = { link = "Macro" },
    ["@lsp.mod.deprecated"]  = { strikethrough = true },

    -- Diagnósticos
    DiagnosticError = { fg = c.red },
    DiagnosticWarn  = { fg = c.yellow },
    DiagnosticInfo  = { fg = c.blue },
    DiagnosticHint  = { fg = c.emerald },
    DiagnosticOk    = { fg = c.green },
    DiagnosticVirtualTextError = { fg = c.red, bg = soft(c.red, 0.1) },
    DiagnosticVirtualTextWarn  = { fg = c.yellow, bg = soft(c.yellow, 0.1) },
    DiagnosticVirtualTextInfo  = { fg = c.blue, bg = soft(c.blue, 0.1) },
    DiagnosticVirtualTextHint  = { fg = c.emerald, bg = soft(c.emerald, 0.1) },
    DiagnosticUnderlineError = { sp = c.red, undercurl = true },
    DiagnosticUnderlineWarn  = { sp = c.yellow, undercurl = true },
    DiagnosticUnderlineInfo  = { sp = c.blue, undercurl = true },
    DiagnosticUnderlineHint  = { sp = c.emerald, undercurl = true },
    DiagnosticUnnecessary    = { fg = c.comment },

    -- Diff / Git
    DiffAdd      = { bg = soft(c.green, 0.2) },
    DiffChange   = { bg = soft(c.blue, 0.15) },
    DiffDelete   = { fg = c.red, bg = soft(c.red, 0.2) },
    DiffText     = { bg = soft(c.blue, 0.35) },
    Added        = { fg = c.green },
    Changed      = { fg = c.yellow },
    Removed      = { fg = c.red },
  }

  for group, spec in pairs(require("minecraft.plugins").get(c, o, soft)) do
    groups[group] = spec
  end
  return groups
end

-- Colores de :terminal; en el tema claro "negro" y "blanco" se invierten
function M.terminal(c)
  local black, white = c.bg_float, c.fg_dim
  local bright_black, bright_white = c.comment, c.fg
  if c.background == "light" then
    black, white = c.fg, c.bg_alt
    bright_black, bright_white = c.fg_dim, c.bg_float
  end
  local colors = {
    black, c.red, c.green, c.yellow, c.blue, c.purple, c.cyan, white,
    bright_black, c.red, c.green, c.yellow, c.blue, c.purple, c.cyan, bright_white,
  }
  for i, color in ipairs(colors) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M
