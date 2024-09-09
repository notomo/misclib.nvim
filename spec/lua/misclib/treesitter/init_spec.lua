local helper = require("misclib.test.helper")
local tslib = helper.require("misclib.treesitter")
local assert = require("assertlib").typed(assert)

describe("tslib.has_parser()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns true if parser exists", function()
    local got = tslib.has_parser("lua")
    assert.is_true(got)
  end)

  it("returns false if parser does not exist", function()
    local got = tslib.has_parser("not_found")
    assert.is_false(got)
  end)
end)
