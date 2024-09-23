local get_words = function()
  local ret = ""

  if vim.fn.mode() == "v" then
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")
    ret = vim.fn.getline(vstart[2], vend[2])
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
