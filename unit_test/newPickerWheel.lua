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
	
	--[[
	
	RECENT CHANGES/THINGS TO REVIEW:
	
	1) Picker wheel now soft lands. 
	
	How: Scroll the PickerWheel.
	Expected behavior: When you release your finger/mouse, it should soft land onto the nearest target row.

	--]]
	
	--Set up the Picker Wheel's columns
	local columnData = {}
	columnData[1] = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
	columnData[1].alignment = "right"
	columnData[1].width = 150
	columnData[1].startIndex = monthIndex or 3
		
	columnData[2] = {}
	for i = 1, 31 do
		columnData[2][i] = i
	end
	columnData[2].alignment = "center"
	columnData[2].width = 60
	columnData[2].startIndex = dayIndex or 25
		
	columnData[3] = {}
	for i = 1, 25 do
		columnData[3][i] = i + 1990
	end
	columnData[3].startIndex = yearIndex or 20
		
	--Create a Picker Wheel
	local picker = widget.newPickerWheel{
		top = display.contentHeight - 222, 		--Test setting top position.
		font = native.systemFontBold,			--Test setting a font.
		columns = columnData,					--Add column data to picker.
	}
	group:insert( picker )
	
	--Create some text to display the chosen values on screen
	local displayedValues = display.newEmbossedText( "Chosen date: ", 0, 0, native.systemFont, 18 )
	displayedValues.x, displayedValues.y = display.contentCenterX, 160
	group:insert( displayedValues )
	
	--Show picker values on button press
	local function showPickerValues( event )
		-- extract selected rows from pickerWheel columns
		local pickerValues = picker:getValues()
		monthIndex = pickerValues[1].index
		dayIndex = pickerValues[2].index
		yearIndex = pickerValues[3].index
		
		--Set displayed value text
		displayedValues:setText( "Chosen date: " .. pickerValues[1].value .. " " .. pickerValues[2].value .. ", " .. pickerValues[3].value )
		displayedValues.x = display.contentCenterX
		
		--Output to console
		print( "Chosen date: " .. pickerValues[1].value .. " " .. pickerValues[2].value .. ", " .. pickerValues[3].value )
		
		return true
	end

	--Button to print picker values
	local pickerButton = widget.newButton{
	    id = "showPickerValues",
	    left = 60,
	    top = 200,
	    label = "Show Values",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = showPickerValues
	}
	group:insert( pickerButton )
	
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
