local widget = require( "widgetnew" )
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
	    top = 50,
	    label = "Return To Menu",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST													  --
	----------------------------------------------------------------------------------------------------------------
	
	--[[
	
	RECENT CHANGES/THINGS TO REVIEW:
	
	1) CHANGE/FEATURE NAME. 
	
	How: HOW TO TEST CHANGE.
	Expected behavior: EXPECTED BEHAVIOR OF CHANGE.

	--]]
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_TEXT = false
	local TEST_SET_SIZE = true
	
	local myText = display.newEmbossedText( "Embossed Text", 0, 0, native.systemFont, 28 )
	myText.x, myText.y = display.contentCenterX, display.contentCenterY
	myText:setTextColor( 0 )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	--Test setText()
	if TEST_SET_TEXT then
		testTimer = timer.performWithDelay( 2000, function()
			myText:setText( "Hello World!" ) -- Hello World!
		end, 1 )
	end
	
	--Test set size
	if TEST_SET_SIZE then
		testTimer = timer.performWithDelay( 2000, function()
			myText.size = 40 -- 40px
			print( "changing size" )
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
