local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

require("genvdoc").generate(full_plugin_name, {
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if not node.declaration then
          return nil
        end
        return node.declaration.module
      end,
    },
  },
})

local gen_readme = function()
  local content = ([[
# %s

misc
]]):format(full_plugin_name)

  local readme = io.open("README.md", "w")
  readme:write(content)
  readme:close()
end
gen_readme()
