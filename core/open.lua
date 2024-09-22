local open = function()
  vim.api.nvim_exec(Reference.opts.open_command .. " " .. Reference.cache_file, false)
end

return open
