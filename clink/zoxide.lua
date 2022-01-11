-- =============================================================================
--
-- Settings copied from 'zoxide init'. Run `clink set` to modify these options, e.g. `clink set zoxide.cmd f`
--

settings.add('zoxide.cmd', 'z', 'Changes the prefix of the aliases')
settings.add('zoxide.hook', { 'pwd', 'prompt', 'none' }, 'Changes when directory scores are incremented')
settings.add('zoxide.no_aliases', false, "Don't define aliases")

-- =============================================================================
--
-- Utility functions for zoxide.
--

-- Generate `cd` command
local function __zoxide_cd(dir)
  if os.getenv '_ZO_ECHO' == '1' then
    print(dir)
  end

  -- 'cd /d -' doesn't work for clink versions before v1.2.41 (https://github.com/chrisant996/clink/issues/191)
  -- lastest cmder release (v1.3.18) uses clink v1.1.45
  if dir == '-' and (clink.version_encoded or 0) < 10020042 then
    return 'cd -'
  end

  return 'cd /d ' .. dir
end

-- Run `zoxide query` and generate `cd` command from result
local function __zoxide_query(options, keywords)
  options = table.concat(options, ' ')
  keywords = table.concat(keywords, ' ')

  local file = io.popen('zoxide query ' .. options .. ' -- ' .. keywords)
  local result = file:read '*line'
  local ok = file:close()

  if ok then
    return __zoxide_cd(result)
  else
    return 'call' -- no-op that just sets %ERRORLEVEL% to 1
  end
end

-- Add directory to the database.
local function __zoxide_add(dir)
  os.execute('zoxide add -- "' .. dir .. '"')
end

-- =============================================================================
--
-- Hook configuration for zoxide.
--

local __zoxide_oldpwd
local __zoxide_prompt = clink.promptfilter()

function __zoxide_prompt:filter()
  local zoxide_hook = settings.get 'zoxide.hook'

  if zoxide_hook == 'none' then
    -- do nothing
    return
  elseif zoxide_hook == 'prompt' then
    -- run `zoxide add` on every prompt
    __zoxide_add(os.getcwd())
  elseif zoxide_hook == 'pwd' then
    -- run `zoxide add` when the working directory changes
    local cwd = os.getcwd()
    if __zoxide_oldpwd and __zoxide_oldpwd ~= cwd then
      __zoxide_add(cwd)
    end
    __zoxide_oldpwd = cwd
  end
end

-- =============================================================================
--
-- Define aliases.
--

-- 'z' alias
local function __zoxide_z(keywords)
  if #keywords == 0 then
    return __zoxide_cd(os.getenv 'USERPROFILE')
  elseif #keywords == 1 then
    local keyword = keywords[1]
    if keyword == '-' then
      return __zoxide_cd '-'
    elseif os.isdir(keyword) then
      return __zoxide_cd(keyword)
    end
  end

  local cwd = '"' .. os.getcwd() .. '"'
  return __zoxide_query({ '--exclude', cwd }, keywords)
end

-- 'zi' alias
local function __zoxide_zi(keywords)
  return __zoxide_query({ '--interactive' }, keywords)
end

-- =============================================================================
--
-- Clink input text filter.
--

local function onfilterinput(text)
  args = string.explode(text, ' ', '"')
  if #args == 0 then
    return
  end

  -- settings
  zoxide_cmd = settings.get 'zoxide.cmd'
  zoxide_no_aliases = settings.get 'zoxide.no_aliases'

  -- edge case:
  -- * zoxide command prefix is 'cd'
  -- * clink converted 'cd -' -> 'cd /d "some_directory"'
  local cd_regex = '^%s*cd%s+/d%s+"(.-)"%s*$'
  if zoxide_cmd == 'cd' and text:match(cd_regex) then
    if zoxide_no_aliases then
      -- clink handles it
      return
    else
      -- zoxide handles it
      return __zoxide_cd(text:gsub(cd_regex, '%1')), false
    end
  end

  local cmd = table.remove(args, 1)
  if cmd == '__zoxide_z' or (cmd == zoxide_cmd and not zoxide_no_aliases) then
    return __zoxide_z(args), false
  elseif cmd == '__zoxide_zi' or (cmd == zoxide_cmd .. 'i' and not zoxide_no_aliases) then
    return __zoxide_zi(args), false
  else
    return
  end
end

if clink.onfilterinput then
  clink.onfilterinput(onfilterinput)
else
  clink.onendedit(onfilterinput)
end

-- =============================================================================
--
-- To initalize zoxide, add this script to one of clink's lua script locations (e.g. zoxide.lua)
-- (see https://chrisant996.github.io/clink/clink.html#location-of-lua-scripts)
