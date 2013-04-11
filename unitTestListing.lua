-- Copyright (C) 2013 Corona Inc. All Rights Reserved.

local widget = nil -- require( _G.widgetLibraryPath )

local function requireWidgetFiles()
    widget = require( _G.widgetLibraryPath )
end

-- If we failed to find it
if false == pcall( requireWidgetFiles ) then
	print( "widget library not found, falling back to core version" ) 
	widget = require( "widget" )
end

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_ANDROID_THEME = false

function scene:createScene( event )	
	local group = self.view
	
	-- Set theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end
	
	--Display an iOS style background
	local background = display.newImage( "unitTestAssets/background.png" )
	group:insert( background )
	
	--Create a title to make the menu visibly clear
	local title = display.newEmbossedText( "Select a unit test to view", 0, 0, native.systemFont, 20)
	title.x, title.y = display.contentCenterX, 20
	group:insert( title )
	
	local scrollView = widget.newScrollView
	{
		left = 0,
		top = 40,
		width = display.contentWidth * 0.5,
		height = display.contentHeight - 50,
		horizontalScrollDisabled = true,
		hideScrollBar = true,
		hideBackground = true,
	}
	group:insert( scrollView )
	
	--Go to selected unit test
	local function gotoSelection( event )
		local phase = event.phase
		
		if "moved" == phase then		
			local dy = math.abs( event.y - event.yStart )
		
			if dy > 15 then
				scrollView:takeFocus( event )
			end
		elseif "ended" == phase then
			local targetScene = event.target.id
		
			storyboard.gotoScene( targetScene )
		end
		
		return true
	end

	-- spinner unit test
	local spinnerButton = widget.newButton
	{
	    id = "spinner",
	    left = 60,
	    top = 10,
	    label = "Spinner",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( spinnerButton )
	
	
	-- switch unit test
	local switchButton = widget.newButton
	{
	    id = "switch",
	    left = 60,
	    top = spinnerButton.y + 30,
	    label = "Switch",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( switchButton )
	
	
	-- Stepper unit test
	local stepperButton = widget.newButton
	{
	    id = "stepper",
	    left = 60,
	    top = switchButton.y + 30,
	    label = "Stepper",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( stepperButton )
	
	
	-- Search field unit test
	local searchFieldButton = widget.newButton
	{
	    id = "searchField",
	    left = 60,
	    top = stepperButton.y + 30,
	    label = "Search Field",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( searchFieldButton )
	
	-- progressView unit test
	local progressViewButton = widget.newButton
	{
	    id = "progressView",
	    left = 60,
	    top = searchFieldButton.y + 30,
	    label = "Progress View",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( progressViewButton )
	
	-- segmentedControl unit test
	local segmentedControlButton = widget.newButton
	{
	    id = "segmentedControl",
	    left = 60,
	    top = progressViewButton.y + 30,
	    label = "Segmented Control",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( segmentedControlButton )
	
	-- button unit test
	local buttonButton = widget.newButton
	{
	    id = "button",
	    left = 60,
	    top = segmentedControlButton.y + 30,
	    label = "Button",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( buttonButton )
	
	-- tabBar unit test
	local tabBarButton = widget.newButton
	{
	    id = "tabBar",
	    left = 60,
	    top = buttonButton.y + 30,
	    label = "TabBar",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( tabBarButton )
	
	-- slider unit test
	local sliderButton = widget.newButton
	{
	    id = "slider",
	    left = 60,
	    top = tabBarButton.y + 30,
	    label = "Slider",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( sliderButton )
	
	-- picker unit test
	local pickerButton = widget.newButton
	{
	    id = "picker",
	    left = 60,
	    top = sliderButton.y + 30,
	    label = "Picker",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( pickerButton )
	
	-- tableView unit test
	local tableViewButton = widget.newButton
	{
	    id = "tableView",
	    left = 60,
	    top = pickerButton.y + 30,
	    label = "TableView",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( tableViewButton )
	
	-- scrollView unit test
	local scrollViewButton = widget.newButton
	{
	    id = "scrollView",
	    left = 60,
	    top = tableViewButton.y + 30,
	    label = "ScrollView",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onEvent = gotoSelection
	}
	scrollView:insert( scrollViewButton )
end

function scene:didExitScene( event )
	storyboard.removeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "didExitScene", scene )

return scene
