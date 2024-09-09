local helper = require("misclib.test.helper")
local cursorlib = helper.require("misclib.cursor")
local assert = require("assertlib").typed(assert)

describe("cursorlib.to_bottom()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can set cursor position to the bottom in the current window", function()
    helper.set_lines([[


bottom]])

    cursorlib.to_bottom()

    assert.current_line("bottom")
  end)

  it("can set cursor position to the bottom in the specified window", function()
    vim.cmd.split()
    local window_id = vim.api.nvim_get_current_win()
    helper.set_lines([[


bottom]])
    vim.cmd.wincmd("p")

    cursorlib.to_bottom(window_id)

    vim.cmd.wincmd("p")
    assert.current_line("bottom")
  end)
end)

describe("cursorlib.set_column()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("sets cursor column", function()
    helper.set_lines([[

12345

]])
    vim.cmd.normal({ args = { "j" }, bang = true })

    cursorlib.set_column(3)

    assert.same({ 2, 3 }, vim.api.nvim_win_get_cursor(0))
  end)

  it("can set column greater than column end", function()
    helper.set_lines([[

12345

]])
    vim.cmd.normal({ args = { "j" }, bang = true })

    cursorlib.set_column(10)

    assert.same({ 2, 4 }, vim.api.nvim_win_get_cursor(0))
  end)
end)

describe("cursorlib.set()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("sets cursor position", function()
    helper.set_lines([[

1234

]])

    cursorlib.set({ 2, 3 })

    assert.same({ 2, 3 }, vim.api.nvim_win_get_cursor(0))
  end)

  it("sets cursor position even if the row does not exist", function()
    helper.set_lines([[

1234]])

    cursorlib.set({ 10, 3 })

    assert.same({ 2, 3 }, vim.api.nvim_win_get_cursor(0))
  end)
end)
