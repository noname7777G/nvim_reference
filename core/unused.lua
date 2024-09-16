local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local pick_syn = function(syn_list, opts, old_word)
  pickers.new(opts, {
    promt_title = "Synonym",
    finder = finders.new_table {
      results = syn_list
    },

    sorter = conf.generic_sorter(opts),

attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local filtered_word = selection[1]:gsub("%s*", ""):gsub("%(.*%)", "")
        vim.cmd(":.s/\\<" .. old_word .. "\\>/" .. filtered_word .. " / 1")
        vim.cmd("nohlsearch")
      end)
      return true
    end,

  }):find()
end



local function get_fields_rec(json, key, fields)
  fields = fields or {}

  for k, v in pairs(json) do
    if k == key then
      fields[#fields + 1] = v
    elseif type(v) == "table" then
      fields = get_fields_rec(v, key, fields)
    end
  end
  return fields
end
