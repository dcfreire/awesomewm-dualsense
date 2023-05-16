-------------------------------------------------
-- Dualsense for Awesome Window Manager
-- Requires dualsensectl
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local BATTERY = "dualsensectl battery"
local POWER_OFF = "dualsensectl power-off"
local controller_icon = os.getenv("HOME") .. '/.config/awesome/widgets/dualsense/controller_icon.png'

local function worker(args)
    local args = args or {}
    local timeout = args.timeout or 1
    local font = args.font or 'Play 9'
    local controller = wibox.widget {
        {
            id = "icon",
            image = controller_icon,
            widget = wibox.widget.imagebox,
        },
        {
            id="battery",
            markup = "",
            widget = wibox.widget.textbox,
            font = font
        },
        layout = wibox.layout.align.horizontal,
    }

    function controller.update(_, text, _, _)
        local bat = tonumber(string.match(text, "%d*"))

        if bat == nil then
            controller:get_children_by_id('battery')[1]:set_markup('')
            controller:set_visible(false)
        elseif controller:get_children_by_id('battery')[1]:get_markup() ~= text then
            controller:get_children_by_id('battery')[1]:set_markup(' ' .. bat .. '%')
            controller:set_visible(true)
        end
    end

    watch(BATTERY, timeout, controller.update, controller)

    controller:connect_signal("button::press", function(_, _, _, button)
        if (button == 2) then
            awful.spawn(POWER_OFF, false)      -- middle click
        end
    end)

    return controller
end


return worker