local M = {}

local function rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

-- Mezcla fg sobre bg; alpha = 1 devuelve fg, alpha = 0 devuelve bg
function M.blend(fg, bg, alpha)
  local r1, g1, b1 = rgb(fg)
  local r2, g2, b2 = rgb(bg)
  local function ch(a, b)
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format("#%02x%02x%02x", ch(r1, r2), ch(g1, g2), ch(b1, b2))
end

-- Colores de los modos (lualine, mini.statusline). Normal usa el acento de la
-- variante; si otro modo usaba ese mismo color, pasa al verde para que no se
-- confundan
---@param c minecraft.Palette
---@return table<"normal"|"insert"|"visual"|"replace"|"command"|"terminal", string>
function M.mode_colors(c)
  local modes = {
    normal = c.green,
    insert = c.cyan,
    visual = c.purple,
    replace = c.red,
    command = c.orange,
    terminal = c.emerald,
  }
  for mode, color in pairs(modes) do
    if mode ~= "normal" and color == c.accent then
      modes[mode] = c.green
    end
  end
  modes.normal = c.accent
  return modes
end

-- Tipos de símbolo LSP; los colores viven en los grupos LspKind<Tipo>
-- stylua: ignore
M.kind_names = {
  "Array", "Boolean", "Class", "Color", "Constant", "Constructor", "Enum",
  "EnumMember", "Event", "Field", "File", "Folder", "Function", "Interface",
  "Key", "Keyword", "Method", "Module", "Namespace", "Null", "Number", "Object",
  "Operator", "Package", "Property", "Reference", "Snippet", "String", "Struct",
  "Text", "TypeParameter", "Unit", "Value", "Variable",
}

-- Enlaza los grupos de tipos de un plugin a LspKind<Tipo>.
-- pattern: p. ej. "CmpItemKind%s" → CmpItemKindFunction = LspKindFunction
---@param groups table<string, vim.api.keyset.highlight>
---@param pattern string
function M.link_kinds(groups, pattern)
  for _, kind in ipairs(M.kind_names) do
    groups[pattern:format(kind)] = { link = "LspKind" .. kind }
  end
  return groups
end

return M
