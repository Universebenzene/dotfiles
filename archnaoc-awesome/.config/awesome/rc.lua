-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- -- -- -- -- Benzene's Own Config -- -- -- -- --
-- Xdg Menu
local xdg_menu = require("archmenu")
-- Lain
local lain = require("lain")
--local lainwatch = require("lainwatch")
local markup = lain.util.markup
-- Widgets icons
img                                           = {}
img.bat000charging                            = "/home/benzene/.config/awesome/icons/bat-000-charging.png"
img.bat000                                    = "/home/benzene/.config/awesome/icons/bat-000.png"
img.bat020charging                            = "/home/benzene/.config/awesome/icons/bat-020-charging.png"
img.bat020                                    = "/home/benzene/.config/awesome/icons/bat-020.png"
img.bat040charging                            = "/home/benzene/.config/awesome/icons/bat-040-charging.png"
img.bat040                                    = "/home/benzene/.config/awesome/icons/bat-040.png"
img.bat060charging                            = "/home/benzene/.config/awesome/icons/bat-060-charging.png"
img.bat060                                    = "/home/benzene/.config/awesome/icons/bat-060.png"
img.bat080charging                            = "/home/benzene/.config/awesome/icons/bat-080-charging.png"
img.bat080                                    = "/home/benzene/.config/awesome/icons/bat-080.png"
img.bat100charging                            = "/home/benzene/.config/awesome/icons/bat-100-charging.png"
img.bat100                                    = "/home/benzene/.config/awesome/icons/bat-100.png"
img.batcharged                                = "/home/benzene/.config/awesome/icons/bat-charged.png"
img.ethon                                     = "/home/benzene/.config/awesome/icons/ethernet-connected.png"
img.ethoff                                    = "/home/benzene/.config/awesome/icons/ethernet-disconnected.png"
img.volhigh                                   = "/home/benzene/.config/awesome/icons/volume-high.png"
img.vollow                                    = "/home/benzene/.config/awesome/icons/volume-low.png"
img.volmed                                    = "/home/benzene/.config/awesome/icons/volume-medium.png"
img.volmutedblocked                           = "/home/benzene/.config/awesome/icons/volume-muted-blocked.png"
img.volmuted                                  = "/home/benzene/.config/awesome/icons/volume-muted.png"
img.voloff                                    = "/home/benzene/.config/awesome/icons/volume-off.png"
img.wifidisc                                  = "/home/benzene/.config/awesome/icons/wireless-disconnected.png"
img.wififull                                  = "/home/benzene/.config/awesome/icons/wireless-full.png"
img.wifihigh                                  = "/home/benzene/.config/awesome/icons/wireless-high.png"
img.wifilow                                   = "/home/benzene/.config/awesome/icons/wireless-low.png"
img.wifimed                                   = "/home/benzene/.config/awesome/icons/wireless-medium.png"
img.wifinone                                  = "/home/benzene/.config/awesome/icons/wireless-none.png"
img.widget_netdown                            = "/home/benzene/.config/awesome/icons/net_down.png"
img.widget_netup                              = "/home/benzene/.config/awesome/icons/net_up.png"
img.widget_mem                                = "/home/benzene/.config/awesome/icons/device-ram.png"
img.touchpad_enabled                          = "/home/benzene/.config/awesome/icons/input-touchpad-symbolic.png"
img.touchpad_disabled                         = "/home/benzene/.config/awesome/icons/touchpad-disabled-symbolic.png"
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

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
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run. -- Benz
terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1" -- Benz

-- Table of layouts to cover with awful.layout.inc, order matters. -- Benz
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.left,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
-- local function client_menu_toggle_fn()
--     local instance = nil
--
--     return function ()
--         if instance and instance.wibox.visible then
--             instance:hide()
--             instance = nil
--         else
--             instance = awful.menu.clients({ theme = { width = 250 } })
--         end
--     end
-- end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. "\\ " .. awesome.conffile }, -- Benz
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
   { "restart lightdm", function() awful.spawn.with_shell("systemctl restart lightdm") end }, -- Benz
   { "reboot", function() awful.spawn.with_shell("systemctl reboot") end }, -- Benz
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
                                    { "Applications", xdgmenu } -- Benz
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_menu_icon, -- Benz
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar

-- -- -- -- -- Benzene's Own Config -- -- -- -- --
-- Net
the={}
local netdownicon = wibox.widget.imagebox(img.widget_netdown)
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget.imagebox(img.widget_netup)
local netupinfo = lain.widget.net({
    settings = function()
--      if iface ~= "network off" and
--         string.match(theme.weather.widget.text, "N/A")
--      then
--          theme.weather.update()
--      end

        widget:set_markup(markup.fontfg("Cantarell 8.4", "#e54c62", net_now.sent .. "    "))
        netdowninfo:set_markup(markup.fontfg("Cantarell 8.4", "#87af5f", net_now.received .. " "))
    end
})

-- MEM
local memicon = wibox.widget.imagebox(img.widget_mem)
local swapinfo = wibox.widget.textbox()
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg("Cantarell 8.4", "#e0da37", " " .. mem_now.used .. "M(" .. mem_now.perc .. "%) "))
        swapinfo:set_markup(markup.fontfg("Cantarell 8.4", "#399C20", "/" .. mem_now.swapused .. "M "))
    end
})
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()
-- -- -- -- -- Benzene's Own Config -- -- -- -- --
local function rounded_shape(size, partial)
    if partial == 1 then
        return function(cr, width, height)
                   gears.shape.partially_rounded_rect(cr, width, height,
                        false, true, false, true, size)
               end
    elseif partial == 2 then
        return function(cr, width, height)
                   gears.shape.partially_rounded_rect(cr, width, height,
                        true, true, false, false, size)
               end
     else
        return function(cr, width, height)
                   gears.shape.rounded_rect(cr, width, height, size)
               end
    end
end
local month_calendar = awful.widget.calendar_popup.month({
    position = "tr",
    opacity = 1,
    font = "Cantarell 10",
    week_numbers = 1,
    bg = "#00000000",
    start_sunday = 1,
    long_weekdays = 1,
    style_month = {
        shape = rounded_shape(12, 2),
        padding = 4,
        bg_color = "#aaaaaa8f",
        border_color = "#b9214faa"
    },
     style_header = {
        shape = rounded_shape(6),
        padding = 1,
        fg_color = "#222222",
        bg_color = "#6181ffaa",
        border_color = "#6181ffaa"
    },
    style_weekday = {
        shape = rounded_shape(5),
        fg_color = "#222222",
        bg_color = "#de5e1eaa",
        border_color = "#de5e1e00"
    },
    style_weeknumber = {
        shape = rounded_shape(5),
        fg_color = "#222222",
        bg_color = "#2eea17aa",
        border_color = "2eea17aa"
    },
    style_normal = {
        fg_color = "#000000",
        bg_color = "#667788aa",
        border_color = "#22222200",
    },
    style_focus = {
        shape = rounded_shape(5, 1),
        fg_color = "#000000",
        bg_color = "#1793d1ee",
        border_color = "#1793d1aa"
    }
})
month_calendar:attach( mytextclock, "tr" )
--lain.widget.calendar({
--attach_to = { mytextclock },
--notification_preset = {
--    fg = "#aaaaaa",
--    bg = "#222222cf",
--    position = "top_right",
--    font = "Source Code Pro 11"
--}
--})
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- Benzene's Own Config -- -- -- -- --
-- ALSA widget
-- local volicon = wibox.widget.imagebox()
-- local voltip = awful.tooltip({
--     objects = { volicon }
-- })
-- voltip.textbox.font = "Cantarell 15"
-- voltip.timeout = 0
-- the.volume = lain.widget.alsabar({
--     togglechannel = "IEC958,3",
--     notification_preset = { font = "Monospace 12", fg = "#aaaaaa", bg = "#222222cc" },
--     settings = function()
--         local index, perc = "", tonumber(volume_now.level) or 0
--
--         if volume_now.status == "off" then
--             index = "volmutedblocked"
--         else
--             if perc <= 5 then
--                 index = "volmuted"
--             elseif perc <= 25 then
--                 index = "vollow"
--             elseif perc <= 75 then
--                 index = "volmed"
--             else
--                 index = "volhigh"
--             end
--         end
--
--         volicon:set_image(img[index])
--         voltip:set_markup(string.format("%d%%", volume_now.level))
--     end
-- })
-- volicon:buttons(gears.table.join (
--           awful.button({}, 1, function()
--             awful.spawn.with_shell(string.format("%s -e alsamixer", terminal))
--           end),
--           awful.button({}, 2, function()
--             awful.spawn(string.format("%s set %s 100%%", the.volume.cmd, the.volume.channel))
--             the.volume.notify()
--           end),
--           awful.button({}, 3, function()
--             awful.spawn(string.format("%s set %s toggle", the.volume.cmd, the.volume.togglechannel or the.volume.channel))
--             the.volume.notify()
--           end),
--           awful.button({}, 4, function()
--             awful.spawn(string.format("%s set %s 1%%+", the.volume.cmd, the.volume.channel))
--             the.volume.notify()
--           end),
--           awful.button({}, 5, function()
--             awful.spawn(string.format("%s set %s 1%%-", the.volume.cmd, the.volume.channel))
--             the.volume.notify()
--           end)
-- ))

-- PULSE widget
local pvolicon = wibox.widget.imagebox()
local pvoltip = awful.tooltip({
    objects = { pvolicon }
})
pvoltip.textbox.font = "Cantarell 15"
pvoltip.timeout = 0
the.pvolume = lain.widget.pulsebar({
    notification_preset = { font = "Monospace 12", fg = "#aaaaaa", bg = "#222222cc" },
--  margins = 4,    -- pvolbar
    tick = "█",
    tick_none = "─",
    tick_pre = "┠",
    tick_post = "┨",
    settings = function()
        local index, perc = "", tonumber(volume_now.left) or 0

        if volume_now.muted == "yes" then
            index = "volmutedblocked"
        else
            if perc <= 5 then
                index = "volmuted"
            elseif perc <= 25 then
                index = "vollow"
            elseif perc <= 75 then
                index = "volmed"
            else
                index = "volhigh"
            end
        end

        pvolicon:set_image(img[index])
        pvoltip:set_markup(string.format("%d%%", volume_now.left))
    end
})
-- local pvolbar = the.pvolume.bar -- pvolbar
pvolicon:buttons(gears.table.join (
          awful.button({}, 1, function()
            awful.spawn("pavucontrol")
          end),
          awful.button({}, 2, function()
            awful.spawn(string.format("pactl set-sink-volume %s 100%%", the.pvolume.device))
            the.pvolume.notify()
          end),
          awful.button({}, 3, function()
            awful.spawn(string.format("pactl set-sink-mute %s toggle", the.pvolume.device))
            the.pvolume.notify()
          end),
          awful.button({}, 4, function()
            awful.spawn(string.format("pactl set-sink-volume %s +1%%", the.pvolume.device))
            the.pvolume.update()
          end),
          awful.button({}, 5, function()
            awful.spawn(string.format("pactl set-sink-volume %s -1%%", the.pvolume.device))
            the.pvolume.update()
          end)
))

-- Battery widget
--local baticon = wibox.widget.imagebox(img.bat000)
--local battooltip = awful.tooltip({
--    objects = { baticon }
--  margin_leftright = 15,
--  margin_topbottom = 12
--})
--battooltip.textbox.font = "Cantarell 18"
--battooltip.timeout = 0
--battooltip:set_shape(function(cr, width, height)
--    gears.shape.infobubble(cr, width, height, corner_radius, arrow_size, width - 35)
--end)
--local bat = lain.widget.bat({
--    timeout = 30,
--    settings = function()
--        local index, perc = "bat", tonumber(bat_now.perc) or 0
--
--        if perc <= 7 then
--            index = index .. "000"
--        elseif perc <= 20 then
--            index = index .. "020"
--        elseif perc <= 40 then
--            index = index .. "040"
--        elseif perc <= 60 then
--            index = index .. "060"
--        elseif perc <= 80 then
--            index = index .. "080"
--        elseif perc <= 100 then
--            index = index .. "100"
--        end
--
--        if bat_now.status == "Charging" then
--            index = index .. "charging"
--        end
--
--        baticon:set_image(img[index])
--        if bat_now.status == "Full" then
--            baticon:set_image(img["batcharged"])
--        end
--        battooltip:set_markup(string.format("%s%%, %s", bat_now.perc, bat_now.time))
--    end
--})
--         battooltip:set_markup(string.format("%s%%, %s, %s, %s, %s", bat_now.perc, bat_now.time, bat_now.ac_status, bat_now.status, index))

-- TouchPad
--local touchicon = wibox.widget.imagebox()
--local mytouchsig = lainwatch({
----  cmd = "/home/benzene/.local/bin/touchpadstatus",
--    cmd = { awful.util.shell, "-c", "xinput list-props bcm5974 | awk 'NR==2 {printf(\"%d\\n\",$4)}'" },
--    settings = function()
--        local stat = output:match("%d")
--
--        if stat == "1" then
--            touchicon:set_image(img.touchpad_enabled)
--        else
--            touchicon:set_image(img.touchpad_disabled)
--        end
--    end
--})


-- Ethernet status
local ethicon1 = wibox.widget.imagebox()
-- local myethsig = lainwatch({
local myethsig1, myethTimer1 = awful.widget.watch(
--     cmd = "cat /sys/class/net/enp0s25/carrier",
    'bash -c "cat /sys/class/net/enp0s25/carrier"', 5,
--     settings = function()
    function(widget, stdout)
--         local carrier = output:match("%d")
        local carrier = tonumber(stdout)

        if carrier == 1 then
            ethicon1:set_image(img.ethon)
        else
            ethicon1:set_image(img.ethoff)
        end
    end
)

local ethicon2 = wibox.widget.imagebox()
-- local myethsig = lainwatch({
local myethsig, myethTimer = awful.widget.watch(
--     cmd = "cat /sys/class/net/enp7s0/carrier",
    'bash -c "cat /sys/class/net/enp7s0/carrier"', 5,
--     settings = function()
    function(widget, stdout)
--         local carrier = output:match("%d")
        local carrier = tonumber(stdout)

        if carrier == 1 then
            ethicon2:set_image(img.ethon)
        else
            ethicon2:set_image(img.ethoff)
        end
    end
)
--ethicon:connect_signal("button::press", function() awful.spawn(string.format("%s -e wicd-gtk", terminal)) end)
--ethicon:connect_signal("button::press", function() awful.spawn("wicd-gtk") end)

-- Wifi carrier and signal strength
-- local wificon = wibox.widget.imagebox()
-- local wifitooltip = awful.tooltip({
--     objects = { wificon },
--     margin_leftright = 15,
--     margin_topbottom = 15
-- })
-- wifitooltip.wibox.fg = "#aaaaaa"
-- wifitooltip.textbox.font = "Cantarell 10"
-- wifitooltip.timeout = 0
-- wifitooltip:set_shape(function(cr, width, height)
--     gears.shape.infobubble(cr, width, height, corner_radius, arrow_size, width - 120)
-- end)
-- local mywifisig = lain.widgets.abase({
--     cmd = { awful.util.shell, "-c", "awk 'NR==3 {printf(\"%d-%.0f\\n\",$2, $3*10/7)}' /proc/net/wireless; iw dev wlan0 link" },
--     settings = function()
--         local carrier, perc = output:match("(%d)-(%d+)")
--         local tiptext = output:gsub("(%d)-(%d+)", ""):gsub("%s+$", "")
--
--         if carrier == "1" then
--             wificon:set_image(img.wifidisc)
--             wifitooltip:set_markup("No carrier")
--         else
--             perc = tonumber(perc)
--             if perc <= 5 then
--                 wificon:set_image(img.wifinone)
--             elseif perc <= 25 then
--                 wificon:set_image(img.wifilow)
--             elseif perc <= 50 then
--                 wificon:set_image(img.wifimed)
--             elseif perc <= 75 then
--                 wificon:set_image(img.wifihigh)
--             else
--                 wificon:set_image(img.wififull)
--             end
--             wifitooltip:set_markup(tiptext)
--         end
--     end
-- })
-- wificon:connect_signal("button::press", function() awful.spawn(string.format("%s -e wavemon", terminal)) end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
-- -- -- -- -- Benzene's Own Config -- -- -- -- --
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end))
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)


-- -- -- -- -- Benzene's Own Config -- -- -- -- --
    -- Each screen has its own tag table.
    awful.tag({ "1til" }, s, awful.layout.layouts[1])
    tag_names = { "2til", "3til", "4til", "5bro", "6soc", "7sys", "8", "9" }
    -- layout_list={"layouts[1]","layouts[1]","layouts[1]","layouts[2]","layouts[2]","layouts[2]","layouts[3]","layouts[3]","layouts[3]"}
    layout_list = { 1, 1, 1, 10, 1, 5, 5, 5 }
    for stag = 1, 8 do
        awful.tag.add(tag_names[stag], {
                      screen = s,
                      layout = awful.layout.layouts[layout_list[stag]],
                  })
              end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc(-1) end), -- Benz
                           awful.button({ }, 5, function () awful.layout.inc( 1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, bg = "#00000000", height = 19 }) -- Benz

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
-- -- -- -- -- Benzene's Own Config -- -- -- -- --
            netdownicon,
            netdowninfo,
            netupicon,
            netupinfo.widget,
            memicon,
            memory.widget,
            swapinfo,
            --touchicon,
            layout = wibox.layout.fixed.horizontal,
            --mykeyboardlayout,
            wibox.widget.systray(),
            ethicon1,
            ethicon2,
            mytextclock,
            --wificon,
            --volicon,
            pvolicon,
            --pvolbar,
            --baticon,
            s.mylayoutbox,
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
-- -- -- -- -- Benzene's Own Config -- -- -- -- --
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group = "awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey, "Control" }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = gears.filesystem.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

-- -- -- -- -- Benzene's Own Config -- -- -- -- --
    -- Calendar
    --awful.key({ modkey }, "c", function () lain.widget.calendar.show(7) end,
    --          {description = "show the calendar", group = "lain"}),
    --awful.key({ modkey, "Control" }, "c", function () lain.widget.calendar.hide(7) end,
    --          {description = "hide the calendar", group = "lain"}),
    awful.key({ modkey }, "c", function() month_calendar:toggle() end,
              {description = "toggle calendar visiblility", group = "awesome"}),

    -- ALSA/PULSE volume control
    awful.key({ modkey }, "a",
        function ()
            os.execute(string.format("pactl set-sink-volume %s +2%%", the.pvolume.device))
            the.pvolume.update()
            the.pvolume.notify()
            --os.execute(string.format("amixer set %s 2%%+", the.volume.channel))
            --the.volume.update()
            --the.volume.notify()
        end,
        {description = "volume up", group = "lain"}),
    awful.key({ modkey }, "z",
        function ()
            os.execute(string.format("pactl set-sink-volume %s -2%%", the.pvolume.device))
            the.pvolume.update()
            the.pvolume.notify()
            --os.execute(string.format("amixer set %s 2%%-", the.volume.channel))
            --the.volume.update()
            --the.volume.notify()
        end,
        {description = "volume down", group = "lain"}),
    awful.key({ modkey }, "g",
        function ()
            os.execute(string.format("pactl set-sink-mute %s toggle", the.pvolume.device))
            the.pvolume.update()
            --os.execute(string.format("amixer set Master toggle", the.volume.togglechannel or the.volume.channel))
            --the.volume.update()
        end,
        {description = "volume mute", group = "lain"}),
--  awful.key({ altkey, "Control" }, "m",
--      function ()
--          os.execute(string.format("amixer set %s 100%%", the.volume.channel))
--          the.volume.update()
--      end),

--  awful.key({ modkey }, "z",
--		function ()
--			os.execute(string.format("amixer -q set %s 0%%", the.volume.channel))
--			the.volume.update()
--		end)
    -- TouchPad Control
--    awful.key({}, "XF86LaunchB",
--        function ()
--            os.execute(string.format("xinput set-prop bcm5974 \"Device Enabled\" 1"))
--            mytouchsig.update()
--        end,
--        {description = "touchpad on", group = "extra"}),
--    awful.key({}, "XF86LaunchA",
--        function ()
--            os.execute(string.format("xinput set-prop bcm5974 \"Device Enabled\" 0"))
--            mytouchsig.update()
--        end,
--        {description = "touchpad off", group = "extra"}),
--    -- Brightness
--    awful.key({}, "XF86MonBrightnessUp",
--        function ()
--            os.execute(string.format("xbacklight -inc 5"))
--        end,
--        {description = "brightness up", group = "extra"}),
--    awful.key({}, "XF86MonBrightnessDown",
--        function ()
--            os.execute(string.format("xbacklight -dec 5"))
--        end,
--        {description = "brightness down", group = "extra"}),
--    -- KeyBoard Brightness
--    awful.key({}, "XF86KbdBrightnessUp",
--        function ()
--            os.execute(string.format("/home/benzene/.local/bin/kb-light.py +"))
--        end,
--        {description = "keyboard brightness up", group = "extra"}),
--    awful.key({}, "XF86KbdBrightnessDown",
--        function ()
--            os.execute(string.format("/home/benzene/.local/bin/kb-light.py -"))
--        end,
--        {description = "keyboard brightness down", group = "extra"}),
    awful.key({ modkey }, "0",
        function ()
            memory.update()
--          the.volume.update()
            the.pvolume.update()
            myethTimer1:emit_signal("timeout")
            myethTimer:emit_signal("timeout")
            --bat.update()
            --mytouchsig.update()
        end,
        {description = "refresh some widgets", group = "lain"})
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
-- -- -- -- -- Benzene's Own Config -- -- -- -- --
    awful.key({ modkey,           }, "i",
        awful.titlebar.toggle,
        {description = "toggle title bar", group = "client"})
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
-- -- -- -- -- Benzene's Own Config -- -- -- -- --
                     maximized_vertical = false,
                     maximized_horizontal = false
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
-- -- -- -- -- Benzene's Own Config -- -- -- -- --
          "File-roller",
          "Gpick",
          "Gimp-2.8",
          "GoldenDict",
          "Gnome-screenshot",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer",
          "matplotlib",  -- python-matplotlib
          "Youdao Dict",
          "sunloginclient",
          "TeamViewer"
        },
        name = {
          "Event Tester",  -- xev.
          "Load New Table", -- topcat browser
          "我的足迹",      -- firefox history
          "关于 Mozilla Firefox" -- about firefox
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
--     { rule = { class = "Soffice" .. "." },
--       properties = { screen = 2, tag = "3job" } },
    { rule = {
        class = "okular" },
      properties = {  tag = "3til" } },
    { rule = {
        class = "firefox" },
      properties = {  tag = "5bro" } },
--  { rule = {
--      class = "TelegramDesktop" },
--    properties = {  tag = "5soc" } },
    { rule = {
        class = "Thunderbird" },
      properties = {  tag = "6soc" } },
    { rule = {
        class = "Gnome-system-monitor" },
      properties = {  tag = "7sys" } },
    { rule = {
        class = "Gimp-2.10" },
      properties = {  tag = "8" } },
    { rule = {
        class = "TeamViewer" },
      properties = {  tag = "8" } },
    { rule = {
        class = "sunloginclient" },
      properties = {  tag = "9" } },
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

}
-- }}}

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

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )


-- -- -- -- -- Benzene's Own Config -- -- -- -- --
    awful.titlebar(c, { size = 16 }) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
    -- Hide the menubar if we are not floating
    local l = awful.layout.get(c.screen)
    if not (l.name == "floating" or c.floating) then
        awful.titlebar.hide(c)
    end
end)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- -- -- -- -- Benzene's Own Config -- -- -- -- --
-- Autorun
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null  	|| (" .. cmd .. ")")
end
--run_once("xinput set-prop bcm5974 \"Device Enabled\" 0")
run_once("picom -b")
run_once("xfce4-terminal")
run_once("fcitx &")
--run_once("nm-applet &")
run_once("firefox &")
--run_once("evolution &")
run_once("teamviewer &")
run_once("sunloginclient &")
run_once("thunderbird &")
run_once("gnome-system-monitor &")
--awful.spawn.with_shell("xrandr --output VGA-1 --auto")
--awful.spawn.with_shell(mytouchsig.update())
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- }}}
