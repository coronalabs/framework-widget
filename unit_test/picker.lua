-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newPickerWheel unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_THEME = true
local USE_ANDROID_THEME = false

function scene:createScene( event )
	local group = self.view
	
	-- Set a theme
	if USE_THEME then
		if USE_ANDROID_THEME then
			widget.setTheme( "theme_android" )
		else
			widget.setTheme( "theme_ios" )
		end
	end
	
	--Display an iOS style background
	local background = display.newImageRect( "assets/background.png", 640, 960 )
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
			startIndex = 5,
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
			align = "center",
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
	
	local function showValues( event )
		local values = pickerWheel:getValues()
		
		--print( values )
		
		---[[
		for i = 1, #values do
			print( "Column", i, "value is:", values[i].value )
			print( "Column", i, "index is:", values[i].index )
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
	

	
	--transition.to( pickerWheel, { y = 100 } )
	
	--[[
	
	-- Create some text to display the chosen values on screen
	local displayedValues = display.newEmbossedText( "Chosen date: ", 0, 0, native.systemFont, 18 )
	displayedValues.x, displayedValues.y = display.contentCenterX, 160
	group:insert( displayedValues )
	
	-- Show picker values on button press
	local function showPickerValues( event )
		-- extract selected rows from pickerWheel columns
		local pickerValues = picker:getValues()
		monthIndex = pickerValues[1].index
		dayIndex = pickerValues[2].index
		yearIndex = pickerValues[3].index
		
		--Set displayed value text
		displayedValues:setText( "Chosen date: " .. pickerValues[1].value .. " " .. pickerValues[2].value .. ", " .. pickerValues[3].value )
		displayedValues.x = display.contentCenterX
		
		--Output to console
		print( "Chosen date: " .. pickerValues[1].value .. " " .. pickerValues[2].value .. ", " .. pickerValues[3].value )
		
		return true
	end

	--Button to print picker values
	local pickerButton = widget.newButton
	{
	    id = "showPickerValues",
	    left = 60,
	    top = 200,
	    label = "Show Values",
	    width = 200, height = 52,
	    onRelease = showPickerValues
	}
	group:insert( pickerButton )
	--]]
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
