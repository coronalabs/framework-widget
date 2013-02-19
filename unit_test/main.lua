--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
	File: 
		main.lua
--]]

-------------------------------------------------------------------------------------------------
-- Change the package.path and make it so we can require the "widget.lua" file from the root directory
-------------------------------------------------------------------------------------------------
local onDeviceTest = false -- Change this to false if you wish to run this on device

if "simulator" == system.getInfo( "environment" ) and not onDeviceTest then	
	local path = package.path
	
	-- Get index of first semicolon
	local firstPath = string.find( path, ";", 1, true ) -- This is now the plugin path.
	local nextPath = string.find( path, ";", firstPath, true ) -- This is now the correct path
		
	if nextPath > 0 then
		-- Second path (after first semicolon) is project dir
		local projDir = string.sub( path, 1, nextPath )

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
package.preload.widget_scrollview = nil
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

-- Hide the status bar
display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" ); 

---[[
storyboard.gotoScene( "unitTestListing" )
--]]
