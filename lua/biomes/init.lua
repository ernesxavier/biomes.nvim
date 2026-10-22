---@alias biomes.LightVariant "plains"|"cherry"|"snowy"
---@alias biomes.DarkVariant "nether"|"end"|"deep_dark"
---@alias biomes.Variant biomes.LightVariant|biomes.DarkVariant

---@class biomes.Palette
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
---@field math string Texto de las ecuaciones (Markdown, LaTeX)
---@field math_bg string Franja detrás de las ecuaciones
---@field accent string Color de identidad: modo normal, pestaña activa, títulos...
---@field search string
---@field on_search string

---@class biomes.Styles
---@field comments? vim.api.keyset.highlight
---@field keywords? vim.api.keyset.highlight
---@field functions? vim.api.keyset.highlight
---@field variables? vim.api.keyset.highlight
---@field types? vim.api.keyset.highlight
---@field strings? vim.api.keyset.highlight
---@field operators? vim.api.keyset.highlight
---@field sidebars? biomes.PanelStyle Fondo de neo-tree, nvim-tree, trouble...
---@field floats? biomes.PanelStyle Fondo de ventanas flotantes, pickers, which-key...

---@alias biomes.PanelStyle
---| "shaded" # Fondo con contraste (bg_alt / bg_float)
---| "normal" # Mismo fondo que el editor
---| "transparent" # Sin fondo

---@class biomes.PluginsConfig
---@field all? boolean Cargar los grupos de todos los plugins soportados
---@field auto? boolean Cargar solo los de plugins instalados (lazy.nvim / vim.pack)
---@field [string] boolean Activar o desactivar uno: `snacks = false`, `["snacks.nvim"] = false`

---@class biomes.Config
---@field variant? biomes.Variant Variante por defecto
---@field light_variant? biomes.LightVariant Variante de `:set background=light` si aún no se usó una clara
---@field dark_variant? biomes.DarkVariant Variante de `:set background=dark` si aún no se usó una oscura
---@field transparent? boolean No pintar el fondo (también vuelve transparentes paneles y flotantes)
---@field dim_inactive? boolean Atenuar el fondo de las ventanas sin foco
---@field styles? biomes.Styles Atributos extra (italic, bold...) por tipo de elemento
---@field plugins? biomes.PluginsConfig Qué grupos de plugins cargar
---@field on_colors? fun(colors: biomes.Palette, variant: biomes.Variant)
---@field on_highlights? fun(highlights: table<string, vim.api.keyset.highlight>, colors: biomes.Palette, variant: biomes.Variant)

local M = {}

---@type biomes.Variant[]
M.variants = { "plains", "cherry", "snowy", "nether", "end", "deep_dark" }

---@type biomes.Config
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

---@param opts? biomes.Config
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Paleta de una variante con on_colors aplicado (copia, no modifica el módulo)
---@param variant? biomes.Variant
---@return biomes.Palette
function M.palette(variant)
  variant = variant or M.config.variant --[[@as biomes.Variant]]
  local colors = vim.deepcopy(require("biomes.palettes." .. variant))
  M.config.on_colors(colors, variant)
  return colors
end

-- Última variante usada de cada modo en la sesión
---@type table<"light"|"dark", biomes.Variant>
local last = {}

-- Si 'background' ya no coincide con la variante activa, es que el usuario lo
-- cambió (:set background=...); en ese caso se vuelve a la última variante de
-- ese modo, o a light_variant / dark_variant
---@param variant biomes.Variant
---@return biomes.Variant
local function resolve(variant)
  local wanted = require("biomes.palettes." .. variant).background
  if vim.o.background == wanted or vim.g.colors_name ~= "biomes-" .. variant then
    return variant
  end
  local fallback = vim.o.background == "dark" and M.config.dark_variant or M.config.light_variant
  return last[vim.o.background] or fallback --[[@as biomes.Variant]]
end

---@param variant? biomes.Variant
function M.load(variant)
  variant = variant or M.config.variant
  if not vim.tbl_contains(M.variants, variant) then
    vim.notify("biomes: variante desconocida '" .. variant .. "'", vim.log.levels.ERROR)
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
  vim.g.colors_name = "biomes-" .. variant

  local highlights = require("biomes.highlights")
  local groups = highlights.get(c, M.config)
  M.config.on_highlights(groups, c, variant)
  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
  highlights.terminal(c)
end

return M
