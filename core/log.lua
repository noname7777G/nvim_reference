local log = {}

log.file_path = "./debug_log"

log.start = function()
  local old_file, errdesc, errno = io.open(log.file_path, "w+")

  if old_file then
    old_file:close()
  else
    print("log error:\n", errdesc, errno)
  end

  log.file, errdesc, errno = io.open(log.file_path, "a")
  if not log.file then
    print("log error:\n", errdesc, errno)
    return
  end
end

log.error = function(errdesc, errno)
  errdesc = errdesc or "nil"
  errno = errno or "nil"

  local log_str = "ERROR:\n" .. "TIME: " .. os.date() .. "\nCALLING FUNCTION: " .. debug.getinfo(2).name .. "\n" .. errdesc .. "\n" .. errno .. "\n\n"
  log.file:write(log_str)
end

log.debug = function(str)
  log.file:write("DEBUG:\n" .. str .. "\n\n")
end

return log
