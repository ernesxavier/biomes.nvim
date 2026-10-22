-- Generador de las paletas de biomes.nvim
--
-- Uso, desde la raíz del repositorio:
--   nvim -l scripts/palettes.lua           escribe lua/biomes/palettes/*.lua desde scripts/spec.lua
--   nvim -l scripts/palettes.lua check     solo muestra el reporte, sin escribir nada
--   nvim -l scripts/palettes.lua extract   reconstruye scripts/spec.lua desde las paletas actuales
--
-- Los colores de scripts/spec.lua están en OKLCH: L (luminosidad, 0-1),
-- C (saturación) y H (tono en grados). Cada tema tiene dos perillas en `tune`
-- que afectan a todos los colores del código a la vez: `lightness` (se suma a L)
-- y `chroma` (multiplica C).

local ROOT = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local SPEC = ROOT .. "/scripts/spec.lua"
local PALETTES = ROOT .. "/lua/biomes/palettes/"

local VARIANTS = { "plains", "cherry", "snowy", "nether", "end", "deep_dark" }

-- Orden de los roles en los archivos de paleta; cada grupo va separado por una línea en blanco
local GROUPS = {
  { "bg", "bg_alt", "bg_float", "cursorline", "selection", "border" },
  { "fg", "fg_dim", "comment", "line_nr" },
  { "red", "orange", "yellow", "green", "cyan", "blue", "purple", "brown", "emerald" },
  { "operator", "number", "punct" },
  { "math", "math_bg" },
  { "accent" },
  { "search", "on_search" },
}

-- Colores del código: los que mueven las perillas de `tune`
local SYNTAX = {
  red = true, orange = true, yellow = true, green = true, cyan = true, blue = true,
  purple = true, brown = true, emerald = true, operator = true, number = true, math = true,
}

-- Umbrales del reporte
local MIN_CONTRAST = 4.5 -- WCAG AA para texto
local MIN_DISTANCE = 0.065 -- distancia en OKLab a partir de la cual dos colores se distinguen bien

--------------------------------------------------------------------------------
-- Color
--------------------------------------------------------------------------------

local atan2 = math.atan2 or math.atan

local function to_linear(c)
  return c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
end

local function to_srgb(c)
  return c <= 0.0031308 and 12.92 * c or 1.055 * c ^ (1 / 2.4) - 0.055
end

local function hex_to_rgb(hex)
  return tonumber(hex:sub(2, 3), 16) / 255, tonumber(hex:sub(4, 5), 16) / 255, tonumber(hex:sub(6, 7), 16) / 255
end

local function oklab(hex)
  local r, g, b = hex_to_rgb(hex)
  r, g, b = to_linear(r), to_linear(g), to_linear(b)
  local l = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ^ (1 / 3)
  local m = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ^ (1 / 3)
  local s = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ^ (1 / 3)
  return 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
    1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
    0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s
end

local function oklch(hex)
  local L, a, b = oklab(hex)
  return L, math.sqrt(a * a + b * b), math.deg(atan2(b, a)) % 360
end

local function oklab_to_linear(L, a, b)
  local l = (L + 0.3963377774 * a + 0.2158037573 * b) ^ 3
  local m = (L - 0.1055613458 * a - 0.0638541728 * b) ^ 3
  local s = (L - 0.0894841775 * a - 1.2914855480 * b) ^ 3
  return 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
    -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
    -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
end

-- OKLCH a hex; si el color no cabe en sRGB se reduce la saturación hasta que quepa
local function lch_to_hex(L, C, H)
  local eps = 1e-4
  while true do
    local a, b = C * math.cos(math.rad(H)), C * math.sin(math.rad(H))
    local r, g, bl = oklab_to_linear(L, a, b)
    local fits = r >= -eps and r <= 1 + eps and g >= -eps and g <= 1 + eps and bl >= -eps and bl <= 1 + eps
    if fits or C <= 0 then
      local function ch(x)
        x = to_srgb(math.max(0, x))
        return math.floor(math.max(0, math.min(1, x)) * 255 + 0.5)
      end
      return string.format("#%02x%02x%02x", ch(r), ch(g), ch(bl))
    end
    C = math.max(0, C - 0.001)
  end
end

local function luminance(hex)
  local r, g, b = hex_to_rgb(hex)
  return 0.2126 * to_linear(r) + 0.7152 * to_linear(g) + 0.0722 * to_linear(b)
end

local function contrast(a, b)
  local x, y = luminance(a), luminance(b)
  if x < y then
    x, y = y, x
  end
  return (x + 0.05) / (y + 0.05)
end

local function distance(a, b)
  local L1, a1, b1 = oklab(a)
  local L2, a2, b2 = oklab(b)
  return math.sqrt((L1 - L2) ^ 2 + (a1 - a2) ^ 2 + (b1 - b2) ^ 2)
end

--------------------------------------------------------------------------------
-- Especificación → paleta
--------------------------------------------------------------------------------

-- Devuelve { rol = hex } a partir de la especificación de un tema
local function build(spec)
  local tune = spec.tune or {}
  local dl, kc = tune.lightness or 0, tune.chroma or 1
  local hex = {}
  for role, c in pairs(spec.colors) do
    if not c.ref then
      local L, C, H = c[1], c[2], c[3]
      if SYNTAX[role] then
        L, C = L + dl, C * kc
      end
      hex[role] = lch_to_hex(L, C, H)
    end
  end
  -- Roles que repiten a otro (acento, búsqueda...): se resuelven después
  for role, c in pairs(spec.colors) do
    if c.ref then
      hex[role] = assert(hex[c.ref], ("%s.ref = %q no existe"):format(role, c.ref))
    end
  end
  return hex
end

local function render(name, spec, hex)
  local lines = { "-- " .. spec.title, "return {", ('  background = "%s",'):format(spec.background) }
  for _, group in ipairs(GROUPS) do
    lines[#lines + 1] = ""
    for _, role in ipairs(group) do
      local c = spec.colors[role]
      if c then
        local note = c.ref and c.note or c[4]
        local line = ('  %-10s = "%s",'):format(role, hex[role])
        lines[#lines + 1] = note and (line .. " -- " .. note) or line
      end
    end
  end
  lines[#lines + 1] = "}"
  return table.concat(lines, "\n") .. "\n"
end

--------------------------------------------------------------------------------
-- Reporte
--------------------------------------------------------------------------------

local CODE = { "red", "orange", "yellow", "green", "cyan", "blue", "purple", "brown", "emerald", "operator", "number" }

local function report(name, hex)
  local problems = {}
  local lo, hi = math.huge, 0
  for _, role in ipairs(CODE) do
    local r = contrast(hex[role], hex.bg)
    lo, hi = math.min(lo, r), math.max(hi, r)
    if r < MIN_CONTRAST then
      problems[#problems + 1] = ("%s %.1f:1 sobre el fondo"):format(role, r)
    end
  end
  local math_c = contrast(hex.math, hex.math_bg)
  if math_c < MIN_CONTRAST then
    problems[#problems + 1] = ("math %.1f:1 sobre math_bg"):format(math_c)
  end

  -- Par de colores más parecido entre todo lo que aparece en el código
  local keys = vim.list_extend(vim.deepcopy(CODE), { "fg", "comment", "punct" })
  local closest = { math.huge }
  for i = 1, #keys do
    for j = i + 1, #keys do
      local a, b = keys[i], keys[j]
      if not (a == "fg" and b == "punct") then
        local d = distance(hex[a], hex[b])
        if d < closest[1] then
          closest = { d, a, b }
        end
      end
    end
  end
  if closest[1] < MIN_DISTANCE then
    problems[#problems + 1] = ("%s y %s casi iguales (%.3f)"):format(closest[2], closest[3], closest[1])
  end

  print(("%-10s código %.1f-%.1f:1 · comentarios %.1f:1 · ecuaciones %.1f:1 · par más parecido %s/%s %.3f%s"):format(
    name, lo, hi, contrast(hex.comment, hex.bg), math_c, closest[2], closest[3], closest[1],
    #problems > 0 and ("\n           ⚠ " .. table.concat(problems, "\n           ⚠ ")) or ""
  ))
  return #problems
end

--------------------------------------------------------------------------------
-- extract: paletas → especificación
--------------------------------------------------------------------------------

local function read_palette(name)
  local path = PALETTES .. name .. ".lua"
  local p = { colors = {}, order = {} }
  for line in io.lines(path) do
    local title = line:match("^%-%- (.+)$")
    if title and not p.title then
      p.title = title
    end
    p.background = p.background or line:match('^%s*background%s*=%s*"(%a+)"')
    local role, hex, note = line:match('^%s*([%w_]+)%s*=%s*"(#%x%x%x%x%x%x)",%s*%-?%-?%s*(.-)%s*$')
    if role then
      p.colors[role] = { hex = hex:lower(), note = note ~= "" and note or nil }
      p.order[#p.order + 1] = role
    end
  end
  return p
end

local function fmt_num(x, digits)
  return (("%." .. digits .. "f"):format(x):gsub("0+$", ""):gsub("%.$", ".0"))
end

local function extract()
  local out = {
    "-- Especificación de las paletas de biomes.nvim.",
    "-- Generada con `nvim -l scripts/palettes.lua extract` y pensada para editarse a mano;",
    "-- después de editarla, `nvim -l scripts/palettes.lua` reescribe las paletas.",
    "--",
    "-- Cada color es { L, C, H, comentario } en OKLCH: L luminosidad (0-1), C saturación,",
    "-- H tono en grados. `ref` repite otro rol (el acento y la búsqueda siguen a su",
    "-- color de origen, y así la regla de modos de lualine detecta los choques).",
    "-- `tune` mueve todos los colores del código de un tema: lightness se suma a L",
    "-- y chroma multiplica C.",
    "return {",
  }
  local skip = { accent = false, search = false, on_search = false, math = false }
  for _, name in ipairs(VARIANTS) do
    local p = read_palette(name)
    -- "end" es palabra reservada de Lua: va entre corchetes
    out[#out + 1] = ("  %s = {"):format(name == "end" and '["end"]' or name)
    out[#out + 1] = ("    title = %q,"):format(p.title)
    out[#out + 1] = ("    background = %q,"):format(p.background)
    out[#out + 1] = "    tune = { lightness = 0, chroma = 1 },"
    out[#out + 1] = "    colors = {"
    for _, role in ipairs(p.order) do
      local c = p.colors[role]
      -- ¿Repite exactamente a un rol anterior? (acento, búsqueda, ecuaciones en los oscuros)
      local ref
      if skip[role] ~= nil then
        for _, other in ipairs(p.order) do
          if other == role then
            break
          end
          if p.colors[other].hex == c.hex and skip[other] == nil then
            ref = other
            break
          end
        end
      end
      if ref then
        out[#out + 1] = ('      %-10s = { ref = %q%s },'):format(role, ref, c.note and (", note = %q"):format(c.note) or "")
      else
        local L, C, H = oklch(c.hex)
        out[#out + 1] = ("      %-10s = { %s, %s, %s%s },"):format(
          role, fmt_num(L, 6), fmt_num(C, 6), fmt_num(H, 4), c.note and (", %q"):format(c.note) or ""
        )
      end
    end
    out[#out + 1] = "    },"
    out[#out + 1] = "  },"
  end
  out[#out + 1] = "}"
  local f = assert(io.open(SPEC, "w"))
  f:write(table.concat(out, "\n") .. "\n")
  f:close()
  print("escrito " .. SPEC)
end

--------------------------------------------------------------------------------

local mode = arg[1] or "write"
if mode == "extract" then
  extract()
  return
end

local spec = dofile(SPEC)
local total = 0
for _, name in ipairs(VARIANTS) do
  local hex = build(spec[name])
  total = total + report(name, hex)
  if mode == "write" then
    local f = assert(io.open(PALETTES .. name .. ".lua", "w"))
    f:write(render(name, spec[name], hex))
    f:close()
  end
end
if mode == "write" then
  print("paletas escritas en " .. PALETTES)
end
if total > 0 then
  print(("\n%d advertencia(s): revisa los colores marcados con ⚠"):format(total))
end
