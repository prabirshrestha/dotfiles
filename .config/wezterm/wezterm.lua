local wezterm = require("wezterm")

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    table.insert(launch_menu, { label = "PowerShell", args = {"powershell.exe", "-NoLogo"} })
else
    table.insert(launch_menu, { label = "Bash", args = {"bash", "-l"} })
end

return {
    default_prog = { "/usr/bin/bash", "-l" },
    font = wezterm.font_with_fallback({
        "Fira Code",
    }),
    font_size = 18.0,
    launch_menu = launch_menu,
}
