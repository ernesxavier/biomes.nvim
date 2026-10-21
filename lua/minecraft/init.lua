local M = {}

M.variants = { "overworld", "nether", "end" }

M.config = {
  variant = "overworld",
  transparent = false,
  italic_comments = true,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.palette(variant)
  return require("minecraft.palettes." .. (variant or M.config.variant))
end

function M.load(variant)
  variant = variant or M.config.variant
  if not vim.tbl_contains(M.variants, variant) then
    vim.notify("minecraft: variante desconocida '" .. variant .. "'", vim.log.levels.ERROR)
    return
  end

  local c = M.palette(variant)

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  -- Se limpia colors_name antes de cambiar 'background' para que nvim no
  -- vuelva a cargar el colorscheme anterior al detectar el cambio
  vim.g.colors_name = nil
  vim.o.background = c.background
  vim.o.termguicolors = true
  vim.g.colors_name = "minecraft-" .. variant

  for group, spec in pairs(require("minecraft.highlights").get(c, M.config)) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

return M
