local format_header = function(entry, formatted_file)

end

local format_body = function(entries)
  local formatted_file, errdesc, errno = io.open(Reference.cache_file, "w")
  if not formatted_file then
    Reference.log.error(errdesc, errno)
    return
  end

  for _, entry in ipairs(entries.value) do
    format_header(entry, formatted_file)
  end

  formatted_file:close()
  Reference.open()
end

return format_body
