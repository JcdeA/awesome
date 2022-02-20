local wibox = require("wibox")
local beautiful = require("beautiful")

local music = wibox.widget {
    widget = wibox.widget.textbox
}

awesome.connect_signal("bling::playerctl::status", function(playing,player_name)
    music.font = beautiful.font
      local markup = (playing and "\u{f1bc}" or "<span foreground='#5B6268'>\u{f1bc}</span>")

    music.markup = markup
end)

return music
