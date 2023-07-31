local M = {}

function M.group_by(list, make_key)
  local groups = {}
  vim.iter(list):each(function(element)
    local key = make_key(element)
    if not key then
      return
    end

    local elements = groups[key] or {}
    table.insert(elements, element)
    groups[key] = elements
  end)
  return groups
end

return M
