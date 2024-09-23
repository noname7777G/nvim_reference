Reference = {}

Reference.opts = {} --Reference options
Reference.opts.open_command = ":vsplit"
Reference.opts.temp_dir = ".cache/nvim/"

local home = os.getenv("HOME") --Set full paths
home = home .. "/"
Reference.cache_file = home .. Reference.opts.temp_dir .. "CURRENT_WORD"
Reference.temp_file =  home .. Reference.opts.temp_dir .. "reference_temp.json"

Reference.thesaurus = require"core/thesaurus/init" --Thesaurus data, opts, and functions
Reference.opts.thesaurus = {}
Reference.opts.thesaurus.max_words_per_line = 6
Reference.opts.thesaurus.key = ""

Reference.dictionary = require"core/dictionary/init" --Dictionary data, opts, and functions
Reference.opts.dictionary = {}
Reference.opts.dictionary.key = ""

Reference.log = require"core/log" --Debug and message functions
Reference.wget_entries = require"core/wget_entries" --Used to call MW API
Reference.filter_cword= require"core/filter_cword"
Reference.pick = require"core/pick"
Reference.open = require "core/open"
