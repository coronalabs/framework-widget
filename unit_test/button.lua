-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newButton unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	--Display an iOS style background
	local background = display.newImageRect( "assets/background.png", 640, 960 )
	group:insert( background )
	
	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	-- Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 0,
	    top = 5,
	    label = "Exit",
		labelAlign = "center",
		fontSize = 18,
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	-- Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_LABEL = false
		
	-- Handle widget button events
	local onButtonEvent = function (event )
		local phase = event.phase
		local target = event.target
		
		if "began" == phase then
			print( target.id .. " pressed" )
						
			-- Set a new label
			target:setLabel( "Hello Corona!" )
    	elseif "ended" == phase then
        	print( target.id .. " released" )
						
			-- Reset the label
			target:setLabel( target.oldLabel )
    	end
    	
    	return true
	end
	
		
	-- Standard button 
	local buttonUsingFiles = widget.newButton
	{
		defaultFile = "assets/default.png",
		overFile = "assets/over.png",
	    id = "Left Label Button",
	    left = 0,
	    top = 120,
	    label = "Files",
		labelAlign = "left",
		fontSize = 18,
		labelColor =
		{ 
			default = { 0, 0, 0 },
			over = { 255, 255, 255 },
		},
	    onEvent = onButtonEvent
	}
	buttonUsingFiles.x = display.contentCenterX
	buttonUsingFiles.oldLabel = "Files"	
	group:insert( buttonUsingFiles )

	-- Set up sheet parameters for imagesheet button
	local sheetInfo =
	{
		width = 200,
		height = 60,
		numFrames = 2,
		sheetContentWidth = 200,
		sheetContentHeight = 120,
	}
	
	-- Create the button sheet
	local buttonSheet = graphics.newImageSheet( "assets/btnBlueSheet.png", sheetInfo )

	
	-- ImageSheet button 
	local buttonUsingImageSheet = widget.newButton
	{
		sheet = buttonSheet,
		defaultFrame = 1,
		overFrame = 2,
	    id = "Centered Label Button",
	    left = 60,
	    top = 200,
	    label = "ImageSheet",
		labelAlign = "center",
		fontSize = 18,
		labelColor =
		{ 
			default = { 255, 255, 255 },
			over = { 255, 0, 0 },
		},
	    onEvent = onButtonEvent
	}
	buttonUsingImageSheet.x = display.contentCenterX
	buttonUsingImageSheet.oldLabel = "ImageSheet"	
	group:insert( buttonUsingImageSheet )
		

	-- Theme button 
	local buttonUsingTheme = widget.newButton
	{
	    id = "Right Label Button",
	    left = 0,
	    top = 280,
	    label = "Theme",
		labelAlign = "right",
	    width = 140, 
		height = 50,
		fontSize = 18,
		labelColor =
		{ 
			default = { 0, 0, 0 },
			over = { 255, 255, 255 },
		},
	    onEvent = onButtonEvent
	}
	buttonUsingTheme.oldLabel = "Theme"
	buttonUsingTheme.x = display.contentCenterX
	group:insert( buttonUsingTheme )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	--Test setting label
	if TEST_SET_LABEL then
		testTimer = timer.performWithDelay( 2000, function()
			buttonUsingTheme:setLabel( "New Label" ) -- "New Label"
		end, 1 )		
	end
	
end

function scene:exitScene( event )
	--Cancel test timer if active
	if testTimer ~= nil then
		timer.cancel( testTimer )
		testTimer = nil
	end
	
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
