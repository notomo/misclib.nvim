local helper = require("misclib.test.helper")
local bufferlib = helper.require("misclib.buffer")
local assert = require("assertlib").typed(assert)

describe("buffer.delete_by_name()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("deletes if the named buffer exists", function()
    local name = "test://test"
    vim.cmd.new(name)

    bufferlib.delete_by_name(name)

    assert.window_count(1)
  end)

  it("does not raise error if the named buffer does not exist", function()
    bufferlib.delete_by_name("not_found")
  end)
end)

describe("buffer.find()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("return bufnr that exactly matched with path", function()
    local path = helper.test_data:create_file("hoge")
    vim.cmd.edit(path)
    local bufnr = vim.api.nvim_get_current_buf()

    local got = bufferlib.find(path)
    assert.equal(got, bufnr)
  end)

  it("can find even if the buffer path include special characters", function()
    local path = helper.test_data:create_file("[test]?{}*.,~")
    vim.cmd.edit(path)
    local bufnr = vim.api.nvim_get_current_buf()

    local got = bufferlib.find(path)
    assert.equal(got, bufnr)
  end)
end)
