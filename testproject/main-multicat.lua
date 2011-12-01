--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK "Widget" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 1.5
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

local widget = require "widgetlib"
widget.setTheme( "theme_ios" )

-- create display groups
local demoGroup = display.newGroup()
local tabBarGroup = display.newGroup()

-- forward declarations for widgets (so they can be removed manually)
local list, scrollBox, backButton, doneButton, pickerButton, picker

-- private functions
local function clearGroup( g )
	-- remove all widgets (they must be removed manually)
	if list then list:removeSelf(); list = nil; end
	if scrollBox then scrollBox:removeSelf(); scrollBox = nil; end
	if backButton then backButton:removeSelf(); backButton = nil; end
	if doneButton then doneButton:removeSelf(); doneButon = nil; end
	if pickerButton then pickerButton:removeSelf(); pickerButton = nil; end
	if picker then picker:removeSelf(); picker = nil; end
	
	-- clear the contents of a group, but don't delete the group
	for i=g.numChildren,1,-1 do
		display.remove( g[i] )
	end
end

-- create a gradient for the top-half of the toolbar
local toolbarGradient = graphics.newGradient( {168, 181, 198, 255 }, {139, 157, 180, 255}, "down" )

-- create toolbar to go at the top of the screen
local titleBar = widget.newTabBar{
	top = display.statusBarHeight,
	topGradient = toolbarGradient,
	bottomFill = { 117, 139, 168, 255 },
	height = 44
}

-- position the demo group underneath the toolbar
demoGroup.y = display.statusBarHeight + titleBar.height + 1

-- create embossed text to go above toolbar
local titleText = display.newEmbossedText( "Widget Demo", 0, 0, native.systemFontBold, 20, { 255 } )
titleText:setReferencePoint( display.CenterReferencePoint )
titleText.x = display.contentWidth * 0.5
titleText.y = titleBar.y + titleBar.height * 0.5

-- tab button listeners
local function showTableView( event )
	clearGroup( demoGroup )
	
	-- create tableView widget
	list = widget.newTableView{
		width = 320,
		height = 366,
		maskFile = "assets/mask-320x366.png"
	}
	
	-- insert widget into demoGroup
	demoGroup:insert( list.view )
	
	-- onEvent listener for the tableView
	local function onRowTouch( event )
		local row = event.target
		local rowGroup = event.view

		if event.phase == "press" then
			
			if not row.isCategory and row.title then
				row.title.text = "Pressed..."
				row.title:setReferencePoint( display.CenterLeftReferencePoint )
				row.title.x = 15
			end

		elseif event.phase == "release" then

			if not row.isCategory then
				row.reRender = true
				print( "You touched row #" .. event.index )
			end
		end

		return true
	end

	-- onRender listener for the tableView
	local function onRowRender( event )
		local row = event.target
		local rowGroup = event.view
		local textFunction = display.newRetinaText
		if row.isCategory then textFunction = display.newEmbossedText; end
		
		row.title = textFunction( "Row #" .. event.index, 12, 0, native.systemFontBold, 16 )
		row.title:setReferencePoint( display.CenterLeftReferencePoint )
		row.title.y = row.height * 0.5
		
		if not row.isCategory then
			row.title.x = 15
			row.title:setTextColor( 0 )
		end

		-- must insert everything into event.view:
		rowGroup:insert( row.title )
	end
	
	-- Add 100 rows, and two categories to the tableView:
	for i=1,100 do
		local rowHeight, rowColor, lineColor, isCategory

		-- make the 25th item a category
		if i == 1 then
			isCategory = true; rowHeight = 24; rowColor={ 174, 183, 190, 255 }; lineColor={0,0,0,255}
		end

		-- make the 50th item a category as well
		if i == 4 then
			isCategory = true; rowHeight = 24; rowColor={ 174, 183, 190, 255 }; lineColor={0,0,0,255}
		end
		
		if i == 20 then
			isCategory = true; rowHeight = 24; rowColor={ 174, 183, 190, 255 }; lineColor={0,0,0,255}
		end
		
			if i == 25 then
				isCategory = true; rowHeight = 24; rowColor={ 174, 183, 190, 255 }; lineColor={0,0,0,255}
			end
		
		-- insert the row into the tableView widget
		list:insertRow{
			onEvent=onRowTouch,
			onRender=onRowRender,
			height=rowHeight,
			isCategory=isCategory,
			rowColor=rowColor,
			lineColor=lineColor
		}
	end
end

local function showScrollView( event )
	clearGroup( demoGroup )
	
	-- create scrollView widget
	scrollBox = widget.newScrollView{
		--top = display.statusBarHeight + titleBar.height,
		width = 320,
		height = 366,
		maskFile = "assets/mask-320x366.png"
	}
	
	-- insert widget into demoGroup
	demoGroup:insert( scrollBox.view )
	
	local longImage = display.newImageRect( "assets/scrollimage.png", 320, 1024 )
	longImage:setReferencePoint( display.TopLeftReferencePoint )
	longImage.x, longImage.y = 0, 0
	
	-- insert image into scrollView
	scrollBox:insert( longImage )
end

local function showButtons( event )
	clearGroup( demoGroup )
	
	-- set starting indexes for picker columns
	local monthIndex, dayIndex, yearIndex = 10, 5, 21
	
	-- create grey background
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight-demoGroup.y )
	bg:setFillColor( 152, 152, 156, 255 )
	demoGroup:insert( bg )
	
	-- create a label to show selected date
	local dateText = display.newRetinaText( "No date selected.", 0, 0, native.systemFontBold, 22 )
	dateText:setTextColor( 0 )
	dateText:setReferencePoint( display.CenterReferencePoint )
	dateText.x = display.contentWidth * 0.5
	dateText.y = 100
	demoGroup:insert( dateText )
	
	-- onRelease listener for pickerButton
	local function onButtonRelease( event )
		-- onRelease listener for back button
		local function onBackRelease( event )
			
			-- remove the picker, the done button, and the back button (event.target)
			if picker then picker:removeSelf(); picker = nil; end
			if doneButton then doneButton:removeSelf(); doneButton = nil; end
			if backButton then backButton:removeSelf(); backButton = nil; end

			return true
		end
		
		-- onRelease listener for the done button
		local function onDoneRelease( event )
			
			-- extract pickerwheel column values
			local dateColumns = picker:getValues()
			local month, day, year = dateColumns[1].value, dateColumns[2].value, dateColumns[3].value
			
			-- mark column index so we can start in same position next time
			monthIndex = dateColumns[1].index
			dayIndex = dateColumns[2].index
			yearIndex = dateColumns[3].index
			
			-- change the dateText's label
			dateText.text = month .. " " .. day .. ", " .. year
			
			-- remove the picker, the done button, and the back button (event.target)
			if picker then picker:removeSelf(); picker = nil; end
			if doneButton then doneButton:removeSelf(); doneButton = nil; end
			if backButton then backButton:removeSelf(); backButton = nil; end
			
			return true
		end

		-- create 'back' button to be placed on toolbar
		backButton = widget.newButton{
			label = "Back",
			left = 5, top = 28,
			style = "backSmall",
			onRelease = onBackRelease
		}
		
		-- create 'done' button to be placed on toolbar
		doneButton = widget.newButton{
			label = "Done",
			left = 255, top = 28,
			style = "blue2Small",
			onRelease = onDoneRelease
		}
		
		-- set up the pickerWheel's columns
		local columnData = {}
		columnData[1] = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
		columnData[1].alignment = "right"
		columnData[1].width = 150
		columnData[1].startIndex = monthIndex
		
		columnData[2] = {}
		for i=1,31 do
			columnData[2][i] = i
		end
		columnData[2].alignment = "center"
		columnData[2].width = 60
		columnData[2].startIndex = dayIndex
		
		columnData[3] = {}
		for i=1,25 do
			columnData[3][i] = i+1990
		end
		columnData[3].startIndex = yearIndex
		
		-- create pickerWheel widget
		picker = widget.newPickerWheel{
			id="pickerWheel",
			top=480, --258,
			font=native.systemFontBold,
			columns=columnData,
		}
		
		-- slide the picker-wheel up
		transition.to( picker, { time=250, y=258, transition=easing.outQuad } )
	end
	
	-- create button to show pickerWheel
	pickerButton = widget.newButton{
		label = "Show Picker",
		left = 22, top = 285,
		onRelease = onButtonRelease
	}
	
	-- insert picker button into demoGroup
	demoGroup:insert( pickerButton.view )
end

-- create buttons table for the tab bar
local tabButtons = {
	{
		label="tableView",
		up="assets/tabIcon.png",
		down="assets/tabIcon-down.png",
		width=32, height=32,
		onPress=showTableView,
		selected=true
	},
	{
		label="scrollView",
		up="assets/tabIcon.png",
		down="assets/tabIcon-down.png",
		width=32, height=32,
		onPress=showScrollView,
	},
	{
		label="button",
		up="assets/tabIcon.png",
		down="assets/tabIcon-down.png",
		width=32, height=32,
		onPress=showButtons,
	}
}

-- create a tab-bar and place it at the bottom of the screen
local demoTabs = widget.newTabBar{
	top=display.contentHeight-50,
	buttons=tabButtons
}

-- insert tab bar into display group
tabBarGroup:insert( demoTabs.view )

-- start off in the tableView tab
showTableView()