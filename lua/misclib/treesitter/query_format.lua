local M = {}

function M.execute(expr)
  if expr == "" then
    return ""
  end

  local root_node = require("misclib.treesitter").get_first_tree_root(expr, "query")
  if type(root_node) == "string" then
    error(root_node)
  end

  local function format_node(node, indent)
    local node_type = node:type()

    if node_type == "program" then
      local result = {}
      for child in node:iter_children() do
        local formatted = format_node(child, indent)
        if formatted ~= "" then
          table.insert(result, formatted)
        end
      end
      return table.concat(result, "\n")
    end

    if node_type == "named_node" then
      local name_text = ""
      local field_defs = {}
      local nested_nodes = {}

      for child, field_name in node:iter_children() do
        local child_type = child:type()
        if field_name == "name" and child_type == "identifier" then
          name_text = vim.treesitter.get_node_text(child, expr)
        elseif child_type == "field_definition" then
          table.insert(field_defs, child)
        elseif child_type == "named_node" then
          table.insert(nested_nodes, child)
        end
      end

      if name_text == "" then
        return ""
      end

      local parts = {}
      table.insert(parts, string.rep(" ", indent) .. "(" .. name_text)

      -- まず nested nodes を処理
      for _, nested in ipairs(nested_nodes) do
        local nested_formatted = format_node(nested, indent + 2)
        if nested_formatted ~= "" then
          table.insert(parts, "\n" .. nested_formatted)
        end
      end

      -- 次に field definitions を処理
      for _, field_def in ipairs(field_defs) do
        local field_formatted = format_node(field_def, indent + 2)
        if field_formatted ~= "" then
          table.insert(parts, "\n" .. string.rep(" ", indent + 2) .. field_formatted)
        end
      end

      table.insert(parts, ")")
      return table.concat(parts)
    end

    if node_type == "field_definition" then
      local field_name = ""
      local field_value = nil

      for child, fname in node:iter_children() do
        local child_type = child:type()
        if fname == "name" and child_type == "identifier" then
          field_name = vim.treesitter.get_node_text(child, expr)
        elseif child_type == "named_node" then
          field_value = child
        end
      end

      if field_name ~= "" and field_value then
        local value_formatted = format_node(field_value, indent)
        local lines = vim.split(value_formatted, "\n")
        if #lines > 1 then
          local first_line = lines[1]:gsub("^%s*", "")
          local remaining_lines = {}
          for i = 2, #lines do
            table.insert(remaining_lines, lines[i])
          end
          return field_name .. ": " .. first_line .. "\n" .. table.concat(remaining_lines, "\n")
        else
          return field_name .. ": " .. value_formatted:gsub("^%s*", "")
        end
      end
      return ""
    end

    if
      node_type == "identifier"
      or node_type == "string"
      or node_type == "string_content"
      or node_type == "predicate_type"
      or node_type == "parameters"
      or node_type == "capture"
    then
      return vim.treesitter.get_node_text(node, expr)
    end

    return ""
  end

  local result = format_node(root_node, 0)

  if result:sub(-1) ~= "\n" and result ~= "" then
    result = result .. "\n"
  end

  return result
end

return M
