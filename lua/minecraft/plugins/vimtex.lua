-- https://github.com/lervag/vimtex
---@type minecraft.PluginGroups
return function(c)
  return {
    texCmd          = { fg = c.purple },
    texCmdEnv       = { fg = c.red },
    texEnvArgName   = { fg = c.yellow },
    texPartArgTitle = { fg = c.yellow, bold = true },
    texMathZone     = { fg = c.cyan },
    texMathCmd      = { fg = c.blue },
    texMathDelim    = { fg = c.emerald },
    texRefArg       = { fg = c.orange },
    texFileArg      = { fg = c.green },
  }
end
