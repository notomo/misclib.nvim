local M = {}

function M.encode(url)
  vim.validate({ url = { url, "string" } })
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w %/:.])", function(char)
    return ("%%%02X"):format(char:byte())
  end)
  url = url:gsub(" ", "+")
  return url
end

function M.decode(url)
  vim.validate({ url = { url, "string" } })
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
  return url
end

return M
