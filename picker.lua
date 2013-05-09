-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newPickerWheel unit test.

local widget = require( _G.widgetLibraryPath )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_ANDROID_THEME = false

function scene:createScene( event )
	local group = self.view
	
	-- Test android theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end
	
	--Display an iOS style background
	local background = display.newImageRect( "unitTestAssets/background.png", 640, 960 )
	group:insert( background )
	
	-- Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = 5,
	    label = "Exit",
	    width = 200, height = 52,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	local days = {}
	local years = {}
	
	for i = 1, 31 do
		days[i] = i
	end
	
	for i = 1, 44 do
		years[i] = 1969 + i
	end
	
	-- Set up the Picker Wheel's columns
	local columnData = 
	{ 
		{ 
			align = "right",
			width = 150,
			startIndex = 1,
			labels = 
			{
				"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
			},
		},
		
		{
			align = "left",
			width = 60,
			startIndex = 18,
			labels = days,
		},
		
		{
			align = "right",
			width = 80,
			startIndex = 10,
			labels = years,
		},
	}
		
	-- Create a new Picker Wheel
	local pickerWheel = widget.newPickerWheel
	{
		top = display.contentHeight - 222,
		font = native.systemFontBold,
		columns = columnData,
	}
	group:insert( pickerWheel )
	
	-- Scroll the second column to it's 8'th row
	--pickerWheel:scrollToIndex( 2, 8, 0 )
		
	
	local function showValues( event )		
		local values = pickerWheel:getValues()
		
		--print( values )
		
		---[[
		for i = 1, #values do
			print( "Column", i, "value is:", values[i].value )
			--print( "Column", i, "index is:", values[i].index )
		end
		--]]
		
		return true
	end
	
	
	local getValuesButton = widget.newButton{
	    id = "getValues",
	    left = 60,
	    top = 80,
	    label = "Values",
	    width = 100, height = 52,
	    onRelease = showValues;
	}
	returnToListing.x = display.contentCenterX
	group:insert( getValuesButton )
end

function scene:didExitScene( event )
	--Cancel test timer if active
	if testTimer ~= nil then
		timer.cancel( testTimer )
		testTimer = nil
	end
	
	storyboard.removeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "didExitScene", scene )

return scene
