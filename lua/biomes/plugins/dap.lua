-- https://github.com/mfussenegger/nvim-dap
---@type biomes.PluginGroups
return function(c, _, u)
  return {
    DapBreakpoint          = { fg = c.red },
    DapBreakpointCondition = { fg = c.yellow },
    DapBreakpointRejected  = { fg = c.comment },
    DapLogPoint            = { fg = c.blue },
    DapStopped             = { fg = c.green },
    DapStoppedLine         = { bg = u.soft(c.yellow, 0.12) },
  }
end
