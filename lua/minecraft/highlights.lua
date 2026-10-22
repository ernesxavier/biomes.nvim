local blend = require("minecraft.util").blend

local M = {}

-- c: paleta, o: opciones de configuración
function M.get(c, o)
  local s = o.styles
  local bg = o.transparent and "NONE" or c.bg

  -- Fondo de un tipo de panel según su estilo ("shaded" usa `shaded`)
  local function panel(panel_style, shaded)
    if o.transparent or panel_style == "transparent" then
      return "NONE"
    end
    return panel_style == "normal" and c.bg or shaded
  end
  local float_bg = panel(s.floats, c.bg_float)
  local sidebar_bg = panel(s.sidebars, c.bg_alt)

  -- Agrega los atributos configurados en styles a un grupo
  local function style(spec, extra)
    return vim.tbl_extend("force", spec, extra or {})
  end

  -- Fondos suaves derivados de los acentos
  local soft = function(color, alpha)
    return blend(color, c.bg, alpha or 0.15)
  end

  -- Ventanas sin foco: más oscuras en los temas oscuros y un poco más
  -- sombreadas en el claro
  local inactive_bg = bg
  if o.dim_inactive and not o.transparent then
    inactive_bg = c.background == "dark" and blend("#000000", c.bg, 0.3) or soft(c.fg, 0.06)
  end

  local groups = {
    -- Editor
    Normal       = { fg = c.fg, bg = bg },
    NormalNC     = { fg = c.fg, bg = inactive_bg },
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
    PmenuSel     = { fg = c.bg, bg = c.accent, bold = true },
    PmenuSbar    = { bg = c.bg_alt },
    PmenuThumb   = { bg = c.border },
    PmenuMatch   = { fg = c.cyan, bold = true },
    StatusLine   = { fg = c.fg, bg = c.bg_alt },
    StatusLineNC = { fg = c.fg_dim, bg = c.bg_alt },
    WinBar       = { fg = c.fg_dim, bg = bg },
    WinBarNC     = { fg = c.comment, bg = bg },
    TabLine      = { fg = c.fg_dim, bg = c.bg_alt },
    TabLineSel   = { fg = c.bg, bg = c.accent, bold = true },
    TabLineFill  = { bg = c.bg_alt },
    Title        = { fg = c.yellow, bold = true },
    Directory    = { fg = c.blue },
    ErrorMsg     = { fg = c.red },
    WarningMsg   = { fg = c.yellow },
    ModeMsg      = { fg = c.fg, bold = true },
    MoreMsg      = { fg = c.green },
    Question     = { fg = c.cyan },
    WildMenu     = { fg = c.bg, bg = c.accent },
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

    -- Tokens semánticos: se enlazan a Treesitter para que los colores coincidan
    -- con o sin LSP; solo se agregan matices que Treesitter no puede saber
    ["@lsp.type.boolean"]             = { link = "@boolean" },
    ["@lsp.type.builtinType"]         = { link = "@type.builtin" },
    ["@lsp.type.comment"]             = {}, -- dejar que Treesitter resalte TODO/FIXME
    ["@lsp.type.decorator"]           = { link = "@attribute" },
    ["@lsp.type.deriveHelper"]        = { link = "@attribute" },
    ["@lsp.type.enum"]                = { link = "@type" },
    ["@lsp.type.enumMember"]          = { link = "@constant" },
    ["@lsp.type.escapeSequence"]      = { link = "@string.escape" },
    ["@lsp.type.formatSpecifier"]     = { link = "@string.special" },
    ["@lsp.type.generic"]             = { link = "@variable" },
    ["@lsp.type.interface"]           = { fg = c.yellow, italic = true },
    ["@lsp.type.keyword"]             = { link = "@keyword" },
    ["@lsp.type.lifetime"]            = { link = "@keyword.modifier" },
    ["@lsp.type.macro"]               = { link = "@function.macro" },
    ["@lsp.type.namespace"]           = { link = "@module" },
    ["@lsp.type.namespace.python"]    = { link = "@variable" }, -- basedpyright marca los imports como namespace
    ["@lsp.type.number"]              = { link = "@number" },
    ["@lsp.type.operator"]            = { link = "@operator" },
    ["@lsp.type.parameter"]           = { link = "@variable.parameter" },
    ["@lsp.type.property"]            = { link = "@property" },
    ["@lsp.type.selfKeyword"]         = { link = "@variable.builtin" },
    ["@lsp.type.selfTypeKeyword"]     = { link = "@variable.builtin" },
    ["@lsp.type.string"]              = { link = "@string" },
    ["@lsp.type.typeAlias"]           = { link = "@type.definition" },
    ["@lsp.type.typeParameter"]       = { fg = c.brown, italic = true },
    ["@lsp.type.unresolvedReference"] = { sp = c.red, undercurl = true },
    ["@lsp.type.variable"]            = {}, -- usar el estilo de Treesitter
    ["@lsp.mod.deprecated"]           = { strikethrough = true },
    ["@lsp.typemod.class.defaultLibrary"]      = { link = "@type.builtin" },
    ["@lsp.typemod.enum.defaultLibrary"]       = { link = "@type.builtin" },
    ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
    ["@lsp.typemod.function.defaultLibrary"]   = { link = "@function.builtin" },
    ["@lsp.typemod.keyword.async"]             = { link = "@keyword.coroutine" },
    ["@lsp.typemod.macro.defaultLibrary"]      = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"]     = { link = "@function.builtin" },
    ["@lsp.typemod.struct.defaultLibrary"]     = { link = "@type.builtin" },
    ["@lsp.typemod.type.defaultLibrary"]       = { link = "@type.builtin" },
    ["@lsp.typemod.typeAlias.defaultLibrary"]  = { link = "@type.builtin" },
    ["@lsp.typemod.variable.callable"]         = { link = "@function" },
    ["@lsp.typemod.variable.defaultLibrary"]   = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.global"]           = { fg = c.fg, bold = true },
    ["@lsp.typemod.variable.static"]           = { link = "@constant" },
    ["@lsp.typemod.parameter.mutable"]         = { fg = c.brown, underline = true },
    ["@lsp.typemod.variable.mutable"]          = { underline = true },

    -- Tipos de símbolo LSP (completado, breadcrumbs, outline...)
    LspKindArray         = { link = "@punctuation.bracket" },
    LspKindBoolean       = { link = "@boolean" },
    LspKindClass         = { link = "@type" },
    LspKindColor         = { fg = c.red },
    LspKindConstant      = { link = "@constant" },
    LspKindConstructor   = { link = "@constructor" },
    LspKindEnum          = { link = "@type" },
    LspKindEnumMember    = { link = "@constant" },
    LspKindEvent         = { fg = c.purple },
    LspKindField         = { link = "@variable.member" },
    LspKindFile          = { fg = c.blue },
    LspKindFolder        = { link = "Directory" },
    LspKindFunction      = { link = "@function" },
    LspKindInterface     = { link = "@lsp.type.interface" },
    LspKindKey           = { link = "@variable.member" },
    LspKindKeyword       = { link = "@keyword" },
    LspKindMethod        = { link = "@function.method" },
    LspKindModule        = { link = "@module" },
    LspKindNamespace     = { link = "@module" },
    LspKindNull          = { link = "@constant.builtin" },
    LspKindNumber        = { link = "@number" },
    LspKindObject        = { link = "@constant" },
    LspKindOperator      = { link = "@operator" },
    LspKindPackage       = { link = "@module" },
    LspKindProperty      = { link = "@property" },
    LspKindReference     = { fg = c.red },
    LspKindSnippet       = { fg = c.emerald },
    LspKindString        = { link = "@string" },
    LspKindStruct        = { link = "@type" },
    LspKindText          = { fg = c.fg_dim },
    LspKindTypeParameter = { link = "@lsp.type.typeParameter" },
    LspKindUnit          = { fg = c.orange },
    LspKindValue         = { fg = c.orange },
    LspKindVariable      = { link = "@variable" },

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

  local ctx = {
    soft = soft,
    float_bg = float_bg,
    sidebar_bg = sidebar_bg,
    link_kinds = require("minecraft.util").link_kinds,
    mode_colors = require("minecraft.util").mode_colors,
  }
  for group, spec in pairs(require("minecraft.plugins").get(c, o, ctx)) do
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
