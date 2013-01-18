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
	local TEST_SET_BUTTON_ACTIVE = false
	local TEST_IMAGESHEET_TAB_BAR = false
	
	
	-- Create the tabBar's buttons
	local tabButtons = 
	{
		{
			width = 32, 
			height = 32,
			defaultFile = "assets/tabIcon.png",
			overFile = "assets/tabIcon-down.png",
			label = "Tab1",
			--labelXOffset = - 20,
			--labelYOffset = - 20,
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = native.systemFontBold,
			size = 8,
			onPress = function() print( "Tab 1 pressed" ) end,
			selected = false
		},
		{
			width = 32, 
			height = 32,
			defaultFile = "assets/tabIcon.png",
			overFile = "assets/tabIcon-down.png",
			label = "Tab2",
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = native.systemFontBold,
			size = 8,
			onPress = function( event ) print( "Tab 2 pressed" ); print( event.target._id ) end,
			selected = true
		},
		{
			width = 32, 
			height = 32,
			defaultFile = "assets/tabIcon.png",
			overFile = "assets/tabIcon-down.png",
			label = "Tab3",
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = native.systemFontBold,
			size = 8,
			onPress = function() print( "Tab 3 pressed" ) end,
			selected = false
		},
		{
			width = 32, 
			height = 32,
			defaultFile = "assets/tabIcon.png",
			overFile = "assets/tabIcon-down.png",
			label = "Tab4",
			labelColor =
			{
				default = { 0, 0, 0 },
				over = { 255, 255, 255 },
			},
			font = native.systemFontBold,
			size = 8,
			onPress = function() print( "Tab 4 pressed" ) end,
			selected = false
		},
	}
	
	-- Create a tabBar
	local tabBar = widget.newTabBar
	{
		left = 0,
		top = display.contentHeight - 52,
		width = display.contentWidth,
		backgroundFile = "assets/woodbg.png",
		tabSelectedLeftFile = "assets/tabBar_tabSelectedLeftEdge.png",
		tabSelectedRightFile = "assets/tabBar_tabSelectedRightEdge.png",
		tabSelectedMiddleFile = "assets/tabBar_tabSelectedMiddle.png",
		tabSelectedFrameWidth = 20,
		tabSelectedFrameHeight = 100,
		buttons = tabButtons,
	}
	tabBar.isVisible = not TEST_IMAGESHEET_TAB_BAR
	group:insert( tabBar )
	
	
	
	--- IMAGE SHEET TAB BAR
	
	local sheetOptions = require( "assets.tabBar.tabBar" )
	local imageSheet = graphics.newImageSheet( "assets/tabBar/tabBar.png", sheetOptions:getSheet() )
	
	-- Create the tabBar's buttons
	local tabButtonsImageSheet = 
	{
		{
			defaultFrame = sheetOptions:getFrameIndex( "tabBar_iconInactive" ),
			overFrame = sheetOptions:getFrameIndex( "tabBar_iconActive" ),
			label = "Tab1",
			labelXOffset = - 20,
			labelYOffset = - 20,
			onPress = function() print( "Tab 1 pressed" ) end,
			selected = false
		},
		{
			defaultFrame = sheetOptions:getFrameIndex( "tabBar_iconInactive" ),
			overFrame = sheetOptions:getFrameIndex( "tabBar_iconActive" ),
			label = "Tab2",
			onPress = function( event ) print( "Tab 2 pressed" ); print( event.target._id ) end,
			selected = true
		},
		{
			defaultFrame = sheetOptions:getFrameIndex( "tabBar_iconInactive" ),
			overFrame = sheetOptions:getFrameIndex( "tabBar_iconActive" ),
			label = "Tab3",
			onPress = function() print( "Tab 3 pressed" ) end,
			selected = false
		},
		{
			defaultFrame = sheetOptions:getFrameIndex( "tabBar_iconInactive" ),
			overFrame = sheetOptions:getFrameIndex( "tabBar_iconActive" ),
			label = "Tab4",
			onPress = function() print( "Tab 4 pressed" ) end,
			selected = false
		},
	}
	
	-- Create a tabBar
	local tabBarImageSheet = widget.newTabBar
	{
		left = 0,
		top = display.contentHeight - 52,
		width = display.contentWidth,
		sheet = imageSheet,
		backgroundFrame = sheetOptions:getFrameIndex( "tabBar_background" ),
		tabSelectedLeftFrame = sheetOptions:getFrameIndex( "tabBar_tabSelectedLeftEdge" ),
		tabSelectedRightFrame = sheetOptions:getFrameIndex( "tabBar_tabSelectedRightEdge" ),
		tabSelectedMiddleFrame = sheetOptions:getFrameIndex( "tabBar_tabSelectedMiddle" ),
		tabSelectedFrameWidth = 20,
		tabSelectedFrameHeight = 100,
		buttons = tabButtonsImageSheet,
	}
	tabBarImageSheet.isVisible = TEST_IMAGESHEET_TAB_BAR
	group:insert( tabBarImageSheet )
		
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	if TEST_SET_BUTTON_ACTIVE then
		testTimer = timer.performWithDelay( 2000, function()
			if TEST_IMAGESHEET_TAB_BAR then
				tabBarImageSheet:setTabActive( 4 )
			else
				tabBar:setTabActive( 4 )
			end
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
