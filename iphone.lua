--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK "Widget" Sample Code
-- ====================================================================
--
-- File: iphone.lua
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
	
	-- create a white background for the app "stage"
	local whiteBg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	whiteBg:setFillColor( 255, 255, 255, 255 )
	
	--================================================================================================
	--
	-- Callback functions for list items
	--
	--================================================================================================
	
	-- localize vars/widgets from main
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
	
	-- forward references
	local myPanel, scrollView, leftList, rightList, rowOfButtons
	
	-- listener for back button
	local onButtonRelease = function( event )
		
		-- slide the button panel group out of view
		myPanel:slideRight{ distance=display.contentWidth }
		
		local removeButton = function()
			
			
			-- remove scrollviews and tableviews
			display.remove( scrollView )
			display.remove( leftList )
			display.remove( rightList )
			display.remove( rowOfButtons )
			
			
			-- remove this entire panel
			display.remove( myPanel )
			
			
			-- nil out variables
			myPanel = nil
			scrollView = nil
			leftList = nil
			rightList = nil
			rowOfButtons = nil
		end
		
		-- slide the previous list back into view
		apiList.view:slideRight{ alpha=1.0, onComplete=removeButton }
		
		-- reset the app's toolbar title text (aka "label" )
		appToolbar.label = "Widget Demo"
		
		return true
	end
	
	
	--
	--
	----------------------------------------------------------------------------------------
	--
	--
	
	
	local newButton_release = function()
		
		-- change the app's toolbar label
		appToolbar.label = "UI Buttons"
		
		-- create a new group for this "panel"
		myPanel = display.newGroup()
		
		
		--
		--
		
		local onBtnRelease = function( event )
			
			if event.phase == "release" then
				print( "You pressed and released button #" .. event.target.id )
			end
			
			return true
		end
		
		
		--
		--
		
		-- create a ui button
		local myButton1 = newButton{ id=1, label="Default Button", x=0, y=100, onEvent=onBtnRelease }
		if not myButton1 then
			myButton1 = newRoundedRectButton{ id=1, label="Default Button", x=0, y=100, width=125, height=30, cornerRadius=4, onRelease=onBtnRelease }
		end
		myButton1:setReferencePoint( display.CenterReferencePoint )
		myButton1.x = display.contentWidth * 0.5
		myPanel:insert( myButton1.view )
		
		
		--
		--
		
		-- another ui button, but with larger label
		local myButton2 = newButton{ id=2, label="Supports Variable Widths", x=0, y=myButton1.y+50, onEvent=onBtnRelease }
		if not myButton2 then
			myButton2 = newRoundedRectButton{ id=2, label="Rounded Rect Button", x=0, y=myButton1.y+50, width=175, height=30, cornerRadius=4, onRelease=onBtnRelease }
		end
		myButton2:setReferencePoint( display.CenterReferencePoint )
		myButton2.x = display.contentWidth * 0.5
		myPanel:insert( myButton2.view )
		
		--
		--
		
		-- rounded rect button (also serves as back button)
		local myButton3 = newRoundedRectButton{ label="Go Back", x=0, y=display.contentHeight - 75, width=298, height=56, fontSize=18, onRelease=onButtonRelease }
		myButton3:setReferencePoint( display.CenterReferencePoint )
		myButton3.x = display.contentWidth * 0.5
		myPanel:insert( myButton3.view )
		
		
		--
		--
		
		-- position this panel to the right of current view
		myPanel.x = display.contentWidth
		
		-- slide the api list to the left
		apiList.view:slideLeft{ alpha=0 }
		
		-- slide the content of this new "panel" to the left
		myPanel:slideLeft{ slideAlpha=0, distance=display.contentWidth }
		
	end
	
	
	--
	--
	----------------------------------------------------------------------------------------
	--
	--
	
	
	local newSegmentedControl_release = function()
		
		-- change the app's toolbar label
		appToolbar.label = "Segmented Control"
		
		myPanel = display.newGroup()
		
		-- create the different "fruit" objects
		local apple, lemon, kiwi
		
		apple = display.newImageRect( "apple.png", 250, 250 )
		apple:setReferencePoint( display.CenterReferencePoint )
		apple.x = display.contentWidth * 0.5
		apple.y = display.contentHeight * 0.5 + 25
		
		lemon = display.newImageRect( "lemon.png", 200, 200 )
		lemon:setReferencePoint( display.CenterReferencePoint )
		lemon.x = display.contentWidth * 0.5
		lemon.y = apple.y
		lemon.isVisible = false
		
		kiwi = display.newImageRect( "kiwi.png", 250, 250 )
		kiwi:setReferencePoint( display.CenterReferencePoint )
		kiwi.x = display.contentWidth * 0.5
		kiwi.y = apple.y
		kiwi.isVisible = false
		
		myPanel:insert( apple )
		myPanel:insert( lemon )
		myPanel:insert( kiwi )
		
		
		--
		--
		
		-- event listener for all the buttons
		local onBtnPress = function( event )
			print( "You pressed button #" .. event.target.id )
			
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
			
			return true
		end
		
		
		--
		--
		
		-- set up a table to hold button information
		local myButtons = {
			{ label="Apple", onPress=onBtnPress, isDown=true },
			{ label="Lemon", onPress=onBtnPress },
			{ label="Kiwi", onPress=onBtnPress }
		}
		
		
		--
		--
		
		-- set up the segmented control
		rowOfButtons = newSegmentedControl( myButtons )
		rowOfButtons:setReferencePoint( display.CenterReferencePoint )
		rowOfButtons.x = display.contentWidth * 0.5
		rowOfButtons.y = 100
		myPanel:insert( rowOfButtons.view )
		
		
		--
		--
		
		-- create back button as rounded rect button
		local myButton3 = newRoundedRectButton{ label="Go Back", x=0, y=display.contentHeight - 75, width=298, height=56, fontSize=18, onRelease=onButtonRelease }
		myButton3:setReferencePoint( display.CenterReferencePoint )
		myButton3.x = display.contentWidth * 0.5
		myPanel:insert( myButton3.view )
		
		
		
		--
		--
		
		-- position this panel to the right of current view
		myPanel.x = display.contentWidth
		
		-- slide the api list to the left
		apiList.view:slideLeft{ alpha=0 }
		
		-- slide the content of this new "panel" to the left
		myPanel:slideLeft{ slideAlpha=0, distance=display.contentWidth }
	end
	
	
	--
	--
	
	local newSlider_release = function()
		
		-- change the app's toolbar label
		appToolbar.label = "Slider Widgets"
		
		myPanel = display.newGroup()
		
		-- forward references
		local colorCircle, r, g, b
		
		
		-- event listener for slider widgets
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
		
		
		-- create 3 sliders
		local rSlider, gSlider, bSlider
		local halfW = display.contentWidth * 0.5
		
		rSlider = newSlider{ id="r", x=halfW, y=275, value=75, callback=sliderCallback, width=175 }
		gSlider = newSlider{ id="g", x=halfW, y=rSlider.y+45, value=25, callback=sliderCallback, width=125 }
		bSlider = newSlider{ id="b", x=halfW, y=gSlider.y+45, value=50, callback=sliderCallback, width=200 }
		
		myPanel:insert( rSlider.view )
		myPanel:insert( gSlider.view )
		myPanel:insert( bSlider.view )
		
		
		--
		--
		
		
		-- create a vector circle that will change colors
		colorCircle = display.newCircle( display.contentWidth * 0.5, display.contentHeight * 0.5 - 75, 75 )
		colorCircle.strokeWidth = 3
		colorCircle:setStrokeColor( 0, 0, 0, 255 )
		myPanel:insert( colorCircle )
		
		-- calculate rgb based on starting slider position
		r = (rSlider.value * 255) / 100
		g = (gSlider.value * 255) / 100
		b = (bSlider.value * 255) / 100
		
		-- fill the circle
		colorCircle:setFillColor( r, g, b, 255 )
		
		
		--
		--
		
		-- create back button as rounded rect button
		local myButton3 = newRoundedRectButton{ label="Go Back", x=0, y=display.contentHeight - 75, width=298, height=56, fontSize=18, onRelease=onButtonRelease }
		myButton3:setReferencePoint( display.CenterReferencePoint )
		myButton3.x = display.contentWidth * 0.5
		myPanel:insert( myButton3.view )
		
		
		
		--
		--
		
		-- position this panel to the right of current view
		myPanel.x = display.contentWidth
		
		-- slide the api list to the left
		apiList.view:slideLeft{ alpha=0 }
		
		-- slide the content of this new "panel" to the left
		myPanel:slideLeft{ slideAlpha=0, distance=display.contentWidth }
	end
	
	
	--
	--
	
	local newScrollView_release = function()
		
		-- change the app's toolbar label
		appToolbar.label = "ScrollView Widget"
		
		myPanel = display.newGroup()
		
		scrollView = newScrollView{ y=listBoxStart, height=320 }
		myPanel:insert( scrollView.view )	--> remember, you must remove scrollView manually
			
		-- create image (for scrolling)
		local scrollImage = display.newImageRect( "scrollimage.png", 320, 1024 )
		scrollImage:setReferencePoint( display.TopLeftReferencePoint )
		scrollImage.x, scrollImage.y = 0, 0
		scrollView:insert( scrollImage )
		
		
		-- create line to go underneath the scrollView
		local lineY = listBoxStart + 320 + 1
		local bottomLine = display.newLine( 0, lineY, display.contentWidth, lineY )
		bottomLine:setColor( 0, 0, 0, 255 )
		myPanel:insert( bottomLine )
		
		
		--
		--
		
		-- create back button as rounded rect button
		local myButton3 = newRoundedRectButton{ label="Go Back", x=0, y=display.contentHeight - 75, width=298, height=56, fontSize=18, onRelease=onButtonRelease }
		myButton3:setReferencePoint( display.CenterReferencePoint )
		myButton3.x = display.contentWidth * 0.5
		myPanel:insert( myButton3.view )
		
		
		
		--
		--
		
		-- position this panel to the right of current view
		myPanel.x = display.contentWidth
		
		-- slide the api list to the left
		apiList.view:slideLeft{ alpha=0 }
		
		-- slide the content of this new "panel" to the left
		myPanel:slideLeft{ slideAlpha=0, distance=display.contentWidth }
	end
	
	
	--
	--
	
	local newTableView_release = function()
		-- change the app's toolbar label
		appToolbar.label = "TableView Widgets"
		
		myPanel = display.newGroup()
		
		local itemData = {}
		local deleteButton
		
		-- onRelease event for each list item
		local helloWorld = function( event )
			print( "\"Hello\" from " .. event.target.titleText.text )
		end
		
		-- onSwipe event listener for individual list items
		local onSwipe = function( event )
			local listItem = event.target
			local swipeDirection = event.direction
			
			if swipeDirection == "left" then
				print( "You swiped '" .. listItem.titleText.text .. "' left!" )
				
				--leftList:deleteRow( event.target )
				
				local itemTarget = event.target
				
				local onDeleteRelease = function( event )
					leftList:deleteRow( itemTarget )
				end
				
				-- remove existing delete button (if it exists)
				display.remove( deleteButton )
				
				-- create a new delete button
				deleteButton = newButton{ label="Delete", buttonTheme="red", x=0, y=0, onRelease=onDeleteRelease }
				if not deleteButton then
					deleteButton = newRoundedRectButton{ label="Delete", x=0, y=0, width=65, height=30, cornerRadius=4, onRelease=onDeleteRelease }
				end
				event.target.itemContent:insert( deleteButton.view )
				deleteButton.y = event.target.rowHeight * 0.5 - deleteButton.height * 0.5
				deleteButton.x = display.contentWidth - deleteButton.width - 10
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
				
				if deleteButton then
					deleteButton.view:setReferencePoint( display.TopRightReferencePoint )
					transition.to( deleteButton.view, { xScale=0.1, time=100, onComplete=removeButton } )
				end
			end
			
			return true
		end
		
		-- populate data table
		for i=1,50 do
			
			local item = {
				icon = {
					image = "anscaLogo.png",
					width = 32,
					height = 32,
					paddingTop = 12,
					paddingRight = 15
				},
				title = { label = "List Item #" .. i },
				subtitle = { label = "Desc text for #" .. i .. "..." },
				onRelease = helloWorld,
				onLeftSwipe = onSwipe,
				onRightSwipe = onSwipe,
				hideArrow = true
			}
			
			itemData[i] = item
		end
		
		-- add in some categories
		table.insert( itemData, 10, { categoryName="Category 1" } )
		table.insert( itemData, 25, { categoryName="Category 2" } )
		table.insert( itemData, 35, { categoryName="Category 3" } )
		
		-- create a tableView, and insert into the myPanel group
		leftList = newTableView{ y=listBoxStart, rowHeight=60, height=320, width=320, backgroundColor="none" }
		myPanel:insert( leftList.view )		--> remember, you must remove leftList manually
		
		-- sync both tableViews with data table
		leftList:sync( itemData )
		
		-- create line to go underneath the tableViews
		local lineY = listBoxStart + 320 + 1
		local bottomLine = display.newLine( 0, lineY, display.contentWidth, lineY )
		bottomLine:setColor( 0, 0, 0, 255 )
		myPanel:insert( bottomLine )
		
		--
		--
		
		-- create back button as rounded rect button
		local myButton3 = newRoundedRectButton{ label="Go Back", x=0, y=display.contentHeight - 75, width=298, height=56, fontSize=18, onRelease=onButtonRelease }
		myButton3:setReferencePoint( display.CenterReferencePoint )
		myButton3.x = display.contentWidth * 0.5
		myPanel:insert( myButton3.view )
		
		--
		--
		
		-- position this panel to the right of current view
		myPanel.x = display.contentWidth
		
		-- slide the api list to the left
		apiList.view:slideLeft{ alpha=0 }
		
		-- slide the content of this new "panel" to the left
		myPanel:slideLeft{ slideAlpha=0, distance=display.contentWidth }
	end
	
	
	--
	--
	
	local newPickerWheel_release = function()
		
		-- change the app's toolbar label
		appToolbar.label = "Picker Wheel"
		
		myPanel = display.newGroup()
		
		local dateText, isPickerShowing, myPicker
		
		-- create touchable text
		local dateText = display.newText( "Touch to Choose Date.", 0, 0, skinSetting.defaultFont, 22 )
		dateText:setTextColor( 0, 0, 0, 255 )
		dateText:setReferencePoint( display.CenterReferencePoint )
		dateText.x = display.contentWidth * 0.5
		dateText.y = 175
		myPanel:insert( dateText )
		
		-- touch listener for label (display.newText)
		function dateText:touch( event )
			if event.phase == "began" and not isPickerShowing then
				isPickerShowing = true
				
				local doneButton
				
				local onDone = function( event )
					
					-- get values from picker wheel
					local m = myPicker.col1.value
					local d = myPicker.col2.value
					local y = myPicker.col3.value
					
					if myPicker.col1.listItems then
						print( myPicker.col1.listItems[1].titleText.text )
					end
					
					-- Update label text
					dateText.text = m .. " " .. d .. ", " .. y	
					
					-- remove the button
					display.remove( doneButton )
					doneButton = nil
					
					-- remove the picker wheel
					display.remove( myPicker )
					myPicker = nil
					
					-- make date text touchable again
					isPickerShowing = false
				end
				
				doneButton = newButton{ label="Done", size=12, onRelease=onDone }
				if not doneButton then
					doneButton = newRoundedRectButton{ label="Done", x=0, y=0, width=55, height=30, cornerRadius=2, onRelease=onDone }
				end
				doneButton:setReferencePoint( display.CenterRightReferencePoint )
				doneButton.x = display.contentWidth - 5
				doneButton.y = listBoxStart - 22
				
				myPicker = newPickerWheel{ preset="usDate", startMonth="feb", startDay=19, startYear=2011 }
				myPicker.y = display.contentHeight - myPicker.height
			end
		end
		
		-- add touch listener to label text
		dateText:addEventListener( "touch", dateText )
		
		
		--
		--
		
		-- create back button as rounded rect button
		local myButton3 = newRoundedRectButton{ label="Go Back", x=0, y=display.contentHeight - 75, width=298, height=56, fontSize=18, onRelease=onButtonRelease }
		myButton3:setReferencePoint( display.CenterReferencePoint )
		myButton3.x = display.contentWidth * 0.5
		myPanel:insert( myButton3.view )
		
		
		
		--
		--
		
		-- position this panel to the right of current view
		myPanel.x = display.contentWidth
		
		-- slide the api list to the left
		apiList.view:slideLeft{ alpha=0 }
		
		-- slide the content of this new "panel" to the left
		myPanel:slideLeft{ slideAlpha=0, distance=display.contentWidth }
		
	end
	
	
	--================================================================================================
	--
	-- Setup list on start screen
	--
	--================================================================================================
	
	-- Create table to hold list items
	local apiListItems = {}
	local icon = {
		image = "anscaLogo.png",
		width = 32,
		height = 32,
		paddingTop = 12,
		paddingRight = 15
	}
	local item
	
	-- newButton()
	item = { title = { label = "newButton", }, subtitle = { label = "Native adjustable-width UI button." }, icon=icon, onRelease=newButton_release }
	table.insert( apiListItems, item )
	
	-- newSegmentedControl()
	item = { title = { label = "newSegmentedControl", }, subtitle = { label = "Creates row of segmented buttons." }, icon=icon, onRelease=newSegmentedControl_release }
	table.insert( apiListItems, item )
	
	-- newSlider()
	item = { title = { label = "newSlider", }, subtitle = { label = "Adjustable-width UI slider control." }, icon=icon, onRelease=newSlider_release }
	table.insert( apiListItems, item )
	
	-- newScrollView()
	item = { title = { label = "newScrollView", }, subtitle = { label = "Scrolling content box w/ scrollbar." }, icon=icon, onRelease=newScrollView_release }
	table.insert( apiListItems, item )
	
	-- newTableView()
	item = { title = { label = "newTableView", }, subtitle = { label = "Blazing fast scrolling content list box." }, icon=icon, onRelease=newTableView_release }
	table.insert( apiListItems, item )
	
	-- newPickerWheel()
	item = { title = { label = "newPickerWheel", }, subtitle = { label = "Custom and/or preset wheel picker." }, icon=icon, onRelease=newPickerWheel_release }
	table.insert( apiListItems, item )
	
	-- Create the actual tableview
	apiList = newTableView{ y=listBoxStart, backgroundColor="none" }
	apiList:sync( apiListItems )	--> will sync the tableview with the table of row data
	
	-- remove status bar touch event from apiList:
	apiList:removeStatusBarTouch()

	
	--================================================================================================
	--
	-- Display App Toolbar
	--
	--================================================================================================
	
	appToolbar = newToolbar( "Widget Demo" )
	
	-- create black border above (for iPad letterboxing)
	local blackBorder = display.newRect( 0, 0, display.contentWidth, 100 )
	blackBorder:setReferencePoint( display.BottomLeftReferencePoint )
	blackBorder:setFillColor( 0, 0, 0, 255 )
	blackBorder.x, blackBorder.y = 0, appToolbar.y
	
end
