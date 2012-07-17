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
	
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
