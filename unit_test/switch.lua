-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newSwitch unit test.

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
	local TEST_SET_STATE = false
	local TEST_DELAY = 1000
	
	local radioGroup = {}
	
	local function onRadioPress( event )
		local self = event.target

		-- Turn off other radio buttons in this set
		--[[
		for k, v in pairs( radioGroup ) do
			if radioGroup[k].id ~= self.id then
				radioGroup[k]:setState( { isOn = false } )
			end
		end
		--]]

		print( self.id, "is on?:", self.isOn )
	end
		
	local function onCheckBoxPress( event )
		local self = event.target
		
		print( self.id, "is on?:", self.isOn )
	end
	
	local function onOnOffPress( event )
		local self = event.target
		
		print( self.id, "is on?:", self.isOn )
		
		--display.remove( self )
	end
		
	
	
	-- Create a radio switch
	local radioButton = widget.newSwitch
	{
		left = 0,
		top = 120,
		style = "radio",
		id = "Radio button1",
		initialSwitchState = true,
		radioSet = radioGroup,
		onPress = onRadioPress,
	}
	radioButton.x = display.contentCenterX
	group:insert( radioButton )
	
	-- Create a radio switch
	local radioButton2 = widget.newSwitch
	{
		left = 80,
		top = 120,
		style = "radio",
		id = "Radio button2",
		initialSwitchState = false,
		radioSet = radioGroup,
		onPress = onRadioPress,
	}
	--radioButton2.x = display.contentCenterX + 80
	group:insert( radioButton2 )
	
	
	
	-- Create a radio switch
	local radioButton3 = widget.newSwitch
	{
		left = 20,
		top = 120,
		style = "radio",
		id = "Radio button3",
		initialSwitchState = false,
		radioSet = radioGroup,
		onPress = onRadioPress,
	}
	--radioButton2.x = display.contentCenterX + 80
	group:insert( radioButton3 )
	
	
	
	
	
	---- other
	local otherRadioGroup = {}
	
	-- Create a radio switch
	local radioButtonOther = widget.newSwitch
	{
		left = 20,
		top = 160,
		style = "radio",
		id = "Radio button4",
		initialSwitchState = false,
		radioSet = otherRadioGroup,
		onPress = onRadioPress,
	}
	--radioButton2.x = display.contentCenterX + 80
	group:insert( radioButtonOther )
	
	-- Create a radio switch
	local radioButtonOther2 = widget.newSwitch
	{
		left = 80,
		top = 160,
		style = "radio",
		id = "Radio button4",
		initialSwitchState = false,
		radioSet = otherRadioGroup,
		onPress = onRadioPress,
	}
	--radioButton2.x = display.contentCenterX + 80
	group:insert( radioButtonOther2 )
	
	
	
	
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
		initialSwitchState = true,
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
	
	-- Test toggling the switch programatically
	if TEST_SET_STATE then
		timer.performWithDelay( 1000, function()
			onOffSwitch:setState( { isOn = false, isAnimated = true, onComplete = onOnOffPress } )
			checkboxButton:setState( { isOn = true, isAnimated = true, onComplete = onCheckBoxPress } )
		end)
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
