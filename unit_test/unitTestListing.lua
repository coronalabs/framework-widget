local widget = require( "widgetnew" )
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
	
	--Go to selected unit test
	local function gotoSelection( event )
		local targetScene = event.target.id
		
		storyboard.gotoScene( targetScene )
		
		return true
	end

	--Picker Wheel unit test
	local newPickerWheelButton = widget.newButton{
	    id = "newPickerWheel",
	    left = 60,
	    top = 50,
	    label = "newPickerWheel",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	group:insert( newPickerWheelButton )
	
	
	--ScrollView unit test
	local newScrollViewButton = widget.newButton{
	    id = "newScrollView",
	    left = 60,
	    top = newPickerWheelButton.y + 35,
	    label = "newScrollView",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	group:insert( newScrollViewButton )
	
	
	--TableView unit test
	local newTableViewButton = widget.newButton{
	    id = "newTableView",
	    left = 60,
	    top = newScrollViewButton.y + 35,
	    label = "newTableView",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	group:insert( newTableViewButton )
	
	
	--NewSlider unit test
	local newSliderButton = widget.newButton{
	    id = "newSlider",
	    left = 60,
	    top = newTableViewButton.y + 35,
	    label = "newSlider",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	group:insert( newSliderButton )
	
	--NewButton unit test
	local newButtonButton = widget.newButton{
	    id = "newButton",
	    left = 60,
	    top = newSliderButton.y + 35,
	    label = "newButton",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	group:insert( newButtonButton )
	
	--NewTabBar unit test
	local newTabBarButton = widget.newButton{
	    id = "newTabBar",
	    left = 60,
	    top = newButtonButton.y + 35,
	    label = "newTabBar",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = gotoSelection
	}
	group:insert( newTabBarButton )
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
