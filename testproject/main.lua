--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK "Widget" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 1.6
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

display.setStatusBar( display.DefaultStatusBar )
display.setDefault( "background", 255 )
system.activate( "multitouch" )

--require "strict"	-- checks for undeclared globals, etc.
local widget = require "widgetnew"
local storyboard = require "storyboard"
widget.setTheme( "theme_ios" )

local sbHeight = display.statusBarHeight
local tbHeight = 44
local top = sbHeight + tbHeight

-- create a gradient for the top-half of the toolbar
local toolbarGradient = graphics.newGradient( {168, 181, 198, 255 }, {139, 157, 180, 255}, "down" )

-- create toolbar to go at the top of the screen
local titleBar = widget.newTabBar{
	top = sbHeight,
	gradient = toolbarGradient,
	bottomFill = { 117, 139, 168, 255 },
	height = 44
}

-- create embossed text to go on toolbar
local titleText = display.newEmbossedText( "Widget Demo", 0, 0, native.systemFontBold, 20 )
titleText:setReferencePoint( display.CenterReferencePoint )
titleText:setTextColor( 255 )
titleText.x = 160
titleText.y = titleBar.y

-- create a shadow underneath the titlebar (for a nice touch)
local shadow = display.newImage( "assets/shadow.png" )
shadow:setReferencePoint( display.TopLeftReferencePoint )
shadow.x, shadow.y = 0, top
shadow.xScale = display.contentWidth / shadow.contentWidth
shadow.alpha = 0.45

-- setup storyboard scenes (non-external module scenes)
local scene1 = storyboard.newScene( "tableView" )
local scene1a = storyboard.newScene( "rowScene" )
local scene2 = storyboard.newScene( "scrollView" )
local scene3 = storyboard.newScene( "other" )

-- forward declarations and variable used in multiple scenes
local chosenRowIndex, backButton, doneButton
local dayIndex, monthIndex, yearIndex

-- tableView scene
function scene1:createScene( event )
	local group = self.view
	
	local list = widget.newTableView{
		top = top,
		height = 366,
		renderThresh = 100,
		noLines = false,
		--maxVelocity = 5,
		--maskFile = "assets/mask-320x366.png"
	}

	--list.isLocked = true
	
	--[[
	timer.performWithDelay( 5000, function()
		--list:scrollToIndex( 68 )	-- y = -3755
		list:scrollToY( -3755, 0 )
	end, 1 )
	--]]
	
	-- handles individual row rendering
	local function onRowRender( event )
		local row = event.row
		local rowGroup = event.view
		local label = "Row ("
		local color = 0
		
		if row.isCategory then
			label = "Category (";
			color = 255
		end
		
		row.textObj = display.newRetinaText( rowGroup, label .. row.index .. ")", 0, 0, native.systemFont, 16 )
		row.textObj:setTextColor( color )
		row.textObj:setReferencePoint( display.CenterLeftReferencePoint )
		row.textObj.x, row.textObj.y = 20, rowGroup.contentHeight * 0.5
	end
	
	-- handles row presses/swipes
	local function rowListener( event )
		local row = event.row
		local background = event.background
		
		if event.phase == "press" then
			
			print( "Pressed row: " .. row.index )
			background:setFillColor( 0, 110, 233, 255 )
			
			if row.textObj then
				row.textObj:setText( "Row pressed..." )
				row.textObj:setReferencePoint( display.TopLeftReferencePoint )
				row.textObj.x = 20
			end
			
		elseif event.phase == "release" or event.phase == "tap" then
			
			print( "Tapped and/or Released row: " .. row.index )
			background:setFillColor( 0, 110, 233, 255 )
			row.reRender = true
			
			-- set chosen row index to this row's index
			chosenRowIndex = row.index
			
			-- go to row scene
			storyboard.gotoScene( "rowScene", "slideLeft", 350 )
			
		elseif event.phase == "swipeLeft" then
			print( "Swiped Left row: " .. row.index )
		
		elseif event.phase == "swipeRight" then
			print( "Swiped Right row: " .. row.index )
			
		end
	end

	local function onRowEvent( event )
		print( "touched " .. event.row.index )
	end
	
	-- insert rows into list (tableView widget)
	for i=1,100 do
		local isCategory
		local rowColor
		local rowHeight
		local listener = rowListener
		
		if i == 1 or i == 25 or i == 50 or i == 75 then
			isCategory = true
			rowHeight = 24
			rowColor = { 150, 160, 180, 200 }
			listener = nil
		end
		
		list:insertRow{
			height = rowHeight,
			rowColor = rowColor,
			isCategory = isCategory,
			onRender = onRowRender,
			onEvent = onRowEvent,
			--listener = listener
		}
	end
	
	-- don't forget to insert objects into the scene group!
	group:insert( list )

	--[[
	timer.performWithDelay( 2000, function()
		for i=100,1,-1 do
			
			list:deleteAllRows()
		end
	end, 1 )
	--]]
end
scene1:addEventListener( "createScene", scene1 )

-- scene that shows when row is pressed/released in tableView
function scene1a:createScene( event )
	local group = self.view
	
	local bg = display.newRect( group, 0, top, display.contentWidth, 366 )
	bg:setFillColor( 172 )
	
	self.textObj = display.newEmbossedText( "Pressed row #" .. chosenRowIndex, 0, 0, native.systemFontBold, 18 )
	self.textObj:setTextColor( 0 )
	self.textObj:setReferencePoint( display.CenterReferencePoint )
	self.textObj.x, self.textObj.y = 160, 366 * 0.5
	
	group:insert( self.textObj )
end
scene1a:addEventListener( "createScene", scene1a )

-- enterScene listener for row scene (called every time scene is requested)
function scene1a:enterScene( event )
	local group = self.view
	
	if self.textObj then
		self.textObj:setText( "Pressed row #" .. chosenRowIndex )
		self.textObj:setReferencePoint( display.CenterReferencePoint )
		self.textObj.x, self.textObj.y = 160, 366 * 0.5
		self.textObj.isVisible = true
	end
	
	-- onRelease listener for back button
	local function onBackRelease( event )
		storyboard.gotoScene( "tableView", "slideRight", 350 )
		
		local function removeButton()
			display.remove( backButton )
			backButton = nil
		end
		
		transition.to( backButton, { time=125, x=160, alpha=0, onComplete=removeButton } )
	end
	
	-- create back button to go on the toolbar (is local due to forward declaration defined earlier)
	backButton = widget.newButton{
		style = "backSmall",
		label = "Back", yOffset = -2,
		onRelease = onBackRelease
	}
	backButton.x = 40
	backButton.y = titleBar.y
end
scene1a:addEventListener( "enterScene", scene1a )

-- exitScene listener for row scene
function scene1a:exitScene( event )
	if self.textObj then
		self.textObj.isVisible = false
	end
end
scene1a:addEventListener( "exitScene", scene1a )

-- destroyScene listener for row scene (called when scene is purged)
function scene1a:destroyScene( event )
	if self.textObj then
		self.textObj:removeSelf()
		self.textObj = nil
	end
end
scene1a:addEventListener( "destroyScene", scene1a )

-- scrollView scene
function scene2:createScene( event )
	local group = self.view
	
	local scrollListener = function( event )
		print( event.type )
	end
	
	-- create scrollView widget that scrolls horizontally/vertically if
	-- scrollWidth/Height params are greater than width/height parameters
	local scrollBox = widget.newScrollView{
		top = top,
		width = display.contentWidth, height = 366,
		scrollWidth = 768, scrollHeight = 190,
		--maskFile = "assets/mask-320x366.png",
		bgColor = {255,255,255,255},
		scrollBarColor = {255, 0, 128}, --Sets the scrollbar color. If this is ommited or not a table, the scrollbar falls back to it's default color
		listener = scrollListener
	}
	
	-- insert image into scrollView widget
	local bg = display.newImageRect( "assets/scrollimage.jpg", 768, 1024 )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x, bg.y = 0, 0
	scrollBox:insert( bg )

	--timer.performWithDelay( 1000, function() scrollBox.content.velocity = 0; end, 0 )
	
	-- don't forget to insert objects into the scene group!
	group:insert( scrollBox )
end
scene2:addEventListener( "createScene", scene2 )

-- other scene
function scene3:createScene( event )
	local group = self.view
	
	local bg = display.newRect( group, 0, top, display.contentWidth, 366 )
	bg:setFillColor( 172 )
	
	-- onRelease listener for 'Show Picker' button
	local function onButtonRelease( event )
		-- set up the pickerWheel's columns
		local columnData = {}
		columnData[1] = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
		columnData[1].alignment = "right"
		columnData[1].width = 150
		columnData[1].startIndex = monthIndex or 3
		
		columnData[2] = {}
		for i=1,31 do
			columnData[2][i] = i
		end
		columnData[2].alignment = "center"
		columnData[2].width = 60
		columnData[2].startIndex = dayIndex or 25
		
		columnData[3] = {}
		for i=1,25 do
			columnData[3][i] = i+1990
		end
		columnData[3].startIndex = yearIndex or 20
		
		-- create pickerWheel widget
		local picker = widget.newPickerWheel{
			top=display.contentHeight,
			font=native.systemFontBold,
			columns=columnData,
		}
		
		-- onComplete listener for pickerWheel "slide up" transition
		local function showDoneButton()
		
			local function onDoneRelease( event )
				-- extract selected rows from pickerWheel columns
				local pickerValues = picker:getValues()
				monthIndex = pickerValues[1].index
				dayIndex = pickerValues[2].index
				yearIndex = pickerValues[3].index
				
				print( "Chosen date: " .. pickerValues[1].value .. " " .. pickerValues[2].value .. ", " .. pickerValues[3].value )
				
				display.remove( picker )
				picker = nil
				
				display.remove( doneButton )
				doneButton = nil
			end
			
			-- button below is local because of forward declaration defined earlier
			doneButton = widget.newButton{
				style = "blue1Small",
				label = "Done",
				onRelease = onDoneRelease
			}
			doneButton.x = display.contentWidth - 40
			doneButton.y = titleBar.y
		end
		
		-- slider pickerWheel up into view
		transition.to( picker, { time=350, y=display.contentHeight-222, transition=easing.inOutExpo, onComplete=showDoneButton } )
	end
	
	-- create button widget to show pickerWheel
	local button = widget.newButton{
		label = "Show Picker",
		onRelease = onButtonRelease
	}
	group:insert( button )
	button.x = 160
	button.y = 300

	local button2 = widget.newButton{
		label = "Other Button",
		onRelease = function() print( "pressed!" ); end
	}
	group:insert( button2 )
	button2.x = 160
	button2.y = 400
	
	-- create a label, slider, and slider listener
	local sliderResult = display.newEmbossedText( group, "Slider at 50%", 0, 0, native.systemFontBold, 22 )
	sliderResult:setTextColor( 0 )
	sliderResult:setReferencePoint( display.CenterReferencePoint )
	sliderResult.x = 160
	sliderResult.y = 150
	
	-- slider listener function
	local function sliderListener( event )
		local string = "Slider at " .. event.value .. "%"
		sliderResult:setText( string )
		sliderResult:setReferencePoint( display.CenterReferencePoint )
		sliderResult.x = 160
		sliderResult.y = 150
	end
	
	local slider = widget.newSlider{
		top = 200,
		left = 50,
		listener = sliderListener
	}
	group:insert( slider )
end
scene3:addEventListener( "createScene", scene3 )

-- create buttons table for the tab bar
local tabButtons = {
	{
		label="tableView",
		default="assets/tabIcon.png",
		down="assets/tabIcon-down.png",
		width=32, height=32,
		onPress=function() storyboard.gotoScene( "tableView" ); end,
		selected=true
	},
	{
		label="scrollView",
		default="assets/tabIcon.png",
		down="assets/tabIcon-down.png",
		width=32, height=32,
		onPress=function() storyboard.gotoScene( "scrollView" ); end,
	},
	{
		label="Other",
		default="assets/tabIcon.png",
		down="assets/tabIcon-down.png",
		width=32, height=32,
		onPress=function() storyboard.gotoScene( "other" ); end,
	}
}

-- create a tab-bar and place it at the bottom of the screen
local demoTabs = widget.newTabBar{
	top=display.contentHeight-50,
	buttons=tabButtons,
	maxTabWidth = 120
}

-- begin with tableView scene
storyboard.gotoScene( "tableView" )