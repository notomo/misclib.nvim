local helper = require("misclib.test.helper")
local MultiError = helper.require("misclib.multi_error")

describe("MultiError", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns nil if no error is added", function()
    local errs = MultiError.new()
    assert.is_nil(errs:error())
  end)

  it("returns joined error", function()
    local errs = MultiError.new()
    errs:add("err1")
    errs:add("err2")
    assert.equal("err1\nerr2", errs:error())
  end)
end)
