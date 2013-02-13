-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newEmbossedText unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	widget.setTheme( "theme_ios" )
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	-- Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 0,
	    top = 5,
	    label = "Exit",
		labelAlign = "center",
		fontSize = 18,
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_TEXT = false
	local TEST_SET_SIZE = false
	
	local myText = widget.embossedText( "Embossed Text", 0, 0, native.systemFont, 28 )
	myText.x = display.contentCenterX
	myText.y = display.contentCenterY
	myText:setTextColor( 255 )
	group:insert( myText )

	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	--Test setText()
	if TEST_SET_TEXT then
		testTimer = timer.performWithDelay( 2000, function()
			myText:setText( "Hello World!" )
		end, 1 )
	end
	
	--Test set size
	if TEST_SET_SIZE then
		testTimer = timer.performWithDelay( 2000, function()
			myText:setSize( 40 )
		end, 1 )
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
