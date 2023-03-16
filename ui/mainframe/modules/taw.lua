local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")
local awful     = require("awful")

local weather   = wibox.widget {
  {
    {
      {
        {
          {
            id = "desc",
            font = beautiful.font .. " Light 12",
            markup = "Scattered Clouds",
            valign = "center",
            align = "start",
            widget = wibox.widget.textbox,
          },
          {
            id = "temp",
            font = beautiful.font .. " Light 16",
            markup = "31 C",
            valign = "center",
            align = "start",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.vertical
        },
        {
          {
            id            = "image",
            image         = "~/.config/awesome/theme/icons/weather/weather-overcast-symbolic.svg",
            opacity       = 0.65,
            clip_shape    = helpers.rrect(4),
            forced_height = 50,
            forced_width  = 50,
            widget        = wibox.widget.imagebox
          },
          widget = wibox.container.place,
          halign = 'right'
        },
        spacing = dpi(30),
        layout = wibox.layout.fixed.vertical
      },
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
    margins = 18,
  },
  forced_width = 200,
  bg = beautiful.bg2 .. 'cc',
  widget = wibox.container.background
}

local time      = wibox.widget {
  {
    {
      {
        {
          {
            {
              {
                font = beautiful.font .. " Bold 42",
                format = "%I",
                align = "center",
                valign = "center",
                widget = wibox.widget.textclock
              },
              {
                font = beautiful.font .. " 42",
                format = "%M",
                align = "center",
                valign = "center",
                widget = wibox.widget.textclock
              },
              spacing = 15,
              layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.place,
            halign = 'center'
          },
          {
            font = beautiful.font,
            format = "%A, %d %b",
            align = "center",
            valign = "center",
            widget = wibox.widget.textclock
          },
          spacing = 10,
          layout = wibox.layout.fixed.vertical
        },
        widget = wibox.container.place,
        halign = 'center',
        valign = 'center'
      },
      widget = wibox.container.margin,
      margins = 20,
    },
    bg = beautiful.bg2 .. 'cc',
    widget = wibox.container.background
  },
  widget = wibox.container.margin,
  margins = {
    left = 20,
  },

}

awesome.connect_signal("connect::weather", function(out)
  weather:get_children_by_id('desc')[1].markup = out.desc
  weather:get_children_by_id('temp')[1].markup = out.temp
  weather:get_children_by_id('image')[1].image = out.image
end)

local finalWidget = {
  layout = wibox.layout.align.horizontal,
  weather,
  time,
  nil
}

return finalWidget
