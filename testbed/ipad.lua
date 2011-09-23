--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK "Widget" Sample Code
-- ====================================================================
--
-- File: ipad.lua
--
-- Version 1.0
--
-- Copyright (C) 2011 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Published changes made to this software and associated documentation and module files (the
-- "Software") may be used and distributed by ANSCA, Inc. without notification. Modifications
-- made to this software and associated documentation and module files may or may not become
-- part of an official software release. All modifications made to the software will be
-- licensed under these same terms and conditions.
--
--*********************************************************************************************

module(..., package.seeall)

function loadMod()

	-- forward references
	local apple, lemon, kiwi
	local colorCircle, r, g, b
	local list1, list2, deleteButton
	local selectedList
	local pickerButton, datePicker
	
	-- create a white background for the app "stage"
	local whiteBg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	whiteBg:setFillColor( 255, 255, 255, 255 )
	
	--================================================================================================
	--
	-- Callback functions section
	--
	--================================================================================================
	
	local skinSetting = skinSetting
	local listBoxStart = listBoxStart
	local newEmbossedText = newEmbossedText
	local newButton = newButton
	local newSegmentedControl = newSegmentedControl
	local newSlider = newSlider
	local newToolbar = newToolbar
	local newScrollView = newScrollView
	local newTableView = newTableView
	local newPickerWheel = newPickerWheel
	local newRoundedRectButton = newRoundedRectButton
	
	local onListItemTouch = function( event )
		local item = event.target
		
		print( "You touched: " .. item.titleText.text )
	end
	
	--
	
	-- onSwipe event listener for individual list items
	local onSwipe = function( swipeDirection, listItem, targetList )
		
		if swipeDirection == "left" then
			print( "You swiped '" .. listItem.titleText.text .. "' left!" )
			
			local itemTarget = listItem
			
			local onDeleteRelease = function( event )
				targetList:deleteRow( itemTarget )
			end
			
			-- remove existing delete button (if it exists)
			display.remove( deleteButton )
			
			-- create a new delete button
			deleteButton = newButton{ label="Delete", buttonTheme="red", x=0, y=0, onRelease=onDeleteRelease }
			if not deleteButton then
				deleteButton = newRoundedRectButton{ label="Delete", x=0, y=0, width=65, height=30, cornerRadius=4, onRelease=onDeleteRelease }
			end
			listItem.itemContent:insert( deleteButton.view )
			deleteButton.y = listItem.rowHeight * 0.5 - deleteButton.height * 0.5
			deleteButton.x = 200 - deleteButton.width - 10
			deleteButton.view:setReferencePoint( display.TopRightReferencePoint )
			deleteButton.view.xScale = 0.1
			
			transition.to( deleteButton.view, { xScale=1.0, time=100 } )
			
		elseif swipeDirection == "right" then
			print( "You swiped '" .. listItem.titleText.text .. "' right!" )
			
			-- remove existing delete button (if it exists)
			local removeButton = function()
				display.remove( deleteButton )
				deleteButton = nil
			end
			
			removeButton()
		end
		
		return true
		
	end
	
	local list1Swipe = function( event )
		local item = event.target
		local direction = event.direction
		
		onSwipe( direction, item, list1 )
	end
	
	local list2Swipe = function( event )
		local item = event.target
		local direction = event.direction
		
		onSwipe( direction, item, list2 )
	end
	
	--
	
	local onFruitTabTouch = function( event )
		local id = tonumber(event.target.id)
				
		if id == 1 then
			
			apple.isVisible = true
			lemon.isVisible = false
			kiwi.isVisible = false
			
		elseif id == 2 then
		
			apple.isVisible = false
			lemon.isVisible = true
			kiwi.isVisible = false
		
		elseif id == 3 then
			
			apple.isVisible = false
			lemon.isVisible = false
			kiwi.isVisible = true
			
		end
	end
	
	--
	
	local sliderCallback = function( event )
		
		local id = event.target.id
			
		if id == "r" then
			r = (event.target.value * 255) / 100
		
		elseif id == "g" then
			g = (event.target.value * 255) / 100
		
		elseif id == "b" then
			b = (event.target.value * 255) / 100
		end
		
		colorCircle:setFillColor( r, g, b, 255 )
		
	end
	
	--
	
	local onButtonRelease = function( event )
		datePicker = newPickerWheel{ preset="usDate", startMonth=10, startDay=28, startYear=2011, width=display.contentWidth }
		datePicker.x = 0
		datePicker.y = display.contentHeight - datePicker.height
		
		local pickerBar = newToolbar( "widget.newPickerWheel()" )
		pickerBar.width = display.contentWidth
		pickerBar.x = 0
		pickerBar.y = datePicker.y - 44
		
		local doneButton
		
		local onPickerHide = function( event )
			if datePicker then
			
				-- extract data from selected picker wheel items (each column separately)
				local m, d, y = datePicker.col1.value, datePicker.col2.value, datePicker.col3.value
				
				-- print the selected items to terminal
				print( "Selected date: ", m, d, y )
				
				-- remove the picker, the toolbar, and the ui button
				display.remove( datePicker )
				datePicker = nil
				
				display.remove( pickerBar )
				pickerBar = nil
				
				display.remove( doneButton )
				doneButton = nil
			end
		end
		
		doneButton = newButton{ label="Complete Selection", onRelease=onPickerHide }
		if not doneButton then
			doneButton = newRoundedRectButton{ label="Complete Selection", x=0, y=0, width=155, height=30, cornerRadius=2, onRelease=onPickerHide }
		end
		doneButton.view:setReferencePoint( display.CenterReferencePoint )
		doneButton.x = display.contentWidth - 125
		doneButton.y = pickerBar.y + 22
	end
	
	--================================================================================================
	--
	-- Widget creation section
	--
	--================================================================================================
	
	-- Create app's title bar
	appToolbar = newToolbar( "Widget Demo" )
	
	-- 
	
	
	-- Function to create two tableViews and a scrollView
	
	local createListsAndScrollView = function()
		
		-- Create text label
		local label = display.newText( "widget.newTableView() & widget.newScrollView()", 0, 0, skinSetting.defaultFont, 24 )
		label:setTextColor( 0, 0, 0, 255 )
		label:setReferencePoint( display.CenterReferencePoint )
		label.x = display.contentWidth * 0.5
		label.y = 100
		
		local label2 = display.newText( "Swipe left to delete list items; right to cancel.", 0, 0, skinSetting.defaultFont, 18 )
		label2:setTextColor( 25, 25, 25, 255 )
		label2:setReferencePoint( display.CenterReferencePoint )
		label2.x = display.contentWidth * 0.5
		label2.y = 135
		
		-- settings
		local viewsY = 175
		
		-- table to hold tableview item data
		local itemData1 = {}
		local itemData2 = {}
		
		-- populate data table
		for i=1,50 do
			
			local item1 = {
				icon = {
					image = "anscaLogo.png",
					width = 32,
					height = 32,
					paddingTop = 12,
					paddingRight = 15
				},
				title = { label = "List Item #" .. i },
				subtitle = { label = "Desc text for #" .. i .. "..." },
				onRelease = onListItemTouch,
				onLeftSwipe = list1Swipe,
				onRightSwipe = list1Swipe,
				hideArrow = true
			}
			
			itemData1[i] = item1
			
			local item2 = {
				icon = {
					image = "anscaLogo.png",
					width = 32,
					height = 32,
					paddingTop = 12,
					paddingRight = 15
				},
				title = { label = "List Item #" .. i },
				subtitle = { label = "Desc text for #" .. i .. "..." },
				onRelease = onListItemTouch,
				onLeftSwipe = list2Swipe,
				onRightSwipe = list2Swipe,
				hideArrow = true
			}
			
			itemData2[i] = item2
		end
		
		-- add in some categories
		table.insert( itemData1, 10, { categoryName="Category 1" } )
		table.insert( itemData1, 25, { categoryName="Category 2" } )
		table.insert( itemData1, 35, { categoryName="Category 3" } )
		
		-- create rectangle to go behind list (to serve as border)
		local borderRect1 = display.newRect( 49, viewsY-1, 202, 322 )
		borderRect1:setFillColor( 0, 0, 0, 255 )
		
		-- create first list
		list1 = newTableView{
			width = 200,
			height = 320,
			x = 50,
			y = viewsY
		}
		
		-- sync list with data table
		list1:sync( itemData1 )
		
		-- create second border rectangle (for next list)
		local borderRect2 = display.newRect( 284, viewsY-1, 202, 322 )
		borderRect2:setFillColor( 0, 0, 0, 255 )
		
		-- create second list
		list2 = newTableView{
			width = 200,
			height = 320,
			x = 285,
			y = viewsY
		}
		
		-- sync list with data table
		list2:sync( itemData2 )
		
		-- create third border rectangle (for scrollview)
		local borderRect3 = display.newRect( 519, viewsY-1, 202, 322 )
		borderRect3:setFillColor( 0, 0, 0, 255 )
		
		-- create scrollview
		local scrollingContent = newScrollView{
			width = 200,
			height = 320,
			x = 520,
			y = viewsY
		}
		
		-- create image that will go inside scrollview
		local scrollImage = display.newImage( "scrollimage200.png" )
		
		-- add it to scrollview
		scrollingContent:insert( scrollImage )
	end
	
	-- Function to create the segmented control widget/content
	
	local createSegmentedContent = function()
		
		-- create label
		local label = display.newText( "widget.newSegmentedControl()", 0, 0, skinSetting.defaultFont, 18 )
		label:setTextColor( 0, 0, 0, 255 )
		label:setReferencePoint( display.CenterReferencePoint )
		label.x = 190
		label.y = 550
		
		-- create individual fruit images
		apple = display.newImageRect( "apple.png", 250, 250 )
		apple:setReferencePoint( display.CenterReferencePoint )
		apple.x = 190
		apple.y = 750
		
		lemon = display.newImageRect( "lemon.png", 200, 200 )
		lemon:setReferencePoint( display.CenterReferencePoint )
		lemon.x = apple.x
		lemon.y = apple.y
		lemon.isVisible = false
		
		kiwi = display.newImageRect( "kiwi.png", 250, 250 )
		kiwi:setReferencePoint( display.CenterReferencePoint )
		kiwi.x = apple.x
		kiwi.y = apple.y
		kiwi.isVisible = false
		
		-- set up a table to hold button information
		local myButtons = {
			{ label="Apple", onPress=onFruitTabTouch, isDown=true },
			{ label="Lemon", onPress=onFruitTabTouch },
			{ label="Kiwi", onPress=onFruitTabTouch }
		}
		
		local fruitTabs = newSegmentedControl( myButtons )
		fruitTabs:setReferencePoint( display.CenterReferencePoint )
		fruitTabs.x = apple.x
		fruitTabs.y = apple.y - 150
	end
	
	-- Function to demonstrate sliders functionality
	
	local createSliders = function()
		
		-- create label
		local label = display.newText( "widget.newSlider()", 0, 0, skinSetting.defaultFont, 22 )
		label:setTextColor( 0, 0, 0, 255 )
		label:setReferencePoint( display.CenterReferencePoint )
		label.x = 545
		label.y = 565
		
		-- create a vector circle that will change colors
		colorCircle = display.newCircle( 450, 700, 75 )
		colorCircle.strokeWidth = 3
		colorCircle:setStrokeColor( 0, 0, 0, 255 )
		
		-- create Ansca logo on top of circle
		local anscaLogo = display.newImage( "anscaLogo@2x.png" )
		anscaLogo:setReferencePoint( display.CenterReferencePoint )
		anscaLogo.x = 450
		anscaLogo.y = 700
		
		-- create 3 sliders
		local rSlider, gSlider, bSlider
		
		rSlider = newSlider{ id="r", x=650, y=650, value=75, callback=sliderCallback, width=150 }
		gSlider = newSlider{ id="g", x=650, y=rSlider.y+45, value=25, callback=sliderCallback, width=125 }
		bSlider = newSlider{ id="b", x=650, y=gSlider.y+45, value=50, callback=sliderCallback, width=175 }
		
		-- set circle color based on position of sliders
		r = (rSlider.value * 255) / 100
		g = (gSlider.value * 255) / 100
		b = (bSlider.value * 255) / 100
		colorCircle:setFillColor( r, g, b, 255 )
	end
	
	-- Function to demonstrate uiButtons and picker wheel
	
	local createButtonsForWheel = function()
		
		-- create label
		local label = display.newText( "widget.newButton()", 0, 0, skinSetting.defaultFont, 20 )
		label:setTextColor( 0, 0, 0, 255 )
		label:setReferencePoint( display.CenterReferencePoint )
		label.x = 560
		label.y = 890
		
		-- create the button
		pickerButton = newButton{ label = "Show Picker Wheel", onRelease = onButtonRelease }
		if not pickerButton then
			pickerButton = newRoundedRectButton{ label="Show Picker Wheel", x=0, y=0, width=155, height=30, cornerRadius=4, onRelease=onButtonRelease }
		end
		pickerButton.view:setReferencePoint( display.CenterReferencePoint )
		pickerButton.x = 560
		pickerButton.y = 945
	end
	
	createListsAndScrollView()
	createSegmentedContent()
	createSliders()
	createButtonsForWheel()
end
