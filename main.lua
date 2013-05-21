--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
	File: 
		main.lua
--]]

-- Nil out the preloaded theme files so we load the local ones
package.preload.widget_theme_ios = nil
package.preload.widget_theme_ios_sheet = nil
package.preload.widget_theme_android = nil
package.preload.widget_theme_android_sheet = nil

-- set the package path to look for the local versions first
if nil == string.find( package.path, "widgetLibrary/*.lua;", 1, true ) then
	package.path = "widgetLibrary/*.lua;" .. package.path
end

-- Set the path to the widget library
_G.widgetLibraryPath = "widget"

-- For xcode console output
io.output():setvbuf( "no" )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require( "storyboard" )
storyboard.gotoScene( "unitTestListing" )

--storyboard.gotoScene( "tableView" )
