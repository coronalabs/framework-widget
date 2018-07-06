
-- Abstract: widget.newPickerWheel()
-- Code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

local M = 
{
	_options = {},
	_widgetName = "widget.newPickerWheel",
}

-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )
local isByteColorRange = display.getDefault( "isByteColorRange" )

local labelColor = { 0.60 }
local defaultRowColor = { 1 }
local blackColor = { 0 }

-- Set constants
local kDEFAULT_WIDGET_WIDTH = 320
local kDEFAULT_WIDGET_HEIGHT = 222

if isByteColorRange then
	_widget._convertColorToV1( labelColor )
	_widget._convertColorToV1( defaultRowColor )
	_widget._convertColorToV1( blackColor )
end

-- Creates a new pickerWheel
local function createPickerWheel( pickerWheel, options )

	-- Create a local reference to our options table
	local opt = options

	-- Issue warning if resizable construction and legacy widget themes are used
	if opt.resizable == true and ( _widget.themeName == "widget_theme_ios" or _widget.themeName == "widget_theme_android" ) then
		print( "WARNING: " .. M._widgetName .. " - resizable construction is not compatible with the legacy widget theme '" .. _widget.themeName .. "'; please use a different theme or the default widget construction method" )
		return
	end

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

	if opt.resizable == true then
		-- For resizable pickers, begin with an invisible vector rectangle for sizing
		-- Rectangle height is opt.rowHeight*5 (plus border padding) because pickers inherently use 5 rows to display choices
		viewOverlay = display.newRect( pickerWheel, 0, 0, opt.width + (opt.borderPadding*2), (opt.rowHeight*5) + (opt.borderPadding*2) )
		viewOverlay.isVisible = false
	else
		if opt.overlayFrame then
			viewOverlay = display.newImageRect( pickerWheel, imageSheet, opt.overlayFrame, kDEFAULT_WIDGET_WIDTH, kDEFAULT_WIDGET_HEIGHT )
		else
			viewOverlay = display.newRect( pickerWheel, 0, 0, kDEFAULT_WIDGET_WIDTH, kDEFAULT_WIDGET_HEIGHT )
			viewOverlay.isVisible = false
		end
	end
	view._overlay = viewOverlay
	
	----------------------------------
	-- Properties
	----------------------------------
	
	-- The table which holds our pickerWheel columns
	viewColumns = {}
	view._columns = viewColumns

	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	if opt.resizable == true then
		view._width = opt.width
		view._height = opt.rowHeight*5  -- Height is opt.rowHeight*5 because pickers inherently use 5 rows to display choices
		view._yPosition = pickerWheel.y + ( (opt.rowHeight*5) * 0.5 )
	else
		view._width = kDEFAULT_WIDGET_WIDTH
		view._height = kDEFAULT_WIDGET_HEIGHT
		view._yPosition = pickerWheel.y + ( view._height * 0.5 )
	end

	view._top = opt.top
	view._didTap = false
	view._forceScrollRow = nil

	-------------------------------------------------------
	-- Assign properties/objects to the pickerWheel
	-------------------------------------------------------
	
	-- Assign objects to the pickerWheel
	pickerWheel._imageSheet = imageSheet
	pickerWheel._view = view
	pickerWheel:insert( view )
	
	-- Function to render the pickerWheels columns
	local function _renderColumns( event )

		local row = event.row
		local font = event.target._font or opt.font
		local fontSize = event.target._fontSize
		local alignment = event.target._align
		local highlightRow = false

		local rh = row.contentHeight
		local rw = row.contentWidth

		-- Create the row's label text
		local rowTitle = display.newText( row, row._label, 0, 0, font, fontSize )
		rowTitle.y = rh * 0.5

		-- When the widget is outside the view so no column is rendered, then _values does not exist, so we check for it
		if pickerWheel._view._columns[row.id]._values then
			-- Highlight the selected row as it comes into view, only if force row selection is not underway
			if ( row.index == pickerWheel._view._columns[row.id]._values.index and nil == pickerWheel._view._forceScrollRow ) then
				highlightRow = true
			end
			-- If user has called force row selection, highlight row as it comes into view
			if ( row.index == pickerWheel._view._forceScrollRow and nil ~= pickerWheel._view._forceScrollRow ) then
				pickerWheel._view._forceScrollRow = nil
				highlightRow = true
			end
		end

		-- If highlight row boolean is true, highlight row according to user-defined OR default label color settings
		if highlightRow == true then
			if ( event.target._fontColorSelected and type( event.target._fontColorSelected ) == "table" ) then
				rowTitle:setFillColor( unpack( event.target._fontColorSelected ) )  -- This is the user-defined label highlight color
			else
				rowTitle:setFillColor( unpack( blackColor ) )  -- This is the default label highlight color
			end
		else
			if ( event.target._fontColor and type( event.target._fontColor ) == "table" ) then
				rowTitle:setFillColor( unpack( event.target._fontColor ) )  -- This is the user-defined label unselected color
			else
				rowTitle:setFillColor( unpack( labelColor ) )  -- This is the default label unselected color
			end
		end

		row.value = rowTitle.text

		local availableWidth = viewOverlay.width - 28
		if opt.resizable == true then
			availableWidth = view._width
		end
		local columnWidth = view._columns[row.id].width or availableWidth / #view._columns

		-- Align the text as requested
		if "center" == alignment then

			local rowTitleX
			if isGraphicsV1 then
				rowTitleX = row.x
			else
				rowTitleX = rw - columnWidth * 0.5
			end
			rowTitle.x = rowTitleX

		elseif "left" == alignment then

			local rowTitleX
			local labelPadding = event.target._labelPadding or 6
			if isGraphicsV1 then
				rowTitleX = ( rowTitle.contentWidth * 0.5 ) + labelPadding
			else
				rowTitleX = rw - columnWidth + labelPadding
				rowTitle.anchorX = 0
			end
			rowTitle.x = rowTitleX

		elseif "right" == alignment then
			
			local rowTitleX
			local labelPadding = event.target._labelPadding or 6
			if isGraphicsV1 then
				rowTitleX = row.x + ( row.contentWidth * 0.5 ) - ( rowTitle.contentWidth * 0.5 ) - labelPadding
			else
				rowTitleX = rw - labelPadding
				rowTitle.anchorX = 1
			end
			rowTitle.x = rowTitleX
		end
	end

	-- Create a background to sit behind the pickerWheel
	if opt.resizable == true then
		-- Height is opt.rowHeight*5 because pickers inherently use 5 rows to display choices
		if opt.backgroundFrame then
			viewBackground = display.newImageRect( view, imageSheet, opt.backgroundFrame, opt.width, opt.rowHeight*5 )
		else
			viewBackground = display.newRect( view, 0, 0, opt.width, opt.rowHeight*5 )
			viewBackground.isVisible = false
		end
	else
		if opt.backgroundFrame then
			viewBackground = display.newImageRect( view, imageSheet, opt.backgroundFrame, kDEFAULT_WIDGET_WIDTH, kDEFAULT_WIDGET_HEIGHT )
		else
			viewBackground = display.newRect( view, 0, 0, kDEFAULT_WIDGET_WIDTH, kDEFAULT_WIDGET_HEIGHT )
			viewBackground.isVisible = false
		end
	end
	viewBackground.x = viewOverlay.x
	viewBackground.y = viewOverlay.y
	view._background = viewBackground

	-- Function to create the column separator
	function view:_createSeparator( x )
		local separator = display.newSprite( self, imageSheet, { name="separator", start=opt.separatorFrame, count=1 } )
		if opt.resizable == true then
			-- Height is opt.rowHeight*5 because pickers inherently use 5 rows to display choices
			separator.height = (opt.rowHeight*5)
		else
			separator.height = kDEFAULT_WIDGET_HEIGHT
		end
		separator.x = x
		return separator
	end

	-- The available width for the whole pickerWheel (to fit columns)
	local availableWidth = viewOverlay.width - 28
	if opt.resizable == true then
		availableWidth = view._width
	end

	-- local method that handles scrolling to the tapped / touched index
	local function didTapValue( event )
		local phase = event.phase
		local row = event.target
		if "tap" == phase or "release" == phase then
			view._columns[ row.id ]:scrollToIndex( row.index )
			view._didTap = true
			view._forceScrollRow = nil
		end
		-- If select value function is defined, call it
		if ( pickerWheel.onValueSelected and "function" == type(pickerWheel.onValueSelected) ) then
			pickerWheel.onValueSelected{ column = row.id, row = row.index }
		end
	end

	-- Create the pickerWheel columns (which are tableViews)
	-- Padding values for default (non-resizable) pickers come from the following considerations:
	-- Rows are 40 in height and we need 2 full rows of padding at the top and bottom of the tableView widget: 40 * 2 = 80.
	-- In addition, there are 22 extra pixels in the overall picker height: 222 (default height) - 200 (5 rows * 40) = 22.
	-- Divide extra pixels (22) by 2, then add to top or bottom padding: (22/2) + 80 = 91.
	local topPadding = 91
	local bottomPadding = 91
	local initialPos = -140  -- Default width of picker is 280, so start first column at -280/2

	if opt.resizable == true then
		-- For resizable pickers, formula is much easier:
		-- There is no extra padding to deal with, so just add 2 full rows of padding at the top and bottom of the tableView widget.
		topPadding = opt.rowHeight * 2
		bottomPadding = opt.rowHeight * 2
		initialPos = - view._width * 0.5
	end
	if isGraphicsV1 then
		topPadding = 90
		bottomPadding = pickerWheel.contentHeight - 20 - pickerWheel.contentHeight * 0.5 -- 20 is half a row height
	end

	-- Pre-check column width settings and issue warnings
	local totalColumnWidth = 0
	for i = 1, #opt.columnData do
		if opt.columnData[i].width then
			if not tonumber(opt.columnData[i].width) then
				print( "WARNING: " .. M._widgetName .. " - 'width' parameter for column " .. i .. " should be a number; using 80 instead" )
				opt.columnData[i].width = 80
			elseif opt.columnData[i].width < 0 then
				print( "WARNING: " .. M._widgetName .. " - 'width' parameter for column " .. i .. " should be a positive number; using 80 instead" )
				opt.columnData[i].width = 80
			end
			totalColumnWidth = totalColumnWidth + opt.columnData[i].width
		end
	end
	if opt.resizable == true then
		if totalColumnWidth > availableWidth then
			print( "WARNING: " .. M._widgetName .. " - total width for all columns (" .. tostring(totalColumnWidth) .. ") exceeds the defined overall widget 'width' of " .. tostring(availableWidth) .. "; bleeding may occur, so the total width of all columns should not exceed " .. tostring(availableWidth) )
		end
	else
		if totalColumnWidth > 280 then
			print( "WARNING: " .. M._widgetName .. " - total width for all columns (" .. tostring(totalColumnWidth) .. ") exceeds the recommended limit of 280; bleeding may occur, so the total width of all columns should not exceed 280" )
		end
	end

	for i = 1, #opt.columnData do

		local columnWidth = opt.columnData[i].width or availableWidth / #opt.columnData

		if i > 1 then
			initialPos = viewColumns[i-1].x + ( viewColumns[i-1]._view._width * 0.5 )
		--elseif i == #opt.columnData then
			--initialPos = math.ceil( ( availableWidth * 0.5 ) - columnWidth )
		end

		local colTop = kDEFAULT_WIDGET_HEIGHT * -0.5
		local colHeight = kDEFAULT_WIDGET_HEIGHT
		if opt.resizable == true then
			colTop = (-opt.rowHeight*3) + (opt.rowHeight*0.5)
			colHeight = opt.rowHeight*5
		end
		
		viewColumns[i] = _widget.newTableView
		{
			left = initialPos,
			top = colTop,
			width = columnWidth,
			height = colHeight,
			topPadding = topPadding,
			bottomPadding = bottomPadding,
			noLines = true,
			hideBackground = false,
			hideScrollBar = true,
			friction = 0.92,
			rowColor = opt.columnColor,
			backgroundColor = opt.backgroundColor or defaultRowColor,
			onRowRender = _renderColumns,
			listener = nil,
			onRowTouch = didTapValue
		}
		viewColumns[i]._view._onValueSelected = pickerWheel.onValueSelected
		viewColumns[i]._view._isUsedInPickerWheel = true
		viewColumns[i]._view._inUserControl = false

		-- Column properties
		viewColumns[i]._align = opt.columnData[i].align or "center"
		viewColumns[i]._labelPadding = opt.columnData[i].labelPadding
		viewColumns[i]._fontSize = opt.fontSize
		viewColumns[i]._font = opt.font
		viewColumns[i]._fontColor = opt.fontColor
		viewColumns[i]._fontColorSelected = opt.fontColorSelected
		viewColumns[i]._view._fontColor = opt.fontColor

		-- Set the volumns initial values
		viewColumns[i]._values = 
		{ 
			index = opt.columnData[i].startIndex,
			value = opt.columnData[i].labels[opt.columnData[i].startIndex],
		}
		
		-- Create the column's rows
		for j = 1, #opt.columnData[i].labels do
			viewColumns[i]:insertRow
			{
				rowHeight = opt.rowHeight,
				rowColor = { 
					default = opt.columnColor,
    				over = opt.columnColor, 
    			},
				label = opt.columnData[i].labels[j],
				id = i
			}
		end

		-- Insert the pickerWheel column into the view
		view:insert( viewColumns[i] )
	
		-- Scroll to the defined index
		viewColumns[i]:scrollToIndex( opt.columnData[i].startIndex, 0 )
	end

	-- Resizable skin foundation
	if opt.resizable == true then
		if opt.middleSpanTopFrame then
			local middleSpanTop = display.newSprite( view, imageSheet, { name="middleSpanTop", start=opt.middleSpanTopFrame, count=1 } )
			middleSpanTop.width = viewBackground.contentWidth
			middleSpanTop.x = viewBackground.x
			-- Align middle span (top part) to top edge of central row, minus any offset
			middleSpanTop.anchorY = 0
			middleSpanTop.y = viewBackground.y - (opt.rowHeight*0.5) - opt.middleSpanOffset
		end
		if opt.middleSpanBottomFrame then
			local middleSpanBottom = display.newSprite( view, imageSheet, { name="middleSpanBottom", start=opt.middleSpanBottomFrame, count=1 } )
			middleSpanBottom.width = viewBackground.contentWidth
			middleSpanBottom.x = viewBackground.x
			-- Align middle span (bottom part) to bottom edge of central row, plus any offset
			middleSpanBottom.anchorY = 1
			middleSpanBottom.y = viewBackground.y + (opt.rowHeight*0.5) + opt.middleSpanOffset
		end
		if opt.topFadeFrame then
			local topFade = display.newSprite( view, imageSheet, { name="topFade", start=opt.topFadeFrame, count=1 } )
			topFade.width = viewBackground.contentWidth
			-- The following clause checks if it's a default theme widget (not custom-skinned) and also checks the constructed height
			-- If less than 200, height of fade frame is scaled down so that it doesn't visually overwhelm toward vertical center
			if ( ( _widget.isHolo() or _widget.isSeven() ) and viewBackground.height < 200 ) then
				topFade.height = (viewBackground.height/200) * topFade.contentHeight
			end
			topFade.x = viewBackground.x
			topFade.anchorY = 0
			topFade.y = viewBackground.contentBounds.yMin
		end
		if opt.bottomFadeFrame then
			local bottomFade = display.newSprite( view, imageSheet, { name="bottomFade", start=opt.bottomFadeFrame, count=1 } )
			bottomFade.width = viewBackground.contentWidth
			-- The following clause checks if it's a default theme widget (not custom-skinned) and also checks the constructed height
			-- If less than 200, height of fade frame is scaled down so that it doesn't visually overwhelm toward vertical center
			if ( ( _widget.isHolo() or _widget.isSeven() ) and viewBackground.height < 200 ) then
				bottomFade.height = (viewBackground.height/200) * bottomFade.contentHeight
			end
			bottomFade.x = viewBackground.x
			bottomFade.anchorY = 1
			bottomFade.y = viewBackground.contentBounds.yMax
		end
	end

	-- Create the column separators
	if opt.separatorFrame then
		for i = 1, #opt.columnData - 1 do
			view:_createSeparator( viewColumns[i].x + viewColumns[i]._view._width * 0.5 )
		end
	end

	-- Resizable skin surrounding frame
	-- This frame is only constructed if ALL of the elements are defined (docs note that this framing is "all or nothing")
	if ( opt.resizable == true and opt.sheet and opt.topLeftFrame and opt.topRightFrame and opt.bottomLeftFrame and opt.bottomRightFrame and opt.topMiddleFrame and opt.middleLeftFrame and opt.middleRightFrame and opt.bottomMiddleFrame ) then
		local topLeft = display.newSprite( view, imageSheet, { name="topLeft", start=opt.topLeftFrame, count=1 } )
		topLeft.anchorX = 0
		topLeft.anchorY = 0
		topLeft.x = viewBackground.contentBounds.xMin - opt.borderPadding
		topLeft.y = viewBackground.contentBounds.yMin - opt.borderPadding
		local topRight = display.newSprite( view, imageSheet, { name="topRight", start=opt.topRightFrame, count=1 } )
		topRight.anchorX = 1
		topRight.anchorY = 0
		topRight.x = viewBackground.contentBounds.xMax + opt.borderPadding
		topRight.y = viewBackground.contentBounds.yMin - opt.borderPadding
		local bottomLeft = display.newSprite( view, imageSheet, { name="bottomLeft", start=opt.bottomLeftFrame, count=1 } )
		bottomLeft.anchorX = 0
		bottomLeft.anchorY = 1
		bottomLeft.x = viewBackground.contentBounds.xMin - opt.borderPadding
		bottomLeft.y = viewBackground.contentBounds.yMax + opt.borderPadding
		local bottomRight = display.newSprite( view, imageSheet, { name="bottomRight", start=opt.bottomRightFrame, count=1 } )
		bottomRight.anchorX = 1
		bottomRight.anchorY = 1
		bottomRight.x = viewBackground.contentBounds.xMax + opt.borderPadding
		bottomRight.y = viewBackground.contentBounds.yMax + opt.borderPadding
		local topMiddle = display.newSprite( view, imageSheet, { name="topMiddle", start=opt.topMiddleFrame, count=1 } )
		topMiddle.width = opt.width - ( topLeft.contentWidth + topRight.contentWidth ) + (opt.borderPadding*2)
		topMiddle.anchorY = 0
		topMiddle.x = viewBackground.x
		topMiddle.y = viewBackground.contentBounds.yMin - opt.borderPadding
		local middleLeft = display.newSprite( view, imageSheet, { name="middleLeft", start=opt.middleLeftFrame, count=1 } )
		middleLeft.height = (opt.rowHeight*5) - ( topLeft.contentHeight + bottomLeft.contentHeight ) + (opt.borderPadding*2)
		middleLeft.anchorX = 0
		middleLeft.x = viewBackground.contentBounds.xMin - opt.borderPadding
		middleLeft.y = viewBackground.y
		local middleRight = display.newSprite( view, imageSheet, { name="middleRight", start=opt.middleRightFrame, count=1 } )
		middleRight.height = (opt.rowHeight*5) - ( topRight.contentHeight + bottomRight.contentHeight ) + (opt.borderPadding*2)
		middleRight.anchorX = 1
		middleRight.x = viewBackground.contentBounds.xMax + opt.borderPadding
		middleRight.y = viewBackground.y
		local bottomMiddle = display.newSprite( view, imageSheet, { name="bottomMiddle", start=opt.bottomMiddleFrame, count=1 } )
		bottomMiddle.width = opt.width - ( bottomLeft.contentWidth + bottomRight.contentWidth ) + (opt.borderPadding*2)
		bottomMiddle.anchorY = 1
		bottomMiddle.x = viewBackground.x
		bottomMiddle.y = viewBackground.contentBounds.yMax + opt.borderPadding
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
	
	-- Function to "force scroll" to a specific pickerWheel column row
	function pickerWheel:selectValue( targetColumn, targetIndex, snapToIndex )

		-- Perform argument error checking
		if ( nil == tonumber(targetColumn) or nil == tonumber(targetIndex) ) then return
		else
			if ( targetColumn % 1 ~= 0 ) then return end  -- Confirm integer
			if ( targetIndex % 1 ~= 0 ) then return end  -- Confirm integer
			if ( targetColumn < 1 or targetColumn > #self._view._columns ) then return end  -- Confirm is within column range
			if ( targetIndex < 1 or targetIndex > self._view._columns[targetColumn]:getNumRows() ) then return end  -- Confirm is within row range
		end

		-- If pickerWheel column is under user control (being moved, etc.) then return/cancel out of this method
		if self._view._columns[targetColumn]._view._inUserControl == true then return end

		-- Look up actual column values if available
		if viewColumns then
			if ( viewColumns[targetColumn] ) then
				self._view._columns[targetColumn]._values =
				{
					index = viewColumns[targetColumn]._view._rows[targetIndex]["index"],
					value = viewColumns[targetColumn]._view._rows[targetIndex]["_label"]
				}
			end
		end

		-- If snapToIndex argument is true, set time parameter to 0
		local time ; if snapToIndex == true then time = 0 end

		self._view._forceScrollRow = targetIndex
		self._view._columns[targetColumn]:reloadData()
		self._view._columns[targetColumn]:scrollToIndex( targetIndex, time )

		-- If select value function is defined, call it
		if ( self.onValueSelected and "function" == type(self.onValueSelected) ) then
			if targetColumn and targetIndex then
				self.onValueSelected{ column = targetColumn, row = targetIndex }
			end
		end
	end

	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------

	-- Override scale function as pickerWheels don't support it
	function pickerWheel:scale()
		print( "WARNING: " .. M._widgetName .. " does not support scaling" )
	end

	-- EnterFrame listener for our pickerWheel
	function view:enterFrame( event )

		if not self.parent then
			Runtime:removeEventListener( "enterFrame", self )
			return true
		end

		local _pickerWheel = self.parent
		-- Update the y position	
		-- this has to be calculated in content coordinates to abstract the widget being in a group
		local xPos, yPos = _pickerWheel:localToContent( 0, 0 )

		if isGraphicsV1 then
			self._yPosition = yPos + self.y + ( self._height * 0.5 )
		else
			self._yPosition = yPos + ( self._height * 0.5 )
		end
		
		-- Manage the pickerWheel columns
		for i = 1, #self._columns do
		
			if "ended" == self._columns[i]._view._phase and not self._columns[i]._view._updateRuntime then
			    if not self._didTap then
					self._columns[i]._values = self._columns[i]._view:_getRowAtPosition( yPos )
				else
				    self._columns[i]._values = self._columns[i]._view:_getRowAtIndex( self._columns[i]._view._lastRowIndex )
				    self._didTap = false
				end
				self._columns[i]._view._phase = "none"
				self._columns[i]._view._inUserControl = false

				if nil == self._columns[i]._values then
					if ( viewColumns[i] ) then
						if ( self._columns[i]._view._hasHitBottomLimit == true and self._columns[i]._view._hasHitTopLimit == false ) then
							self._columns[i]._values = {
								index = viewColumns[i]._view._rows[1]["index"],
								value = viewColumns[i]._view._rows[1]["_label"]
							}
						elseif ( self._columns[i]._view._hasHitBottomLimit == false and self._columns[i]._view._hasHitTopLimit == true ) then
							self._columns[i]._values = {
								index = viewColumns[i]._view._rows[#self._columns[i]._view._rows]["index"],
								value = viewColumns[i]._view._rows[#self._columns[i]._view._rows]["_label"]
							}
						end
						-- If select value function is defined, call it
						if ( pickerWheel.onValueSelected and "function" == type(pickerWheel.onValueSelected) ) then
							pickerWheel.onValueSelected{ column = i, row = self._columns[i]._values.index }
						end
					end
					self._columns[i]:reloadData()
				else
					if ( self._columns[i]._fontColorSelected and type( self._columns[i]._fontColorSelected ) == "table" ) then
						self._columns[i]._view._rows[self._columns[i]._values.index]._view[2]:setFillColor( unpack( self._columns[i]._fontColorSelected ) )
					else
						self._columns[i]._view._rows[self._columns[i]._values.index]._view[2]:setFillColor( unpack( blackColor ) )
					end
				end
			end
		end

		-- Constrain x/y scale values to 1.0
		if _pickerWheel.xScale ~= 1.0 then
			_pickerWheel.xScale = 1.0
			print( "WARNING: " .. M._widgetName .. " does not support scaling" )
		end
		if _pickerWheel.yScale ~= 1.0 then
			_pickerWheel.yScale = 1.0
			print( "WARNING: " .. M._widgetName .. " does not support scaling" )
		end

		return true
	end

	Runtime:addEventListener( "enterFrame", view )

	-- Function to retrieve the column values
	function view:_getValues()
		local values = {}

		-- Loop through all the columns and retrieve the values
		for i = 1, #self._columns do

			if self._columns[i]._values then
				values[i] = self._columns[i]._values
			end
		end

		return values
	end

	-- Finalize function for the pickerWheel
	function pickerWheel:_finalize()
		-- Remove the event listener
		Runtime:removeEventListener( "enterFrame", self._view )
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
		if imageSheet then imageSheet = nil; end
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
	opt.x = customOptions.x or nil
	opt.y = customOptions.y or nil
	if customOptions.x and customOptions.y then
		opt.left = 0
		opt.top = 0
	end
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.font = customOptions.font or themeOptions.font or native.systemFontBold
	opt.fontSize = customOptions.fontSize or themeOptions.fontSize or 22
	opt.fontColor = customOptions.fontColor or themeOptions.fontColor or labelColor
	opt.fontColorSelected = customOptions.fontColorSelected or themeOptions.fontColorSelected or blackColor
	opt.columnColor = customOptions.columnColor or themeOptions.columnColor or defaultRowColor
	opt.backgroundColor = customOptions.columnColor or themeOptions.columnColor or defaultRowColor
	opt.onValueSelected = customOptions.onValueSelected

	-- Determine pickerWheel style (accept both spellings)
	if ( customOptions.style == "resizable" or customOptions.style == "resizeable" ) then
		opt.resizable = true
		-- Confirm picker width is specified for resizable pickers
		if not tonumber(customOptions.width) then
			print( "WARNING: " .. M._widgetName .. " - for resizable construction, 'width' parameter must be specified as a positive integer; using default instead (" .. kDEFAULT_WIDGET_WIDTH .. ")" )
			opt.width = kDEFAULT_WIDGET_WIDTH
		else
			opt.width = math.abs(customOptions.width)
		end
	else
		opt.resizable = false
	end

	if _widget.isSeven() then
		opt.font = customOptions.font or themeOptions.font or native.systemFont
		opt.fontSize = customOptions.fontSize or themeOptions.fontSize or 20
	end

	-- Frames & images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data

	-- Set row height
	opt.rowHeight = 40
	if ( opt.resizable == true ) then
		if tonumber(customOptions.rowHeight) then
			opt.rowHeight = math.abs(customOptions.rowHeight)
			if ( opt.rowHeight % 1 ~= 0 ) then
				opt.rowHeight = math.round(opt.rowHeight)
				print( "WARNING: " .. M._widgetName .. " - for resizable construction, 'rowHeight' parameter must be a positive integer; using " .. opt.rowHeight .. " instead" )
			end
		else
			print( "WARNING: " .. M._widgetName .. " - for resizable construction, 'rowHeight' parameter must be specified as a positive integer; using default instead (" .. opt.rowHeight .. ")" )
		end
		opt.borderPadding = 0
		if ( customOptions.borderPadding and opt.sheet ) then
			if not tonumber(customOptions.borderPadding) then
				print( "WARNING: " .. M._widgetName .. " - for resizable construction, 'borderPadding' parameter must be a number; using 0 instead" )
			elseif customOptions.borderPadding < 0 then
				print( "WARNING: " .. M._widgetName .. " - for resizable construction, 'borderPadding' parameter must be a positive number; using 0 instead" )
			else
				opt.borderPadding = customOptions.borderPadding
			end
		end
	end

	opt.columnData = customOptions.columns

	-- Default picker
	opt.backgroundFrame = customOptions.backgroundFrame or nil
	opt.overlayFrame = customOptions.overlayFrame or nil
	opt.separatorFrame = customOptions.separatorFrame or customOptions.seperatorFrame or nil
	-- If custom sheet is not defined, fall back to using frames from theme
	if not opt.sheet then
		opt.backgroundFrame = _widget._getFrameIndex( themeOptions, themeOptions.backgroundFrame )
		opt.overlayFrame = _widget._getFrameIndex( themeOptions, themeOptions.overlayFrame )
		opt.separatorFrame = _widget._getFrameIndex( themeOptions, themeOptions.separatorFrame ) or _widget._getFrameIndex( themeOptions, themeOptions.seperatorFrame )
	end
	-- Resizable picker
	if opt.resizable == true then
		opt.topLeftFrame = customOptions.topLeftFrame or nil
		opt.topMiddleFrame = customOptions.topMiddleFrame or nil
		opt.topRightFrame = customOptions.topRightFrame or nil
		opt.middleLeftFrame = customOptions.middleLeftFrame or nil
		opt.middleRightFrame = customOptions.middleRightFrame or nil
		opt.bottomLeftFrame = customOptions.bottomLeftFrame or nil
		opt.bottomMiddleFrame = customOptions.bottomMiddleFrame or nil
		opt.bottomRightFrame = customOptions.bottomRightFrame or nil
		opt.topFadeFrame = customOptions.topFadeFrame or nil
		opt.bottomFadeFrame = customOptions.bottomFadeFrame or nil
		opt.middleSpanTopFrame = customOptions.middleSpanTopFrame or nil
		opt.middleSpanBottomFrame = customOptions.middleSpanBottomFrame or nil
		-- If custom sheet is not defined, fall back to using frames from theme
		if not opt.sheet then
			opt.topFadeFrame = _widget._getFrameIndex( themeOptions, themeOptions.topFadeFrame )
			opt.bottomFadeFrame = _widget._getFrameIndex( themeOptions, themeOptions.bottomFadeFrame )
			opt.middleSpanTopFrame = _widget._getFrameIndex( themeOptions, themeOptions.middleSpanTopFrame )
			opt.middleSpanBottomFrame = _widget._getFrameIndex( themeOptions, themeOptions.middleSpanBottomFrame )
		end
		opt.middleSpanOffset = customOptions.middleSpanOffset or themeOptions.middleSpanOffset or 0
	end

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
	pickerWheel.onValueSelected = opt.onValueSelected

	-- Create the pickerWheel
	createPickerWheel( pickerWheel, opt )
	
	if isGraphicsV1 then
		pickerWheel:setReferencePoint( display.TopLeftReferencePoint )
	end

	local x, y = _widget._calculatePosition( pickerWheel, opt )
	pickerWheel.x, pickerWheel.y = x, y
	
	return pickerWheel
end

return M
