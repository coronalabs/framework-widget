-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newSpinner unit test.

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
	local TEST_START_SPINNER = true
	local TEST_PAUSE_SPINNER = false
	local TEST_MOVE_SPINNER = false
	local TEST_TRANSLATE_SPINNER = false
	local TEST_REMOVE_SPINNER = false
	local TEST_DELAY = 1000
	
	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	-- Create a default spinner (created using theme file) - (Single Rotating Image)
	local spinnerDefault = widget.newSpinner
	{
		left = 150,
		top = 130,
	}
	group:insert( spinnerDefault )
	
	local spinnerText = display.newText( "Default spinner (From theme)\nSingle Rotating Image", 0, 0, display.contentWidth, 0, native.systemFontBold, 14 )
	spinnerText.x = display.contentCenterX
	spinnerText.y = spinnerDefault.y - 42
	group:insert( spinnerText )
	
	-- Create a custom spinner (Animating sprite from imagesheet)
	local spinnerCustom = widget.newSpinner
	{
		left = 150,
		top = 230,
		sheet = "assets/customSpinner.png",
		data = "assets.customSpinner",
		start = 1,
		count = 30,
		time = 1000,
	}
	group:insert( spinnerCustom )
	
	local spinnerCustomText = display.newText( "Custom spinner (Custom graphics)\nAnimating sprite from imagesheet", 0, 0, display.contentWidth, 0, native.systemFontBold, 14 )
	spinnerCustomText.x = display.contentCenterX
	spinnerCustomText.y = spinnerCustom.y - 42
	group:insert( spinnerCustomText )
	
	-- Create a custom spinner that isn't animated and just rotates - (Single Rotating Image)
	local spinnerCustomJustRotates = widget.newSpinner
	{
		left = 150,
		top = 330,
		width = 80,
		height = 80,
		image = "assets/loadingCog.png",
		deltaAngle = 1,
	}	
	group:insert( spinnerCustomJustRotates )
	
	local spinnerCustomJustRotatesText = display.newText( "Custom spinner (Custom graphics)\nSingle Rotating Image", 0, 0, display.contentWidth, 0, native.systemFontBold, 14 )
	spinnerCustomJustRotatesText.x = display.contentCenterX
	spinnerCustomJustRotatesText.y = spinnerCustomJustRotates.y - 62
	group:insert( spinnerCustomJustRotatesText )
	
	-- Create a custom spinner that isn't animated and just rotates - (Single Rotating Image from imagesheet)
	local spinnerCustomJustRotatesFromImageSheet = widget.newSpinner
	{
		left = 150,
		top = 440,
		width = 35,
		height = 35,
		sheet = "assets/customSpinner.png",
		data = "assets.customSpinner",
		start = 1,
		count = 1,
		deltaAngle = -1,
	}
	group:insert( spinnerCustomJustRotatesFromImageSheet )
	
	local spinnerCustomJustRotatesFromImageSheetText = display.newText( "Custom spinner (Custom graphics)\nSingle Rotating Image from imagesheet", 0, 0, display.contentWidth, 0, native.systemFontBold, 14 )
	spinnerCustomJustRotatesFromImageSheetText.x = display.contentCenterX
	spinnerCustomJustRotatesFromImageSheetText.y = spinnerCustomJustRotatesFromImageSheet.y - 42
	group:insert( spinnerCustomJustRotatesFromImageSheetText )


	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	-- Test starting the spinners animation
	if TEST_START_SPINNER then
		timer.performWithDelay( 100, function()
			spinnerDefault:start()
			spinnerCustom:start()
			spinnerCustomJustRotates:start()
			spinnerCustomJustRotatesFromImageSheet:start()
		end )
	end
	
	-- Test pausing the spinners animation
	if TEST_PAUSE_SPINNER then
		timer.performWithDelay( TEST_DELAY, function()
			spinnerDefault:stop()
			spinnerCustom:stop()
			spinnerCustomJustRotates:stop()
			spinnerCustomJustRotatesFromImageSheet:stop()
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
	end
	
	-- Test moving the spinners animation
	if TEST_MOVE_SPINNER then
		timer.performWithDelay( TEST_DELAY, function()
			spinnerDefault:translate( 20, 20 )
			spinnerCustom:translate( 20, 20 )
			spinnerCustomJustRotates:translate( 20, 20 )
			spinnerCustomJustRotatesFromImageSheet:translate( 20, 20 )
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
	end
	
	-- Test moving the spinners animation
	if TEST_TRANSLATE_SPINNER then
		timer.performWithDelay( TEST_DELAY, function()
			transition.to( spinnerDefault, { x = 100, y = 100 } )
			transition.to( spinnerCustom, { x = 100, y = 100 } )
			transition.to( spinnerCustomJustRotates, { x = 100, y = 100 } )
			transition.to( spinnerCustomJustRotatesFromImageSheet, { x = 100, y = 100 } )
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
	end
	
	-- Test removing the spinner
	if TEST_REMOVE_SPINNER then
		timer.performWithDelay( TEST_DELAY, function()
			spinnerDefault:removeSelf()
			spinnerDefault = nil
			spinnerCustom:removeSelf()
			spinnerCustom = nil
			spinnerCustomJustRotates:removeSelf()
			spinnerCustomJustRotates = nil
			spinnerCustomJustRotatesFromImageSheet:removeSelf()
			spinnerCustomJustRotatesFromImageSheet = nil
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
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
