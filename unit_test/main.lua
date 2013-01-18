--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		main.lua
--]]

-------------------------------------------------------------------------------------------------
-- Change the package.path and make it so we can require the "widget.lua" file from the root directory
-------------------------------------------------------------------------------------------------
if "simulator" == system.getInfo( "environment" ) then	
	local path = package.path

	-- Get index of first semicolon
	local i = string.find( path, ';', 1, true )
	if i > 0 then
		-- First path (before semicolon) is project dir
		local projDir = string.sub( path, 1, i )

		-- Assume widget dir is parent to projDir
		local widgetDir = string.gsub( projDir, '(.*)/([^/]?/\?\.lua)', '%1/../%2' )
		package.path = widgetDir .. path
	end
end

-------------------------------------------------------------------------------------------------
-- Nil out the widgets loaded from the core so we use the local versions of the files.
-------------------------------------------------------------------------------------------------
package.preload.widget = nil
package.preload.widget_button = nil
package.preload.widget_picker = nil
package.preload.widget_progressView = nil
package.preload.widget_scrollView = nil
package.preload.widget_searchField = nil
package.preload.widget_segmentedControl = nil
package.preload.widget_slider = nil
package.preload.widget_spinner = nil
package.preload.widget_stepper = nil
package.preload.widget_switch = nil
package.preload.widget_tabbar = nil
package.preload.widget_tableview = nil

-- For xcode console output
io.output():setvbuf( "no" )

display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )
storyboard.gotoScene( "unitTestListing" )
