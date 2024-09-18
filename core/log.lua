Log = {}

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

Log.detable = function(table)
  Log.debug(detable_rec(table))
end

Log.str = ""

Log.error = function(errdesc, errno)
  errdesc = errdesc or "nil"
  errno = errno or "nil"
  local f = debug.getinfo(2)

  Log.str = Log.str .. "ERROR:\n" .. "TIME: " .. os.date() .. "\nCALLING FUNCTION: " .. f.name .. "\nLINE: " .. f.currentline .. "\nFILE: " .. f.short_src ..  "\nERRDESC: " .. errdesc .. "\nERRNO: " .. errno .. "\n\n"
end

Log.debug = function(str)
  str = str or "nil"
  Log.str = Log.str .. "DEBUG:\n" .. str .. "\n\n"
end

Log.user_err = function(str)
  Log.str = Log.str .. str .. "\n\n"
end

Log.print = function()
  if Log.str ~= "" then
    vim.notify(Log.str)
  end
end

Log.clear = function()
  Log.str = ""
end
