local helper = require("misclib.test.helper")
local messagelib = helper.require("misclib.message")

describe("messagelib.info()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("echos a message", function()
    messagelib.info("info_test")
    assert.exists_message("%[misclib%] info_test")
  end)
end)

describe("messagelib.wrap()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns string that has plugin name prefix", function()
    local actual = messagelib.wrap("test")
    assert.equal("[misclib] test", actual)
  end)

  it("can receive table", function()
    local actual = messagelib.wrap({})
    assert.equal("[misclib] {}", actual)
  end)
end)
