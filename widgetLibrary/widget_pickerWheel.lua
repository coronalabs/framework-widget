-- Copyright © 2013 Corona Labs Inc. All Rights Reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of the company nor the names of its contributors
--      may be used to endorse or promote products derived from this software
--      without specific prior written permission.
--    * Redistributions in any form whatsoever must retain the following
--      acknowledgment visually in the program (e.g. the credits of the program): 
--      'This product includes software developed by Corona Labs Inc. (http://www.coronalabs.com).'
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL CORONA LABS INC. BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

local M = 
{
	_options = {},
	_widgetName = "widget.newPickerWheel",
}


-- Require needed widget files
local _widget = require( "widget" )

-- Creates a new pickerWheel
local function createPickerWheel( pickerWheel, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view, viewBackground, viewOverlay, viewColumns
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	view = display.newGroup()
	
	-- The view's background
	viewOverlay = display.newImageRect( pickerWheel, imageSheet, opt.overlayFrame, opt.overlayFrameWidth, opt.overlayFrameHeight )
	
	----------------------------------
	-- Properties
	----------------------------------
	
	-- The table which holds our pickerWheel columns
	viewColumns = {}

	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Assign properties to our view
	view._width = opt.overlayFrameWidth
	view._height = opt.overlayFrameHeight
	view._top = opt.top
	view._yPosition = pickerWheel.y + ( view._height * 0.5 )
	
	-- Assign objects to our view
	view._overlay = viewOverlay
	view._background = viewBackground
	view._columns = viewColumns
	view._didTap = false
		
	-------------------------------------------------------
	-- Assign properties/objects to the pickerWheel
	-------------------------------------------------------
	
	-- Assign objects to the pickerWheel
	pickerWheel._imageSheet = imageSheet
	pickerWheel._view = view
	pickerWheel:insert( view )
	
	-- Function to render the pickerWheels columns
	local function _renderColumns( event )
		local phase = event.phase
		local row = event.row
		local fontSize = event.target._fontSize
		local alignment = event.target._align

		-- Create the column's title text
		local rowTitle = display.newText( row, row._label, 0, 0, opt.font, fontSize )
		rowTitle.y = row.contentHeight * 0.5
		rowTitle:setTextColor( unpack( opt.fontColor ) )
		row.value = rowTitle.text
		
		-- check if the text is greater than the actual column size
		local availableWidth = viewOverlay.width - 28
		local columnWidth = view._columns[ row.id ].width or availableWidth / #view._columns
		local textWidth = rowTitle.contentWidth
		if textWidth > columnWidth - 1 then
	        --cap the text
	        local pixelsPerChar = 23 -- aproximate median value
	        local numChars = columnWidth / pixelsPerChar
	        print ("nchars: ", numChars)
	        row._label = row._label:sub(1, numChars)
	        rowTitle.text = row._label
	        
	    end
		
		-- Align the text as requested
		if "center" == alignment then
			rowTitle.x = row.x
		elseif "left" == alignment then
			rowTitle.x = ( rowTitle.contentWidth * 0.5 ) + 6
		elseif "right" == alignment then
			rowTitle.x = row.x + ( row.contentWidth * 0.5 ) - ( rowTitle.contentWidth * 0.5 ) - 6
		end
	end
	
	-- Create a background to sit behind the pickerWheel
	viewBackground = display.newImageRect( view, imageSheet, opt.backgroundFrame, opt.overlayFrameWidth, opt.overlayFrameHeight )
	viewBackground.x = viewOverlay.x
	viewBackground.y = viewOverlay.y

	-- Function to create the column seperator
	function view:_createSeperator( x )		
		local seperator = display.newImageRect( self, imageSheet, opt.seperatorFrame, opt.seperatorFrameWidth + 4, opt.backgroundFrameHeight )
		seperator.x = x
		
		return seperator
	end

	-- The available width for the whole pickerWheel (to fit columns)
	local availableWidth = viewOverlay.width - 28
	
	-- local method that handles scrolling to the tapped / touched index
	function didTapValue( event )
		local phase = event.phase
		local row = event.target
		if "tap" == phase or "release" == phase then
			view._columns[ row.id ]:scrollToIndex( row.index )
			view._didTap = true
		end
	end
	
	-- Create the pickerWheel Columns (which are tableView's)
	for i = 1, #opt.columnData do
		viewColumns[i] = _widget.newTableView
		{
			left = -144,
			top = -110,
			width = opt.columnData[i].width or availableWidth / #opt.columnData,
			height = opt.overlayFrameHeight,
			topPadding = 90,
			bottomPadding = 92,
			noLines = true,
			hideBackground = true,
			hideScrollBar = true,
			friction = 0.92,
			rowColor = opt.columnColor,
			onRowRender = _renderColumns,
			maskFile = opt.maskFile,
			listener = nil,
			onRowTouch = didTapValue
		}
		viewColumns[i]._view._isUsedInPickerWheel = true
		 		
		-- Position the columns
		if i > 1 then
			viewColumns[i].x = viewColumns[i-1].x + viewColumns[i-1]._view._width
		end
		
		-- Column properties
		viewColumns[i]._align = opt.columnData[i].align
		viewColumns[i]._fontSize = opt.fontSize
			
		-- Set the volumns initial values
		viewColumns[i]._values = 
		{ 
			index = opt.columnData[i].startIndex,
			value = opt.columnData[i].labels[opt.columnData[i].startIndex],
		}
		
		-- Create the columns row's
		for j = 1, #opt.columnData[i].labels do
			viewColumns[i]:insertRow
			{
				rowHeight = 40,
				rowColor = { 
				default = { 255, 255, 255, 255 },
    			over = { 255, 255, 255, 255 }, 
    			},
				label = opt.columnData[i].labels[j],
				id = i
			}
		end
		
		-- Insert the pickerWheel column into the view
		view:insert( viewColumns[i] )
	
		-- Scroll to the defined index -- TODO needs failsafe
		viewColumns[i]:scrollToIndex( opt.columnData[i].startIndex, 0 )
	end

	-- Create the column seperators
	for i = 1, #opt.columnData - 1 do
		view:_createSeperator( viewColumns[i].x + viewColumns[i]._view._width )
	end

	-- Push the view's background to the front.
	viewOverlay:toFront()
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
		
	-- Function to retrieve the column values
	function pickerWheel:getValues()
		return self._view:_getValues()
	end	
	
	-- Function to scroll to a specific pickerWheel column row
	function pickerWheel:scrollToIndex( ... )
		local arg = { ... }

		local column = nil
		
		-- If the first arg is a number, set the column to that
		if "number" == type( arg[1] ) then
			column = arg[1]
			
			-- We have retrieved the column, now set arg1 to arg2 (which is the index to scroll to) so scrollTo index gets called as expected
			arg[1] = arg[2]
		end
		
		arg[4] = self._view:_getValues()
		
		-- Scroll to the specified column index
		return self._view._columns[column]:scrollToIndex( unpack( arg ) )
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------

	-- Override scale function as pickerWheels don't support it
	function pickerWheel:scale()
		print( M._widgetName, "Does not support scaling" )
	end

	-- EnterFrame listener for our pickerWheel
	function view:enterFrame( event )
		local _pickerWheel = self.parent
		
		-- Update the y position
		self._yPosition = _pickerWheel.y + ( self._height * 0.5 )
				
		-- Manage the Picker Wheels columns
		for i = 1, #self._columns do
			if "ended" == self._columns[i]._view._phase and not self._columns[i]._view._updateRuntime then
			    if not self._didTap then
				    self._columns[i]._values = self._columns[i]._view:_getRowAtPosition( self._yPosition )
				else
				    self._columns[i]._values = self._columns[i]._view:_getRowAtIndex( self._columns[ i ]._view._lastRowIndex )
				    self._didTap = false
				end
				self._columns[i]._view._phase = "none"
			end
		end
		
		-- Constrain x/y scale values to 1.0
		if _pickerWheel.xScale ~= 1.0 then
			_pickerWheel.xScale = 1.0
			print( M._widgetName, "Does not support scaling" )
		end
		
		if _pickerWheel.yScale ~= 1.0 then
			_pickerWheel.yScale = 1.0
			print( M._widgetName, "Does not support scaling" )
		end
		
		return true
	end
	
	Runtime:addEventListener( "enterFrame", view )
	
	-- Function to retrieve the column values
	function view:_getValues()
		local values = {}
		
		-- Loop through all the columns and retrieve the values
		for i = 1, #self._columns do
			values[i] = self._columns[i]._values
		end
		
		return values
	end

	-- Finalize function for the pickerWheel
	function pickerWheel:_finalize()
		-- Remove the event listener
		Runtime:removeEventListener( "enterFrame", self._view )
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
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
	_widget._checkRequirements( customOptions, themeOptions, M._widgetName )
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------

	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.maskFile = customOptions.maskFile or themeOptions.maskFile
	opt.font = customOptions.font or native.systemFontBold
	opt.fontSize = customOptions.fontSize or 22
	opt.fontColor = customOptions.fontColor or { 0, 0, 0 }
	opt.columnColor = customOptions.columnColor or { 255, 255, 255 }
		
	-- Properties
	opt.rowHeight = customOptions.rowHeight or 40
	opt.columnData = customOptions.columns

	-- Frames & images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	opt.backgroundFrame = customOptions.backgroundFrame or _widget._getFrameIndex( themeOptions, themeOptions.backgroundFrame )
	opt.backgroundFrameWidth = customOptions.backgroundFrameWidth or themeOptions.backgroundFrameWidth
	opt.backgroundFrameHeight = customOptions.backgroundFrameHeight or themeOptions.backgroundFrameHeight
	
	opt.overlayFrame = customOptions.overlayFrame or _widget._getFrameIndex( themeOptions, themeOptions.overlayFrame )
	opt.overlayFrameWidth = customOptions.overlayFrameWidth or themeOptions.overlayFrameWidth
	opt.overlayFrameHeight = customOptions.overlayFrameHeight or themeOptions.overlayFrameHeight
	
	opt.seperatorFrame = customOptions.seperatorFrame or _widget._getFrameIndex( themeOptions, themeOptions.seperatorFrame )
	opt.seperatorFrameWidth = customOptions.seperatorFrameWidth or themeOptions.seperatorFrameWidth
	opt.seperatorFrameHeight = customOptions.seperatorFrameHeight or themeOptions.seperatorFrameHeight
	
	-------------------------------------------------------
	-- Create the pickerWheel
	-------------------------------------------------------
		
	-- Create the pickerWheel object
	local pickerWheel = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_pickerWheel",
		baseDir = opt.baseDir,
	}

	-- Create the pickerWheel
	createPickerWheel( pickerWheel, opt )
	
	-- Set the pickerWheel's position ( set the reference point to center, just to be sure )
	pickerWheel:setReferencePoint( display.TopLeftReferencePoint )
	pickerWheel.x = opt.left
	pickerWheel.y = opt.top --+ opt.overlayFrameHeight * 0.5	
	
	return pickerWheel
end

return M
