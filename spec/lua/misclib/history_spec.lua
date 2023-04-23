local helper = require("misclib.test.helper")
local historylib = helper.require("misclib.history")

describe("historylib", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("recalls does nothing if there is no stored", function()
    local store = historylib.new("input")
    local got = store:recall(-1)
    assert.is_nil(got)
  end)

  it("can recalls backward", function()
    local store = historylib.new("input")
    store:save("1")
    store:save("2")

    do
      local got = store:recall(-1)
      assert.equal("2", got)
    end

    do
      local got = store:recall(-1)
      assert.equal("1", got)
    end
  end)

  it("can recalls forward", function()
    local store = historylib.new("input")
    store:save("1")
    store:save("2")

    do
      store:recall(-1)
      local got = store:recall(-1)
      assert.equal("1", got)
    end

    do
      local got = store:recall(1)
      assert.equal("2", got)
    end
  end)

  it("can recalls latest entry", function()
    local store = historylib.new("input")
    store:save("1")
    store:save("2")

    do
      local got = store:recall(-1, "3")
      assert.equal("2", got)
    end

    do
      local got = store:recall(1, "2")
      assert.equal("3", got)
    end

    do
      local got = store:recall(-1, "4")
      assert.equal("2", got)
    end

    do
      local got = store:recall(1, "2")
      assert.equal("4", got)
    end
  end)

  it("can recalls with filter", function()
    vim.fn.histadd("input", "1")
    vim.fn.histadd("input", "ignored1")

    local store = historylib.new("input", {
      filter = function(history)
        return #history == 1
      end,
    })
    store:save("ignored2")

    do
      local got = store:recall(-1)
      assert.equal("1", got)
    end
  end)
end)
