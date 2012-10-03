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
	
	--Toggle these defines to execute automated tests.
	local TEST_START_SPINNER = true
	local TEST_PAUSE_SPINNER = true
	local TEST_REMOVE_SPINNER = true
	local TEST_DELAY = 1000
	
	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	-- Create a default spinner (created using theme file)
	local spinner = widget.newSpinner
	{
		left = 100,
		top = 200,
	}
	
	-- Create a custom spinner
	local spinnerCustom = widget.newSpinner
	{
		left = 200,
		top = 200,
		sheet = "assets/customSpinner.png",
		data = "assets.customSpinner",
		start = 1,
		count = 30,
		time = 1000,
	}
	
	-- Create a custom spinner that isn't animated and just rotates
	local spinnerCustomJustRotates = widget.newSpinner
	{
		left = 160,
		top = 350,
		width = 80,
		height = 80,
		image = "assets/loadingCog.png",
		rotateSpeed = 1,
	}	
	
	-- Create a custom spinner
	local spinnerCustomJustRotatesFromImageSheet = widget.newSpinner
	{
		left = 80,
		top = 350,
		width = 35,
		height = 35,
		sheet = "assets/customSpinner.png",
		data = "assets.customSpinner",
		start = 1,
		count = 1,
		rotateSpeed = -1,
	}


	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	-- Test starting the spinners animation
	if TEST_START_SPINNER then
		timer.performWithDelay( 100, function()
			spinner:start()
			spinnerCustom:start()
			spinnerCustomJustRotates:start()
			spinnerCustomJustRotatesFromImageSheet:start()
		end )
	end
	
	-- Test pausing the spinners animation
	if TEST_PAUSE_SPINNER then
		timer.performWithDelay( TEST_DELAY, function()
			spinner:pause()
			spinnerCustomJustRotates:pause()
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
	end
	
	
	-- Test removing the spinner
	if TEST_REMOVE_SPINNER then
		timer.performWithDelay( TEST_DELAY, function()
			spinner:removeSelf()
			spinner = nil
			spinnerCustomJustRotates:start()
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
