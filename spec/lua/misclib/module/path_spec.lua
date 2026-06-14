local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("misclib.test.helper")
local module_path = require("misclib.module.path")
local assert = require("assertlib").typed(ntf.assert)

describe("module.path.detect()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    {
      file_path = "/test/path/lua/a/b/c.lua",
      want = "a.b.c",
    },
    {
      file_path = "/test/path/lua/a/b/init.lua",
      want = "a.b",
    },
    {
      file_path = "/test/path/lua/a/b/lua/c.lua",
      want = "a.b.lua.c",
    },
  }) do
    local name = ("%s -> %s"):format(c.file_path, c.want)
    it(name, function()
      local got = module_path.detect(c.file_path)
      assert.equal(c.want, got)
    end)
  end
end)
