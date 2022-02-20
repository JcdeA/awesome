-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local revelation = require("revelation")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local helpers = require('helpers')
local menubar = require("menubar")

local wibar = require("widgets.wibar")
local json = require("util.json")
local keys = require("keys")

naughty.config.defaults.margin = 15
naughty.config.defaults.icon_size = 100
naughty.config.defaults.padding = 10
naughty.config.defaults.shape =  function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 5)

end


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default")
beautiful.init(theme_path)

local bling = require("bling")
bling.signal.playerctl.enable()


revelation.init()
-- This is used later as the default terminal and editor to run.
local terminal = "wezterm"
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor

-- Layouts.
awful.layout.layouts = {
    awful.layout.suit.tile.right,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair
}
-- }}}

local rubato = require("rubato") -- Totally optional, only required if you are using animations.

-- These are example rubato tables. You can use one for just y, just x, or both.
-- The duration and easing is up to you. Please check out the rubato docs to learn more.
local anim_y = rubato.timed {
    pos = 1090,
    rate = 120,
    easing = rubato.quadratic,
    intro = 0.05,
    duration = 0.1,
    awestore_compat = true -- This option must be set to true.
}

local anim_x = rubato.timed {
    pos = -970,
    rate = 120,
    easing = rubato.quadratic,
    intro = 0.05,
    duration = 0.1,
    awestore_compat = true -- This option must be set to true.
}

local term_scratch = bling.module.scratchpad {
    command = "wezterm start --class spad",           -- How to spawn the scratchpad
    rule = { instance = "spad" },                     -- The rule that the scratchpad will be searched by
    sticky = true,                                    -- Whether the scratchpad should be sticky
    autoclose = true,                                 -- Whether it should hide itself when losing focus
    floating = true,                                  -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
    geometry = {x=360, y=90, height=900, width=1200}, -- The geometry in a floating state
    reapply = true,                                   -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
    dont_focus_before_close  = false,                 -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
    rubato = {x = anim_x, y = anim_y}                 -- Optional. This is how you can pass in the rubato tables for animations. If you don't want animations, you can ignore this option.
}

function toggle_scratchpad()
  term_scratch:toggle()
end


local nice = require("nice")
nice {
titlebar_height = 30,
titlebar_font = "D2Coding Ligature",
    titlebar_items = {
        right = {},
    },
    button_size = 14,
    
    -- You only need to pass the parameter you are changing
    context_menu_theme = {
        width = 300, 
    },
    
    -- Swap the designated buttons for resizing, and opening the context menu
    mb_resize = nice.MB_MIDDLE,
    mb_contextmenu = nice.MB_RIGHT,
}
-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
-- 	local file = io.open(string.format("%s/.config/awesome/client_colors.json", os.getenv("HOME")), "rb")
-- 	local client_color = {}
-- 
-- 	if file ~= nil then
-- 		client_color = json.decode(file:read("*all"))[c.class] or { focus = "#3c3c3c", normal = "#303030", focus_top = "#3c3c3c", normal_top = "#303030" }
-- 		file:close()
-- 	end
-- 
-- 	awful.titlebar(c, {
-- 			position = "top",l
-- 			size = beautiful.inner_border_width,
-- 			bg_focus = client_color["focus_top"],
-- 			bg_normal = client_color["normal_top"],
-- 		}) : setup {
-- 		layout = wibox.layout.align.horizontal,
-- 	}
-- 
-- 	for _,v in ipairs({ "right", "bottom", "left" }) do
-- 		awful.titlebar(c, {
-- 				position = v,
-- 				size = beautiful.inner_border_width,
-- 				bg_focus = client_color["focus"],
-- 				bg_normal = client_color["normal"],
-- 			}) : setup {
-- 			layout = wibox.layout.align.horizontal
-- 		}
-- 	end
-- end)

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
        -- gears.wallpaper.set("#131313")
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "", "", "" ,"", "", "\u{f1bc}" }, s, awful.layout.layouts[1])

    wibar.get(s)
end)

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

root.keys(keys.globalkeys)
awful.rules.rules = require("rules")


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)



client.connect_signal("property::class", function(c)
   if c.class == "Spotify" then
      local tag = awful.screen.focused().tags[6]
      c:move_to_tag(tag)
      tag:view_only()
      client.focus = c
      c:raise()
   end

   if c.class == "Chromium" or c.class == "Firefox" then
      local tag = awful.screen.focused().tags[2]
      tag:view_only()
      c:move_to_tag(tag)
      client.focus = c
      c:raise()
   end

   if c.class == "org.wezfurlong.wezterm" and (c.name ~= "vim" or  c.name ~= "nvim") then
      local tag = awful.screen.focused().tags[1]
      c:move_to_tag(tag)
      tag:view_only()
      client.focus = c
      c:raise()
   end
   
   if c.class == "discord" then
      local tag = awful.screen.focused().tags[3]
      c:move_to_tag(tag)
      tag:view_only()
      client.focus = c
      c:raise()
   end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus c:raise() end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}




function change_client_state(state)
    client.focus.fullscreen = false
    client.focus.maximized = false
      client.focus.ontop = false
    client.focus.floating = false
    if state == "floating" or state == "stacking" then
        client.focus.floating = true
        client.focus.ontop = true
    elseif state == "maximized" then
        client.focus.maximized = true
        client.focus.ontop = true
    elseif state == "fullscreen" then
        client.focus.ontop = true
        client.focus.fullscreen = true
    end
  end

local is_restart
do
    local restart_detected
    is_restart = function()
        -- If we already did restart detection: Just return the result
        if restart_detected ~= nil then
            return restart_detected
        end

        -- Register a new boolean
        awesome.register_xproperty("awesome_restart_check", "boolean")
        -- Check if this boolean is already set
        restart_detected = awesome.get_xproperty("awesome_restart_check") ~= nil
        -- Set it to true
        awesome.set_xproperty("awesome_restart_check", true)
        -- Return the result
        return restart_detected
    end
  end

function run(cmd)
  if not is_restart() then
    awful.spawn.single_instance(cmd)
  end
end

-- Autostart
run("xset r rate 300 50")
awesome.spawn("sxhkd")
run("ibus-daemon --xim -drx")
run("picom")
run("xinput set-prop 'ELAN1201:00 04F3:3098 Touchpad' 'libinput Natural Scrolling Enabled' 1")
run("/usr/lib/xfce-polkit/xfce-polkit")
run('libinput-gestures')
