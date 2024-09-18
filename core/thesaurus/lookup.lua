local lookup = {}

local url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/_WORD_?key="

lookup.str = function(word)
  local entries_file = Reference.wget_entries(word, url)

  if not entries_file then
    return
  end

  Reference.pick_entry(entries_file, "t")
  Log.print()
  Log.clear()
end

lookup.cword = function()
  local word = vim.fn.expand("<cword>")
  lookup.str(word)

end

return lookup
