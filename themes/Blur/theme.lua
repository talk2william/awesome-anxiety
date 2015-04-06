---------------------------
-- Blur awesome theme --
---------------------------

theme = {}

-- your location to config
pathToConfig = os.getenv("HOME") .. "/.config/awesome/"

theme.font = "Museo Sans Rounded 900 10"

theme.bg_normal     = "#ffffff00"
theme.bg_focus      = "#ffffff"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#33333300"
theme.bg_systray    = "#ffffff"
theme.titlebar_bg_normal = "#ffffff"   --"#e1e2e1"
theme.taglist_bg_focus = "png:" .. pathToConfig .. "themes/Blur/action/action2.png"
theme.tag_icon1 = pathToConfig .. "S/S.png"
theme.tag_icon2 = pathToConfig .. "S/S_ii.png"
theme.tag_icon3 = pathToConfig .. "S/S_iii.png"
theme.tasklist_bg_normal = "#ffffff00"
theme.tasklist_bg_focus = "#ffffff00"

theme.tasklist_fg_focus = "#ffffff"
theme.fg_normal     = "#333333"
theme.fg_focus      = "#d15122"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 2
theme.border_normal = "#ffffff"
theme.border_focus  = "#ffffff"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the Blur one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
--theme.taglist_squares_sel   = pathToConfig .. "/themes/Blur/taglist/squarefw.png"
--theme.taglist_squares_unsel = pathToConfig .. "/themes/Blur/taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = pathToConfig .. "themes/Blur/submenu.png"
theme.menu_height = 20
theme.menu_width  = 110
theme.menu_border_width = 5
theme.menu_border_color = "#ffffff00"
theme.menu_bg_normal = "#ffffff"
theme.menu_bg_focus = "#ffffff"
theme.menu_fg_focus = "#161616"
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"
-- notification icons
theme.widget_icon1 = pathToConfig .. "icons/clck.png"
theme.widget_icon2 = pathToConfig .. "icons/volm.png"
-- Define the image to load

theme.wallpaper = pathToConfig .. "themes/Blur/wallpaper.jpg"

-- You can use your own layout icons like this:

theme.awesome_icon = pathToConfig .. "icons/ok_blur.png"
theme.action_close = pathToConfig .. "themes/Blur/action/action_close.png"
theme.action_max = pathToConfig .. "themes/Blur/action/action_max.png"
theme.action_min = pathToConfig .. "themes/Blur/action/action_min.png"
-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = "hicolor/index.theme"
theme.awesome_icon_x = pathToConfig .. "icons/cut.png"
theme.awesome_power = pathToConfig .. "icons/power.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
