-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: newTableView unit test.

-- Change the package.path and make it so we can require the "widget.lua" file from the root directory
-------------------------------------------------------------------------------------------------
local path = package.path

-- get index of first semicolon
local i = string.find( path, ';', 1, true )
if ( i > 0 ) then
	-- first path (before semicolon) is project dir
	local projDir = string.sub( path, 1, i )

	-- assume widget dir is parent to projDir
	local widgetDir = string.gsub( projDir, '(.*)/([^/]?/\?\.lua)', '%1/../%2' )
	package.path = widgetDir .. path
end

package.preload.widget = nil
-------------------------------------------------------------------------------------------------

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = 20,
	    label = "Return To Menu",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SCROLL_TO_Y = false
	local TEST_SCROLL_TO_INDEX = false
	local TEST_DELETE_ALL_ROWS = false
	local TEST_DELETE_SINGLE_ROW = false
	local TEST_LOCKING_LIST = false
	
	local function tableViewListener( event ) 
		--print( event.phase )
		print( event.type )
	end
	
	--Create Table view
	local list = widget.newTableView{
		top = 100,									--Test setting top position.
		width = 320, height = 366,					--Test setting width/height.
		--renderThresh = 100,							--Test setting render thresh hold.
		noLines = true,								--Test setting noLines between rows.
		--maxVelocity = 5,							--Test setting maxVelocity.
		maskFile = "assets/mask-320x366.png",		--Test setting a mask.
		--baseDir = system.DocumentsDirectory		--Test base directory (Ensure maskFile specified above exists in the baseDir specified).
		hideBackground = true, 			 			--Test hiding the background color.
		scrollBarColor = { 255, 0, 128 }, 			--Test setting the scrollbar color. If this is ommited or not a table, the scrollbar falls back to it's default color.
		hideScrollBar = true, 						--Test hiding the scrollbar. When set to true, scrollbar is shown when set to false or omitted.
		listener = tableViewListener,
	}

	--Handle row rendering
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
	
	--Hande row touch events
	local function onRowTouch( event )
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
	for i = 1, 100 do
		local isCategory, rowColor, rowHeight
		local listener = onRowTouch
		
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
			listener = listener
		}
	end
	
	-- don't forget to insert objects into the scene group!
	group:insert( list )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------			
	
	--Test locking list
	if TEST_LOCKING_LIST then
		list.isLocked = true
	end
	
	--Test to scroll list to Y position
	if TEST_SCROLL_TO_Y then
		testTimer = timer.performWithDelay( 1000, function()
			list:scrollToY( -3755, 6000 ) -- y = -3755
		end, 1 )
	end
	
	--Test to scroll list to index
	if TEST_SCROLL_TO_INDEX then
		testTimer = timer.performWithDelay( 1000, function()
			list:scrollToIndex( 68, 6000 )	-- y = -3755
		end, 1 )
	end
	
	--Test deleting single row
	if TEST_DELETE_SINGLE_ROW then
		testTimer = timer.performWithDelay( 1000, function()			
			list:deleteRow( 5 ) --Delete Row 5
		end, 1 )
	end
	
	--Test delete all rows
	if TEST_DELETE_ALL_ROWS then
		testTimer = timer.performWithDelay( 1000, function()			
			list:deleteAllRows() --No rows after execution
		end, 1 )
	end
end

function scene:exitScene( event )
	--Cancel test timer if active
	if testTimer ~= nil then
		timer.cancel( testTimer )
		testTimer = nil
	end
	
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
