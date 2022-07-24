local helper = require("misclib.test.helper")
local bufferlib = helper.require("misclib.buffer")

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

describe("buffer.set_lines_as_modifiable()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("sets lines event if the buffer is not modifiable", function()
    vim.bo.modifiable = false

    bufferlib.set_lines_as_modifiable(0, 0, -1, false, { "test" })

    assert.current_line("test")
  end)
end)
