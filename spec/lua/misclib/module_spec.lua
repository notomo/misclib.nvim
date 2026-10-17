local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("misclib.test.helper")
local modulelib = require("misclib.module")
local assert = require("assertlib").typed(ntf.assert)

describe("modulelib.find()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns the module if found", function()
    helper.test_data:create_file("lua/valid.lua", [[return {ok = 8888}]])
    vim.api.nvim_set_option_value("runtimepath", helper.test_data.full_path, { operation = "prepend" })

    local m = modulelib.find("valid")
    assert.same({ ok = 8888 }, m)
  end)

  it("returns nil if not found", function()
    local m = modulelib.find("invalid")
    assert.is_nil(m)
  end)

  it("raises error if found but error", function()
    helper.test_data:create_file("lua/error.lua", [[error("raised error", 0)]])
    vim.api.nvim_set_option_value("runtimepath", helper.test_data.full_path, { operation = "prepend" })

    local ok, result = pcall(modulelib.find, "error")
    assert.is_false(ok)
    assert.match("raised error$", result)
  end)
end)
