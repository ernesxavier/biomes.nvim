-- Generador de los temas para otras aplicaciones (extras/)
--
-- Uso, desde la raíz del repositorio:
--   nvim -l scripts/extras.lua             escribe extras/ghostty/biomes-*

local ROOT = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
package.path = ROOT .. "/lua/?.lua;" .. ROOT .. "/lua/?/init.lua;" .. package.path

local terminal_colors = require("biomes.highlights").terminal_colors

local VARIANTS = { "plains", "cherry", "snowy", "nether", "end", "deep_dark" }

-- Ghostty: mismos colores ANSI que :terminal en Neovim
local function ghostty(name, c)
  local lines = { "# biomes-" .. name .. " · generado por scripts/extras.lua" }
  for i, color in ipairs(terminal_colors(c)) do
    lines[#lines + 1] = ("palette = %d=%s"):format(i - 1, color)
  end
  vim.list_extend(lines, {
    "background = " .. c.bg,
    "foreground = " .. c.fg,
    "cursor-color = " .. c.accent,
    "cursor-text = " .. c.bg,
    "selection-background = " .. c.selection,
    "selection-foreground = " .. c.fg,
  })
  return lines
end

vim.fn.mkdir(ROOT .. "/extras/ghostty", "p")
for _, name in ipairs(VARIANTS) do
  local c = dofile(ROOT .. "/lua/biomes/palettes/" .. name .. ".lua")
  local path = ROOT .. "/extras/ghostty/biomes-" .. name
  vim.fn.writefile(ghostty(name, c), path)
  print(path)
end
