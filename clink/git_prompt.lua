local colors = {
    bold_white_on_black = "\x1b[1;37;40m",
    normal_white_on_black = "\x1b[0;37;40m",
    bold_green_on_black = "\x1b[1;32;40m",
    normal_green_on_black = "\x1b[0;32;40m",
    bold_yellow_on_black = "\x1b[1;33;40m",
    normal_yellow_on_black = "\x1b[0;33;40m",
    git_clean = "\x1b[1;37;40m",
    git_dirty = "\x1b[31;1m",
}

---
 -- Finds out the git current branch
 -- @return {false|git branch name}
---
function get_git_branch()
    for line in io.popen("git branch 2>nul"):lines() do
        local m = line:match("%* (.+)$")
        if m then
            return m
        end
    end

    return false
end

---
 -- Gets the git status of the current dir
 -- @return {bool}
---
function get_git_status()
    return os.execute("git diff --quiet --ignore-submodules HEAD 2>nul")
end

---
 -- Gets the current git status in short format
 -- @return {string}
---
function get_git_full_status()
    local file = assert(io.popen("git status -s"))
    local status = file:read('*all')
    file:close()
    return status
end

---
 -- If we are in a git directory gets the
 -- status and sets the prompt string accordingly
 -- @return {string}
---
function git_prompt(path)

    local branch = get_git_branch()
    if branch then
        -- Has branch => therefore it is a git folder, now figure out status
        if get_git_status() then
            color = colors.git_clean
        else
            color = colors.git_dirty
        end

        -- return color.."("..branch..")".."\n"..colors.normal_white_on_black..get_git_full_status()
        return color.."("..branch..")"
    end

    return ""

end

---
 -- Tries to retrieve the current path
 -- @return {string}
---
function pwd()
    local path = ""

    local file = assert(io.popen('cd'))
    local cd = file:read('*all'):match("^(.+)[\r\n]$")
    if cd then
        path = colors.normal_green_on_black .. cd .. " "
    end
    file:close()

    return path
end

function lambda_prompt_filter()
    local path = pwd()
    local git_status = git_prompt(path)
    local lambda_prompt = colors.normal_yellow_on_black .. "λ "

    clink.prompt.value = path .. git_status .. "\n" .. lambda_prompt
end

clink.prompt.register_filter(lambda_prompt_filter, 50)
