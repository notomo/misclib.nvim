local helper = require("misclib.test.helper")
local listlib = helper.require("misclib.collection.list")

describe("list.unique()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    { name = "can use with empty list", list = {}, expected = {} },
    { name = "removes duplicated element", list = { 1, 2, 1, 3, 1, 2 }, expected = { 1, 2, 3 } },
    {
      name = "can select key by function",
      list = {
        { id = 1 },
        { id = 2 },
        { id = 1 },
        { id = 3 },
      },
      make_key = function(e)
        return e.id
      end,
      expected = {
        { id = 1 },
        { id = 2 },
        { id = 3 },
      },
    },
  }) do
    it(c.name, function()
      local actual = listlib.unique(c.list, c.make_key)
      assert.is_same(c.expected, actual)
    end)
  end
end)

describe("list.group_by_adjacent()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    { name = "can use with empty list", list = {}, expected = {} },
    {
      name = "can group list by adjacent and function",
      list = { "", "", "a", "b", "", "c" },
      make_key = function(e)
        return #e == 0 and "empty" or "not_empty"
      end,
      expected = {
        { "empty", { "", "" } },
        { "not_empty", { "a", "b" } },
        { "empty", { "" } },
        { "not_empty", { "c" } },
      },
    },
  }) do
    it(c.name, function()
      local actual = listlib.group_by_adjacent(c.list, c.make_key)
      assert.is_same(c.expected, actual)
    end)
  end
end)

describe("list.fill()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    {
      name = "returns list filled by element",
      list = { 1, 1, 1 },
      length = 5,
      element = 0,
      expected = { 1, 1, 1, 0, 0 },
    },
    {
      name = "returns the same list if already filled",
      list = { 1, 1, 1 },
      length = 3,
      element = 0,
      expected = { 1, 1, 1 },
    },
  }) do
    it(c.name, function()
      local actual = listlib.fill(c.list, c.length, c.element)
      assert.is_same(c.expected, actual)
    end)
  end
end)
