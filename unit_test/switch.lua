-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newSwitch unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton
	{
	    id = "returnToListing",
	    left = 60,
	    top = 10,
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
	
	--Toggle these defines to execute automated tests.
	local TEST_REMOVE_SWITCH = false
	local TEST_DELAY = 1000
	
	local function onRadioPress( event )
		local self = event.target

		print( self.id, "is on?:", self.isOn )
	end
		
	local function onCheckBoxPress( event )
		local self = event.target
		
		print( self.id, "is on?:", self.isOn )
	end
	
	local function onOnOffPress( event )
		local self = event.target
		
		print( self.id, "is on?:", self.isOn )
		
		display.remove( self )
	end
	
	
	-- Create a radio switch
	local radioButton = widget.newSwitch
	{
		left = 0,
		top = 120,
		style = "radio",
		id = "Radio button",
		initialSwitchState = true,
		onPress = onRadioPress,
	}
	radioButton.x = display.contentCenterX
	group:insert( radioButton )
	
	
	-- Create a checkbox switch
	local checkboxButton = widget.newSwitch
	{
		left = 0,
		top = 200,
		style = "checkbox",
		id = "Checkbox button",
		onPress = onCheckBoxPress,
	}
	checkboxButton.x = display.contentCenterX
	group:insert( checkboxButton )
	
	local onOffSwitch = widget.newSwitch
	{
		left = 0,
		top = 300,
		style = "onOff",
		--initialSwitchState = true,
		onRelease = onOnOffPress
	}
	onOffSwitch.x = display.contentCenterX
	group:insert( onOffSwitch )

	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	-- Test removing switch
	if TEST_REMOVE_SWITCH then
		timer.performWithDelay( 100, function()
			display.remove( radioButton )
			display.remove( checkboxButton )
			display.remove( onOffSwitch )
			
			TEST_DELAY = TEST_DELAY + TEST_DELAY
		end )
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
