local wezterm = require("wezterm")

local env = {}
local launch_menu = {}
local default_prog = { "/bin/bash", "-l" }

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    env["TERM"] = ""
    default_prog = { "cmd.exe" }
    table.insert(launch_menu, { label = "PowerShell", args = {"powershell.exe", "-NoLogo"} })

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
        "Consolas"
    }),
    font_size = 12.0,
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
    set_environment_variables = env,
    leader = { key="a", mods="CTRL" },
    keys = {
        { key = "-", mods = "LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}} },
        { key = "\\", mods = "LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}} },
        { key = "z", mods = "LEADER", action="TogglePaneZoomState" },
        { key = "c", mods = "LEADER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
        { key = "h", mods = "LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
        { key = "j", mods = "LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
        { key = "k", mods = "LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
        { key = "l", mods = "LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
        { key = "H", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
        { key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
        { key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
        { key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
        { key = "1", mods = "LEADER", action=wezterm.action{ActivateTab=0}},
        { key = "2", mods = "LEADER", action=wezterm.action{ActivateTab=1}},
        { key = "3", mods = "LEADER", action=wezterm.action{ActivateTab=2}},
        { key = "4", mods = "LEADER", action=wezterm.action{ActivateTab=3}},
        { key = "5", mods = "LEADER", action=wezterm.action{ActivateTab=4}},
        { key = "6", mods = "LEADER", action=wezterm.action{ActivateTab=5}},
        { key = "7", mods = "LEADER", action=wezterm.action{ActivateTab=6}},
        { key = "8", mods = "LEADER", action=wezterm.action{ActivateTab=7}},
        { key = "9", mods = "LEADER", action=wezterm.action{ActivateTab=8}},
        { key = "&", mods = "LEADER|SHIFT", action="CloseCurrentTab"},
        { key = "x", mods = "LEADER", action="CloseCurrentPane"},
    }
}


if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.term = ""
end

return config
