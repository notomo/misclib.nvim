local helper = require("misclib.test.helper")
local assert = require("assertlib").typed(assert)

describe("ordered_dict", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    { items = {}, expected = {} },
    { items = { { key = "a", value = 1 } }, expected = { { key = "a", value = 1 } } },
    { items = { { key = "a", value = 1 }, { key = "a", value = 2 } }, expected = { { key = "a", value = 2 } } },
    {
      items = { { key = "a", value = 1 }, { key = "b", value = 1 }, { key = "a", value = 2 } },
      expected = { { key = "a", value = 2 }, { key = "b", value = 1 } },
    },
    { items = { { key = "a", value = 1 }, { key = "a", value = nil } }, expected = {} },
  }) do
    it(
      ("OrderedDict.new(%s):raw() == %s"):format(
        vim.inspect(c.items, { indent = "", newline = " " }),
        vim.inspect(c.expected, {
          indent = "",
          newline = " ",
        })
      ),
      function()
        local dict = require("misclib.collection.ordered_dict").new()
        for _, item in ipairs(c.items) do
          dict[item.key] = item.value
        end
        local actual = dict:raw()
        assert.same(c.expected, actual)
      end
    )
  end
end)
