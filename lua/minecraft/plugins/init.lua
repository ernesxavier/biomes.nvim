---@class minecraft.PluginContext
---@field soft fun(color: string, alpha?: number): string Fondo suave a partir de un acento
---@field float_bg string Fondo de ventanas flotantes (respeta transparent)

---@alias minecraft.PluginGroups fun(c: minecraft.Palette, o: minecraft.Config, u: minecraft.PluginContext): table<string, vim.api.keyset.highlight>

local M = {}

-- Nombre del plugin (como lo registra el gestor) → módulo en minecraft.plugins
-- stylua: ignore
M.plugins = {
  ["blink.cmp"]            = "blink",
  ["bufferline.nvim"]      = "bufferline",
  ["flash.nvim"]           = "flash",
  ["gitsigns.nvim"]        = "gitsigns",
  ["lazy.nvim"]            = "lazy",
  ["mini.icons"]           = "mini_icons",
  ["noice.nvim"]           = "noice",
  ["render-markdown.nvim"] = "render_markdown",
  ["snacks.nvim"]          = "snacks",
  ["trouble.nvim"]         = "trouble",
  ["vimtex"]               = "vimtex",
  ["which-key.nvim"]       = "which_key",
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
  -- mini.nvim trae todos los módulos mini.* en un solo plugin
  if found and found["mini.nvim"] then
    for name in pairs(M.plugins) do
      if name:find("^mini%.") then
        found[name] = true
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
  local modules = {}
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
    if use then
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
