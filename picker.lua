-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newPickerWheel unit test.

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

function scene:create( event )
	local group = self.view

	local xAnchor = display.contentCenterX
	local yAnchor = display.contentCenterY

	local fontColor = 0
	local background = display.newRect( xAnchor, yAnchor, display.contentWidth, display.contentHeight )
	
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
	background:setFillColor(0.2)
	local backButtonPosition = 5
	local backButtonSize = 34
	
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
		columnColor = { 0.8 },
		--onValueSelected = valueSelected  --NEW
	}
	group:insert( pickerWheel )

	local testRectA1 = display.newRect( group,display.contentCenterX,pickerWheel.y,400,40 )
	testRectA1:setFillColor(1,0,0.2,0.3)
	local testRectAT1 = display.newRect( group,display.contentCenterX,pickerWheel.y-(40*2),400,40 )
	testRectAT1:setFillColor(1,0.2,0,0.2)
	local testRectAT2 = display.newRect( group,display.contentCenterX,pickerWheel.y-40,400,40 )
	testRectAT2:setFillColor(1,0.6,0,0.2)
	local testRectAT3 = display.newRect( group,display.contentCenterX,pickerWheel.y+(40*2),400,40 )
	testRectAT3:setFillColor(1,0.2,0,0.2)
	local testRectAT4 = display.newRect( group,display.contentCenterX,pickerWheel.y+40,400,40 )
	testRectAT4:setFillColor(1,0.6,0,0.2)
	
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

	local resizablePickerWheel = widget.newPickerWheel
	{
		top = pickerWheel.contentBounds.yMax+45,
		left = 20,
		columns = columnData,
		columnColor = { 0.8 },
		fontSize = 12,
		style = "resizable",  --NEW
		width = 250,  --NEW
		rowHeight = rowHeight,  --NEW
		onValueSelected = valueSelected  --NEW
	}
	group:insert( resizablePickerWheel )

	local testRectB1 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y,400,rowHeight )
	testRectB1:setFillColor(1,0,0.2,0.3)
	local testRectBT1 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y-(rowHeight*2),400,rowHeight )
	testRectBT1:setFillColor(1,0.2,0,0.2)
	local testRectBT2 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y-rowHeight,400,rowHeight )
	testRectBT2:setFillColor(1,0.6,0,0.2)
	local testRectBT3 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y+(rowHeight*2),400,rowHeight )
	testRectBT3:setFillColor(1,0.2,0,0.2)
	local testRectBT4 = display.newRect( group,display.contentCenterX,resizablePickerWheel.y+rowHeight,400,rowHeight )
	testRectBT4:setFillColor(1,0.6,0,0.2)
	
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
