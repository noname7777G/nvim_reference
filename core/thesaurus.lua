local inspect = require"core/inspect"
local log = require"core/log"
local format_entry = require"core/format_entry"

log.start()

local p_inspect = function(tab)
  log.debug(inspect(tab))
end

Thesaurus = {}
Thesaurus.opts = {}

Thesaurus.opts.key = ""
Thesaurus.opts.cache_words = true

local home = os.getenv("HOME")
local url = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/_WORD_?key="

Thesaurus.cache_file_path_template = home .. (Thesaurus.opts.cache_file_path or "/.cache/nvim/thesaurus") .. "/_WORD_"
Thesaurus.temp_file =  home .. (Thesaurus.opts.temp_file or "/.cache/nvim/thesaurus/temp")

local wget_entry = function(word)
  local command = "wget -q -O " .. Thesaurus.temp_file .. " " .. Thesaurus.opts.key
  local not_err, errdesc, errno = os.execute(command)

  if not not_err then -- confusing, I know
    return nil, errdesc, errno
  end

  return format_entry(word)
end

local get_word_files = function(word)
  local word_file, errdesc, errno

  if Thesaurus.opts.cache_words then
    local path = Thesaurus.cache_file_path_template:gsub("_WORD_", word)
    word_file, errdesc, errno = io.open(path, "r")

    if errno == 2 then
      word_file, errdesc, errno = wget_entry(word)

    elseif not word_file then
      log.error(errdesc .. "\nError reading cache, downloading from web.", errno)
      word_file, errdesc, errno = wget_entry(word)

    end
  else

    word_file, errdesc, errno = wget_entry(word)
  end

  return word_file, errdesc, errno
end

Thesaurus.lookup = function(word)
  local word_file, errdesc, errno = get_word_files(word)

  if not word_file then
    log.error(errdesc, errno)
    return
  end

end

Thesaurus.lookup_cword = function()
  local word = vim.fn.expand("<cword>")
  Thesaurus.lookup(word)

end

return Thesaurus
