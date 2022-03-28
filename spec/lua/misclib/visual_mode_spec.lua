local helper = require("misclib.test.helper")
local visual_mode = helper.require("misclib.visual_mode")

describe("visual_mode.is_current()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns false if normal mode", function()
    local actual = visual_mode.is_current()
    assert.is_false(actual)
  end)

  it("returns true if character wise visual mode", function()
    vim.cmd([[normal! v]])
    local actual = visual_mode.is_current()
    assert.is_true(actual)
  end)

  it("returns true if line wise visual mode", function()
    vim.cmd([[normal! V]])
    local actual = visual_mode.is_current()
    assert.is_true(actual)
  end)

  it("returns true if block wise visual mode", function()
    vim.cmd([[normal! ]] .. vim.api.nvim_eval('"\\<C-v>"'))
    local actual = visual_mode.is_current()
    assert.is_true(actual)
  end)
end)

describe("visual_mode.leave()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("does nothing in normal mode", function()
    local actual = visual_mode.leave()
    assert.is_false(actual)
  end)

  it("changes to normal mode", function()
    vim.cmd([[normal! v]])

    local actual, mode = visual_mode.leave()
    assert.is_true(actual)
    assert.equal("v", mode)
    assert.equal("n", vim.api.nvim_get_mode().mode)
  end)
end)

describe("visual_mode.row_range()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns nil in normal mode", function()
    local actual = visual_mode.row_range()
    assert.is_nil(actual)
  end)

  it("returns row range in visual mode", function()
    helper.set_lines([[
1
2
3]])
    vim.cmd([[normal! V2j]])

    local actual = visual_mode.row_range()
    assert.is_same(actual, { first = 1, last = 3 })
  end)
end)
