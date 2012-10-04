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
	    top = 10,
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
	--local TEST_SOMETHING = true

	-- Set a theme
	widget.setTheme( "theme_ios" )
	
	local function onSwitchPress( event )
		local self = event.target
		
		print( self.id, " state is: ", self:getState() )
	end
		
	
	-- Create a radio switch
	local radioSwitch = widget.newSwitch
	{
		left = 130,
		top = 120,
		--default = "assets/radioButtonDefault.png",
		--selected = "assets/radioButtonSelected.png",
		style = "radio",
		switchType = "radio",
		id = "Radio button",
		onPress = onSwitchPress,
	}
	group:insert( radioSwitch )
	
	
	-- Create a checkbox switch
	local checboxSwitch = widget.newSwitch
	{
		left = 130,
		top = 200,
		--default = "assets/checkboxDefault.png",
		--selected = "assets/checkboxSelected.png",
		style = "checkbox",
		switchType = "checkbox",
		id = "Checkbox button",
		onPress = onSwitchPress,
	}
	group:insert( radioSwitch )


	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	-- Test starting the spinners animation
	--[[
	if TEST_SOMETHING then
		timer.performWithDelay( 100, function()

			TEST_DELAY = TEST_DELAY + TEST_DELAY
		end )
	end
	--]]
	
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
