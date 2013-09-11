-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newSlider unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_ANDROID_THEME = false
local USE_IOS7_THEME = widget.isSeven()

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	--Display an iOS style background
	local background
	
	if USE_IOS7_THEME then
		background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
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
	local fontUsed = native.systemFont
	
	
	if USE_IOS7_THEME then
		backButtonPosition = 0
		backButtonSize = 40
		fontUsed = "HelveticaNeue-Light"
	end
		
	-- Test android theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end

	-- Button to return to unit test listing
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
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_VALUE = false
	
	--Create some text to show the sliders output
	local sliderResult = display.newEmbossedText( "Slider at 50%", 0, 0, fontUsed, 22 )
	sliderResult:setTextColor( 0 )
	sliderResult:setReferencePoint( display.CenterReferencePoint )
	sliderResult.x = 160
	sliderResult.y = 250
	group:insert( sliderResult )
	
	-- Slider listener function
	local function sliderListener( event )
		--print( "phase is:", event.phase )
		sliderResult:setText( "Slider at " .. event.value .. "%" )
	end

	-- Create a horizontal slider
	local sliderHorizontal = widget.newSlider
	{
		width = 200,
		left = 80,
		top = 300,
		value = 50,
		listener = sliderListener,
	}
	sliderHorizontal.x = display.contentCenterX
	group:insert( sliderHorizontal )
			
	-- Create a vertical slider
	local sliderVertical = widget.newSlider
	{
		height = 150,
		top = 130,
		left = 50,
		value = 80,
		orientation = "vertical",
		listener = sliderListener,
	}
	group:insert( sliderVertical )
		
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	--Test setValue()
	if TEST_SET_VALUE then
		testTimer = timer.performWithDelay( 1000, function()
			sliderHorizontal:setValue( 0 )
			sliderVertical:setValue( 0 )
			sliderResult:setText( "Slider at " .. sliderHorizontal.value .. "%" )
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
