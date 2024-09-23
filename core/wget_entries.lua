local wget_entries = function(url)
  local not_err, errdesc, errno = os.execute("wget -q -O " .. Reference.temp_file .. " " .. url)
  if not not_err then -- confusing, I know
    Reference.log.error(errdesc, errno)

    return
  end

  local entries_file
  entries_file, errdesc, errno = io.open(Reference.temp_file, "r")
  if not entries_file then
    Reference.log.error(errdesc, errno)

    return
  end

  local entries = vim.json.decode(entries_file:read(), {objects = true, array = true})
  if not entries[1].hwi then
    Reference.log.user_err("No entry for that word.")

    return
  end

  return entries
end

return wget_entries
