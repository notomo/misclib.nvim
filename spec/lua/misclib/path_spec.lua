local helper = require("misclib.test.helper")
local pathlib = helper.require("misclib.path")

describe("pathlib.join", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    {
      elements = { "a" },
      want = "a",
    },
    {
      elements = { "a", "b", "c" },
      want = "a/b/c",
    },
    {
      elements = { "a", "b/", "c/" },
      want = "a/b/c/",
    },
  }) do
    local args = vim.inspect(c.elements, { indent = "", newline = "" })
    local name = ([[(unpack(%s)) == "%s"]]):format(args, c.want)
    it(name, function()
      local actual = pathlib.join(unpack(c.elements))
      assert.is_same(c.want, actual)
    end)
  end
end)

describe("pathlib.parent", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    {
      path = "/",
      want = "/",
    },
    {
      path = "a/b",
      want = "a/",
    },
    {
      path = "a/b/",
      want = "a/",
    },
  }) do
    local name = ([[("%s") == "%s"]]):format(c.path, c.want)
    it(name, function()
      local actual = pathlib.parent(c.path)
      assert.is_same(c.want, actual)
    end)
  end
end)

describe("pathlib.tail", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    {
      path = "/",
      want = "/",
    },
    {
      path = "a",
      want = "a",
    },
    {
      path = "a/b",
      want = "b",
    },
    {
      path = "a/b/",
      want = "b/",
    },
  }) do
    local name = ([[("%s") == "%s"]]):format(c.path, c.want)
    it(name, function()
      local actual = pathlib.tail(c.path)
      assert.is_same(c.want, actual)
    end)
  end
end)

describe("pathlib.trim_slash", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    {
      path = "/",
      want = "/",
    },
    {
      path = "a/",
      want = "a",
    },
    {
      path = "a",
      want = "a",
    },
  }) do
    local name = ([[("%s") == "%s"]]):format(c.path, c.want)
    it(name, function()
      local actual = pathlib.trim_slash(c.path)
      assert.is_same(c.want, actual)
    end)
  end
end)
