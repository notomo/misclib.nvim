local helper = require("misclib.test.helper")
local windowlib = helper.require("misclib.window")
local assert = require("assertlib").typed(assert)

describe("window.safe_close()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("closes valid window", function()
    vim.cmd.split()

    windowlib.safe_close(0)

    assert.window_count(1)
  end)

  it("does nothing with invalid window", function()
    vim.cmd.split()
    local window_id = vim.api.nvim_get_current_win()
    vim.cmd.close()

    windowlib.safe_close(window_id)

    assert.window_count(1)
  end)
end)

describe("window.safe_enter()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("enters valid window", function()
    local window_id = vim.api.nvim_open_win(0, false, {
      width = 50,
      height = 10,
      relative = "editor",
      row = 10,
      col = 10,
    })

    windowlib.safe_enter(window_id)

    assert.window_id(window_id)
  end)

  it("does nothing with invalid window", function()
    local current_window_id = vim.api.nvim_get_current_win()

    vim.cmd.split()
    local window_id = vim.api.nvim_get_current_win()
    vim.cmd.close()

    windowlib.safe_enter(window_id)

    assert.window_id(current_window_id)
  end)
end)

describe("window.is_floating()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns true if the window is floating", function()
    local window_id = vim.api.nvim_open_win(0, false, {
      width = 50,
      height = 10,
      relative = "editor",
      row = 10,
      col = 10,
    })

    local actual = windowlib.is_floating(window_id)
    assert.is_true(actual)
  end)

  it("returns false if the window is not floating", function()
    local window_id = vim.api.nvim_get_current_win()
    local actual = windowlib.is_floating(window_id)
    assert.is_false(actual)
  end)
end)

describe("window.jump()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("jumps to the position", function()
    vim.cmd.tabedit()
    local window_id = vim.api.nvim_get_current_win()
    vim.cmd.tabprevious()

    windowlib.jump(window_id, 1, 1)

    assert.window_id(window_id)
  end)
end)
