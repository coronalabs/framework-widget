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
	local TEST_SET_LABEL = true
	
	--Handle widget button events
	local onButtonEvent = function (event )
		local phase = event.phase
		local target = event.target
		
		if phase == "press" then
			print( target.id .. " pressed" )
    	elseif phase == "release" then
        	print( target.id .. " released" )
    	end
    	
    	return true
	end

	--Standard button
	local defaultButton = widget.newButton{
	    id = "Default_Button",			--Test setting id.
	    left = 60,						--Test setting left position.
	    top = 250,						--Test setting top position.
	    label = "Default Button",		--Test setting label.
	    width = 200, height = 52,		--Test setting width/height.
	    cornerRadius = 8,				--Test setting corner radius.
	    onEvent = onButtonEvent			--Test setting event handler.
	}
	group:insert( defaultButton )

	
	--Custom button using two images (default and over)
	local customButton = widget.newButton{
	    id = "Custom_Button",					--Test setting id.
	    left = 60,								--Test setting left position.
	    top = defaultButton.y + 50,				--Test setting top position.
	    label = "Custom Button",				--Test setting label.
	    default = "assets/buttonBlue.png",		--Test setting default image.
	    over = "assets/buttonBlueOver.png",		--Test setting over image.
	    width = 200, height = 60,				--Test setting width/height.
	    cornerRadius = 8,						--Test setting corner radius.
	    onEvent = onButtonEvent					--Test setting event handler.
	}
	group:insert( customButton )
	
	
	--Custom button using imagesheet
	local sheetOptions = {
		width = 200, 
	    height = 60,
	    numFrames = 2,
	   	sheetContentWidth = 200,
	    sheetContentHeight = 120
	}
    local buttonSheet = graphics.newImageSheet( "assets/buttonRedSheet.png", sheetOptions )
	
	local imageSheetButton = widget.newButton{
		sheet = buttonSheet,			--Test setting imageSheet.
        defaultIndex = 1,				--Test setting imageSheet default button index.
        overIndex = 2,					--Test setting imageSheet over button index.
	    id = "ImageSheet_Button",		--Test setting id.
	    left = 60,						--Test setting left position.
	    top = customButton.y + 50,		--Test setting top position.
	    label = "ImageSheet Button",	--Test setting label.
	    width = 200, height = 60,		--Test setting width/height.
	    cornerRadius = 8,				--Test setting corner radius.
	    onEvent = onButtonEvent			--Test setting event handler.
	}
	group:insert( imageSheetButton )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	--Test setting label
	if TEST_SET_LABEL then
		timer.performWithDelay( 2000, function()
			defaultButton:setLabel( "New Label" ) -- "New Label"
		end, 1 )		
	end
	
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
