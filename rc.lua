-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Load Debian menu entries
--local debian_menu = require("debian_menu")

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
                         text = err })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
-- Useful Paths
home = os.getenv("HOME")
conf_dir = home .. "/.config/awesome"
scriptdir = conf_dir .. "/scripts/"
themes = conf_dir .. "/themes"
active_theme = themes .. "/default"

--Active theme
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init( active_theme .. "/theme.lua") 

-- Lazy shortucts
terminal = "rxvt-unicode"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
irc = "screen -S irc irssi"
irc_cmd = terminal .. " -e " .. irc
skype_cmd = terminal .. "-e" .. "skype"
explorer = "thunar"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,		--1
    awful.layout.suit.floating,		--2
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,	--3
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,	--4
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,		--5
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier		--6
}
---- }}}


-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
---- }}}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags =  {
       	 names =  {"main","irc","web","dev","pdf","media","p2p"},
       	 layout = {layouts[1], layouts[3], layouts[5], layouts[1], layouts[5], layouts[6], layouts[5] }
	}

for s = 1, screen.count() do

-- Each screen has its own tag table.
   tags[s] = awful.tag(tags.names, s, tags.layout)
    awful.tag.seticon(beautiful.transm_icon,tags[s][7])
end

--transmission icon, to represent my p2p client (looking for a better one if you wanna propose one)
for s = 1, screen.count() do 
	awful.tag.setproperty(tags[s][7], "icon_only", 1)
end
-- End Tags}}}


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. conf_dir .. "/rc.lua"  },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

communicationmenu = {
    { "Skype", skype_cmd, beautiful.skype_icon },
    { "IRC", irc_cmd, beautiful.irc_icon }
}

downloadmenu = {
  {"Transmission","transmission-gtk",beautiful.transm_icon},
  {"Filezilla","filezilla",beautiful.filez_icon}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                                            { "communicate",communicationmenu, beautiful.comm_icon},
                                    --{ "Debian", debian_menu.Debian, beautiful.debian_icon }, --useless to have a debian menu
                                    { "Download",downloadmenu,beautiful.tunnel_icon},
                                    { "open terminal", terminal, beautiful.vim_icon },
                                    { "restart", awesome.restart, beautiful.restart_icon },
                                    { "quit", awesome.quit, beautiful.switch_icon }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- End Menu}}}


-- {{{ Wibox

	-- Create a textclock widget
	mytextclock = awful.widget.textclock()

	-- Calendar attached to the textclock
	local os = os
	local string = string
	local table = table
	local util = awful.util

	char_width = nil
	text_color = theme.fg_normal or "#FFFFFF"
	today_color = theme.tasklist_fg_focus or "#FF7100"
	calendar_width = 21

	local calendar = nil
	local offset = 0

	local data = nil

	local function pop_spaces(s1, s2, maxsize)
	   local sps = ""
	   for i = 1, maxsize - string.len(s1) - string.len(s2) do
		  sps = sps .. " "
	   end
	   return s1 .. sps .. s2
	end

	local function create_calendar()
	   offset = offset or 0

	   local now = os.date("*t")
	   local cal_month = now.month + offset
	   local cal_year = now.year
	   if cal_month > 12 then
		  cal_month = (cal_month % 12)
		  cal_year = cal_year + 1
	   elseif cal_month < 1 then
		  cal_month = (cal_month + 12)
		  cal_year = cal_year - 1
	   end

	   local last_day = os.date("%d", os.time({ day = 1, year = cal_year,
												month = cal_month + 1}) - 86400)
	   local first_day = os.time({ day = 1, month = cal_month, year = cal_year})
	   local first_day_in_week =
		  os.date("%w", first_day)
	   local result = "su mo tu we th fr sa\n"
	   for i = 1, first_day_in_week do
		  result = result .. " "
	   end

	   local this_month = false
	   for day = 1, last_day do
		  local last_in_week = (day + first_day_in_week) % 7 == 0
		  local day_str = pop_spaces("", day, 2) .. (last_in_week and "" or " ")
		  if cal_month == now.month and cal_year == now.year and day == now.day then
			 this_month = true
			 result = result ..
				string.format('<span weight="bold" foreground = "%s">%s</span>',
							  today_color, day_str)
		  else
			 result = result .. day_str
		  end
		  if last_in_week and day ~= last_day then
			 result = result .. "\n"
		  end
	   end

	   local header
	   if this_month then
		  header = os.date("%a, %d %b %Y")
	   else
		  header = os.date("%B %Y", first_day)
	   end
	   return header, string.format('<span font="%s" foreground="%s">%s</span>',
									theme.font, text_color, result)
	end

	local function calculate_char_width()
	   return beautiful.get_font_height(theme.font) * 0.555
	end

	function hide()
	   if calendar ~= nil then
		  naughty.destroy(calendar)
		  calendar = nil
		  offset = 0
	   end
	end

	function show(inc_offset)
	   inc_offset = inc_offset or 0

	   local save_offset = offset
	   hide()
	   offset = save_offset + inc_offset

	   local char_width = char_width or calculate_char_width()
	   local header, cal_text = create_calendar()
	   calendar = naughty.notify({ title = header,
								   text = cal_text,
								   timeout = 0, hover_timeout = 0.5,
								})
	end

	mytextclock:connect_signal("mouse::enter", function() show(0) end)
	mytextclock:connect_signal("mouse::leave", hide)
	mytextclock:buttons(util.table.join( awful.button({ }, 3, function() show(-1) end),
										 awful.button({ }, 1, function() show(1) end)))

	-- Create a wibox for each screen and add it
	mywibox = {}
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

	--{{{Widgets

	
	   -- CPU widget
	cpuicon = wibox.widget.imagebox()
	cpuicon:set_image(beautiful.widget_cpu)
	cpuwidget = wibox.widget.textbox()
	vicious.register(cpuwidget, vicious.widgets.cpu, '<span font="Terminus 9"><span background="#535d6c" color="#ffffff" font="visitor TT2 BRK 12" > $1% </span> </span>', 3)
	cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(tasks, false) end)))

	
	-- MEM widget
	memicon = wibox.widget.imagebox()
	memicon:set_image(beautiful.widget_mem)
	memwidget = wibox.widget.textbox()
	vicious.register(memwidget, vicious.widgets.mem, ' $2MB ', 13)

	
	    -- Volume widget
	volicon = wibox.widget.imagebox()
	volicon:set_image(beautiful.widget_vol)
	volumewidget = wibox.widget.textbox()
	vicious.register(volumewidget, vicious.widgets.volume,
	function (widget, args)
	  if (args[2] ~= "♩" ) then
	      if (args[1] == 0) then volicon:set_image(beautiful.widget_vol_no)
	      elseif (args[1] <= 50) then volicon:set_image(beautiful.widget_vol_low)
	      else volicon:set_image(beautiful.widget_vol)
	      end
	  else volicon:set_image(beautiful.widget_vol_mute)
	  end
	  return '<span background="#535d6c" font="Terminus 9"><span color="#ffffff" font="visitor TT2 BRK 12">' .. args[1] .. '% </span> </span>'end, 1, "Master")
	
	
	-- Music widget
	mpdwidget = wibox.widget.textbox()
	mpdicon = wibox.widget.imagebox()
	mpdicon:set_image(beautiful.widget_music)
	mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
	
	vicious.register(mpdwidget, vicious.widgets.mpd,
	function(widget, args)
	-- play
	if (args["{state}"] == "Play") then
	    mpdicon:set_image(beautiful.widget_music_on)
	return "<span background='#222222' font='Terminus 9'> <span font='visitor TT2 BRK 12'>" .. "<span color='#e54c62'>" .. args["{Title}"] .. "</span>"  .. "<span color='#b2b2b2'>" .. " - " .. "</span>"  .. "<span color='#b2b2b2'>"  .. args["{Artist}"] .. "</span>" .. " </span></span>"
	-- pause
	elseif (args["{state}"] == "Pause") then
	    mpdicon:set_image(beautiful.widget_music)
	return "<span background='#222222' font='Terminus 9'> <span font='visitor TT2 BRK 12'>" .. "<span color='#b2b2b2'>" .. "Paused" .. "</span>" .. " </span></span>"
	else
	    mpdicon:set_image(beautiful.widget_music)
	return ""
	end
	end, 1)


	--Baterry Widget
	batwidget = wibox.widget.textbox()
	vicious.register(batwidget, vicious.widgets.bat, '<span background="#535d6c" rise="2000" color="#ffffff" font="visitor TT2 BRK 12"> $1 Battery $2% </span> ', 60, "BAT0")

	vicious.cache(vicious.widgets.net)

	
	--Network Widget WLAN
	netwidget = wibox.widget.textbox()
	vicious.register(netwidget, vicious.widgets.net, '<span rise="2000"><span font="visitor TT2 BRK 12">wlan 0 : <span font="visitor TT2 BRK 12" color="#7AC82E">${wlan0 down_kb}</span> Kb </span><span font="Terminus 7" color="#EEDDDD">↓↑</span><span font="visitor TT2 BRK 12"> <span font="visitor TT2 BRK 12" color="#46A8C3">${wlan0 up_kb}</span> Kb</span></span> ', 3)
	neticon = wibox.widget.imagebox()
	neticon:set_image(beautiful.widget_net)
	netwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))


	--Network Widget ETH
	netwidgeteth = wibox.widget.textbox()
	vicious.register(netwidgeteth, vicious.widgets.net, '<span background="#535d6c" rise="2000"><span color="#ffffff" font="visitor TT2 BRK 12"> eth 0 : <span font="visitor TT2 BRK 12" color="#7AC82E">${eth0 down_kb}</span> Kb <span font="Terminus 7">↓↑</span><span color="#ffffff"> <span background="#535d6c" font="visitor TT2 BRK 12" color="#46A8C3">${eth0 up_kb}</span> Kb </span></span></span>', 3)
	netwidgeteth:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))
		
	-- End Widget}}}
	
	
	--{{{ Organize Wiboxes
	
	--- Separators
	spr = wibox.widget.textbox(' ')
	arrl = wibox.widget.imagebox()
	arrl:set_image(beautiful.arrl)
	arrl_dl = wibox.widget.imagebox()
	arrl_dl:set_image(beautiful.arrl_dl)
	arrl_ld = wibox.widget.imagebox()
	arrl_ld:set_image(beautiful.arrl_ld)
	spr = wibox.widget.textbox(' ')
	arrl = wibox.widget.imagebox()
	arrl:set_image(beautiful.arrl)
	arrl_dl = wibox.widget.imagebox()
	arrl_dl:set_image(beautiful.arrl_dl)
	arrl_ld = wibox.widget.imagebox()
	arrl_ld:set_image(beautiful.arrl_ld)	
	
    -- Create the top wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    
    -- Create the bottom wibox (containing most informations) a.k.a. statusbar
    statusbar = awful.wibox({ position = "bottom", screen = 1, height = 14 })
	-- statusbar = awful.wibox({ position = "bottom", screen = 1, ontop = true, width = 1, height = 12 }) -- original exemple



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

   
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    --Widgets are aligned bottom left
    local bleft_layout = wibox.layout.fixed.horizontal()
	bleft_layout:add(batwidget)
   	bleft_layout:add(netwidget) 
   	bleft_layout:add(netwidgeteth) 
	
    --Widgets are aligned bottom right
    local bright_layout = wibox.layout.fixed.horizontal()
   	bright_layout:add(spr)
   	bright_layout:add(arrl)
   	bright_layout:add(arrl)
   	bright_layout:add(mpdicon)
   	bright_layout:add(mpdwidget)


    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spr)
    right_layout:add(arrl_ld)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(arrl_dl)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(arrl_ld)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    if s == 1 then right_layout:add(wibox.widget.systray()) end --Displays the icons of the launched software only on screen 1
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Top line (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
   

    --Bottom line 
    local blayout = wibox.layout.align.horizontal()
    statusbar:set_widget(blayout)
    blayout:set_left(bleft_layout)
    blayout:set_right(bright_layout)
    
    --End Organize Wiboxes}}}
       
-- End Widgets}}}
end

-- {{{ Mouse bindings
	root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)))
-- End Mouse bindings}}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

   
    --{{Personal Key binding 
    	--(Czk Keyboard) ameliorable avec un array de os.execute("setxkbmap country")
    	awful.key({ modkey, "Shift"   }, "!", function () os.execute("setxkbmap us")   end),
    	awful.key({ modkey, "Shift"   }, "/", function () os.execute("setxkbmap fr")   end),
   
    	--lock screen
    	awful.key({ modkey, "Control"   }, "a", function () os.execute("xtrlock")   end),
    --}} 


    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, altkey }, "Right", function () awful.screen.focus_relative( 1) end),--Change the screen focus
    awful.key({ modkey, altkey }, "Left", function () awful.screen.focus_relative(-1) end),--change the screen focus
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    --modification for make thunar the explorer
    awful.key({modkey,		  }, "e", function() awful.util.spawn(explorer) end),

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
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
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
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- End Key bindings}}}


-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
	--rule_any,except,except_any
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
     properties = { floating = true}, 
	},
    -- Iceweasel will be on screen [1] tag[3].
     { rule = { class = "Iceweasel" },
       properties = { tag = tags[1][3] } },
    -- Mumble will be on screen [1] tag[1].
     { rule = { class = "Mumble" },
       properties = { tag = tags[1][1] } },
}
-- End Rules}}}

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

    local titlebars_enabled = false
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

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- End Signals}}


os.execute("killall htop")
awful.util.spawn_with_shell("urxvt -e htop");
os.execute("killall wicd-curses")
awful.util.spawn_with_shell("urxvt -e wicd-curses");
