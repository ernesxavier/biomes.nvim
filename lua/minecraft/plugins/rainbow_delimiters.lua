-- https://github.com/HiPhish/rainbow-delimiters.nvim
---@type minecraft.PluginGroups
return function(c)
  return {
    RainbowDelimiterRed    = { fg = c.red },
    RainbowDelimiterOrange = { fg = c.orange },
    RainbowDelimiterYellow = { fg = c.yellow },
    RainbowDelimiterGreen  = { fg = c.green },
    RainbowDelimiterCyan   = { fg = c.cyan },
    RainbowDelimiterBlue   = { fg = c.blue },
    RainbowDelimiterViolet = { fg = c.purple },
  }
end
