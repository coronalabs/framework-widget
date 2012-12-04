--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		main.lua
--]]

-- Function to copy a file
local function _copyFile( options )
	local sourceFile = options.sourceFile or error( "copyFile - options.sourceFile is either nil or omitted" )
	local sourcePath = options.sourcePath or error( "copyFile - options.sourcePath is either nil or omitted" )
	local destinationFile = options.destinationFile or error( "copyFile - options.destinationFile is either nil or omitted" )
	local destinationPath = options.destinationPath	or error( "copyFile - options.destinationPath is either nil or omitted" )
    local results = true

    -- Copy the source file to the destination file
    local readFilePath = system.pathForFile( sourceFile, sourcePath )
    local writeFilePath = system.pathForFile( destinationFile, destinationPath )
 
    local readHandle = io.open( readFilePath, "rb" )              
    local writeHandle = io.open( writeFilePath, "wb" )
        
    if not writeHandle then
        error( "copyFile - Problem opening write file path" )
        results = false
    else
        -- Read the file from the source directory and write it to the destination directory
        local data = readHandle:read( "*a" )
                
        if not data then
            error( "copyFile - Problem reading data!" )
            results = false
        else
            if not writeHandle:write( data ) then
                print( "copyFile - Problem writing data!" ) 
                results = false
            end
        end
    end
        
    -- Clean up our file handles
    readHandle:close()
    readHandle = nil
    writeHandle:close()
    writeHandle = nil
 
	return results  
end

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

--storyboard.gotoScene( "button" )
