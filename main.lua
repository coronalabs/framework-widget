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

-- Set the path to the widget library
_G.widgetLibraryPath = "widgetLibrary.widget"

-- For xcode console output
io.output():setvbuf( "no" )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require( "storyboard" )
storyboard.gotoScene( "unitTestListing" )

--storyboard.gotoScene( "tableView" )
