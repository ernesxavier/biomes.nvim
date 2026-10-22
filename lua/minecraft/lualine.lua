local M = {}

-- Tema de lualine para una variante; sin variante usa la activa o la de setup()
function M.theme(variant)
  local minecraft = require("minecraft")
  variant = variant
    or (vim.g.colors_name or ""):match("^minecraft%-([%w_]+)$")
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

  local m = require("minecraft.util").mode_colors(c)
  return {
    normal   = mode(m.normal),
    insert   = mode(m.insert),
    visual   = mode(m.visual),
    replace  = mode(m.replace),
    command  = mode(m.command),
    terminal = mode(m.terminal),
    inactive = {
      a = { fg = c.comment, bg = bg },
      b = { fg = c.comment, bg = bg },
      c = { fg = c.comment, bg = bg },
    },
  }
end

return M
