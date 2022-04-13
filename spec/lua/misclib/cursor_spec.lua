local helper = require("misclib.test.helper")
local cursorlib = helper.require("misclib.cursor")

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
    vim.cmd([[split]])
    local window_id = vim.api.nvim_get_current_win()
    helper.set_lines([[


bottom]])
    vim.cmd([[wincmd p]])

    cursorlib.to_bottom(window_id)

    vim.cmd([[wincmd p]])
    assert.current_line("bottom")
  end)
end)

describe("cursorlib.set_column()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("sets cursor column", function()
    helper.set_lines([[

1234

]])
    vim.cmd([[normal! j]])

    cursorlib.set_column(3)

    assert.same({ 2, 3 }, vim.api.nvim_win_get_cursor(0))
  end)
end)
