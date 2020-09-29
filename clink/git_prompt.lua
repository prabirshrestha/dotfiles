-- bases on Cmder's boot script: https://github.com/cmderdev/cmder/blob/master/config/cmder.lua

local settings = {
    color_vsc_unknown = "\x1b[30;1m",
    color_vsc_clean = "\x1b[1;37;40m",
    color_vsc_dirty = "\x1b[31;1m",
    color_lambda = "\x1b[1;30;40m",
    color_console = "\x1b[0m",
    benchmark = false,
}

profile_settings = {
    extension_npm_cache = 1,
    extension_npm = 1
}

function interp(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

---
 -- Resolves closest directory location for specified directory.
 -- Navigates subsequently up one level and tries to find specified directory
 -- @param  {string} path    Path to directory will be checked. If not provided
 --                          current directory will be used
 -- @param  {string} dirname Directory name to search for
 -- @return {string} Path to specified directory or nil if such dir not found

local function get_dir_contains(path, dirname)

    -- return parent path for specified entry (either file or directory)
    local function pathname(path)
        local prefix = ""
        local i = path:find("[\\/:][^\\/:]*$")
        if i then
            prefix = path:sub(1, i-1)
        end
        return prefix
    end

    -- Navigates up one level
    local function up_one_level(path)
        if path == nil then path = '.' end
        if path == '.' then path = clink.get_cwd() end
        return pathname(path)
    end

    -- Checks if provided directory contains git directory
    local function has_specified_dir(path, specified_dir)
        if path == nil then path = '.' end
        local found_dirs = clink.find_dirs(path..'/'..specified_dir)
        if #found_dirs > 0 then return true end
        return false
    end

    -- Set default path to current directory
    if path == nil then path = '.' end

    -- If we're already have .git directory here, then return current path
    if has_specified_dir(path, dirname) then
        return path..'/'..dirname
    else
        -- Otherwise go up one level and make a recursive call
        local parent_path = up_one_level(path)
        if parent_path == path then
            return nil
        else
            return get_dir_contains(parent_path, dirname)
        end
    end
end

local function get_git_dir(path)
    return get_dir_contains(path, '.git')
end

---
 -- Find out current branch
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
 -- Get the status of working dir
 -- @return {bool}
---
function get_git_status()
    return os.execute("git diff --quiet --ignore-submodules HEAD 2>nul")
end


function git_prompt_filter()
    if get_git_dir() then
        local branch = get_git_branch()
        if branch then
            if get_git_status() then
                color = settings.color_vsc_clean
            else
                color = settings.color_vsc_dirty
            end

            clink.prompt.value = clink.prompt.value .. color.." ["..branch.."]"
            return false
        end
    end
    return false
end

function add_modules(path) 
    local completions_dir = path
    for _,lua_module in ipairs(clink.find_files(completions_dir..'*.lua')) do
        -- Skip files that starts with _. This could be useful if some files should be ignored

        if profile_settings["extension_" .. lua_module:match[[(.*).lua$]]] ~= -1 then 
            if not string.match(lua_module, '^_.*') then
                local filename = completions_dir..lua_module
                -- use dofile instead of require because require caches loaded modules
                -- so config reloading using Alt-Q won't reload updated modules.
                dofile(filename)
            end
        end
    end
end

function main_prompt_decorator()
    clink.prompt.value = interp("${old}\n${lambda} ${color_console}", {
            old = clink.prompt.value,
            lambda = "➥",
            color_lambda = settings.color_lambda,
            color_console = settings.color_console,
        })
end

function benchmark_call(f_name, ...)
    if settings.benchmark then
        local time = os.clock()
        local result = _G[f_name](arg)
        print(f_name .. " : " .. (os.clock() - time))
    else
        local result = _G[f_name](arg)
    end
    return result

end


clink.prompt.register_filter(function() benchmark_call("main_prompt_decorator") end, 60)
clink.prompt.register_filter(function() benchmark_call("git_prompt_filter") end, 50)

local script_dir = debug.getinfo(1, "S").source:match[[^@?(.*[\/])[^\/]-$]]
add_modules(script_dir .. "clink-completions/")
