require"core/log"

Reference = {}

Reference.thesaurus = require"core/thesaurus/t"
Reference.dictionary = require"core/dictionary/d"

Reference.opts = {}
Reference.opts.open_command = ":vsplit "
Reference.opts.temp_dir = "/.cache/nvim/thesaurus/"

Reference.opts.thesaurus = {}
Reference.opts.thesaurus.max_words_per_line = 6
Reference.opts.thesaurus.key = ""

Reference.opts.dictionary = {}
Reference.opts.dictionary.key = ""

Reference.home = os.getenv("HOME")

Reference.cache_file = Reference.home .. Reference.opts.temp_dir .. "CURRENT_WORD"
Reference.temp_file =  Reference.home .. Reference.opts.temp_dir .. "JSONJSONJSON"

Reference.wget_entries = function(word, url)
  local not_err, errdesc, errno = os.execute("wget -q -O " .. Reference.temp_file .. " " .. url:gsub("_WORD_", word) .. Reference.opts.thesaurus.key)

  if not not_err then -- confusing, I know
    Log.error(errdesc, errno)
    return nil
  end

  local entries_file
  entries_file, errdesc, errno = io.open(Reference.temp_file, "r")

  if not entries_file then
    Log.error(errdesc, errno)
    return nil
  end

  return entries_file
end

Reference.pick_entry = require"core/pick"
