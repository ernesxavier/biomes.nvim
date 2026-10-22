-- https://github.com/RRethy/vim-illuminate
---@type biomes.PluginGroups
return function(c)
  return {
    IlluminatedWordText  = { bg = c.selection },
    IlluminatedWordRead  = { bg = c.selection },
    IlluminatedWordWrite = { bg = c.selection, underline = true },
  }
end
