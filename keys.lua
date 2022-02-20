local gears = require("gears")
local awful = require("awful")

local M = {}

-- Default modkey.
modkey = "Mod4"



-- {{{ Key bindings
M.globalkeys = gears.table.join(
  awful.key({ modkey }, "r", function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", {raise = true}
        )
      end
    end,
  { description = "restore minimized", group = "client" }),awful.key({ modkey,           }, "e",      revelation)
)

M.clientkeys = gears.table.join(
-- your code starts
    awful.key({ modkey, 'Control' }, 't',
        function(c)
            awful.titlebar.toggle(c)
        end,
        {description = 'toggle title bar', group = 'client'}))

M.clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

return M
