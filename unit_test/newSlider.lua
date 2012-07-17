local widget = require( "widgetnew" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

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
	
	--Toggle these defines to execute tests
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
		top = 300,
		left = 50,
		listener = sliderListener
	}
	group:insert( slider )
	
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	--Test setValue()
	if TEST_SET_VALUE then
		timer.performWithDelay( 1000, function()
			slider:setValue( 100 ) -- 100%
			sliderResult:setText( "Slider at " .. slider.value .. "%" )
		end, 1 )
	end
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
