local helper = require("misclib.test.helper")
local tablelib = helper.require("misclib.collection.table")
local assert = require("assertlib").typed(assert)

describe("tablelib.group_by()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    {
      name = "can use with empty list",
      list = {},
      expected = {},
    },
    {
      name = "make grouped table",
      list = {
        { id = 1, name = "a" },
        { id = 2, name = "b" },
        { id = 3, name = "a" },
        { id = 4, name = "c" },
      },
      make_key = function(e)
        return e.name
      end,
      expected = {
        a = {
          { id = 1, name = "a" },
          { id = 3, name = "a" },
        },
        b = {
          { id = 2, name = "b" },
        },
        c = {
          { id = 4, name = "c" },
        },
      },
    },
  }) do
    it(c.name, function()
      local actual = tablelib.group_by(c.list, c.make_key)
      assert.same(c.expected, actual)
    end)
  end
end)
