-- Extrae el resaltado real de Neovim para las capturas del README.
-- Abre cada archivo de samples/, aplica cada variante y guarda, carácter por
-- carácter, el color que Treesitter le da con el tema. render.py lo dibuja.
--
-- Lo ejecuta scripts/screenshots/render.py; a mano:
--   nvim --headless -u NONE --cmd "set rtp^=." --cmd "set rtp+=<queries de nvim-treesitter>" \
--     -c "luafile scripts/screenshots/extract.lua" -c q

local here = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
local out_path = vim.env.SCREENSHOT_JSON or (here .. "/highlights.json")
local SAMPLES = { "difusion.jl", "notas.md" }

vim.cmd("filetype on")
local biomes = require("biomes")

local function hex(n)
  return n and string.format("#%06x", n) or nil
end

-- Atributos finales en una posición: se combinan las capturas en orden, y cada
-- una sobrescribe solo lo que define (como hace Neovim al dibujar)
local function attrs_at(buf, row, col, base)
  local a = vim.deepcopy(base)
  for _, cap in ipairs(vim.inspect_pos(buf, row, col, { semantic_tokens = false, extmarks = false, syntax = false }).treesitter) do
    local h = vim.api.nvim_get_hl(0, { name = cap.hl_group_link or cap.hl_group, link = false })
    for _, k in ipairs({ "fg", "bg" }) do
      if h[k] then
        a[k] = hex(h[k])
      end
    end
    for _, k in ipairs({ "bold", "italic", "underline", "undercurl", "strikethrough" }) do
      if h[k] ~= nil then
        a[k] = h[k]
      end
    end
  end
  return a
end

local function same(a, b)
  return a.fg == b.fg and a.bg == b.bg and a.bold == b.bold and a.italic == b.italic and a.underline == b.underline
end

-- Una línea como lista de tramos { texto, atributos }
local function runs(buf, row, line, base)
  local out, byte = {}, 0
  for _, ch in ipairs(vim.fn.split(line, "\\zs")) do
    local a = attrs_at(buf, row, byte, base)
    local last = out[#out]
    if last and same(last.a, a) then
      last.t = last.t .. ch
    else
      out[#out + 1] = { t = ch, a = a }
    end
    byte = byte + #ch
  end
  return out
end

local result = {}
for _, variant in ipairs(biomes.variants) do
  vim.cmd.colorscheme("biomes-" .. variant)
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local base = { fg = hex(normal.fg), bg = hex(normal.bg) }
  local files = {}
  for _, name in ipairs(SAMPLES) do
    vim.cmd.edit(vim.fn.fnameescape(here .. "/samples/" .. name))
    local buf = vim.api.nvim_get_current_buf()
    vim.treesitter.start(buf) -- inspect_pos solo informa capturas con el resaltador activo
    local parser = assert(vim.treesitter.get_parser(buf), "falta el parser de Treesitter para " .. name)
    parser:parse(true) -- incluye inyecciones: Julia en Markdown, LaTeX en $...$
    local lines = {}
    for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      lines[row] = runs(buf, row - 1, line, base)
    end
    files[#files + 1] = { name = name, filetype = vim.bo[buf].filetype, lines = lines }
  end
  result[#result + 1] = {
    variant = variant,
    palette = biomes.palette(variant),
    lualine = require("biomes.lualine").theme(variant),
    files = files,
  }
end

local f = assert(io.open(out_path, "w"))
f:write(vim.json.encode(result))
f:close()
print("escrito " .. out_path)
