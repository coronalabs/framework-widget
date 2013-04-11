--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
	File: 
		main.lua
--]]

-- Set the path to the widget library
_G.widgetLibraryPath = "widgetLibrary.widget"

-- For xcode console output
io.output():setvbuf( "no" )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require( "storyboard" )
storyboard.gotoScene( "unitTestListing" )

--storyboard.gotoScene( "tableView" )
