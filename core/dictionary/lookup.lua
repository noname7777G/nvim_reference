local lookup = {}

local url = "https://dictionaryapi.com/api/v3/references/collegiate/json/_WORD_?key="

lookup.str = function(word)
  local formatted_url = url:gsub("_WORD_", word) .. Reference.opts.dictionary.key
  local entries = Reference.wget_entries(formatted_url)

  if not entries then
    return
  end

  Reference.pick(entries, "dictionary")

  Reference.log.print()
  Reference.log.clear()
end

lookup.cword = function()
  local word = Reference.filter_cword()
  lookup.str(word)

end

return lookup
