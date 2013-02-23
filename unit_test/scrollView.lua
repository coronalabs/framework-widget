-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newScrollView unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Forward reference for test function timer
local testTimer = nil

local USE_ANDROID_THEME = false

function scene:createScene( event )
	local group = self.view
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	-- Test android theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end

	-- Button to return to unit test listing
	local returnToListing = widget.newButton
	{
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
		
	-- Our ScrollView listener
	local function scrollListener( event )
		local phase = event.phase
		local direction = event.direction
		
		if "began" == phase then
			--print( "Began" )
		elseif "moved" == phase then
			--print( "Moved" )
		elseif "ended" == phase then
			--print( "Ended" )
		end
		
		if event.limitReached then
			if "up" == direction then
				print( "Reached Top Limit" )
			elseif "down" == direction then
				print( "Reached Bottom Limit" )
			elseif "left" == direction then
				print( "Reached Left Limit" )
			elseif "right" == direction then
				print( "Reached Right Limit" )
			end
		end
				
		return true
	end

	-- Create a ScrollView
	local scrollView = widget.newScrollView
	{
		top = 100,
		left = 10,
		width = 300,
		height = 350,
		scrollWidth = 465,
		scrollHeight = 1024,
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
	local background = display.newImageRect( "assets/scrollimage.jpg", 768, 1024 )
	background.x = background.contentWidth * 0.5
	background.y = background.contentHeight * 0.5
	scrollView:insert( background )
	group:insert( scrollView )	


	-- Test set focus
	local function rectTouch( event )
		if "moved" == event.phase then
			scrollView:takeFocus( event )
		end
		
		return true
	end

	local rect = display.newRect( 50, 200, 200, 59 )
	rect:addEventListener( "touch", rectTouch )
	scrollView:insert( rect )
	

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
	
	-- Test getContentPosition()
	if TEST_GET_CONTENT_POSITION then
		testTimer = timer.performWithDelay( 2000, function()
			local x, y = scrollView:getContentPosition()
			print( "ScrollView content position. ( x = ", x, " y = ", y, ")" ) 
			x, y = nil
		end, 1 )
	end
	
	-- Test scrollToPosition()
	if TEST_SCROLL_TO_POSITION then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollToPosition( { x = - 0, y = - 600, time = 800, onComplete = function() print( "scrollToPosition test completed" ) end } )
		end, 1 )
	end	
	
	-- Test scrollToTop()
	if TEST_SCROLL_TO_TOP then		
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "top", { time = 800, onComplete = function() print( "scrollToTop test completed" ) end } )
		end, 1 )
	end
	
	-- Test scrollToBottom()
	if TEST_SCROLL_TO_BOTTOM then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "bottom", { time = 800, onComplete = function() print( "scrollToBottom test completed" ) end } )
		end, 1 )
	end
	
	-- Test scrollToLeft()
	if TEST_SCROLL_TO_LEFT then		
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "left", { time = 800, onComplete =  function() print( "scrollToLeft test completed" ) end }  )
		end, 1 )
	end
	
	-- Test scrollToRight()
	if TEST_SCROLL_TO_RIGHT then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "right", { time = 800, onComplete = function() print( "scrollToRight test completed" ) end } )
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
