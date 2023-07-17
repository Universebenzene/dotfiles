--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ
      * (c) 2013, Rman

--]]

local helpers  = require("lain.helpers")
local awful    = require("awful")
local naughty  = require("naughty")
local wibox    = require("wibox")
local math     = math
local string   = string
local type     = type
local tonumber = tonumber

-- PipeWire-Pulse volume bar
-- lain.widget.pipe_pulsebar

local function factory(args)
    local pipe_pulsebar = {
        colors = {
            background      = "#000000",
            mute_background = "#000000",
            mute            = "#EB8F8F",
            unmute          = "#A4CE8A"
        },

        _current_level = 0,
        _mute          = "no",
        device         = "N/A"
    }

    args             = args or {}

    local timeout    = args.timeout or 5
    local settings   = args.settings or function() end
    local width      = args.width or 63
    local height     = args.height or 1
    local margins    = args.margins or 1
    local paddings   = args.paddings or 1
    local ticks      = args.ticks or false
    local ticks_size = args.ticks_size or 7
    local tick       = args.tick or "|"
    local tick_pre   = args.tick_pre or "["
    local tick_post  = args.tick_post or "]"
    local tick_none  = args.tick_none or " "

    pipe_pulsebar.colors              = args.colors or pipe_pulsebar.colors
    pipe_pulsebar.followtag           = args.followtag or false
    pipe_pulsebar.notification_preset = args.notification_preset
    pipe_pulsebar.devicetype          = args.devicetype or "sink"
    pipe_pulsebar.udevicetype         = pipe_pulsebar.devicetype:gsub("^%l",string.upper)
    pipe_pulsebar.cmd                 = args.cmd or "LANG=en_US.UTF-8 pactl get-" .. pipe_pulsebar.devicetype .. "-volume @DEFAULT_" .. string.upper(pipe_pulsebar.devicetype) .. "@; LANG=en_US.UTF-8 pactl get-" .. pipe_pulsebar.devicetype .. "-mute @DEFAULT_" .. string.upper(pipe_pulsebar.devicetype) .. "@; LANG=en_US.UTF-8 pactl list " .. pipe_pulsebar.devicetype .. "s | grep -B 2 'Name: '$(pactl get-default-" .. pipe_pulsebar.devicetype .. ")"
    pipe_pulsebar.scmd                = args.cmd or "LANG=en_US.UTF-8 pactl list " .. pipe_pulsebar.devicetype .. "s | sed -n -e '/" .. pipe_pulsebar.udevicetype .. " #/p' -e '/Base Volume/d' -e '/Volume:/p' -e '/Mute:/p' -e '/device\\.string/p'"

    if not pipe_pulsebar.notification_preset then
        pipe_pulsebar.notification_preset = {
            font = "Monospace 10"
        }
    end

    pipe_pulsebar.bar = wibox.widget {
        color            = pipe_pulsebar.colors.unmute,
        background_color = pipe_pulsebar.colors.background,
        forced_height    = height,
        forced_width     = width,
        margins          = margins,
        paddings         = paddings,
        ticks            = ticks,
        ticks_size       = ticks_size,
        widget           = wibox.widget.progressbar,
    }

    pipe_pulsebar.tooltip = awful.tooltip({ objects = { pipe_pulsebar.bar } })

    function pipe_pulsebar.update(callback)
        helpers.async({ awful.util.shell, "-c", type(pipe_pulsebar.cmd) == "string" and pipe_pulsebar.cmd or pipe_pulsebar.cmd() },
        function(s)
            volume_now = {
                index = string.match(s, " #(%S+)") or "N/A",
                muted  = string.match(s, "Mute: (%S+)") or "N/A"
            }

            pipe_pulsebar.device = volume_now.index

            local ch = 1
            volume_now.channel = {}
            for v in string.gmatch(s, ":.-(%d+)%%") do
              volume_now.channel[ch] = v
              ch = ch + 1
            end

            volume_now.left  = volume_now.channel[1] or "N/A"
            volume_now.right = volume_now.channel[2] or "N/A"

            local volu = volume_now.left
            local mute = volume_now.muted

            if volu:match("N/A") or mute:match("N/A") then return end

            if volu ~= pipe_pulsebar._current_level or mute ~= pipe_pulsebar._mute then
                pipe_pulsebar._current_level = tonumber(volu)
                pipe_pulsebar.bar:set_value(pipe_pulsebar._current_level / 100)
                if pipe_pulsebar._current_level == 0 or mute == "yes" then
                    pipe_pulsebar._mute = mute
                    pipe_pulsebar.tooltip:set_text ("[muted]")
                    pipe_pulsebar.bar.color = pipe_pulsebar.colors.mute
                    pipe_pulsebar.bar.background_color = pipe_pulsebar.colors.mute_background
                else
                    pipe_pulsebar._mute = "no"
                    pipe_pulsebar.tooltip:set_text(string.format("%s %s: %s", pipe_pulsebar.devicetype, pipe_pulsebar.device, volu))
                    pipe_pulsebar.bar.color = pipe_pulsebar.colors.unmute
                    pipe_pulsebar.bar.background_color = pipe_pulsebar.colors.background
                end

                settings()

                if type(callback) == "function" then callback() end
            end
        end)
    end
        helpers.async({ awful.util.shell, "-c", type(pipe_pulsebar.scmd) == "string" and pipe_pulsebar.scmd or pipe_pulsebar.scmd() },
        function(s)
            volume_now.device = string.match(s, "device.string = \"(%S+)\"") or "N/A"
        end)

    function pipe_pulsebar.notify()
        pipe_pulsebar.update(function()
            local preset = pipe_pulsebar.notification_preset

            preset.title = string.format("%s %s - %s%%", pipe_pulsebar.devicetype, pipe_pulsebar.device, pipe_pulsebar._current_level)

            if pipe_pulsebar._mute == "yes" then
                preset.title = preset.title .. " muted"
            end

            -- tot is the maximum number of ticks to display in the notification
            -- fallback: default horizontal wibox height
            local wib, tot = awful.screen.focused().mywibox, 20

            -- if we can grab mywibox, tot is defined as its height if
            -- horizontal, or width otherwise
            if wib then
                if wib.position == "left" or wib.position == "right" then
                    tot = wib.width
                else
                    tot = wib.height
                end
            end

            local int = math.modf((pipe_pulsebar._current_level / 100) * tot)
            preset.text = string.format(
                "%s%s%s%s",
                tick_pre,
                string.rep(tick, int),
                string.rep(tick_none, tot - int),
                tick_post
            )

            if pipe_pulsebar.followtag then preset.screen = awful.screen.focused() end

            if not pipe_pulsebar.notification then
                pipe_pulsebar.notification = naughty.notify {
                    preset  = preset,
                    destroy = function() pipe_pulsebar.notification = nil end
                }
            else
                naughty.replace_text(pipe_pulsebar.notification, preset.title, preset.text)
            end
        end)
    end

    helpers.newtimer(string.format("pipe_pulsebar-%s-%s", pipe_pulsebar.devicetype, pipe_pulsebar.device), timeout, pipe_pulsebar.update)

    return pipe_pulsebar
end

return factory
