-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newSwitch unit test.

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

package.preload.widget = nil
-------------------------------------------------------------------------------------------------

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
	--										START OF UNIT TEST													  --
	----------------------------------------------------------------------------------------------------------------	
	
	--Toggle these defines to execute automated tests.
	--local TEST_SOMETHING = true

	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	local function onSwitchPress( event )
		local self = event.target
		
		print( self.id, "is on?:", self.isOn )
	end
		
	local function onSwitchPress2( event )
		local self = event.target
		
		print( self.id, "is on?:", self.isOn )
	end
	
	-- Create a radio switch
	local radioSwitch = widget.newSwitch
	{
		left = 130,
		top = 120,
		style = "radio",
		switchType = "radio",
		id = "Radio button",
		defaultState = true,
		onPress = onSwitchPress,
	}
	group:insert( radioSwitch )
	
	
	-- Create a checkbox switch
	local checkboxSwitch = widget.newSwitch
	{
		left = 130,
		top = 200,
		style = "checkbox",
		switchType = "checkbox",
		id = "Checkbox button",
		onPress = onSwitchPress2,
	}
	group:insert( checkboxSwitch )
	
	local onOffSwitch = widget.newSwitch
	{
		left = 130,
		top = 300,
	}


	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	-- Test starting the spinners animation
	--[[
	if TEST_SOMETHING then
		timer.performWithDelay( 100, function()

			TEST_DELAY = TEST_DELAY + TEST_DELAY
		end )
	end
	--]]
	
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
