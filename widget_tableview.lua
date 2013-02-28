--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
	File: 
		widget_tableView.lua
		
	What is it?: 
		A widget object that can be used to replicate native tableViews.
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newtableView",
}

-- Creates a new tableView
local function createTableView( tableView, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local view, viewBackground, viewMask, categoryGroup
	
	-- Create the view
	view = display.newGroup()
		
	-- Create the view's background
	viewBackground = display.newRect( tableView, 0, 0, opt.width, opt.height )
	
	-- Create the view's category group
	categoryGroup = display.newGroup()
	
	-- If there is a mask file, create the mask
	if opt.maskFile then
		viewMask = graphics.newMask( opt.maskFile, opt.baseDir )
	end

	-- If a mask was specified, set it
	if viewMask then
		tableView:setMask( viewMask )
		tableView.maskX = opt.width * 0.5
		tableView.maskY = opt.height * 0.5
		tableView.isHitTestMasked = true
	end
	
	----------------------------------
	-- Properties
	----------------------------------
	
	-- Background
	viewBackground.isVisible = not opt.shouldHideBackground
	viewBackground.isHitTestable = true
	viewBackground:setFillColor( unpack( opt.backgroundColor ) )
	
	-- Set the view's initial position ( to account for top padding )
	view.y = view.y + opt.topPadding

	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	view._background = viewBackground
	view._mask = mask
	view._startXPos = 0
	view._startYPos = 0
	view._prevXPos = 0
	view._prevYPos = 0
	view._prevX = 0
	view._prevY = 0
	view._delta = 0
	view._velocity = 0
	view._prevTime = 0
	view._lastTime = 0
	view._tween = nil
	view._left = opt.left
	view._top = opt.top
	view._width = opt.width
	view._height = opt.height
	view._topPadding = opt.topPadding
	view._bottomPadding = opt.bottomPadding
	view._leftPadding = opt.leftPadding
	view._rightPadding = opt.rightPadding
	view._moveDirection = nil
	view._isHorizontalScrollingDisabled = opt.isHorizontalScrollingDisabled
	view._isVerticalScrollingDisabled = opt.isVerticalScrollingDisabled
	view._listener = opt.listener
	view._friction = opt.friction or 0.972
	view._maxVelocity = opt.maxVelocity or 2
	view._timeHeld = 0
	view._rows = {}
	view._rowWidth = opt.rowWidth
	view._rowHeight = opt.rowHeight
	view._onRowRender = opt.onRowRender
	view._onRowUpdate = opt.onRowUpdate
	view._onRowTouch = opt.onRowTouch
	view._scrollHeight = 0
	view._trackVelocity = false	
	view._updateRuntime = false
	view._hasRenderedRows = false
	
	-------------------------------------------------------
	-- Assign properties/objects to the tableView
	-------------------------------------------------------
	
	-- Assign objects to the view
	view._categoryGroup = categoryGroup
	
	-- Assign objects to the tableView
	tableView._view = view
	tableView:insert( view )
	tableView:insert( categoryGroup )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to insert a row into a tableView
	function tableView:insertRow( options )
		return self._view:_insertRow( options )
	end
	
	-- Function to delete a row from a tableView
	function tableView:deleteRow( rowIndex )
		return self._view:_deleteRow( rowIndex )
	end
	
	-- Function to delete all rows from a tableView
	function tableView:deleteAllRows()
		return self._view:_deleteAllRows()
	end
	
	-- Function to scroll the tableView to a specific row
	function tableView:scrollToIndex( rowIndex, time )
		return self._view:_scrollToIndex( rowIndex, time )
	end
	
	-- Function to scroll the tableView to a specific y position
	function tableView:scrollToY( options )
		return self._view:_scrollToY( options )
	end
	
	-- Function to retrieve the x/y position of the tableView's content
	function tableView:getContentPosition()
		return self._view.x, self._view.y
	end

	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Override scale function as tableView's don't support it
	function tableView:scale()
		print( M._widgetName, "Does not support scaling" )
	end
	
	-- Override the insert method for tableView to insert into the view instead
    tableView._cachedInsert = tableView.insert

    function tableView:insert( arg1, arg2 )
        local index, obj
        
        if arg1 and type(arg1) == "number" then
            index = arg1
        elseif arg1 and type(arg1) == "table" then
            obj = arg1
        end
        
        if arg2 and type(arg2) == "table" then
            obj = arg2
        end
        
        if index then
            self._view:insert( index, obj )
        else
            self._view:insert( obj )
        end
    end

	-- Transfer touch from the view's background to the view's content
	function viewBackground:touch( event )
		view:touch( event )
		
		return true
	end
	
	viewBackground:addEventListener( "touch" )
	
	-- Private Function to get a row at a specific y position
	function view:_getRowAtPosition( position )
		local yPosition = position
				
		for k, v in pairs( self._rows ) do	
			local bounds = self._rows[k].contentBounds
			
			local isWithinBounds = yPosition > bounds.yMin and yPosition < bounds.yMax + 1
			
			-- If we have hit the bottom limit, return the first row
			if self._hasHitBottomLimit then
				return self._rows[1]
			end
			
			-- If we have hit the top limit, return the last row
			if self._hasHitTopLimit then
				return self._rows[#self._rows]
			end
			
			-- If the row is within bounds
			if isWithinBounds then								
				transition.to( self, { time = 280, y = - self._rows[k].y - self.parent.y, transition = easing.outQuad } )
				
				return self._rows[k]
			end
		end
	end


	-- Handle touches on the tableView
	function view:touch( event )
		local phase = event.phase 
		
		-- Handle momentum scrolling
		require( "widget_momentumScrolling" )._touch( self, event )

		-- Execute the listener if one is specified
		if self._listener then
			self._listener( event )
		end
		
		-- Handle swipe events on the tableView
		if "ended" == phase or "cancelled" == phase and math.abs( self._velocity ) < 0.01 then
			local xStart = event.xStart
			local xEnd = event.x
			local yStart = event.yStart
			local yEnd = event.y
			local minSwipeDistance = 50

			local xDistance = math.abs( xEnd - xStart )
            local yDistance = math.abs( yEnd - yStart )

			-- Horizontal Swipes
			if xDistance > yDistance then
				if xStart > xEnd then
					if ( xStart - xEnd ) > minSwipeDistance then
						local newEvent =
						{
							phase = "swipeLeft",
							target = event.target,
						}
						if self._onRowTouch then
							self._onRowTouch( newEvent )
						end
					end
				else
					if ( xEnd - xStart ) > minSwipeDistance then
						local newEvent =
						{
							phase = "swipeRight",
							target = event.target,
						}
						if self._onRowTouch then
							self._onRowTouch( newEvent )
						end
					end
				end
			end
		end
		
		-- Set the view's phase so we can access it in the enterFrame listener below
		self._phase = phase
		
		-- Set the view's target row (the row we touched) so we can access it in the enterFrame listener below
		self._targetRow = event.target
	
		-- If the previous phase was a press event, dispatch a release event
		if "press" == self._newPhase then
			if self._onRowTouch then
				local newEvent =
				{
					phase = "release",
					target = event.target,
					background = self._targetRow._border,
					row = self._targetRow,
				}
				
				-- Set the row's border's fill color
				self._targetRow._border:setFillColor( unpack( self._targetRow._rowColor ) )
				
				-- Execute the row's touch event 
				self._onRowTouch( newEvent )
				
				-- Set the phase to none
				self._newPhase = "none"
			end
		end
			
		return true
	end
	
	view:addEventListener( "touch" )
		
  	-- EnterFrame
	function view:enterFrame( event )
		local _tableView = self.parent
		
		-- If we have finished rendering all rows
		if self._hasRenderedRows then
			-- Create the scrollBar
			if not opt.hideScrollBar then
				if not self._scrollBar then
					self._scrollBar = require( "widget_momentumScrolling" ).createScrollBar( view, {} )
				else
					display.remove( self._scrollBar )
					self._scrollBar = require( "widget_momentumScrolling" ).createScrollBar( view, {} )
				end
			end
			
			-- If the calculated scrollHeight is less than the height of the tableView, set it to that.
			if self._scrollHeight < self._height then
				self._scrollHeight = self._height
			end
			
			self._hasRenderedRows = false
		end
		
		-- Handle momentum @ runtime
		require( "widget_momentumScrolling" )._runtime( self, event )
		
		-- Calculate the time the touch was held
		local timeHeld = event.time - self._timeHeld
		
		-- Dispatch the "press" phase
		if "began" == self._phase then
			-- Reset any velocity
			self._velocity = 0
			
			-- If a finger was held down
			if timeHeld >= 110 then
				-- If there is a onRowTouch listener
				if self._onRowTouch then
					-- If the row isn't a category
					if nil ~= self._targetRow.isCategory then
						self._newPhase = "press"
						local newEvent =
						{
							phase = "press",
							target = self._targetRow,
							background = self._targetRow._border,
							row = self._targetRow,
						}
					
						-- Set the row's border fill color
						self._targetRow._border:setFillColor( 30, 144, 255 )
					
						-- Execute the row's onRowTouch listener
						self._onRowTouch( newEvent )
					end
				
					-- Set the phase to nil
					self._phase = nil
					
					-- Reset the time held
					timeHeld = 0
				end
			end
		end
				
		-- Manage all row's lifeCycle
		self:_manageRowLifeCycle()
		
		-- Constrain x/y scale values to 1.0
		if _tableView.xScale ~= 1.0 then
			_tableView.xScale = 1.0
			print( M._widgetName, "Does not support scaling" )
		end
		
		if _tableView.yScale ~= 1.0 then
			_tableView.yScale = 1.0
			print( M._widgetName, "Does not support scaling" )
		end
		
		-- Update the top position of the tableView (if moved)
		if _tableView.y ~= self._top then
			self._top = _tableView.y
		end
		
		return true
	end
	
	Runtime:addEventListener( "enterFrame", view )
	
	
	-- Private function to gather all tableView categories
	function view:_gatherCategories()
		local _categories = {}
		local index = 0
		
		-- Loop through all rows, and add each category to the local table
		for k, v in pairs( self._rows ) do
			if self._rows[k].isCategory then
				index = index + 1
				self._rows[k]._categoryIndex = index
				_categories[#_categories + 1] = self._rows[k]
			end
		end
		
		return _categories
	end
	
	
	-- Function to manage all row's lifeCycle
	function view:_manageRowLifeCycle()
		-- Gather all tableView categories
		if not self._categories then
			self._categories = self:_gatherCategories()
		end
								
		-- Set the upper and lower category limits
		local upperLimit = self._background.y - ( self._background.contentHeight * 0.5 )
		local lowerLimit = self._background.y + ( self._background.contentHeight * 0.5 )
				
		-- Loop through the rows and set any off screen ones to invisible, and on screen ones to visible
		for k, v in pairs( self._rows ) do
			-- Is this row on screen?
			local isRowOnScreen = ( self._rows[k].y + self.y ) + self._rows[k].contentHeight > upperLimit and ( self._rows[k].y + self.y ) - self._rows[k].contentHeight < lowerLimit
			
			-- If there are any categories
			if #self._categories > 0 then
				-- If this row is a category
				if self._rows[k].isCategory then				
					-- If a category has gone up to the top threshold.
					if ( self._rows[k].y + self.y ) - self._rows[k].contentHeight * 0.5 <= upperLimit then						
						-- Insert all category group rows back into the view
						for i = self._categoryGroup.numChildren, 1, -1 do
							self:insert( self._categoryGroup[i] )
						end
					
						-- Insert the current category into the category group
						self._categoryGroup:insert( self._rows[k] )
						-- Set the category groups reference point
						self._categoryGroup:setReferencePoint( display.CenterReferencePoint )
						-- Set the category groups position
						self._categoryGroup.y = ( self._rows[k].contentHeight * 0.5 ) + self._topPadding
					end
				
					-- If the first row isn't past or equal to the top threshold, scroll it
					if ( self._rows[k].y + self.y ) - self._rows[k].contentHeight > upperLimit - ( self._rows[k].contentHeight * 0.5 ) then
						-- If we are back to the first category
						if self._rows[k]._categoryIndex == 1 then
							self:insert( self._rows[k] )
						end
					end
				end
			end
					
			-- Cull rows that are are currently not within our tableView's visible bounds
			if not isRowOnScreen then
				if not self._rows[k].isCategory then
					-- Set the row to invisible
					self._rows[k].isVisible = false
				end
			-- Show rows that are within our tableView's bounds
			else
				-- If the row isn't already visible
				if not self._rows[k].isVisible then
					self._rows[k].isVisible = true
				
					-- Create the rowRender event
					local rowEvent = 
					{
						name = "rowUpdate",
						row = self._rows[k],
						target = tableView,
					}
				
					-- If an onRowRender event exists, execute it
					if self._onRowUpdate and "function" == type( self._onRowUpdate ) then
						self._onRowUpdate( rowEvent )
					end
				end
			end
		end
	end
	
	-- Send row touch event's to the view
	local function _handleRowTouch( event )
		local phase = event.phase
		
		view:touch( event )

		return true
	end

					
	-- Function to insert a row into a tableView
	function view:_insertRow( options )
		-- We haven't finished rendering all rows yet
		self._hasRenderedRows = false
		
		-- Create a new row, a row is a display group
		self._rows[#self._rows + 1] = display.newGroup()
		-- Set the row's index
		self._rows[#self._rows].index = #self._rows
		
		-- Retrieve passed in row customization variables
		local rowId = options.id or #self._rows
		local rowHeight = options.rowHeight or 40
		local isRowCategory = options.isCategory or false
		local rowColor = options.rowColor or { 255, 255, 255 }
		local lineColor = options.lineColor or { 220, 220, 220 }
				
		-- Create the row's touch rectangle (ie it's border)
		local border = display.newRect( self._rows[#self._rows], 0, 0, opt.width, rowHeight )
		border.x = border.contentWidth * 0.5
		border.y = border.contentHeight * 0.5
		border.strokeWidth = 1
		border:setFillColor( unpack( rowColor ) )
		border:setStrokeColor( unpack( rowColor ) )
				
		-- If the user want's lines between rows, set the stroke color accordingly
		if not opt.noLines then
			border:setStrokeColor( unpack( lineColor ) )
		end
		
		-- Set the row's id
		self._rows[#self._rows].id = rowId

		-- Set the row's reference point to it's center point (just incase)
		self._rows[#self._rows]:setReferencePoint( display.CenterReferencePoint )
				
		-- Position the row
		self._rows[#self._rows].x = self.x + self._rows[#self._rows].contentWidth * 0.5
		
		-- Set the row's y position
		if #self._rows <= 1 then
			self._rows[#self._rows].y = rowHeight * #self._rows - ( rowHeight * 0.5 ) - 1
		else
			self._rows[#self._rows].y = self._rows[#self._rows - 1].y + ( self._rows[#self._rows - 1].contentHeight * 0.5 ) + ( self._rows[#self._rows].contentHeight * 0.5 ) - 1
		end
		
		-- Assign private properties to the row
		self._rows[#self._rows]._border = border
		self._rows[#self._rows]._rowColor = rowColor
		
		-- Assign public properties to the row
		self._rows[#self._rows].isCategory = isRowCategory
		
		-- Add event listener to the row
		if not isRowCategory then
			self._rows[#self._rows]:addEventListener( "touch", _handleRowTouch )
		else
			-- If the row is a category, add a listener that ensures the event doesn't propogate down to the row below it
			self._rows[#self._rows]:addEventListener( "touch", function() return true end )
		end
		
		-- Insert the row into the view
		self:insert( self._rows[#self._rows] )
		
		-- Create the rowRender event
		local rowEvent = 
		{
			name = "rowRender",
			row = self._rows[#self._rows],
			target = tableView,
		}

		-- If an onRowRender event exists, execute it
		if self._onRowRender and "function" == type( self._onRowRender ) then
			self._onRowRender( rowEvent )
		end
		
		-- Add this row to the overall height (if this isn't a pickerWheel)
		self._scrollHeight = self._scrollHeight + rowHeight + border.strokeWidth
		
		-- We have finished rendering the rows (unless we render another, in which case this gets reset)
		self._hasRenderedRows = true
	end
	
	-- Function to delete a row from the tableView
	function view:_deleteRow( rowIndex )
		-- Transition out the row in question
		transition.to( self._rows[rowIndex], { x = - ( self._rows[rowIndex].contentWidth * 0.5 ), transition = easing.inQuad, onComplete = function() self._rows[rowIndex] = nil end } )

		-- Loop through the remaining rows, starting at the next row after the deleted one
		for i = rowIndex + 1, #self._rows do
			if self._rows[i].y then
				transition.to( self._rows[i], { y = self._rows[i].y - ( self._rows[i]._border.contentHeight ), transition = easing.outQuad } )
			end
		end
		
		-- Re calculate the scrollHeight
		self._scrollHeight = self._scrollHeight - self._rows[i].height
	end
	
	-- Function to deleta all rows from the tableView
	function view:_deleteAllRows()
		local _tableView = self.parent
		
		-- Loop through all rows and delete each one
		for k, v in pairs( self._rows ) do
			display.remove( self._rows[k] )
			self._rows[k] = nil
		end
		
		-- Delete any category rows
		for k, v in pairs( self._categories ) do
			display.remove( self._categories[k] )
			self._categories[k] = nil
		end
		
		-- Nil out the categories table
		self._categories = nil
		
		-- Reset the view's y position
		self.y = _tableView.y - self._top + self._topPadding
		
		-- Reset the scrollHeight
		self._scrollHeight = 0
	end
	
	-- Function to scroll to a specific row
	function view:_scrollToIndex( rowIndex, time )
		local scrollTime = time or 400
		
		transition.to( self, { y = self.y - self._rows[rowIndex].y + ( self._rows[rowIndex].contentHeight * 0.5 ), time = scrollTime, transition = easing.outQuad } )
	end
	
	-- Function to scroll to a specific y position
	function view:_scrollToY( options )
		local newY = options.y
		local transitionTime = options.time or 400
		local onTransitionComplete = options.onComplete
	
		transition.to( self, { y = newY, time = transitionTime, transition = easing.inOutQuad, onComplete = onTransitionComplete } )
	end
	
	-- Finalize function for the tableView
	function tableView:_finalize()
		Runtime:removeEventListener( "enterFrame", self._view )
		
		display.remove( self._view._categoryGroup )
	
		self._view._categoryGroup = nil
	
		-- Remove scrollBar if it exists
		if self._view._scrollBar then
			display.remove( self._view._scrollBar )
			self._view._scrollBar = nil
		end
	end
			
	return tableView
end


-- Function to create a new tableView object ( widget.newtableView )
function M.new( options )	
	local customOptions = options or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
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
	opt.maskFile = customOptions.maskFile
	opt.listener = customOptions.listener
		
	-- Properties
	opt.shouldHideBackground = customOptions.hideBackground or false
	opt.backgroundColor = customOptions.backgroundColor or { 255, 255, 255, 255 }
	opt.topPadding = customOptions.topPadding or 0
	opt.bottomPadding = customOptions.bottomPadding or 0
	opt.leftPadding = customOptions.leftPadding or 0
	opt.rightPadding = customOptions.rightPadding or 0
	opt.isHorizontalScrollingDisabled = true -- We explicitly disable this as tableViews (aka listViews) only scroll vertically
	opt.isVerticalScrollingDisabled = customOptions.isLocked or false
	opt.friction = customOptions.friction
	opt.maxVelocity = customOptions.maxVelocity
	opt.noLines = customOptions.noLines or false
	opt.hideScrollBar = true --customOptions.hideScrollBar or false
	opt.rowWidth = opt.width
	opt.rowHeight = customOptions.rowHeight or 40
	opt.onRowRender = customOptions.onRowRender
	opt.onRowUpdate = customOptions.onRowUpdate
	opt.onRowTouch = customOptions.onRowTouch

	-------------------------------------------------------
	-- Create the tableView
	-------------------------------------------------------
		
	-- Create the tableView object
	local tableView = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_tableView",
		baseDir = opt.baseDir,
	}

	-- Create the tableView
	createTableView( tableView, opt )
	
	return tableView
end

return M
