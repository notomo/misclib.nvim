local M = {}

local function get_indent(depth)
  return string.rep("  ", depth)
end

local function add_newline_with_indent(result, depth)
  return result .. "\n" .. get_indent(depth)
end

local function process_opening_paren(result, depth)
  if depth > 0 then
    result = add_newline_with_indent(result, depth)
  end
  return result .. "(", depth + 1
end

local function process_closing_paren(result, depth)
  return result .. ")", depth - 1
end

local function process_space(result, expr, i, depth)
  local next_char = expr:sub(i + 1, i + 1)
  if next_char == "(" then
    return add_newline_with_indent(result, depth)
  end
  if expr:sub(i + 1):match("^(%w+):") then
    return add_newline_with_indent(result, depth)
  end
  return result .. " "
end

local function normalize_spacing(result)
  result = result:gsub("(%w+):%s*\n%s*(%b())", "%1: %2")
  result = result:gsub("(%w+:)%s*\n%s*([^(])", "%1 %2")
  result = result:gsub("\n%s*\n", "\n")
  result = result:gsub("(%w+):%s%s+", "%1: ")
  return result
end

function M.execute(expr)
  local result = ""
  local depth = 0
  local i = 1

  while i <= #expr do
    local char = expr:sub(i, i)

    if char == "(" then
      result, depth = process_opening_paren(result, depth)
    elseif char == ")" then
      result, depth = process_closing_paren(result, depth)
    elseif char == " " then
      result = process_space(result, expr, i, depth)
    else
      result = result .. char
    end

    i = i + 1
  end

  return normalize_spacing(result)
end

return M
