local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local format_entry = require"core/format_entry"

local log = require"core/log"

local make_entry_list = function(entries_file)
  local entries = vim.json.decode(entries_file:read(), {objects = true, array = true})
  if not entries[1].hwi then
    log.user_err("No entry for that word.")
    return nil
  end

  local entry_list = {}

  for i, entry in ipairs(entries) do
    entry_list[i] = {
      entry.hwi.hw .. ", " .. entry.fl,
      entry,
      entry.hwi.hw,
    }
  end

  return entry_list
end

local pick_entry = function(entries_file, opts)
  local entry_list = make_entry_list(entries_file)
  if not entry_list then
    return
  end

  pickers.new(opts, {
    promt_title = "Entry",
    finder = finders.new_table {
      results = entry_list,

      entry_maker = function(entry)
        return {
        value = entry,
        display = entry[1],
        ordinal = entry[3],
        }
      end
      },

    sorter = conf.generic_sorter(opts),

    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        format_entry(selection)
      end)
      return true
    end,

  }):find()
end

return pick_entry
