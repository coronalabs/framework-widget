-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newTabBar unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	--Button to return to unit test listing
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
	
	-- Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_BUTTON_ACTIVE = true
	
	-- Create the tabBar's buttons
	local tabButtons = 
	{
		{
			iconInactiveFrame = "tabBar_iconInactive",
			iconActiveFrame = "tabBar_iconActive",
			label = "Tab1",
			onPress = function() print( "Tab 1 pressed" ) end,
			selected = false
		},
		{
			iconInactiveFrame = "tabBar_iconInactive",
			iconActiveFrame = "tabBar_iconActive",
			label = "Tab2",
			onPress = function() print( "Tab 2 pressed" ) end,
			selected = true
		},
		{
			iconInactiveFrame = "tabBar_iconInactive",
			iconActiveFrame = "tabBar_iconActive",
			label = "Tab3",
			--labelColor = { 255, 0, 0 },
			--labelFont = native.systemFontBold,
			--labelSize = 12,
			onPress = function() print( "Tab 3 pressed" ) end,
			selected = false
		},
		{
			iconInactiveFrame = "tabBar_iconInactive",
			iconActiveFrame = "tabBar_iconActive",
			label = "Tab4",
			onPress = function() print( "Tab 4 pressed" ) end,
			selected = false
		},
	}
	
	-- Create a tabBar
	local tabBar = widget.newTabBar
	{
		left = 0,
		top = display.contentHeight - 50,
		width = display.contentWidth,
		buttons = tabButtons,
	}
	group:insert( tabBar )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	if TEST_SET_BUTTON_ACTIVE then
		testTimer = timer.performWithDelay( 2000, function()
			tabBar:setTabActive( 4 )
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
