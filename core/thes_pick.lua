local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local log = require"core/log"
local inspect = require"core/inspect"

local thes_pick = {}

thes_pick.sense = function(sense_list, opts, old_word)
  pickers.new(opts, {
    promt_title = "Sense",
    finder = finders.new_table {
      results = sense_list,

      entry_maker = function(entry)
        return {
        value = entry,
        display = entry[1],
        ordinal = entry[1],
        }
      end
      },

    sorter = conf.generic_sorter(opts),

    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
          log.debug(inspect(selection))
      end)
      return true
    end,

  }):find()
end

return thes_pick
