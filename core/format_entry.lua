local inspect = require"core/inspect"
local log = require"core/log"
local thes_pick = require"core/thes_pick"

local function detable(table, str, depth)
  depth = depth or 0
  str = str or ""

  for k, v in pairs(table) do
    if type(v) == "table" then
      str = str .. string.rep(".", depth) .. k .. ": {\n"
      str = detable(v, str, depth + 1) .. "}\n"
    else
      str = str .. string.rep(".", depth) .. k .. ": " .. tostring(v) .. "\n"
    end
  end

  return str
end

local format_entry = function(word)
  local json_file, errdesc, errno = io.open(Thesaurus.temp_file, "r")
  if not json_file then
    return json_file, errdesc .. "\nError opening temp file.", errno
  end

  local formatted_file_path = Thesaurus.cache_file_path_template:gsub("_WORD_", word)

  local entries = vim.json.decode(json_file:read(), {objects = true, array = true})
  local formatted_file
  formatted_file, errdesc, errno = io.open(formatted_file_path, "w")
  if not formatted_file then
    return nil, errdesc, errno
  end

  local sense_list = {}

  for i, entry in ipairs(entries) do
    sense_list[i] = {
      entry.hwi.hw .. ", " .. entry.fl .. ": " .. entry.shortdef[1],
      entry,
    }
  end

  thes_pick.sense(sense_list)

  return formatted_file, errdesc, errno
end

return format_entry
