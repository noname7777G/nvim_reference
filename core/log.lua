local log = {}

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

log.str = ""

log.print = function()
  if log.str ~= "" then
    vim.notify(log.str)

  end
end

log.clear = function()
  log.str = ""
end

log.error = function(errdesc, errno)
  errdesc = errdesc or "nil"
  errno = errno or "nil"

  local f = debug.getinfo(2)

  log.str = log.str .. "ERROR:\n" .. "TIME: " .. os.date() .. "\nCALLING FUNCTION: " .. f.name .. "\nLINE: " .. f.currentline .. "\nFILE: " .. f.short_src ..  "\nERRDESC: " .. errdesc .. "\nERRNO: " .. errno .. "\n\n"

  log.print()
  log.clear()
end

log.debug = function(str, p_now)
  if not str then return end

  if type(str) == "table" then
    log.str = log.str .. "DEBUG:\n" .. detable_rec(str) .. "\n\n"
  else
    log.str = log.str .. "DEBUG:\n" .. str .. "\n\n"
  end

  if p_now then
    log.print()
    log.clear()

  end
end

log.user_err = function(str)
  log.str = log.str .. str .. "\n\n"

  log.print()
  log.clear()
end


return log
