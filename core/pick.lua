local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local match_groups = function(hw, entry_group)
  for _, entry in ipairs(entry_group.value) do
    if #hw > #entry.hwi.hw then
      if hw == entry.hwi.hw .. "s" then
        return true
      end

    elseif #hw < #entry.hwi.hw then
      if hw .. "s" == entry.hwi.hw then
        return true
      end

    elseif hw == entry.hwi.hw then
      return true
    end
  end

  return false
end

local match_stems = function(hw, entry_group)
  for _, entry in ipairs(entry_group) do
    for _, stem in ipairs(entry.meta.stems) do
      if hw == stem then
        return true
      end
    end
  end

  return false
end

local match_other_hw = function(hw, entry_list)
  for i, entry_group in ipairs(entry_list) do
    for _, entry in ipairs(entry_group.value) do
      local no_dash_hw = hw:gsub("%-", " ")
      local entry_hw = entry.hwi.hw:gsub("%-", " ")

      if entry_hw == no_dash_hw then
        return i
      end
    end

    if match_stems(hw, entry_group) then
      return i
    end

    if match_groups(hw, entry_group) then
      return i
    end
  end

  return 0
end

local make_entry_list = function(entries)
  local entry_list = {}

  for _, entry in ipairs(entries) do
    local hw = entry.hwi.hw
    local match_pos = match_other_hw(hw, entry_list)

    if match_pos ~= 0 then
      table.insert(entry_list[match_pos].value, entry)

    else
      table.insert(entry_list, {
        value = {
          entry,
        },
        hw = hw,
      })
    end
  end

  return entry_list
end

local pick_entry = function(entries, type, opts)
  entries = make_entry_list(entries)

  pickers.new(opts, {
    promt_title = "Entry",
    finder = finders.new_table {
      results = entries,

      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.hw,
          ordinal = entry.hw
        }
      end
    },

    sorter = conf.generic_sorter(opts),

    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        Reference[type].format(selection)
        Reference.open()
      end)

      return true
    end,
  }):find()
end

return pick_entry
