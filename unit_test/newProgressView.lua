-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newProgressView unit test.

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
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	--Toggle these defines to execute automated tests.
	local TEST_REMOVE_PROGRESS_VIEW = false
	local TEST_DELAY = 1000

	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	-- Create a new progress view object
	local newProgressView = widget.newProgressView
	{
		left = 150,
		top = 200,
		--isAnimated = true,
	}
	group:insert( newProgressView )
	
	local currentProgress = 0.0
	

	timer.performWithDelay( 2000, function( event )
		
		currentProgress = currentProgress + 0.25
		newProgressView:setProgress( currentProgress )
		
	end, 4 )
	
	
	--newProgressView:setProgress( 0.5 )

	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	-- Test removing the progress view
	if TEST_REMOVE_PROGRESS_VIEW then
		timer.performWithDelay( 100, function()
			display.remove( newProgressView )
			
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
