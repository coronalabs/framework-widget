-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newSlider unit test.

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
	    top = 50,
	    label = "Return To Menu",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_VALUE = true
	
	--Create some text to show the sliders output
	local sliderResult = display.newEmbossedText( "Slider at 50%", 0, 0, native.systemFontBold, 22 )
	sliderResult:setTextColor( 0 )
	sliderResult:setReferencePoint( display.CenterReferencePoint )
	sliderResult.x = 160
	sliderResult.y = 250
	group:insert( sliderResult )
	
	--Slider listener function
	local function sliderListener( event )
		sliderResult:setText( "Slider at " .. event.value .. "%" )
	end
	
	--Create the slider
	local slider = widget.newSlider{
		top = 300,						--Test setting top position.
		left = 50,						--Test setting left position.
		listener = sliderListener		--Test setting event handler.
	}
	group:insert( slider )
	
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	--Test setValue()
	if TEST_SET_VALUE then
		testTimer = timer.performWithDelay( 1000, function()
			slider:setValue( 100 ) -- 100%
			sliderResult:setText( "Slider at " .. slider.value .. "%" )
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
