local M = {}

--- @param url string
function M.encode(url)
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w %/:.])", function(char)
    return ("%%%02X"):format(char:byte())
  end)
  url = url:gsub(" ", "+")
  return url
end

--- @param url string
function M.decode(url)
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
  return url
end

return M
