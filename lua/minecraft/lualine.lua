local M = {}

-- Tema de lualine para una variante; sin variante usa la activa o la de setup()
function M.theme(variant)
  local minecraft = require("minecraft")
  variant = variant
    or (vim.g.colors_name or ""):match("^minecraft%-(%a+)$")
    or minecraft.config.variant
  local c = minecraft.palette(variant)
  local bg = minecraft.config.transparent and "NONE" or c.bg_alt

  local function mode(color)
    return {
      a = { fg = c.bg, bg = color, gui = "bold" },
      b = { fg = color, bg = c.bg_float },
      c = { fg = c.fg_dim, bg = bg },
    }
  end

  return {
    normal   = mode(c.green),
    insert   = mode(c.cyan),
    visual   = mode(c.purple),
    replace  = mode(c.red),
    command  = mode(c.orange),
    terminal = mode(c.emerald),
    inactive = {
      a = { fg = c.comment, bg = bg },
      b = { fg = c.comment, bg = bg },
      c = { fg = c.comment, bg = bg },
    },
  }
end

return M
