-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newScrollView unit test.

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
	
	-- Set a theme
	widget.setTheme( "theme_ios" )
	
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
	local TEST_GET_CONTENT_POSITION = false
	local TEST_SCROLL_TO_POSITION = false
	local TEST_SCROLL_TO_TOP = false
	local TEST_SCROLL_TO_BOTTOM = false
	local TEST_SCROLL_TO_LEFT = false
	local TEST_SCROLL_TO_RIGHT = false
	local TEST_SCROLLVIEW_ON_TOP_OF_EACHOTHER = false
	
	local scrollView
	
	-- Forward reference to scrollView listener
	local function scrollListener( event )
		print( "Event type:", event.phase )
		
		return true
	end

	-- Create scrollView
	scrollView = widget.newScrollView
	{
		top = 100,
		left = 10,
		width = 300,
		height = 350,
		id = "onBottom",
		--topPadding = 80,
		--bottomPadding = 40,
		--leftPadding = 40,
		--rightPadding = 80,
		--hideBackground = true,
		horizontalScrollingDisabled = false,
		verticalScrollingDisabled = false,
		maskFile = "assets/scrollViewMask-350.png",
		listener = scrollListener,
	}
	
	-- insert image into scrollView widget
	local bg = display.newImageRect( "assets/scrollimage2.jpg", 768, 1024 )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x, bg.y = 0, 0
	scrollView:insert( bg )
	group:insert( scrollView )

	if TEST_SCROLLVIEW_ON_TOP_OF_EACHOTHER then
		-- Create scrollView2
		local scrollView2 = widget.newScrollView
		{
			top = 250,
			left = 10,
			width = 300,
			height = 350,
			id = "onTop",
			maskFile = "assets/scrollViewMask-350.png",
			listener = scrollListener,
		}
	
		-- insert image into scrollView widget
		local bg2 = display.newImageRect( "assets/scrollimage.jpg", 768, 1024 )
		bg2:setReferencePoint( display.TopLeftReferencePoint )
		bg2.x, bg2.y = 0, 0
		scrollView2:insert( bg2 )
		group:insert( scrollView2 )
	end

	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	--Test getContentPosition()
	if TEST_GET_CONTENT_POSITION then
		testTimer = timer.performWithDelay( 2000, function()
			local x, y = scrollView:getContentPosition()
			print( "ScrollView content position. ( x = ", x, " y = ", y, ")" ) 
			x, y = nil
		end, 1 )
	end
	
	
	--Test scrollToPosition()
	if TEST_SCROLL_TO_POSITION then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollToPosition( { x = - 0, y = - 600, time = 800, onComplete = function() print( "scrollToPosition test completed" ) end } )
		end, 1 )
	end	
	
	--Test scrollToTop()
	if TEST_SCROLL_TO_TOP then		
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "top", { time = 800, onComplete = function() print( "scrollToTop test completed" ) end } )
		end, 1 )
	end
	
	--Test scrollToBottom()
	if TEST_SCROLL_TO_BOTTOM then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "bottom", { time = 800, onComplete = function() print( "scrollToBottom test completed" ) end } )
		end, 1 )
	end
	
	--Test scrollToLeft()
	if TEST_SCROLL_TO_LEFT then		
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "left", { time = 800, onComplete =  function() print( "scrollToLeft test completed" ) end }  )
		end, 1 )
	end
	
	--Test scrollToRight()
	if TEST_SCROLL_TO_RIGHT then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "right", { position = "right", time = 800, onComplete = function() print( "scrollToRight test completed" ) end } )
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
