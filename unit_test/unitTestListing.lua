local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Set theme
widget.setTheme( "theme_ios" )

function scene:createScene( event )
	storyboard.purgeAll() -- Purge
	
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
	local spinnerButton = widget.newButton{
	    id = "spinner",
	    left = 60,
	    top = 50,
	    label = "Spinner",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( spinnerButton )
	
	
	-- switch unit test
	local switchButton = widget.newButton{
	    id = "switch",
	    left = 60,
	    top = spinnerButton.y + 35,
	    label = "Switch",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( switchButton )
	
	
	-- Stepper unit test
	local stepperButton = widget.newButton{
	    id = "stepper",
	    left = 60,
	    top = switchButton.y + 35,
	    label = "Stepper",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( stepperButton )
	
	
	-- Search field unit test
	local searchFieldButton = widget.newButton{
	    id = "searchField",
	    left = 60,
	    top = stepperButton.y + 35,
	    label = "Search Field",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( searchFieldButton )
	
	-- progressView unit test
	local progressViewButton = widget.newButton{
	    id = "progressView",
	    left = 60,
	    top = searchFieldButton.y + 35,
	    label = "Progress View",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( progressViewButton )
	
	-- segmentedControl unit test
	local segmentedControlButton = widget.newButton{
	    id = "segmentedControl",
	    left = 60,
	    top = progressViewButton.y + 35,
	    label = "Segmented Control",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( segmentedControlButton )
	
	-- picker unit test
	local pickerButton = widget.newButton{
	    id = "picker",
	    left = 60,
	    top = segmentedControlButton.y + 35,
	    label = "Picker",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( pickerButton )

end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
