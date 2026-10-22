---@alias minecraft.Variant "overworld"|"nether"|"end"

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
---@field search string
---@field on_search string

---@class minecraft.Styles
---@field comments? vim.api.keyset.highlight
---@field keywords? vim.api.keyset.highlight
---@field functions? vim.api.keyset.highlight
---@field variables? vim.api.keyset.highlight
---@field types? vim.api.keyset.highlight
---@field strings? vim.api.keyset.highlight
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
---@field dark_variant? "nether"|"end" Variante al hacer `:set background=dark` desde el Overworld
---@field transparent? boolean No pintar el fondo (también vuelve transparentes paneles y flotantes)
---@field dim_inactive? boolean Atenuar el fondo de las ventanas sin foco
---@field styles? minecraft.Styles Atributos extra (italic, bold...) por tipo de elemento
---@field plugins? minecraft.PluginsConfig Qué grupos de plugins cargar
---@field on_colors? fun(colors: minecraft.Palette, variant: minecraft.Variant)
---@field on_highlights? fun(highlights: table<string, vim.api.keyset.highlight>, colors: minecraft.Palette, variant: minecraft.Variant)

local M = {}

---@type minecraft.Variant[]
M.variants = { "overworld", "nether", "end" }

---@type minecraft.Config
M.config = {
  variant = "overworld",
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

-- Si 'background' ya no coincide con la variante activa, es que el usuario lo
-- cambió (:set background=...); en ese caso se elige la variante del otro modo
---@param variant minecraft.Variant
---@return minecraft.Variant
local function resolve(variant)
  local wanted = require("minecraft.palettes." .. variant).background
  if vim.o.background == wanted or vim.g.colors_name ~= "minecraft-" .. variant then
    return variant
  end
  if vim.o.background == "dark" then
    return M._last_dark or M.config.dark_variant
  end
  for _, v in ipairs(M.variants) do
    if require("minecraft.palettes." .. v).background == "light" then
      return v
    end
  end
  return variant
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
  if c.background == "dark" then
    M._last_dark = variant
  end

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
