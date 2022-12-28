local M = {}

function M.group_by(list, make_key)
  local groups = {}
  for _, element in ipairs(list) do
    local key = make_key(element)
    if not key then
      goto continue
    end

    local elements = groups[key] or {}
    table.insert(elements, element)
    groups[key] = elements

    ::continue::
  end
  return groups
end

return M
