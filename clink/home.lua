local function tilde_match (text, f, l)
    if text == '~' then
        clink.add_match(clink.get_env('userprofile'))
        clink.matches_are_files()
        return true
    end
    if text:sub(1, 1) == '~' then
        clink.add_match(string.gsub(text, "~", clink.get_env('userprofile'), 1))
        clink.suppress_char_append()
        clink.matches_are_files()
        return true
    end
end
clink.register_match_generator(tilde_match, 1)
