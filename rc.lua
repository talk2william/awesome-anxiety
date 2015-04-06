-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- local common = require("awful.widget.common")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors, 
                     fg="#333333",
                     bg="#ffffff"})
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
                         text = err,
                         fg="#333333",
                         bg="#ffffff" })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers

-- Load the theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/Blur/theme.lua")

-- This is used later as the Original terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "kate"
editor_cmd = terminal .. " -e " .. editor
-- Original modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
  awful.layout.suit.floating
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

 -- {{{ Tags
 -- Define a tag table which will hold all screen tags.
 tags = {
   names  = { "", "", "" },
   layout = {layouts[1],layouts[1],layouts[1]},
   icons = {beautiful.tag_icon1,beautiful.tag_icon2,beautiful.tag_icon3}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
    awful.tag.seticon(tags.icons[1],tags[s][1])
    awful.tag.seticon(tags.icons[2],tags[s][2])
    awful.tag.seticon(tags.icons[3],tags[s][3])
end
-- }}}
for a = 1, 3, 1 do
awful.tag.setproperty(tags[1][a], "icon_only", 0)
end



-- {{{ Menu
 myicon = wibox.widget.imagebox()
 myicon:set_image(beautiful.awesome_icon)
 myicon_iii = wibox.widget.imagebox()
 myicon_iii:set_image(beautiful.awesome_power)
-- Create a laucher widget and a main menu
myawesomemenu = {
   { },
   { "MANUAL", terminal .. " -e man awesome" },
   { "CONFIG", editor .. " " .. awesome.conffile },
   { "REFRESH", awesome.restart },
   { }
}
allapps = require("menugen").build_menu()
myapps = {
   { },
   { "DOLPHIN", "dolphin" },
   { "MOZILLA", "firefox" },
   { "CHROME", "google-chrome" },
   { "VLC", "vlc" },
   { "SUBLIME", "sublime" },
   { "KATE", "kate" },
   { "GIMP", "gimp" },
   { }
}

power = {
   { },
   { "POWEROFF", "poweroff" },
   { "REBOOT", "reboot" },
   { "LOGOUT", awesome.quit },
   { }
   }

mypower = awful.menu({ items = power })

mymainmenu = awful.menu({ items = { { },
            { "ALL APPS", allapps },
				    { "AWESOME", myawesomemenu },
	     		  { "APPS", myapps },
            { "POWER", power },
            { "TERMINAL", terminal },
				    { }
            }
            })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
mypower_opt = awful.widget.launcher({ image = beautiful.awesome_power,
                                      menu =  mypower })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
menubar.menu_gen.all_menu_dirs = { "/usr/share/applications/", "/usr/local/share/applications/", "~/.local/share/applications" }
-- }}}

-- {{{ Wibox

--  Network usage widget
 -- Initialize widget, use widget({ type = "textbox" }) for awesome < 3.5
 netwidget = wibox.widget.textbox()
 -- Register widget
 vicious.register(netwidget, vicious.widgets.net, '<span color="#333333">[ ▼ ${eth0 down_kb}</span> <span color="#333333">▲ ${eth0 up_kb} ]</span>', 3)

--display date and tome
tdwidget = wibox.widget.textbox()
local strf = '<span color="#333333">   %b %d %I:%M  </span>'
vicious.register(tdwidget, vicious.widgets.date, strf, 20)

  tdwidget:connect_signal("mouse::enter", function () 
  date = naughty.notify({ 
    title = "DATE!",
    text = os.date("%b %d, %Y"),
    bg = "#ffffff",
    fg="#333333",
    icon = beautiful.widget_icon1,
    icon_size = 44,
    font = "Museo Sans Rounded 900 13",
    height = 80,
    width = 200,
    timeout = 0, })
--  opacity = 0.8
  end)
  tdwidget:connect_signal("mouse::leave", function () naughty.destroy (date) end)

--display memory
memwidget = wibox.widget.textbox()

vicious.register(memwidget, vicious.widgets.mem, '<span font="Inconsolata 11" color="#333333">[ ◕ $2MB ]</span>', 20)

--display volume
volume = wibox.widget.textbox()
vicious.register(volume, vicious.widgets.volume,
'<span color="#ffffff" bgcolor="#333333"> $1% </span>', 0.3, "Master")
volume:connect_signal("mouse::enter", function () 
  vol = naughty.notify({ 
    title = " VOLUME!",
    text = "Scroll Up/Down",
    bg = "#ffffff",
    fg="#333333",
    icon = beautiful.widget_icon2,
    icon_size = 44,
    font = "Museo Sans Rounded 900 13",
    height = 80,
    width = 200,
    timeout = 0 })
--  opacity = 0.8
  end)
volume:connect_signal("mouse::leave", function () naughty.destroy (vol) end)

-- Create a wibox for each screen and add it
mywibox = {}
mywibox_ii = {}
mywibox_toggle = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
--no-names==only-icon
--function myupdate(w, buttons, label, data, objects)
--    w:reset()
--    local l = wibox.layout.fixed.horizontal()
--    for i, o in ipairs(objects) do
--        local cache = data[o]
--        if cache then
--            ib = cache.ib
--        else
--            ib = wibox.widget.imagebox()
--            ib:buttons(common.create_buttons(buttons, o))

--            data[o] = {
--                ib = ib
--            }
--        end

--        local text, bg, bg_image, icon = label(o)
--       ib:set_image(icon)
--    l:add(ib)
        --w:add(ib)
--   end
--   w:add(l)
--end

mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox_toggle[s] = awful.wibox({ position = "left", ontop = true, height = "1", width = "1", screen = s })
    mywibox_toggle[s]:connect_signal("mouse::enter", function () 
      mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
     end)
    mywibox[s] = awful.wibox({ position = "top", ontop = true, height = "50", screen = s })
    mywibox_ii[s] = awful.wibox({ position = "bottom", ontop = true, height = "30", screen = s })
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the middle
    local middle_layout = wibox.layout.fixed.horizontal()
    middle_layout:add(mytaglist[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(volume)
    right_layout:add(tdwidget)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(middle_layout)
    layout:set_right(right_layout)
    
    local taskl = wibox.layout.margin(mytasklist[s], 10, 10)
    taskl:set_margins(4)
    local layout_ii = wibox.layout.align.horizontal()
    layout_ii:set_middle(taskl)
    layout_ii:set_right(mypower_opt)
    
    mywibox_toggle[s]:set_bg("#ffffff00")

    mywibox[s]:set_widget(layout)

    mywibox_ii[s]:set_bg("#ffffff00")
    mywibox_ii[s]:set_widget(layout_ii)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

--c = client.focus
--moveresize (x, y, w, h, c):buttons(awful.util.table.join(
--    awful.button({ }, 1, function (c) awful.mouse.client.resize() end)
--))
volume:buttons(awful.util.table.join(
  awful.button({ }, 4, function () awful.util.spawn("amixer set Master 1%+") end),
  awful.button({ }, 5, function () awful.util.spawn("amixer set Master 1%-") end)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
--    awful.key({}, "Escape",
--        function ()
--          if mywibox[mouse.screen].visible then
--            mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end
--        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

   -- PrintScrn to capture a screen
   awful.key(
       {},
       "Print",
       function()
           awful.util.spawn("scrot -cd 1",false)
       end
   ),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),
    -- Volume control
    awful.key({ altkey }, "Up",
    function ()
    awful.util.spawn("amixer set Master 1%+")
    end),
    awful.key({ altkey }, "Down",
    function ()
    awful.util.spawn("amixer set Master 1%-")
    end),
    awful.key({ altkey }, "m",
    function ()
    awful.util.spawn("amixer set Master playback toggle")
    end),
    awful.key({ altkey, "Control" }, "m", 
    function ()
    awful.util.spawn("amixer set Master playback 100%", false )
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen
                     if c.fullscreen then
                     if mywibox[mouse.screen].visible and mywibox_ii[mouse.screen].visible then
                     mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
                     mywibox_ii[mouse.screen].visible = not mywibox_ii[mouse.screen].visible
                     end
                     else 
                     mywibox[mouse.screen].visible = true
                     mywibox_ii[mouse.screen].visible = true
                     end
                                               end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons },
     },

    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
--ICON (close,maximize and minimize)
 myicon1 = wibox.widget.imagebox()
 myicon1:set_image(beautiful.action_min)
 myicon1:buttons(awful.util.table.join(
    awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    c.minimized = true
                end)
))
 
 myicon2 = wibox.widget.imagebox()
 myicon2:set_image(beautiful.action_max)
 myicon2:buttons(awful.util.table.join(
    awful.button({ }, 1, function()
      if mywibox[mouse.screen].visible then mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end
                    client.focus = c
                    c:raise()
		    c.maximized_horizontal = not c.maximized_horizontal
		    c.maximized_vertical   = not c.maximized_vertical
                end)
))
 
 myicon3 = wibox.widget.imagebox()
 myicon3:set_image(beautiful.action_close)
 myicon3:buttons(awful.util.table.join(
    awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    c:kill()
                end)
))   
 
local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Title in the middle
    local action_icons = wibox.layout.fixed.horizontal()
    action_icons:add(myicon1)
    action_icons:add(myicon2)
    action_icons:add(myicon3)
    
	local icon_set = wibox.layout.align.horizontal()
        icon_set:set_right(action_icons)
	
        local right_layout = wibox.layout.flex.horizontal()
        right_layout:add(icon_set)
        right_layout:buttons(buttons)

        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)

        awful.titlebar(c,{size=30}):set_widget(layout)
        if (c.class == "vlc" or c.class == "Vlc") then
        awful.titlebar.hide(c)
      end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--Starup Commands
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("xrdb ~/.Xresources")
run_once("compton --config ~/.config/awesome/compton.conf -CGb")
