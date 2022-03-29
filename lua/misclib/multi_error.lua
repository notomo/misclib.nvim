local MultiError = {}
MultiError.__index = MultiError

function MultiError.new()
  local tbl = { _errs = {} }
  return setmetatable(tbl, MultiError)
end

function MultiError.add(self, err)
  table.insert(self._errs, err)
end

function MultiError.error(self)
  if #self._errs == 0 then
    return nil
  end
  return table.concat(self._errs, "\n")
end

return MultiError
