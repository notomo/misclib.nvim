local helper = require("misclib.lib.testlib.helper")
local error_handler = helper.require("misclib.error_handler")

describe("error_handler.methods()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns defined methods", function()
    local ReturnValue = error_handler.for_return_value()
    function ReturnValue.method1()
      return 8888
    end
    local methods = ReturnValue:methods()
    local v = methods.method1()
    assert.equal(8888, v)
  end)
end)
