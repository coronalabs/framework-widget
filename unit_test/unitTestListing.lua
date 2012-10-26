local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Set theme
widget.setTheme( "theme_ios" )

function scene:createScene( event )
	storyboard.purgeAll()
	
	local group = self.view
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	--Create a title to make the menu visibly clear
	local title = display.newEmbossedText( "Select a unit test to view", 0, 0, native.systemFont, 20)
	title.x, title.y = display.contentCenterX, 20
	group:insert( title )
	
	local newScrollView = widget.newScrollView{}
	group:insert( newScrollView )
	
	--Go to selected unit test
	local function gotoSelection( event )
		local targetScene = event.target.id
		
		storyboard.gotoScene( targetScene )
		
		return true
	end

	-- spinner unit test
	local newSpinnerButton = widget.newButton{
	    id = "newSpinner",
	    left = 60,
	    top = 50,
	    label = "Spinner",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( newSpinnerButton )
	
	
	-- switch unit test
	local newSwitchButton = widget.newButton{
	    id = "newSwitch",
	    left = 60,
	    top = newSpinnerButton.y + 35,
	    label = "Switch",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( newSwitchButton )
	
	
	-- Stepper unit test
	local newStepperButton = widget.newButton{
	    id = "newStepper",
	    left = 60,
	    top = newSwitchButton.y + 35,
	    label = "Stepper",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( newStepperButton )
	
	
	-- Search field unit test
	local newSearchFieldButton = widget.newButton{
	    id = "newSearchField",
	    left = 60,
	    top = newStepperButton.y + 35,
	    label = "Search Field",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( newSearchFieldButton )
	
	-- progressView unit test
	local newProgressViewButton = widget.newButton{
	    id = "newProgressView",
	    left = 60,
	    top = newSearchFieldButton.y + 35,
	    label = "Progress View",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( newProgressViewButton )
	
	-- segmentedControl unit test
	local newSegmentedControlButton = widget.newButton{
	    id = "newSegmentedControl",
	    left = 60,
	    top = newProgressViewButton.y + 35,
	    label = "Segmented Control",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( newSegmentedControlButton )
	
	--[[
	--NewEmbossedText unit test
	local newEmbossedTextButton = widget.newButton{
	    id = "test_embossedText",
	    left = 60,
	    top = newTabBarButton.y + 35,
	    label = "newEmbossedText",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( newEmbossedTextButton )
	--]]
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
