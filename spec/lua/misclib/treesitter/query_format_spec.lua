local helper = require("misclib.test.helper")
local query_format = helper.require("misclib.treesitter.query_format")
local assert = require("assertlib").typed(assert)

describe("misclib.treesitter.query_format.execute()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    { expr = [[]], want = [[]] },
    { expr = [[
(variable_list name: (identifier))
]], want = [[
(variable_list
  name: (identifier))
]] },
    {
      expr = [[
(dot_index_expression table: (identifier) field: (identifier))
]],
      want = [[
(dot_index_expression
  table: (identifier)
  field: (identifier))
]],
    },
    {
      expr = [[
(arguments (string content: (string_content)))
]],
      want = [[
(arguments
  (string
    content: (string_content)))
]],
    },
    {
      expr = [[
(expression_list value: (function_call name: (identifier) arguments: (arguments (string content: (string_content)))))
]],
      want = [[
(expression_list
  value: (function_call
    name: (identifier)
    arguments: (arguments
      (string
        content: (string_content)))))
]],
    },
  }) do
    it(("format %s"):format(vim.inspect(c.expr, { newline = " " })), function()
      local got = query_format.execute(c.expr)
      assert.equal(c.want, got)
    end)
  end
end)
