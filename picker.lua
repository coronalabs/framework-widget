-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newPickerWheel unit test.

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

function scene:create( event )
	local group = self.view

	local xAnchor, yAnchor

	if not isGraphicsV1 then
		xAnchor = display.contentCenterX
		yAnchor = display.contentCenterY
	else
		xAnchor = 0
		yAnchor = 0
	end

	local fontColor = 0
	local background = display.newRect( xAnchor, yAnchor, display.actualContentWidth, display.actualContentHeight )

	if widget.USE_IOS_THEME then
		if isGraphicsV1 then background:setFillColor( 197, 204, 212, 255 )
		else background:setFillColor( 197/255, 204/255, 212/255, 1 ) end
	elseif widget.USE_ANDROID_HOLO_LIGHT_THEME then
		if isGraphicsV1 then background:setFillColor( 255, 255, 255, 255 )
		else background:setFillColor( 1, 1, 1, 1 ) end
	elseif widget.USE_ANDROID_HOLO_DARK_THEME then
		if isGraphicsV1 then background:setFillColor( 34, 34, 34, 255 )
		else background:setFillColor( 34/255, 34/255, 34/255, 1 ) end
		fontColor = 0.5
	else
		if isGraphicsV1 then background:setFillColor( 255, 255, 255, 255 )
		else background:setFillColor( 1, 1, 1, 1 ) end
	end
	group:insert( background )
	
	local backButtonPosition = 5
	local backButtonSize = 34
	
	--widget.setTheme( "widget_theme_android_holo_dark" )
	background:setFillColor(0)

	-- Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = backButtonPosition,
	    label = "Exit",
	    width = 200, height = backButtonSize,
	    onRelease = function() composer.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	-- Set up the Picker Wheel's columns

	local columnData = 
	{ 
		{ 
			align = "left",
			width = 124,
			labelPadding = 20,  --NEW (default is 6)
			startIndex = 2,
			labels = { "Hoodie", "Short Sleeve", "Long Sleeve", "Sweatshirt" }
		},
		{
			align = "left",
			width = 96,
			labelPadding = 10,
			startIndex = 1,
			labels = { "Dark Grey", "White", "Black", "Orange" }
		},
		{
			align = "left",
			width = 60,
			labelPadding = 10,
			startIndex = 3,
			labels = { "S", "M", "L", "XL", "XXL" }
		},
	}

	-- Function to be called when user selects an option
	local function valueSelectedFixed( event )
		print( "valueSelectedFixed() function called" )
		print( "-------------------------------" )
		print( "Column: " .. event["column"] )
		print( "Row: " .. event["row"] )
	end
	local function valueSelectedResizable( event )
		print( "valueSelectedResizable() function called" )
		print( "-------------------------------" )
		print( "Column: " .. event["column"] )
		print( "Row: " .. event["row"] )
	end

	-- Fixed-size picker wheel
	local options = {
		frames =
		{
			{ x=0, y=0, width=320, height=222 },
			{ x=328, y=0, width=320, height=222 },
			{ x=656, y=0, width=12, height=222 }
		},
		sheetContentWidth = 668,
		sheetContentHeight = 222
	}
	local pickerWheelSheetFixed = graphics.newImageSheet( "unitTestAssets/pickerwheel-fixed.png", options )

	local pickerWheel = widget.newPickerWheel(
	{
		x = display.contentCenterX,
		top = 0,
		fontSize = 18,
		columns = columnData,
		onValueSelected = valueSelectedFixed,  --NEW
		sheet = pickerWheelSheetFixed,
		overlayFrame = 1,
		backgroundFrame = 2,
		separatorFrame = 3,
		listener = testF
	})
	group:insert( pickerWheel )

	--[[local testRectA1 = display.newRect( group,display.contentCenterX,pickerWheel.y,400,40 )
	testRectA1:setFillColor(1,0,0.2,0.3)
	local testRectAT1 = display.newRect( group,display.contentCenterX,pickerWheel.y-(40*2),400,40 )
	testRectAT1:setFillColor(1,0.2,0,0.2)
	local testRectAT2 = display.newRect( group,display.contentCenterX,pickerWheel.y-40,400,40 )
	testRectAT2:setFillColor(1,0.6,0,0.2)
	local testRectAT3 = display.newRect( group,display.contentCenterX,pickerWheel.y+(40*2),400,40 )
	testRectAT3:setFillColor(1,0.2,0,0.2)
	local testRectAT4 = display.newRect( group,display.contentCenterX,pickerWheel.y+40,400,40 )
	testRectAT4:setFillColor(1,0.6,0,0.2)--]]
	
	local getValuesButtonA = widget.newButton(
		{
			id = "getValues",
			top = pickerWheel.contentBounds.yMax+2,
			label = "print() values",
			height = backButtonSize,
			onRelease = function()
				local values = pickerWheel:getValues()
					for i = 1, #values do
						print( "Column", i, "value is:", values[i].value )
						print( "Column", i, "index is:", values[i].index )
					end
				end
		})
	getValuesButtonA.x = display.contentCenterX
	group:insert( getValuesButtonA )



	-- Resizable picker wheel
	local rowHeight = 32

	local options2 = {
		frames =
		{
			{ x=0, y=0, width=20, height=20 },  --topLeft
			{ x=20, y=0, width=120, height=20 },  --topMiddle
			{ x=140, y=0, width=20, height=20 },  --topRight
			{ x=0, y=20, width=20, height=120 },  --middleLeft
			{ x=140, y=20, width=20, height=120 },  --middleRight (adjust x later!)
			{ x=0, y=140, width=20, height=20 },  --bottomLeft (adjust y later!)
			{ x=20, y=140, width=120, height=20 },  --bottomMiddle (adjust y later!)
			{ x=140, y=140, width=20, height=20 },  --bottomRight (adjust x/y later!)
			{ x=180, y=0, width=32, height=80 },  --topFade
			{ x=224, y=0, width=32, height=80 },  --bottomFade
			{ x=276, y=0, width=32, height=20 },  --middleSpanTop
			{ x=276, y=60, width=32, height=20 },  --middleSpanBottom
			{ x=276, y=100, width=12, height=32 }  --separator
		},
		sheetContentWidth = 312,
		sheetContentHeight = 160
	}
	local pickerWheelSheetResizable = graphics.newImageSheet( "unitTestAssets/pickerwheel-resizable.png", options2 )

	local resizablePickerWheel = widget.newPickerWheel
	{
		x = display.contentCenterX,
		top = pickerWheel.contentBounds.yMax+40,
		columns = columnData,
		fontSize = 14,
		style = "resizable",  --NEW (optional)
		width = 280,  --NEW (REQUIRED for resizable!)
		rowHeight = rowHeight,  --NEW (REQUIRED for resizable!)
		onValueSelected = valueSelectedResizable,  --NEW
		sheet = pickerWheelSheetResizable,
		borderPadding = 8,  --NEW (optional)
		topLeftFrame = 1,  --NEW (optional)
		topMiddleFrame = 2,  --NEW (optional)
		topRightFrame = 3,  --NEW (optional)
		middleLeftFrame = 4,  --NEW (optional)
		middleRightFrame = 5,  --NEW (optional)
		bottomLeftFrame = 6,  --NEW (optional)
		bottomMiddleFrame = 7,  --NEW (optional)
		bottomRightFrame = 8,  --NEW (optional)
		topFadeFrame = 9,  --NEW (optional)
		bottomFadeFrame = 10,  --NEW (optional)
		middleSpanTopFrame = 11,  --NEW (optional)
		middleSpanBottomFrame = 12,  --NEW (optional)
		separatorFrame = 13,  --(optional)
		middleSpanOffset = 4  --NEW (optional)
	}
	group:insert( resizablePickerWheel )

	--[[local testRectB1 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y,400,rowHeight )
	testRectB1:setFillColor(1,0,0.2,0.3)
	local testRectBT1 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y-(rowHeight*2),400,rowHeight )
	testRectBT1:setFillColor(1,0.2,0,0.2)
	local testRectBT2 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y-rowHeight,400,rowHeight )
	testRectBT2:setFillColor(1,0.6,0,0.2)
	local testRectBT3 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y+(rowHeight*2),400,rowHeight )
	testRectBT3:setFillColor(1,0.2,0,0.2)
	local testRectBT4 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y+rowHeight,400,rowHeight )
	testRectBT4:setFillColor(1,0.6,0,0.2)--]]

	local getValuesButtonB = widget.newButton(
		{
			id = "getValues",
			top = resizablePickerWheel.contentBounds.yMax+2,
			label = "print() values",
			height = backButtonSize,
			onRelease = function()
				local values = resizablePickerWheel:getValues()
					for i = 1, #values do
						print( "Column", i, "value is:", values[i].value )
						print( "Column", i, "index is:", values[i].index )
					end
				end
		})
	getValuesButtonB.x = display.contentCenterX
	group:insert( getValuesButtonB )



	--NEW :selectValue( targetColumn(INT), targetIndex(INT), snapToIndex(BOOL) )
	timer.performWithDelay( 2000, function() resizablePickerWheel:selectValue( 1, 3 ); end )
	timer.performWithDelay( 4000, function() resizablePickerWheel:selectValue( 1, 4 ); end )
	timer.performWithDelay( 6000, function() resizablePickerWheel:selectValue( 1, 1 ); end )
end

function scene:hide( event )
	if ( "did" == event.phase ) then
		--Cancel test timer if active
		if testTimer ~= nil then
			timer.cancel( testTimer )
			testTimer = nil
		end
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )

return scene
