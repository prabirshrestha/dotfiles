local wezterm = require("wezterm")

local launch_menu = {}
local default_prog = { "/bin/bash", "-l" }

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    default_prog = { "cmd.exe" }
    table.insert(launch_menu, { label = "powerShell", args = {"powershell.exe", "-NoLogo"} })

    -- Find installed visual studio version(s) and add their compilation
    -- environment command prompts to the menu
    for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
        local year = vsvers:gsub("Microsoft Visual Studio/", "")
        table.insert(launch_menu, {
            label = "x64 Native Tools VS " .. year,
            args = {"cmd.exe", "/k", "C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat"},
        })
    end
else
    table.insert(launch_menu, { label = "bash", args = {"bash", "-l"} })
    table.insert(launch_menu, { label = "fish", args = {"fish", "-l"} })
end

local config = {
    check_for_updates = false,
    default_prog = default_prog,
    font = wezterm.font_with_fallback({
        "FiraCode Nerd Font",
        "Fira Code",
    }),
    font_size = 18.0,
    launch_menu = launch_menu,
    colors = {
        foreground = "#839496",
        background = "#002b36",
        cursor_bg = "#839496",
        cursor_fg = "#073642",
        selection_bg = "#073642",
        selection_fg = "#93a1a1",
        ansi = {"#073642","#dc322f","#859900","#b58900","#268bd2","#d33682","#2aa198","#eee8d5"},
        brights = {"#002b36","#cb4b16","#586e75","#657b83","#839496","#6c71c4","#93a1a1","#fdf6e3"},
    },
}


if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.term = ""
end

return config
