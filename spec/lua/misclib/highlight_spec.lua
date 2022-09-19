local helper = require("misclib.test.helper")
local highlightlib = helper.require("misclib.highlight")

describe("highlightlib.define()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("defines a highlight group", function()
    highlightlib.define("TestDefine1", {
      fg = 100,
    })
    local got = vim.api.nvim_get_hl_by_name("TestDefine1", true)
    assert.is_same({ foreground = 100 }, got)
  end)

  it("returns highlight group name", function()
    local got = highlightlib.define("TestDefine2", {
      fg = 100,
    })
    assert.equals("TestDefine2", got)
  end)
end)

describe("highlightlib.link()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("define a link highlight group", function()
    highlightlib.link("TestLink1", "String")
    local want = vim.api.nvim_get_hl_by_name("String", true)
    local got = vim.api.nvim_get_hl_by_name("TestLink1", true)
    assert.is_same(want, got)
  end)

  it("returns highlight group name", function()
    local got = highlightlib.link("TestLink2", "String")
    assert.equals("TestLink2", got)
  end)
end)
