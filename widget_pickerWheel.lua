--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_pickerWheel.lua
		
	What is it?: 
		A widget object that can be used to replicate native pickerWheels.
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newPickerWheel",
}

-- Creates a new pickerWheel
local function createPickerWheel( pickerWheel, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view, viewBackground, viewColumns
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	view = display.newGroup()
	
	-- The view's background
	viewBackground = display.newImageRect( pickerWheel, imageSheet, opt.overlayFrame, opt.overlayFrameWidth, opt.overlayFrameHeight )
	
	viewColumns = {}
	
	----------------------------------
	-- Properties
	----------------------------------

	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	view._background = viewBackground
	view._columns = viewColumns
	
	-- We need to assign these properties to the object
	view._yPosition = pickerWheel.y + ( pickerWheel.contentHeight * 0.5 )
					
	view._currentRow = 1				
					
	-------------------------------------------------------
	-- Assign properties/objects to the pickerWheel
	-------------------------------------------------------
	
	-- Assign objects to the pickerWheel
	pickerWheel._view = view
	pickerWheel:insert( view )
	
	
	
	local function _renderColumns( event )
		local phase = event.phase
		local row = event.row
		local columnNo = event.target._columnNo
		local alignment = event.target._align
		
		local rowTitle = display.newText( row, opt.columnData[columnNo].labels[row.index], 0, 0, native.systemFontBold, 22 )
		rowTitle.y = row.contentHeight * 0.5
		rowTitle:setTextColor( 0, 0, 0 )
		row.value = rowTitle.text
		
		if "center" == alignment then
			rowTitle.x = row.x
		elseif "left" == alignment then
			rowTitle.x = ( rowTitle.contentWidth * 0.5 ) + 6
		elseif "right" == alignment then
			rowTitle.x = ( rowTitle.contentWidth * 0.5 )
		end
	end
	
	-- Create a background to sit behind the pickerWheel
	local rect = display.newRect( view, 0, 0, opt.overlayFrameWidth, opt.overlayFrameHeight )
	rect.x = viewBackground.x
	rect.y = viewBackground.y

	-- 
	function view:_createSeperator( x )
		local group = display.newGroup()
		
		local background = display.newImageRect( group, imageSheet, opt.backgroundFrame, opt.backgroundFrameWidth + 2, opt.backgroundFrameHeight )
		local seperator = display.newImageRect( group, imageSheet, opt.seperatorFrame, opt.seperatorFrameWidth + 4, opt.backgroundFrameHeight )
		seperator.x = x
		background.x = seperator.x
		self:insert( group )
		
		return group
	end

	--
	local availableWidth = viewBackground.width - 28
	
	-- Create the pickerWheel Columns
	for i = 1, #opt.columnData do
		viewColumns[i] = require( "widget" ).newTableView
		{
			left = -144,
			top = -110,
			width = opt.columnData[i].width or availableWidth / #opt.columnData,
			height = opt.overlayFrameHeight,
			topPadding = 90,
			bottomPadding = 92,
			noLines = true,
			hideBackground = true,
			friction = 0.92,
			onRowRender = _renderColumns,
			maskFile = opt.maskFile,
		}
		 		
		-- Position the columns
		if i > 1 then
			viewColumns[i].x = viewColumns[i-1].x + viewColumns[i-1]._view._width
		end
		
		-- Column properties
		viewColumns[i]._columnNo = i
		viewColumns[i]._align = opt.columnData[i].align		
		viewColumns[i]._values = 
		{ 
			index = opt.columnData[i].startIndex,
			value = opt.columnData[i].labels[opt.columnData[i].startIndex],
		}
		
		-- Create the row's
		for j = 1, #opt.columnData[i].labels do
			viewColumns[i]:insertRow
			{
				rowHeight = 40,
				rowColor = { 255, 255, 255 },
			}
		end
		
		-- Insert the pickerWheel column into the view
		view:insert( viewColumns[i] )
	
		-- Scroll to the defined index -- TODO needs failsafe
		viewColumns[i]:scrollToIndex( opt.columnData[i].startIndex, 0 )
	end

	-- Create the column seperators
	for i = 1, #opt.columnData - 1 do
		--viewColumns[i].isVisible = false --TEMP
		view:_createSeperator( viewColumns[i].x + viewColumns[i]._view._width )
	end

	-- Push the view's background to the front. TODO: Could be restructured so this isn't needed
	viewBackground:toFront()
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
		
	function pickerWheel:getValues()
		return self._view:_getValues()
	end	
		
	function view:_getValues()
		local values = {}
		
		for i = 1, #self._columns do
			values[i] = self._columns[i]._values
		end
		
		return values
	end
		
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	

	
	function view:enterFrame( event )
		-- Loop through the columns
		for i = 1, #self._columns do
			if "ended" == self._columns[i]._view._phase and not self._columns[i]._view._updateRuntime then
				self._columns[i]._values = self._columns[i]._view:_getRowAtPosition( self._yPosition )
				self._columns[i]._view._phase = "none"
			end
		end
		
		return true
	end
	
	Runtime:addEventListener( "enterFrame", view )

	-- Finalize function for the pickerWheel
	function pickerWheel:_finalize()
		Runtime:removeEventListener( "enterFrame", self._view )
	end
			
	return pickerWheel
end


-- Function to create a new pickerWheel object ( widget.newPickerWheel )
function M.new( options, theme )	
	local customOptions = options or {}
	local themeOptions = theme or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- Check if the requirements for creating a widget has been met (throws an error if not)
	require( "widget" )._checkRequirements( customOptions, themeOptions, M._widgetName )
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------

	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.width = customOptions.width
	opt.height = customOptions.height
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.maskFile = customOptions.maskFile or themeOptions.maskFile
	opt.listener = customOptions.listener
		
	-- Properties
	
	opt.rowHeight = customOptions.rowHeight or 40
	opt.columnData = customOptions.columns

	-- Frames & images
	opt.sheet = customOptions.sheet or themeOptions.sheet
	opt.sheetData = customOptions.data or themeOptions.data
	
	opt.backgroundFrame = customOptions.backgroundFrame or require( themeOptions.data ):getFrameIndex( themeOptions.backgroundFrame )
	opt.backgroundFrameWidth = customOptions.backgroundFrameWidth or themeOptions.backgroundFrameWidth
	opt.backgroundFrameHeight = customOptions.backgroundFrameHeight or themeOptions.backgroundFrameHeight
	
	opt.overlayFrame = customOptions.overlayFrame or require( themeOptions.data ):getFrameIndex( themeOptions.overlayFrame )
	opt.overlayFrameWidth = customOptions.overlayFrameWidth or themeOptions.overlayFrameWidth
	opt.overlayFrameHeight = customOptions.overlayFrameHeight or themeOptions.overlayFrameHeight
	
	opt.seperatorFrame = customOptions.seperatorFrame or require( themeOptions.data ):getFrameIndex( themeOptions.seperatorFrame )
	opt.seperatorFrameWidth = customOptions.seperatorFrameWidth or themeOptions.seperatorFrameWidth
	opt.seperatorFrameHeight = customOptions.seperatorFrameHeight or themeOptions.seperatorFrameHeight
		

	-------------------------------------------------------
	-- Create the pickerWheel
	-------------------------------------------------------
		
	-- Create the pickerWheel object
	local pickerWheel = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_pickerWheel",
		baseDir = opt.baseDir,
	}

	-- Create the pickerWheel
	createPickerWheel( pickerWheel, opt )
	
	-- Set the pickerWheel's position ( set the reference point to center, just to be sure )
	pickerWheel:setReferencePoint( display.CenterReferencePoint )
	pickerWheel.x = opt.left + pickerWheel.contentWidth * 0.5
	pickerWheel.y = opt.top + pickerWheel.contentHeight * 0.5
	
	return pickerWheel
end

return M
