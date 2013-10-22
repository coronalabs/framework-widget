-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newProgressView unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_ANDROID_THEME = false
local USE_IOS7_THEME = widget.isSeven()
local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

local xAnchor, yAnchor

if not isGraphicsV1 then
	xAnchor = display.contentCenterX
	yAnchor = display.contentCenterY
else
	xAnchor = 0
	yAnchor = 0
end

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	-- Test android theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end
	
	--Display an iOS style background
	local background
	
	if USE_IOS7_THEME then
		background = display.newRect( xAnchor, yAnchor, display.contentWidth, display.contentHeight )
	else
		background = display.newImage( "unitTestAssets/background.png" )
	end
	
	group:insert( background )
	
	if USE_IOS7_THEME then
		-- create a white background, 40px tall, to mask / hide the scrollView
		local topMask = display.newRect( 0, 0, display.contentWidth, 40 )
		topMask:setFillColor( 235, 235, 235, 255 )
		group:insert( topMask )
	end

	local backButtonPosition = 5
	local backButtonSize = 52
	
	if USE_IOS7_THEME then
		backButtonPosition = 0
		backButtonSize = 40
	end
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = display.contentWidth * 0.5,
	    top = backButtonPosition,
	    label = "Exit",
	    width = 200, height = backButtonSize,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	--Toggle these defines to execute automated tests.
	local TEST_REMOVE_PROGRESS_VIEW = false
	local TEST_RESET_PROGRESS_VIEW = true
	local TEST_RESIZE_PROGRESS_VIEW = false
	local TEST_DELAY = 1000
		
	-- Create a new progress view object
	local newProgressView = widget.newProgressView
	{
		left = 0,
		top = 20,
		width = 150,
		isAnimated = true,
	}
	newProgressView.x = display.contentWidth * 0.5 
	newProgressView.y = display.contentCenterY
	
	if TEST_RESIZE_PROGRESS_VIEW then
		newProgressView:resizeView( 250 )
	end
	
	group:insert( newProgressView )
		
	local currentProgress = 0.0

	testTimer = timer.performWithDelay( 100, function( event )
		currentProgress = currentProgress + 0.01
		newProgressView:setProgress( currentProgress )
		
		if TEST_RESET_PROGRESS_VIEW then
			if newProgressView:getProgress() >= 0.5 then
				newProgressView:setProgress( 0 )
				currentProgress = 0.0
			end
		end
		
		--print( newProgressView:getProgress() )
	end, 0 )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	-- Test removing the progress view
	if TEST_REMOVE_PROGRESS_VIEW then
		testTimer = timer.performWithDelay( 100, function()
			display.remove( newProgressView )
			
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
