local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

helper.root = helper.find_plugin_root(plugin_name)
helper.runtimepath = vim.o.runtimepath

function helper.before_each()
  helper.test_data_path = "spec/test_data/" .. math.random(1, 2 ^ 30) .. "/"
  helper.test_data_dir = helper.root .. "/" .. helper.test_data_path
  helper.new_directory("")
end

function helper.after_each()
  vim.cmd("tabedit")
  vim.cmd("tabonly!")
  vim.cmd("silent %bwipeout!")
  helper.cleanup_loaded_modules(plugin_name)
  vim.fn.delete(helper.root .. "/spec/test_data", "rf")
  vim.cmd("messages clear")
  print(" ")
end

function helper.new_file(path, ...)
  local f = io.open(helper.test_data_dir .. path, "w")
  for _, line in ipairs({ ... }) do
    f:write(line .. "\n")
  end
  f:close()
end

function helper.new_directory(path)
  vim.fn.mkdir(helper.test_data_dir .. path, "p")
end

function helper.delete(path)
  vim.fn.delete(helper.test_data_dir .. path, "rf")
end

function helper.set_lines(lines)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(lines, "\n"))
end

local asserts = require("vusted.assert").asserts

asserts.create("exists_message"):register(function(self)
  return function(_, args)
    local expected = args[1]
    self:set_positive(("`%s` not found message"):format(expected))
    self:set_negative(("`%s` found message"):format(expected))
    local messages = vim.split(vim.api.nvim_exec("messages", true), "\n")
    for _, msg in ipairs(messages) do
      if msg:match(expected) then
        return true
      end
    end
    return false
  end
end)

return helper
