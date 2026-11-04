-- Rex configuration. Keep in sync with .config/ghostty/config.

rex.bind("ctrl+a>n", "client.window.new")
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>\\", "pane.split", { direction = "right" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+a>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>x", "pane.close")

-- Press ctrl+a twice to send one ctrl+a to the terminal.
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- Match the Ghostty default: cmd+enter toggles full screen.
rex.bind("cmd+enter", "client.window.fullscreen.toggle")
