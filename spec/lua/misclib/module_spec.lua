local helper = require("misclib.test.helper")
local modulelib = helper.require("misclib.module")

describe("modulelib.find()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns the module if found", function()
    helper.new_directory("lua")
    vim.opt.runtimepath:prepend(helper.test_data_dir)
    helper.new_file("lua/valid.lua", [[return {ok = 8888}]])

    local m = modulelib.find("valid")
    assert.is_same({ ok = 8888 }, m)
  end)

  it("returns nil if not found", function()
    local m = modulelib.find("invalid")
    assert.is_nil(m)
  end)

  it("raises error if found but error", function()
    helper.new_directory("lua")
    vim.opt.runtimepath:prepend(helper.test_data_dir)
    helper.new_file("lua/error.lua", [[error("raised error", 0)]])

    local ok, result = pcall(modulelib.find, "error")
    assert.is_false(ok)
    assert.matches("raised error$", result)
  end)
end)
