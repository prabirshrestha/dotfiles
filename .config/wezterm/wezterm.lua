local wezterm = require("wezterm")

local launch_menu = {}
local default_prog = { "/bin/bash", "-l" }

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    default_prog = { "cmd.exe" }
    table.insert(launch_menu, { label = "powerShell", args = {"powershell.exe", "-NoLogo"} })
else
    table.insert(launch_menu, { label = "bash", args = {"bash", "-l"} })
    table.insert(launch_menu, { label = "fish", args = {"fish", "-l"} })
end

return {
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
    }
}
