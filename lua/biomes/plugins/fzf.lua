-- https://github.com/ibhagwan/fzf-lua
---@type biomes.PluginGroups
return function(c, _, u)
  local float_bg = u.float_bg
  return {
    FzfLuaNormal         = { fg = c.fg, bg = float_bg },
    FzfLuaBorder         = { fg = c.border, bg = float_bg },
    FzfLuaTitle          = { fg = c.bg, bg = c.accent, bold = true },
    FzfLuaPreviewTitle   = { fg = c.bg, bg = c.purple, bold = true },
    FzfLuaCursor         = { link = "Cursor" },
    FzfLuaCursorLine     = { bg = c.selection },
    FzfLuaHeaderBind     = { fg = c.orange },
    FzfLuaHeaderText     = { fg = c.comment },
    FzfLuaPath           = { fg = c.blue },
    FzfLuaDirPart        = { fg = c.comment },
    FzfLuaFilePart       = { fg = c.fg },
    FzfLuaFzfNormal      = { fg = c.fg },
    FzfLuaFzfCursorLine  = { bg = c.selection },
    FzfLuaFzfMatch       = { fg = c.cyan, bold = true },
    FzfLuaFzfPointer     = { fg = c.orange },
    FzfLuaFzfMarker      = { fg = c.orange },
    FzfLuaFzfPrompt      = { fg = c.accent },
    FzfLuaFzfSeparator   = { fg = c.border },
    FzfLuaFzfBorder      = { fg = c.border },
  }
end
