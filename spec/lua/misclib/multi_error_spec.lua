local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("misclib.test.helper")
local MultiError = require("misclib.multi_error")
local assert = require("assertlib").typed(ntf.assert)

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
