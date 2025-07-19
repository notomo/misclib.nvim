local helper = require("misclib.test.helper")
local query_format = helper.require("misclib.treesitter.query_format")
local assert = require("assertlib").typed(assert)

describe("misclib.treesitter.query_format.execute()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    { expr = [[]], want = [[]] },
    {
      expr = [[
(variable_list name: (identifier))]],
      want = [[
(variable_list
  name: (identifier))]],
    },
    {
      expr = [[
[(do_statement) (while_statement)] @fold]],
      want = [[
[
  (do_statement)
  (while_statement)
] @fold]],
    },
    {
      expr = [[
(dot_index_expression table: (identifier) field: (identifier))]],
      want = [[
(dot_index_expression
  table: (identifier)
  field: (identifier))]],
    },
    {
      expr = [[
(arguments (string content: (string_content)))]],
      want = [[
(arguments
  (string
    content: (string_content)))]],
    },
    {
      expr = [[
(expression_list value: (function_call name: (identifier) arguments: (arguments (string content: (string_content)))))]],
      want = [[
(expression_list
  value: (function_call
    name: (identifier)
    arguments: (arguments
      (string
        content: (string_content)))))]],
    },
    {
      expr = [[(test)* @capture]],
      want = [[(test)* @capture]],
    },
    {
      expr = [[(test) @capture (#eq? @capture "value")]],
      want = [[(test) @capture (#eq? @capture "value")]],
    },
    {
      expr = [[(test) @capture (#eq? @capture "value") (#not-eq? @capture "other")]],
      want = [[(test) @capture (#eq? @capture "value") (#not-eq? @capture "other")]],
    },
    {
      expr = [["literal"]],
      want = [["literal"]],
    },
    {
      expr = [[(test (nested)?)]],
      want = [[(test
  (nested)?)]],
    },
    {
      expr = [[(test1) (test2)]],
      want = [[(test1)

(test2)]],
    },
    {
      expr = [[(test1) @capture (#eq? @capture "value")
(test2) @other]],
      want = [[(test1) @capture (#eq? @capture "value")

(test2) @other]],
    },
    {
      expr = [[[")" "+"] @indent.end]],
      want = [[[
  ")"
  "+"
] @indent.end]],
    },
    {
      expr = [[(ERROR "(") @indent.begin]],
      want = [[(ERROR
  "(") @indent.begin]],
    },
    {
      expr = [[; test
; test
(test)]],
      want = [[; test
; test
(test)]],
    },
    {
      expr = [[(test)

; comment1
; comment2
(test2)]],
      want = [[(test)

; comment1
; comment2
(test2)]],
    },
  }) do
    it(("format %s"):format(vim.inspect(c.expr, { newline = " " })), function()
      local got = query_format.execute(c.expr)
      assert.equal(c.want, got)
    end)
  end
end)
