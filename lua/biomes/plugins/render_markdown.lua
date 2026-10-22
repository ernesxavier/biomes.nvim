-- https://github.com/MeanderingProgrammer/render-markdown.nvim
---@type biomes.PluginGroups
return function(c, _, u)
  return {
    RenderMarkdownH1Bg = { bg = u.soft(c.red) },
    RenderMarkdownH2Bg = { bg = u.soft(c.orange) },
    RenderMarkdownH3Bg = { bg = u.soft(c.yellow) },
    RenderMarkdownH4Bg = { bg = u.soft(c.green) },
    RenderMarkdownH5Bg = { bg = u.soft(c.blue) },
    RenderMarkdownH6Bg = { bg = u.soft(c.purple) },
    RenderMarkdownCode       = { bg = c.bg_alt },
    RenderMarkdownCodeInline = { fg = c.green, bg = c.bg_alt },
    RenderMarkdownBullet     = { fg = c.orange },
    RenderMarkdownQuote      = { fg = c.comment },
    RenderMarkdownDash       = { fg = c.border },
    RenderMarkdownTableHead  = { fg = c.purple },
    RenderMarkdownTableRow   = { fg = c.border },
  }
end
