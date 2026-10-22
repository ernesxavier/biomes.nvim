---@class minecraft.PluginContext
---@field soft fun(color: string, alpha?: number): string Fondo suave a partir de un acento
---@field float_bg string Fondo de ventanas flotantes (respeta transparent)
---@field link_kinds fun(groups: table, pattern: string): table Enlaza `pattern` (p. ej. "CmpItemKind%s") a LspKind<Tipo>

---@alias minecraft.PluginGroups fun(c: minecraft.Palette, o: minecraft.Config, u: minecraft.PluginContext): table<string, vim.api.keyset.highlight>

local M = {}

-- Nombre del plugin (como lo registra el gestor) → módulo en minecraft.plugins
-- stylua: ignore
M.plugins = {
  ["blink.cmp"]               = "blink",
  ["bufferline.nvim"]         = "bufferline",
  ["flash.nvim"]              = "flash",
  ["fzf-lua"]                 = "fzf",
  ["gitsigns.nvim"]           = "gitsigns",
  ["indent-blankline.nvim"]   = "indent_blankline",
  ["lazy.nvim"]               = "lazy",
  ["neo-tree.nvim"]           = "neo_tree",
  ["noice.nvim"]              = "noice",
  ["nvim-cmp"]                = "cmp",
  ["nvim-dap"]                = "dap",
  ["nvim-navic"]              = "navic",
  ["nvim-notify"]             = "notify",
  ["nvim-tree.lua"]           = "nvim_tree",
  ["nvim-treesitter-context"] = "treesitter_context",
  ["rainbow-delimiters.nvim"] = "rainbow_delimiters",
  ["render-markdown.nvim"]    = "render_markdown",
  ["snacks.nvim"]             = "snacks",
  ["telescope.nvim"]          = "telescope",
  ["trouble.nvim"]            = "trouble",
  ["vim-illuminate"]          = "illuminate",
  ["vimtex"]                  = "vimtex",
  ["which-key.nvim"]          = "which_key",
  -- mini.nvim completo o sus módulos sueltos comparten un archivo
  ["mini.nvim"]               = "mini",
  ["mini.clue"]               = "mini",
  ["mini.cursorword"]         = "mini",
  ["mini.diff"]               = "mini",
  ["mini.files"]              = "mini",
  ["mini.hipatterns"]         = "mini",
  ["mini.icons"]              = "mini",
  ["mini.indentscope"]        = "mini",
  ["mini.jump"]               = "mini",
  ["mini.jump2d"]             = "mini",
  ["mini.notify"]             = "mini",
  ["mini.pick"]               = "mini",
  ["mini.starter"]            = "mini",
  ["mini.statusline"]         = "mini",
  ["mini.surround"]           = "mini",
  ["mini.tabline"]            = "mini",
  ["mini.trailspace"]         = "mini",
}

-- Nombres de los plugins instalados según lazy.nvim y vim.pack; nil si no
-- hay ningún gestor que consultar
---@return table<string, boolean>?
local function installed()
  local found
  local ok, lazy = pcall(require, "lazy.core.config")
  if ok and lazy.plugins then
    found = {}
    for name in pairs(lazy.plugins) do
      found[name] = true
    end
  end
  -- Solo si ya se usó vim.pack.add(): acceder a vim.pack lo carga (~3 ms)
  local pack = package.loaded["vim.pack"]
  if pack then
    local ok_pack, packs = pcall(pack.get, nil, { info = false })
    -- En 0.12 vim.pack siempre existe; una lista vacía no dice nada
    if ok_pack and #packs > 0 then
      found = found or {}
      for _, p in ipairs(packs) do
        found[p.spec.name] = true
      end
    end
  end
  return found
end

-- Módulos a cargar según la configuración y los plugins instalados
---@param opts minecraft.PluginsConfig
---@return string[]
function M.enabled(opts)
  local present = (opts.all or not opts.auto) and nil or installed()
  local modules, seen = {}, {}
  for name, mod in pairs(M.plugins) do
    -- Se puede activar/desactivar por módulo ("snacks") o por nombre ("snacks.nvim")
    local use = opts[mod]
    if use == nil then
      use = opts[name]
    end
    if use == nil then
      if opts.all then
        use = true
      elseif opts.auto then
        use = present == nil or present[name] == true
      end
    end
    if use and not seen[mod] then
      seen[mod] = true
      modules[#modules + 1] = mod
    end
  end
  table.sort(modules)
  return modules
end

---@param c minecraft.Palette
---@param o minecraft.Config
---@param u minecraft.PluginContext
function M.get(c, o, u)
  local groups = {}
  for _, mod in ipairs(M.enabled(o.plugins or {})) do
    for group, spec in pairs(require("minecraft.plugins." .. mod)(c, o, u)) do
      groups[group] = spec
    end
  end
  return groups
end

return M
