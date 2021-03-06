---------------------------
-- Default awesome theme --
---------------------------

theme = {}

themes_dir = os.getenv("HOME") .. "/.config/awesome/themes/default/"

theme.font          = "visitor TT2 BRK 12"

--Wallpaper
theme.wallpaper = themes_dir .. "/konachan.jpg"


theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#000000"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
theme.taglist_bg_focus = "#535d6c"
theme.taglist_fg_focus = "#ffffff"
theme.tasklist_bg_focus = "#535d6c"

-- Display the taglist squares
theme.taglist_squares_sel   = themes_dir .. "/taglist/squarefw.png"
theme.taglist_squares_unsel = themes_dir .. "/taglist/squarew.png"
theme.taglist_squares_resize = "false"
theme.tasklist_floating_icon = themes_dir .. "/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_border_width = "1"
theme.menu_submenu_icon = themes_dir .. "/submenu.png" --arrow icon
theme.menu_height = "16"
theme.menu_width  = "110"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
--theme.titlebar_close_button_normal = themes_dir .. "/titlebar/close_normal.png"
--theme.titlebar_close_button_focus  = themes_dir .. "/titlebar/close_focus.png"

--theme.titlebar_ontop_button_normal_inactive = themes_dir .. "/titlebar/ontop_normal_inactive.png"
--theme.titlebar_ontop_button_focus_inactive  = themes_dir .. "/titlebar/ontop_focus_inactive.png"
--theme.titlebar_ontop_button_normal_active = themes_dir .. "/titlebar/ontop_normal_active.png"
--theme.titlebar_ontop_button_focus_active  = themes_dir .. "/titlebar/ontop_focus_active.png"

--theme.titlebar_sticky_button_normal_inactive = themes_dir .. "/titlebar/sticky_normal_inactive.png"
--theme.titlebar_sticky_button_focus_inactive  = themes_dir .. "/titlebar/sticky_focus_inactive.png"
--theme.titlebar_sticky_button_normal_active = themes_dir .. "/titlebar/sticky_normal_active.png"
--theme.titlebar_sticky_button_focus_active  = themes_dir .. "/titlebar/sticky_focus_active.png"

--theme.titlebar_floating_button_normal_inactive = themes_dir .. "/titlebar/floating_normal_inactive.png"
--theme.titlebar_floating_button_focus_inactive  = themes_dir .. "/titlebar/floating_focus_inactive.png"
--theme.titlebar_floating_button_normal_active = themes_dir .. "/titlebar/floating_normal_active.png"
--theme.titlebar_floating_button_focus_active  = themes_dir .. "/titlebar/floating_focus_active.png"

--theme.titlebar_maximized_button_normal_inactive = themes_dir .. "/titlebar/maximized_normal_inactive.png"
--theme.titlebar_maximized_button_focus_inactive  = themes_dir .. "/titlebar/maximized_focus_inactive.png"
--theme.titlebar_maximized_button_normal_active = themes_dir .. "/titlebar/maximized_normal_active.png"
--theme.titlebar_maximized_button_focus_active  = themes_dir .. "/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_dir .. "/layouts/fairhw.png"
theme.layout_fairv = themes_dir .. "/layouts/fairvw.png"
theme.layout_floating  = themes_dir .. "/layouts/floatingw.png"
theme.layout_magnifier = themes_dir .. "/layouts/magnifierw.png"
theme.layout_max = themes_dir .. "/layouts/maxw.png"
theme.layout_fullscreen = themes_dir .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_dir .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_dir .. "/layouts/tileleftw.png"
theme.layout_tile = themes_dir .. "/layouts/tilew.png"
theme.layout_tiletop = themes_dir .. "/layouts/tiletopw.png"
theme.layout_spiral  = themes_dir .. "/layouts/spiralw.png"
theme.layout_dwindle = themes_dir .. "/layouts/dwindlew.png"


--Personal icons (awesome menu rc.lua)
theme.awesome_icon = themes_dir .. "../../icons/awesome16.png"

theme.debian_icon = themes_dir .. "/icons/debian_icon16.png"
theme.irc_icon = themes_dir .. "/icons/irssi.png"
theme.vim_icon = themes_dir .. "/icons/vim.png"
theme.restart_icon = themes_dir .. "/icons/restart.png"
theme.web_icon = themes_dir .. "/icons/internet.png"
theme.transm_icon = themes_dir .. "/icons/transmission.png"
theme.skype_icon = themes_dir .. "/icons/skype.png"
theme.switch_icon = themes_dir .. "/icons/switch.png"
theme.comm_icon = themes_dir .. "/icons/commh.png"
theme.filez_icon = themes_dir .. "/icons/filezilla.png"
theme.tunnel_icon = themes_dir .. "/icons/tunnel.png"
--widget
theme.widget_vol = themes_dir .. "/icons/vol.png"
theme.widget_vol_low = themes_dir .. "/icons/vol_low.png"
theme.widget_vol_no = themes_dir .. "/icons/vol_no.png"
theme.widget_vol_mute = themes_dir .. "/icons/vol_mute.png"
theme.widget_cpu = themes_dir .. "/icons/cpu.png"
theme.widget_mem = themes_dir .. "/icons/mem.png"
theme.widget_music = themes_dir .. "/icons/note.png"
theme.widget_music_on = themes_dir .. "/icons/note_on.png"

--separator
theme.arrl = themes_dir .. "/icons/arrl.png"
theme.arrl_dl = themes_dir .. "/icons/arrl_dl.png"
theme.arrl_ld = themes_dir .. "/icons/arrl_ld.png"


 return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
