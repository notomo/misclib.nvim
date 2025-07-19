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
      local current_line = {}

      for child in node:iter_children() do
        local child_type = child:type()
        local formatted = format_node(child, indent)
        if formatted ~= "" then
          if child_type == "predicate" then
            table.insert(current_line, formatted)
          else
            if #current_line > 0 then
              result[#result] = result[#result] .. " " .. table.concat(current_line, " ")
              current_line = {}
            end
            table.insert(result, formatted)
          end
        end
      end

      if #current_line > 0 and #result > 0 then
        result[#result] = result[#result] .. " " .. table.concat(current_line, " ")
      end

      return table.concat(result, "\n\n")
    end

    if node_type == "named_node" then
      local name_text = ""
      local field_defs = {}
      local nested_nodes = {}
      local quantifier_text = ""
      local capture_text = ""

      for child, field_name in node:iter_children() do
        local child_type = child:type()
        if field_name == "name" and child_type == "identifier" then
          name_text = vim.treesitter.get_node_text(child, expr)
        elseif child_type == "field_definition" then
          table.insert(field_defs, child)
        elseif child_type == "named_node" then
          table.insert(nested_nodes, child)
        elseif child_type == "quantifier" then
          quantifier_text = vim.treesitter.get_node_text(child, expr)
        elseif child_type == "capture" then
          capture_text = vim.treesitter.get_node_text(child, expr)
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

      table.insert(parts, ")" .. quantifier_text .. " " .. capture_text)
      return table.concat(parts):gsub("%s+$", "")
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

    if node_type == "list" then
      local parts = {}
      table.insert(parts, string.rep(" ", indent) .. "[")

      local list_items = {}
      local trailing_content = ""

      for child in node:iter_children() do
        local child_type = child:type()
        if child_type == "named_node" then
          local formatted = format_node(child, indent + 2)
          if formatted ~= "" then
            table.insert(list_items, formatted)
          end
        elseif child_type == "capture" or child_type == "predicate_type" then
          trailing_content = " " .. vim.treesitter.get_node_text(child, expr)
        end
      end

      if #list_items > 0 then
        for _, item in ipairs(list_items) do
          table.insert(parts, "\n" .. item)
        end
        table.insert(parts, "\n" .. string.rep(" ", indent) .. "]" .. trailing_content)
      else
        table.insert(parts, "]" .. trailing_content)
      end

      return table.concat(parts)
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

    if node_type == "predicate" then
      return vim.treesitter.get_node_text(node, expr)
    end

    if node_type == "quantifier" then
      return vim.treesitter.get_node_text(node, expr)
    end

    if node_type == "anonymous_node" then
      return vim.treesitter.get_node_text(node, expr)
    end

    if node_type == "grouping" then
      return vim.treesitter.get_node_text(node, expr)
    end

    if node_type == "definition" then
      return vim.treesitter.get_node_text(node, expr)
    end

    if node_type == "comment" then
      return vim.treesitter.get_node_text(node, expr)
    end

    return vim.treesitter.get_node_text(node, expr)
  end

  local result = format_node(root_node, 0)
  return result
end

return M
