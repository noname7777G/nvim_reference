local pick_entry = require"core/pick"

local log = require"core/log"

log.start()

Thesaurus = {}
Thesaurus.opts = {}

Thesaurus.opts.key = ""
Thesaurus.opts.cache_words = true

Thesaurus.home = os.getenv("HOME")
Thesaurus.url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/_WORD_?key="

Thesaurus.cache_file_path_template = Thesaurus.home .. (Thesaurus.opts.cache_file_path or "/.cache/nvim/thesaurus") .. "/_WORD_"
Thesaurus.temp_file =  Thesaurus.home .. (Thesaurus.opts.temp_file or "/.cache/nvim/thesaurus/temp")

Thesaurus.current_entry_file_path = "" --fucking callbacks

local wget_entries = function(word)
  local not_err, errdesc, errno = os.execute("wget -q -O " .. Thesaurus.temp_file .. " " .. Thesaurus.url:gsub("_WORD_", word) .. Thesaurus.opts.key)

  if not not_err then -- confusing, I know
    log.error(errdesc, errno)
    return nil
  end

  local entries_file
  entries_file, errdesc, errno = io.open(Thesaurus.temp_file, "r")

  if not entries_file then
    log.error(errdesc, errno)
    return nil
  end

  return entries_file
end

Thesaurus.lookup = function(word)
  local entries_file = wget_entries(word)

  if not entries_file then
    return
  end

  pick_entry(entries_file)
end

Thesaurus.lookup_cword = function()
  local word = vim.fn.expand("<cword>")
  Thesaurus.lookup(word)

end

return Thesaurus
