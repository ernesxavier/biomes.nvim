-- https://github.com/lervag/vimtex
---@type minecraft.PluginGroups
return function(c)
  -- En la sintaxis de vimtex un grupo anidado reemplaza al de afuera, así que
  -- cada grupo que aparece dentro de una ecuación lleva la franja explícita
  local bg = c.math_bg
  return {
    texCmd          = { fg = c.purple },
    texCmdEnv       = { fg = c.red },
    texEnvArgName   = { fg = c.yellow },
    texPartArgTitle = { fg = c.yellow, bold = true },
    texRefArg       = { fg = c.orange },
    texFileArg      = { fg = c.green },

    -- Ecuaciones
    texMathZone      = { fg = c.math, bg = bg },
    texMathCmd       = { fg = c.blue, bg = bg },      -- \frac, \sum
    texMathSymbol    = { fg = c.blue, bg = bg },      -- \alpha, \infty
    texMathCmdText   = { fg = c.purple, bg = bg },    -- \text{...}
    texMathDelim     = { fg = c.emerald, bg = bg },   -- \left( \right)
    texMathOper      = { fg = c.operator, bg = bg },  -- + - = ^ _
    texMathDelimZone = { fg = c.punct, bg = bg },     -- $ $$ \[ \]
  }
end
