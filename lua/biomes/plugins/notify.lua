-- https://github.com/rcarriga/nvim-notify
---@type biomes.PluginGroups
return function(c, _, u)
  local groups = { NotifyBackground = { bg = c.bg } }
  local levels = { ERROR = c.red, WARN = c.yellow, INFO = c.blue, DEBUG = c.comment, TRACE = c.purple }
  for level, color in pairs(levels) do
    groups["Notify" .. level .. "Border"] = { fg = u.soft(color, 0.6), bg = u.float_bg }
    groups["Notify" .. level .. "Icon"]   = { fg = color }
    groups["Notify" .. level .. "Title"]  = { fg = color, bold = true }
    groups["Notify" .. level .. "Body"]   = { fg = c.fg, bg = u.float_bg }
  end
  return groups
end
