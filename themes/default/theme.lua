---------------------------
-- Default awesome theme --
---------------------------

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local themes_path = "~/.config/awesome/themes/"

local theme = {}

theme.font          = "D2Coding Ligature 10"

-- theme.bg_normal     = "#232831"
-- theme.bg_focus      = "#2d333f"
theme.bg_normal     = "#181a1b"
theme.bg_focus      = "#272727"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal
theme.systray_icon_spacing = 15

theme.fg_normal     = "#f9f9f9"
theme.taglist_fg_empty = "#5B6268"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.gap_single_client = false
theme.useless_gap   = dpi(5)
theme.border_width  = 1
theme.inner_border_width  =2
theme.border_normal = "#000000"
theme.border_focus  = "#000000"
theme.border_marked = "#777777"
theme.border_radius = 15



theme.notification_font = "Inter Display 11"
theme.notification_margin = 100
theme.notification_spacing = dpi(15)
theme.notification_border_width = 2


-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

theme.wallpaper = "~/.wallpaper/wp9378837-windows-11-wallpapers.jpg"
theme.icon_theme = nil

return theme
