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
	
	widget.setTheme( "widget_theme_android_holo_dark" )
	
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
	
	local days = {}
	local years = {}
	
	for i = 1, 31 do
		days[i] = i
	end
	
	for i = 1, 44 do
		years[i] = 1969 + i
	end
	
	-- Set up the Picker Wheel's columns
	local columnData = 
	{ 
		{ 
			align = "left",
			width = 100,
			--labelPadding = 20,  --NEW (default is 6)
			startIndex = 1,
			labels = 
			{
				"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
			},
		},
		{
			align = "center",
			width = 60,
			startIndex = 18,
			labels = days,
		},
		{
			align = "right",
			width = 60,
			--labelPadding = 0,  --NEW (default is 6)
			startIndex = 10,
			labels = years,
		},
	}

	local function valueSelected( event )
		print( "onValueSelected() called" )
		print( "------------------------" )
		for k,v in pairs(event) do
			print(k,v)
		end
		print( "--------------" )
	end



	-- Default picker wheel
	local pickerWheel = widget.newPickerWheel
	{
		top = display.contentHeight - 436,
		left = 0,
		columns = columnData,
		--columnColor = { 0.8 },
		onValueSelected = valueSelected  --NEW
	}
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
	local rowHeight = 26

	local options = {
		frames =
		{
			{ x=0, y=0, width=16, height=16 },  --topLeft
			{ x=16, y=0, width=16, height=16 },  --topMiddle
			{ x=304, y=0, width=16, height=16 },  --topRight (adjust x later!)
			{ x=0, y=16, width=16, height=16 },  --middleLeft
			{ x=304, y=16, width=16, height=16 },  --middleRight (adjust x later!)
			{ x=0, y=206, width=16, height=16 },  --bottomLeft (adjust y later!)
			{ x=16, y=206, width=16, height=16 },  --bottomMiddle (adjust y later!)
			{ x=304, y=206, width=16, height=16 },  --bottomRight (adjust x/y later!)
			{ x=20, y=16, width=20, height=34 },  --topFade
			{ x=20, y=172, width=20, height=34 },  --bottomFade
			{ x=20, y=89, width=20, height=22 },  --middleSpanTop
			{ x=20, y=111, width=20, height=22 },  --middleSpanBottom
			{ x=328, y=8, width=16, height=16 },  --background
			{ x=642, y=16, width=4, height=16 },  --separator
			{ x=0, y=0, width=320, height=222 },  --overlay (not used for resizable, only for testing here)
		},
		sheetContentWidth = 648,
		sheetContentHeight = 222
	}
	local pickerWheelSheet = graphics.newImageSheet( "unitTestAssets/pickerSheet.png", options )

	local resizablePickerWheel = widget.newPickerWheel
	{
		top = pickerWheel.contentBounds.yMax+45,
		left = 20,
		columns = columnData,
		columnColor = { 0.8 },
		fontSize = 12,
		style = "resizable",  --NEW (optional)
		width = 250,  --NEW (REQUIRED for resizable!)
		rowHeight = rowHeight,  --NEW (REQUIRED for resizable!)
		onValueSelected = valueSelected,  --NEW
		sheet = pickerWheelSheet,
		borderPadding = 16,  --NEW (optional)
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
		backgroundFrame = 13,  --(optional)
		overlayFrame = 15,  --(optional)
		separatorFrame = 14,  --(optional)
		middleSpanOffset = 2  --NEW (optional)
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
	--timer.performWithDelay( 2000, function() resizablePickerWheel:selectValue( 1, 5 ); end )
	--timer.performWithDelay( 4000, function() resizablePickerWheel:selectValue( 1, 12 ); end )
	--timer.performWithDelay( 6000, function() resizablePickerWheel:selectValue( 1, 1 ); end )
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
