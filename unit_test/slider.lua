-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newSlider unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	-- Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = 5,
	    label = "Exit",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_VALUE = true
	
	--Create some text to show the sliders output
	local sliderResult = display.newEmbossedText( "Slider at 50%", 0, 0, native.systemFontBold, 22 )
	sliderResult:setTextColor( 0 )
	sliderResult:setReferencePoint( display.CenterReferencePoint )
	sliderResult.x = 160
	sliderResult.y = 250
	group:insert( sliderResult )
	
	-- Slider listener function
	local function sliderListener( event )
		--print( "phase is:", event.phase )
		sliderResult:setText( "Slider at " .. event.value .. "%" )
	end

	-- Create a horizontal slider
	local sliderHorizontal = widget.newSlider
	{
		width = 200,
		top = 300,
		left = 50,
		value = 100,
		listener = sliderListener,
	}
	group:insert( sliderHorizontal )
	
		
	-- Create a vertical slider
	local sliderVertical = widget.newSlider
	{
		height = 150,
		top = 130,
		left = 50,
		value = 100,
		orientation = "vertical",
		listener = sliderListener,
	}
	group:insert( sliderVertical )
		
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	--Test setValue()
	if TEST_SET_VALUE then
		testTimer = timer.performWithDelay( 1000, function()
			sliderHorizontal:setValue( 20 ) -- 100%
			sliderResult:setText( "Slider at " .. sliderHorizontal.value .. "%" )
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
