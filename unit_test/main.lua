-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: main.lua

-- Change the package.path and make it so we can require the "widget.lua" file from the root directory
-------------------------------------------------------------------------------------------------
local path = package.path

-- get index of first semicolon
local i = string.find( path, ';', 1, true )
if ( i > 0 ) then
	-- first path (before semicolon) is project dir
	local projDir = string.sub( path, 1, i )

	-- assume widget dir is parent to projDir
	local widgetDir = string.gsub( projDir, '(.*)/([^/]?/\?\.lua)', '%1/../%2' )
	package.path = widgetDir .. path
end

package.preload.widget = nil
-------------------------------------------------------------------------------------------------

-- For xcode console output
io.output():setvbuf( "no" )

display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )
storyboard.gotoScene( "unitTestListing" )
