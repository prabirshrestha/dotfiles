local handle = io.popen("git config --get-regex alias")
local result = handle:read("*a")
handle:close()

local aliases = {}

for alias in string.gmatch(result, "%.(%S+)") do
  table.insert(aliases, alias)
end

clink.arg.register_parser("git", aliases)
