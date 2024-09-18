local format_wvrs = function(wvrs)
  local str = "(" .. wvrs[1].wvl .. ": " .. wvrs[1].wva
  table.remove(wvrs, 1)
  if not wvrs[1] then
    str = str .. ")"
  end

  for i, alt in ipairs(wvrs) do
    if wvrs[i + 1] then
      str = str .. ", " .. alt.wva
    else
      str = str .. ", " .. alt.wvl .. alt.wva .. ")"
    end
  end
  return str
end

local format_wvbvrs = function(wvbvrs)
  local str = "(" .. wvbvrs[1].wvbvl .. ": " .. wvbvrs[1].wvbva
  table.remove(wvbvrs, 1)
  if not wvbvrs[1] then
    return str .. ")"
  end

  for i, alt in ipairs(wvbvrs) do
    if wvbvrs[i + 1] then
      str = str .. ", " .. alt.wvbva
    else
      str = str .. ", " .. alt.wvbvl .. alt.wvbva .. ")"
    end
  end
  return str
end

local format_wsls = function(wsls)
  local str = " [" .. wsls[1]
  table.remove(wsls, 1)
  if not wsls[1] then
    return str .. "]"
  end

  for _, wsl in ipairs(wsls) do
    str = str .. ", " .. wsl
  end

  return str .. "]"
end

local format_word_list = function(list, title)
  local str = "\t" .. title .. ":\n"

  for _, syn_grp in ipairs(list) do
    local sub_str = ""

    for i, syn in ipairs(syn_grp) do
      local alts_str = ""

      if syn.wvrs then
        alts_str = " " .. format_wvrs(syn.wvrs)
      elseif syn.wvbvrs then
        alts_str = " " .. format_wvbvrs(syn.wvbvrs)
      end

      if syn.wsls then
        alts_str = alts_str .. format_wsls(syn.wsls)
      end

      if syn_grp[i + 1] then
        sub_str = sub_str .. syn.wd .. alts_str .. ", "

        if math.fmod(i, Reference.opts.thesaurus.max_words_per_line) == 5 then
          sub_str = sub_str .. "\n\t\t"
        end

      else
        sub_str = sub_str .. syn.wd .. alts_str .. "\n"
      end
    end
    str = str .. "\t\t" .. sub_str .. "\n"
  end

  return str .. "\n"
end

local format_entry = function(entry)
  entry = entry.value[2]

  local formatted_file, errdesc, errno = io.open(Reference.cache_file, "w")
  if not formatted_file then
    Log.error(errdesc, errno)
    return nil
  end

  local offensive = ""
  if entry.meta.offensive then
    offensive = ", offensive"
  end
  formatted_file:write(entry.hwi.hw .. ", " .. entry.fl .. offensive .. "\n\nOther forms:\n")

  local stems = ""
  local cnt = 1
  for _, stem in ipairs(entry.meta.stems) do
    if stem ~= entry.hwi.hw then
      stems = stems .. cnt .. ": " .. stem .. "\n"
      cnt = cnt + 1
    end
  end
  formatted_file:write(stems .. "\nSenses:\n")

  for i, sense in ipairs(entry.def[1].sseq) do
    sense = sense[1][2]
    local str = i .. ": " .. sense.dt[1][2] .. "\n"

    if sense.dt[2] then
      str = str .. "\tExample: " .. sense.dt[2][2][1].t .. "\n\n"
    end

    if sense.syn_list then
      str = str .. format_word_list(sense.syn_list, "Synonyms")
    end

    if sense.sim_list then
      str = str .. format_word_list(sense.sim_list, "Similar words")
    end

    if sense.rel_list then
      str = str ..  format_word_list(sense.rel_list, "Related words")
    end

    if sense.phrase_list then
      str = str .. format_word_list(sense.phrase_list, "Synonymous phrases")
    end

    if sense.opp_list then
      str = str .. format_word_list(sense.opp_list, "Opposite words")
    end

    if sense.ant_list then
      str = str .. format_word_list(sense.ant_list, "Antonyms")
    end

    if sense.near_list then
      str = str .. format_word_list(sense.near_list, "Near antonyms")
    end

    formatted_file:write(str)
  end

  formatted_file:close()
  vim.api.nvim_exec(Reference.opts.open_command .. Reference.cache_file, false)
end

return format_entry
