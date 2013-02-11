local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Set theme
widget.setTheme( "theme_ios" )

function scene:createScene( event )	
	local group = self.view
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	--Create a title to make the menu visibly clear
	local title = display.newEmbossedText( "Select a unit test to view", 0, 0, native.systemFont, 20)
	title.x, title.y = display.contentCenterX, 20
	group:insert( title )
	
	local newScrollView = widget.newScrollView
	{
		top = 40,
		width = display.contentWidth,
		height = display.contentHeight,
		scrollHeight = display.contentHeight - 180,
		horizontalScrollDisabled = true,
		hideBackground = true,
	}
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
	    left = 50,
	    top = 10,
	    label = "Spinner",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( spinnerButton )
	
	
	-- switch unit test
	local switchButton = widget.newButton{
	    id = "switch",
	    left = 50,
	    top = spinnerButton.y + 30,
	    label = "Switch",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( switchButton )
	
	
	-- Stepper unit test
	local stepperButton = widget.newButton{
	    id = "stepper",
	    left = 50,
	    top = switchButton.y + 30,
	    label = "Stepper",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( stepperButton )
	
	
	-- Search field unit test
	local searchFieldButton = widget.newButton{
	    id = "searchField",
	    left = 50,
	    top = stepperButton.y + 30,
	    label = "Search Field",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( searchFieldButton )
	
	-- progressView unit test
	local progressViewButton = widget.newButton{
	    id = "progressView",
	    left = 50,
	    top = searchFieldButton.y + 30,
	    label = "Progress View",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( progressViewButton )
	
	-- segmentedControl unit test
	local segmentedControlButton = widget.newButton{
	    id = "segmentedControl",
	    left = 50,
	    top = progressViewButton.y + 30,
	    label = "Segmented Control",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( segmentedControlButton )
	
	-- button unit test
	local buttonButton = widget.newButton{
	    id = "button",
	    left = 50,
	    top = segmentedControlButton.y + 30,
	    label = "Button",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( buttonButton )
	
	-- tabBar unit test
	local tabBarButton = widget.newButton{
	    id = "tabBar",
	    left = 50,
	    top = buttonButton.y + 30,
	    label = "TabBar",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( tabBarButton )
	
	-- slider unit test
	local sliderButton = widget.newButton{
	    id = "slider",
	    left = 50,
	    top = tabBarButton.y + 30,
	    label = "Slider",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( sliderButton )
	
	-- embossedText unit test
	local embossedTextButton = widget.newButton{
	    id = "embossedText",
	    left = 50,
	    top = sliderButton.y + 30,
	    label = "Embossed Text",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( embossedTextButton )
	
	-- picker unit test
	local pickerButton = widget.newButton{
	    id = "picker",
	    left = 50,
	    top = embossedTextButton.y + 30,
	    label = "Picker",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( pickerButton )
	
	-- tableView unit test
	local tableViewButton = widget.newButton{
	    id = "tableView",
	    left = 50,
	    top = pickerButton.y + 30,
	    label = "TableView",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( tableViewButton )
	
	-- scrollView unit test
	local scrollViewButton = widget.newButton{
	    id = "scrollView",
	    left = 50,
	    top = tableViewButton.y + 30,
	    label = "ScrollView",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	newScrollView:insert( scrollViewButton )

end

function scene:didExitScene( event )
	storyboard.removeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "didExitScene", scene )

return scene
