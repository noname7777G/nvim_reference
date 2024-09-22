require"core/reference"

Reference.opts.thesaurus.key = "you can definitely see me"
Reference.opts.dictionary.key = "" -- dictionary functionality to come.

vim.keymap.set('n', "<leader>tl", Reference.thesaurus.lookup.cword)

-- Defaults are set in reference.lua, here they are:
Reference.opts.open_command = ":vsplit" --Command used to open the formatted file
Reference.opts.temp_dir = ".cache/nvim/" --Relative to $HOME
Reference.opts.thesaurus.max_words_per_line = 6 --Some thesaurus word lists are really long,
                                                --I have considered having the plugin enable linewrapping
                                                --but I do not think it is possible to do this in a single buffer.


Reference.thesaurus.lookup.str("test")

--TODO
--Create Referece.dictionary functions and data, including a format_entry function.
--Make it so that calling lookup.cword() gets the word under the cursor between underscores.
  --ie if the cursor is over "test" in "test_var_name", only the word "test" would be selected.
  --Might be worth making this work for CamelCase as well.
