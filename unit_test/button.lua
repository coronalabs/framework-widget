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
	
	--Button to return to unit test listing
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
	
	local oldLabel = nil
	
	-- Handle widget button events
	local onButtonEvent = function (event )
		local phase = event.phase
		local target = event.target
		
		if "began" == phase then
			print( target.id .. " pressed" )
			
			-- Set the old label
			oldLabel = target:getLabel()
			
			-- Set a new label
			target:setLabel( "Hello Corona!" )
    	elseif "ended" == phase then
        	print( target.id .. " released" )
						
			-- Reset the label
			target:setLabel( oldLabel )
    	end
    	
    	return true
	end
	
		
	-- Standard button 
	local topLeftButton = widget.newButton
	{
	    id = "Left Button",
	    left = 0,
	    top = 80,
	    label = "Left",
		labelAlign = "center",
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
	group:insert( topLeftButton )
	
	
	-- Standard button 
	local centerButton = widget.newButton
	{
	    id = "Center Button",
	    left = 0,
	    top = 0,
	    label = "Center",
		labelAlign = "center",
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
	centerButton.x = display.contentCenterX
	centerButton.y = display.contentCenterY
	group:insert( centerButton )
	
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	--Test setting label
	if TEST_SET_LABEL then
		testTimer = timer.performWithDelay( 2000, function()
			topLeftButton:setLabel( "New Label" ) -- "New Label"
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
