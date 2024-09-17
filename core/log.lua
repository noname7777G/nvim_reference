local log = {}

local inspect = require"core/inspect"

log.inspect = function(tab)
  log.debug(inspect(tab))
end

local function detable_rec(table, str, depth)
  depth = depth or 0
  str = str or ""

  for k, v in pairs(table) do
    if type(v) == "table" then
      str = str .. string.rep(".", depth) .. k .. ": {\n"
      str = detable_rec(v, str, depth + 1) .. string.rep(".", depth) .. "}\n"
    else
      str = str .. string.rep(".", depth) .. k .. ": " .. tostring(v) .. "\n"
    end
  end

  return str
end

log.detable = function(table)
  log.debug(detable_rec(table))
end

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
  local f = debug.getinfo(2)

  local log_str = "ERROR:\n" .. "TIME: " .. os.date() .. "\nCALLING FUNCTION: " .. f.name .. "\nLINE: " .. f.currentline .. "\nFILE: " .. f.short_src ..  "\nERRDESC: " .. errdesc .. "\nERRNO: " .. errno .. "\n\n"
  log.file:write(log_str)
end

log.debug = function(str)
  log.file:write("DEBUG:\n" .. str .. "\n\n")
end

return log
