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

-- Nil out the widgets loaded from the core so we use the local versions of the files.
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

-------------------------------------------------------------------------------------------------

-- For xcode console output
io.output():setvbuf( "no" )

display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )
storyboard.gotoScene( "unitTestListing" )

--storyboard.gotoScene( "switch" )
