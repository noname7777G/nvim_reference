local get_words = function()
  local ret = ""

  if vim.fn.mode() == "v" then
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")
    local line_start = vstart[2]
    local line_end = vend[2]
    ret = vim.fn.getline(line_start,line_end)
    ret = ret:gsub(" ", [[%20]])

  elseif vim.fn.mode() == "n" then
    ret = vim.fn.expand("<cword>")
    ret = ret:gsub("_", [[%20]])

  else
    Reference.log.user_err("please ensure you are in visual or normal mode")
    return

  end

  return ret
end

return get_words
