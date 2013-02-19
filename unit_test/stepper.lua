-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newStepper unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_THEME = true
local USE_ANDROID_THEME = false

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	-- Set a theme
	if USE_THEME then
		if USE_ANDROID_THEME then
			widget.setTheme( "widget_theme_android" )
		else
			widget.setTheme( "widget_theme_ios" )
		end
	end
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = 10,
	    label = "Return To Menu",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------	
	--Toggle these defines to execute automated tests.
	local TEST_REMOVE_STEPPER = false
	local TEST_DELAY = 1000
	
	local startAtNumber = 2
	
	local numberText = display.newText( "0000", 0, 0, native.systemFontBold, 24 )
	numberText.x = display.contentCenterX
	numberText.y = 140
	numberText.no = startAtNumber
	group:insert( numberText )
	
	local function onPress( event )
		local phase = event.phase

		if "increment" == phase then
			numberText.no = numberText.no + 1
		elseif "decrement" == phase then
			numberText.no = numberText.no - 1
		end
	
		print( "current value is:", event.value )
		print( "minimum value is:", event.minimumValue )
		print( "maximum value is:", event.maximumValue )

		numberText.text = string.format( "%04d", numberText.no )
	end
		
	
	local newStepper = widget.newStepper
	{
		id = "dy",
		left = 100,
		top = 100,
		initialValue = startAtNumber,
		minimumValue = 0,
		maximumValue = 25,
		onPress = onPress,
	}
	newStepper.x = display.contentCenterX
	group:insert( newStepper )
	
	-- Update the intial text
	numberText.text = string.format( "%04d", startAtNumber )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	-- Test removing stepper
	if TEST_REMOVE_STEPPER then
		timer.performWithDelay( 100, function()
			display.remove( newStepper )
			
			TEST_DELAY = TEST_DELAY + TEST_DELAY
		end )
	end

	
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
