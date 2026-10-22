---@alias minecraft.LightVariant "plains"|"cherry"|"snowy"
---@alias minecraft.DarkVariant "nether"|"end"|"deep_dark"
---@alias minecraft.Variant minecraft.LightVariant|minecraft.DarkVariant

---@class minecraft.Palette
---@field background "light"|"dark"
---@field bg string
---@field bg_alt string
---@field bg_float string
---@field cursorline string
---@field selection string
---@field border string
---@field fg string
---@field fg_dim string
---@field comment string
---@field line_nr string
---@field red string
---@field orange string
---@field yellow string
---@field green string
---@field cyan string
---@field blue string
---@field purple string
---@field brown string
---@field emerald string
---@field operator string Operadores (+, *, ->, ::...)
---@field number string Números
---@field punct string Paréntesis, comas y demás puntuación
---@field accent string Color de identidad: modo normal, pestaña activa, títulos...
---@field search string
---@field on_search string

---@class minecraft.Styles
---@field comments? vim.api.keyset.highlight
---@field keywords? vim.api.keyset.highlight
---@field functions? vim.api.keyset.highlight
---@field variables? vim.api.keyset.highlight
---@field types? vim.api.keyset.highlight
---@field strings? vim.api.keyset.highlight
---@field operators? vim.api.keyset.highlight
---@field sidebars? minecraft.PanelStyle Fondo de neo-tree, nvim-tree, trouble...
---@field floats? minecraft.PanelStyle Fondo de ventanas flotantes, pickers, which-key...

---@alias minecraft.PanelStyle
---| "shaded" # Fondo con contraste (bg_alt / bg_float)
---| "normal" # Mismo fondo que el editor
---| "transparent" # Sin fondo

---@class minecraft.PluginsConfig
---@field all? boolean Cargar los grupos de todos los plugins soportados
---@field auto? boolean Cargar solo los de plugins instalados (lazy.nvim / vim.pack)
---@field [string] boolean Activar o desactivar uno: `snacks = false`, `["snacks.nvim"] = false`

---@class minecraft.Config
---@field variant? minecraft.Variant Variante por defecto
---@field light_variant? minecraft.LightVariant Variante de `:set background=light` si aún no se usó una clara
---@field dark_variant? minecraft.DarkVariant Variante de `:set background=dark` si aún no se usó una oscura
---@field transparent? boolean No pintar el fondo (también vuelve transparentes paneles y flotantes)
---@field dim_inactive? boolean Atenuar el fondo de las ventanas sin foco
---@field styles? minecraft.Styles Atributos extra (italic, bold...) por tipo de elemento
---@field plugins? minecraft.PluginsConfig Qué grupos de plugins cargar
---@field on_colors? fun(colors: minecraft.Palette, variant: minecraft.Variant)
---@field on_highlights? fun(highlights: table<string, vim.api.keyset.highlight>, colors: minecraft.Palette, variant: minecraft.Variant)

local M = {}

---@type minecraft.Variant[]
M.variants = { "plains", "cherry", "snowy", "nether", "end", "deep_dark" }

---@type minecraft.Config
M.config = {
  variant = "plains",
  light_variant = "plains",
  dark_variant = "nether",
  transparent = false,
  dim_inactive = false,
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = {},
    types = {},
    strings = {},
    operators = {},
    sidebars = "shaded",
    floats = "shaded",
  },
  plugins = {
    all = false,
    auto = true,
  },
  on_colors = function(colors, variant) end,
  on_highlights = function(highlights, colors, variant) end,
}

---@param opts? minecraft.Config
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Paleta de una variante con on_colors aplicado (copia, no modifica el módulo)
---@param variant? minecraft.Variant
---@return minecraft.Palette
function M.palette(variant)
  variant = variant or M.config.variant --[[@as minecraft.Variant]]
  local colors = vim.deepcopy(require("minecraft.palettes." .. variant))
  M.config.on_colors(colors, variant)
  return colors
end

-- Última variante usada de cada modo en la sesión
---@type table<"light"|"dark", minecraft.Variant>
local last = {}

-- Si 'background' ya no coincide con la variante activa, es que el usuario lo
-- cambió (:set background=...); en ese caso se vuelve a la última variante de
-- ese modo, o a light_variant / dark_variant
---@param variant minecraft.Variant
---@return minecraft.Variant
local function resolve(variant)
  local wanted = require("minecraft.palettes." .. variant).background
  if vim.o.background == wanted or vim.g.colors_name ~= "minecraft-" .. variant then
    return variant
  end
  local fallback = vim.o.background == "dark" and M.config.dark_variant or M.config.light_variant
  return last[vim.o.background] or fallback --[[@as minecraft.Variant]]
end

---@param variant? minecraft.Variant
function M.load(variant)
  variant = variant or M.config.variant
  if not vim.tbl_contains(M.variants, variant) then
    vim.notify("minecraft: variante desconocida '" .. variant .. "'", vim.log.levels.ERROR)
    return
  end
  variant = resolve(variant)

  local c = M.palette(variant)
  last[c.background] = variant

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  -- Se limpia colors_name antes de cambiar 'background' para que nvim no
  -- vuelva a cargar el colorscheme anterior al detectar el cambio
  vim.g.colors_name = nil
  vim.o.background = c.background
  vim.o.termguicolors = true
  vim.g.colors_name = "minecraft-" .. variant

  local highlights = require("minecraft.highlights")
  local groups = highlights.get(c, M.config)
  M.config.on_highlights(groups, c, variant)
  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
  highlights.terminal(c)
end

return M
