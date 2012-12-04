-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newTabBar unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

function scene:createScene( event )
	local group = self.view
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = 50,
	    label = "Return To Menu",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	
	-- create buttons table for the tab bar
	
	--print(  )
	
	local tabButtons = {
		{
			--label = "Tab1",
			--width = 32, height = 32,
			--onPress = function() print( "Tab 1 pressed" ) end,
			selected = true
		},
		
		{
			--label = "Tab2",
			--width = 32, height = 32,
			--onPress = function() print( "Tab 1 pressed" ) end,
			selected = true
		},
	}
	
	
	-- create a tab-bar and place it at the bottom of the screen
	local tabBar = widget.newTabBar
	{
		top = display.contentHeight-50,
		buttons = tabButtons,
		width = display.contentWidth,
		height = 50,
		--maxTabWidth = 120,
	}
	group:insert( tabBar )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	--[[
	timer.performWithDelay( 2000, function()
		end, 1 )
	--]]
	
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
