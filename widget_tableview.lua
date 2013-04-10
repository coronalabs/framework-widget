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

-- Localize math functions
local mAbs = math.abs

-- Require needed widget files
local _widget = require( "widget" )
local _momentumScrolling = require( "widget_momentumScrolling" )


-- Creates a new tableView
local function createTableView( tableView, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local view, viewBackground, viewMask, viewFixed, categoryGroup
	
	-- Create the view
	view = display.newGroup()
	
	-- Create the fixed view
	viewFixed = display.newGroup()
		
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
	view._mask = viewMask
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
	view._isLocked = opt.isLocked
	view._hideScrollBar = opt.hideScrollBar
	view._rows = {}
	view._rowWidth = opt.rowWidth
	view._rowHeight = opt.rowHeight
	view._currentCategoryIndex = 0	
	view._offScreenRows = {}
	view._rowProperties = {}
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
	view._fixedGroup = viewFixed
	
	-- Assign objects to the tableView
	tableView._view = view
	tableView:insert( view )
	tableView:insert( categoryGroup )
	tableView:insert( viewFixed )
	
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
	function tableView:scrollToIndex( ... )
		return self._view:_scrollToIndex( ... )
	end
	
	-- Function to scroll the tableView to a specific y position
	function tableView:scrollToY( options )
		return self._view:_scrollToY( options )
	end
	
	-- Function to retrieve the x/y position of the tableView's content
	function tableView:getContentPosition()
		return self._view.y
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
			local currentRow = self._rows[k]
			
			-- If the current row exists on screen
			if currentRow.y then
				local bounds = currentRow.contentBounds
			
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
					transition.to( self, { time = 280, y = - currentRow.y - self.parent.y, transition = easing.outQuad } )
				
					return currentRow
				end
			end
		end
	end


	-- Handle touches on the tableView
	function view:touch( event )
		local phase = event.phase
		
		-- Set the time held
		if "began" == phase then
			self._timeHeld = event.time
			
			-- Set the initial touch
			if not self._initalTouch then
				self._initialTouch = true
			end
		end	
		
		-- Distance moved
        local dy = mAbs( event.y - event.yStart )
		local moveThresh = 20
		
		if "moved" == phase and not self._isUsedInPickerWheel then
	  		if dy < moveThresh and self._initialTouch then
				if event.phase ~= "ended" and event.phase ~= "cancelled" then
					event.phase = "began"
				end
			else
				-- This wasn't the initial touch
				self._initialTouch = false
				-- New phase is now nil, since it was moved
				self._newPhase = nil
				
				if "table" == type( self._targetRow ) then
					if "table" == type( self._targetRow._border ) then
						-- If the row isn't a category
						if not self._targetRow.isCategory then
							-- Set the row's border's fill color
							self._targetRow._border:setFillColor( unpack( self._targetRow._rowColor.default ) )
							-- The row was no longer touched
							self._targetRow._wasTouched = false
						end
					end
				end
			end
		end
		
		-- Set the view's phase so we can access it in the enterFrame listener below
		self._phase = event.phase
		
		-- Handle momentum scrolling (if the view isn't locked)
		if not self._isLocked then
			_momentumScrolling._touch( self, event )
		end
				
		-- Execute the listener if one is specified
		if "function" == type( self._listener ) then
			self._listener( event )
		end
		
		-- Set the view's target row (the row we touched) so we can access it in the enterFrame listener below
		self._targetRow = event.target
		
		-- Handle swipe events on the tableView
		if "ended" == phase or "cancelled" == phase then
			-- This wasn't the initial touch
			self._initialTouch = false
			
	 		if mAbs( self._velocity ) < 0.01 then
				local xStart = event.xStart
				local xEnd = event.x
				local yStart = event.yStart
				local yEnd = event.y
				local minSwipeDistance = 50

				local xDistance = mAbs( xEnd - xStart )
	            local yDistance = mAbs( yEnd - yStart )

				-- Horizontal Swipes
				if xDistance > yDistance then
					if xStart > xEnd then
						if ( xStart - xEnd ) > minSwipeDistance then
							local newEvent =
							{
								phase = "swipeLeft",
								target = event.target,
								row = self._targetRow,
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
								row = self._targetRow,
							}
							if self._onRowTouch then
								self._onRowTouch( newEvent )
							end
						end
					end
				end
			end
		end
			
		-- If the previous phase was a press event, dispatch a release event
		if "press" == self._newPhase and not self._initialTouch then
			if self._onRowTouch then
				local newEvent =
				{
					phase = "release",
					target = event.target,
					row = self._targetRow,
				}
				
				-- Set the row's border's fill color
				self._targetRow._border:setFillColor( unpack( self._targetRow._rowColor.default ) )
				
				-- Execute the row's touch event 
				self._onRowTouch( newEvent )
				
				-- Set the phase to none
				self._newPhase = nil
				
				-- This wasn't the initial touch
				self._initialTouch = false
				
				-- The row shouldn't allow a tap event at this time
				self._targetRow._cannotTap = true
				
				-- This row was touched
				self._targetRow._wasTouched = false
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
			if not self._hideScrollBar then
				if not self._isLocked and not self._scrollBar then
					self._scrollBar = _momentumScrolling.createScrollBar( view, opt.scrollBarOptions )
				end
			end
			
			-- If the calculated scrollHeight is less than the height of the tableView, set it to that.
			if "number" == type( self._scrollHeight ) then
				if self._scrollHeight < self._height then
					self._scrollHeight = self._height
				end
			end
			
			self._hasRenderedRows = false
		end
		
		-- Handle momentum @ runtime
		_momentumScrolling._runtime( self, event )
		
		-- Calculate the time the touch was held
		local timeHeld = event.time - self._timeHeld
				
		-- Dispatch the "press" phase
		if "began" == self._phase and self._initialTouch and not self._targetRow._wasTouched then
			-- Reset any velocity
			self._velocity = 0
			
			-- If there is a onRowTouch listener
			if self._onRowTouch then
				-- If the row isn't a category
				if nil ~= self._targetRow.isCategory then
					-- The row can allow tap's again
					self._targetRow._cannotTap = false
				end
			end
			
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
							row = self._targetRow,
						}
				
						-- Set the row's border fill color
						self._targetRow._border:setFillColor( unpack( self._targetRow._rowColor.over ) )
				
						-- Execute the row's onRowTouch listener
						self._onRowTouch( newEvent )
						
						self._targetRow._wasTouched = true							
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
	
		
	-- Function to set all tableView categories (if any)
	function view:_gatherCategories()
		local categories = {}
		local numCategories = 0
		local firstCategory = 0
		local previousCategory = 0
		
		-- Loop through all rows and set categories
		for i = 1, #self._rows do
			local currentRow = self._rows[i]
			
			if currentRow.isCategory then
				if not previousCategory then
					categories["cat-" .. i] = "first"
					previousCategory = i
					numCategories = numCategories + 1
				else
					categories["cat-" .. i] = previousCategory
					previousCategory = i
					numCategories = numCategories + 1
				end
				
				-- Store reference to first category index
				if not firstCategory then
					firstCategory = i
				end
			end
		end
		
		-- Assign some category variables to the view
		self._firstCategoryIndex = firstCategory
		
		-- Return the gathered categories table
		return categories, numCategories
	end


	-- Function to render a category
	function view:_renderCategory( row )
		-- Create a reference to the row
		local currentRow = row
		
		-- Function to create a new category
		local function newCategory()
			local category = display.newGroup()
			
			-- Create the row's touch rectangle (ie it's border)
			local border = display.newRect( category, 0, 0, currentRow._width, currentRow._height )
			border.x = border.contentWidth * 0.5
			border.y = border.contentHeight * 0.5
			border.strokeWidth = 1
			border:setFillColor( unpack( currentRow._rowColor.default ) )
			border:setStrokeColor( unpack( currentRow._rowColor.default ) )

			-- If the user want's lines between rows, set the stroke color accordingly
			if not currentRow._noLines then
				border:setStrokeColor( unpack( currentRow._lineColor ) )
			end

			-- Set the row's id
			category.id = currentRow.id
			
			-- Set the categories index
			category.index = currentRow.index
			
			-- Set the category as a category
			category.isCategory = true
			
			-- Ensure the stuck category doesn't leak touch events to rows below it
			category:addEventListener( "touch", function() return true end )
			category:addEventListener( "tap", function() return true end )
			
			-- Insert the category into the group
			self._categoryGroup.y = 0
			self._categoryGroup:insert( category )
			
			return category
		end
					
		-- Function to create a new category
		local function initNewCategory()			
			-- If there is already a category rendered, remove it
			if self._currentCategory then
				display.remove( self._currentCategory )
				self._currentCategory = nil
			end
						
			-- Create the category
			self._currentCategory = newCategory()
			self._currentCategory:setReferencePoint( display.CenterReferencePoint )
			self._currentCategory.x = self._currentCategory.contentWidth * 0.5
			self._currentCategory.y = self._currentCategory.contentHeight * 0.5
			
			-- Create the rowRender event
			local rowEvent = 
			{
				name = "rowRender",
				row = self._currentCategory,
				target = self.parent,
			}

			-- If an onRowRender event exists, execute it
			if self._onRowRender and "function" == type( self._onRowRender ) then
				self._onRowRender( rowEvent )
			end
		end
		
		-- If there is currently no category rendered
		if not self._currentCategory then 
			initNewCategory()
		else
			if self._currentCategory.index ~= currentRow.index then
				initNewCategory()
			end
		end
	end
	
		
	-- Function to manage all row's lifeCycle
	function view:_manageRowLifeCycle()
		-- Gather all tableView categories
		if not self._categories then
			self._categories, self._numCategories = self:_gatherCategories()
		end
		
		-- Ensure that the category is stuck in the correct position
		if self._currentCategory and self._currentCategory.y ~= self._currentCategory.contentHeight * 0.5 then
			self._currentCategory.y = self._currentCategory.contentHeight * 0.5
		end
										
		-- Set the upper and lower category limits
		local upperLimit = self._background.y - ( self._background.contentHeight * 0.5 )
		local lowerLimit = self._background.y + ( self._background.contentHeight * 0.5 )
		
		-- Create a local reference to our categories
		local categories = self._categories
				
		-- Loop through all of the rows contained in the tableView 
		for i = 1, #self._rows do
			local currentRow = self._rows[i]
			local currentRowExists = currentRow ~= nil
			
			-- Manage tableView categories (if there are any)
			if self._numCategories > 0 then
				-- If the row still exists
				if currentRowExists and currentRow.y and currentRow.contentHeight then
					-- Set the rows top position
					currentRow._top = self.y + currentRow.y - currentRow.contentHeight * 0.5
							
					-- Category "pushing" effect
					if self._currentCategory and currentRow.isCategory and currentRow.index ~= self._currentCategory.index then
						if currentRow._top < self._currentCategory.contentHeight and currentRow._top >= 0 then
							-- Push the category upward
							if self._currentCategory then
								self._currentCategory.y = currentRow._top - ( self._currentCategory.contentHeight * 0.5  )
							end
						end
					end
					
					-- Determine which category should be rendered (Sticky category at top)
					if currentRow.isCategory and currentRow._top <= 0 then
						self._currentCategoryIndex = i
						
						-- Hide the current row
						currentRow.isVisible = false
						
					elseif currentRow ~= nil and currentRow.isCategory and currentRow._top >= 0 and self._currentCategory and currentRow.index == self._currentCategory.index then
						-- Category moved below top of tableView, render previous category
						currentRow.isVisible = true
												
						-- Remove current category if the first category moved below the top of the tableView
						display.remove( self._currentCategory )
						self._currentCategory = nil
						self._currentCategoryIndex = nil
					end
				end	
			end 
			
			-------------------------
			-- Handle row culling
			-------------------------
			
			-- Is this row currently within the tableView bounds ? Or above or below it.
			if currentRowExists and currentRow ~= nil and currentRow.y and currentRow.contentHeight then
				local isRowWithinBounds = ( currentRow.y + self.y ) + currentRow.contentHeight > upperLimit and ( currentRow.y + self.y ) - currentRow.contentHeight * 2 < lowerLimit
			
				if currentRow.isCategory then
					isRowWithinBounds = ( currentRow.y + self.y ) - currentRow.contentHeight < lowerLimit
				end
			
				-- Hide rows that are are currently not within our tableView's visible bounds
				if not isRowWithinBounds then
					-- Add this row to the off screen rows table
					self._offScreenRows[#self._offScreenRows +1] = 
					{
						id = currentRow.id,
						index = currentRow.index,
						y = currentRow.y,
						isCategory = currentRow.isCategory,
						rowColor = currentRow._rowColor,
						contentWidth = currentRow.contentWidth,
						contentHeight = currentRow.contentHeight,
						rowHeight = currentRow._height,
						_border = currentRow._border,
						previousYPosition = currentRow.y,
						_shouldRender = true, -- We are re-rendering this row
					}

					-- Remove this row
					display.remove( currentRow )
					currentRow = nil
				end
			end
		end
				
		-- Recreate rows that are moving back on screen
		for k, v in pairs( self._offScreenRows ) do
			local currentRow = self._offScreenRows[k]
			local isRowWithinBounds = ( currentRow.y + self.y ) + currentRow.contentHeight > upperLimit and ( currentRow.y + self.y ) - currentRow.contentHeight * 2 < lowerLimit
			
			-- If the row is back within the tableView bounds, re-create it
			if isRowWithinBounds then
				if currentRow._shouldRender and currentRow.x == nil then
					-- Re-insert the row into the view
					self:_insertRow( 
					{
						isCategory = currentRow.isCategory,
						index = currentRow.index,
						id = currentRow.id,
						rowHeight = currentRow.rowHeight,
						rowColor = currentRow.rowColor,
						previousYPosition = currentRow.previousYPosition,	
					}, true )
				end
				
				-- Nil this row
				self._offScreenRows[k] = nil
			end
		end		
		
		-- Render current category (if there are any categories)
		if self._numCategories > 0 then
			if self._currentCategoryIndex and self._currentCategoryIndex > 0 then
				self:_renderCategory( self._rows[self._currentCategoryIndex] )
			end
		end
	end
	
	-- Send row touch event's to the view
	local function _handleRowTouch( event )
		local phase = event.phase
		
		view:touch( event )

		return true
	end
	
	
	-- Handle tap events on the row
	local function _handleRowTap( event )
		local row = event.target
		
		-- If tap's are allowed on the row at this time
		if not row._cannotTap then
			if "function" == type( view._onRowTouch ) then
				local newEvent =
				{
					phase = "tap",
					target = row,
				}

				-- Set the row's border fill color
				row._border:setFillColor( unpack( row._rowColor.over ) )
		
				-- After a little delay, set the row's fill color back to default
				timer.performWithDelay( 100, function()
					-- Set the row's border fill color
					row._border:setFillColor( unpack( row._rowColor.default ) )
				end)

				-- Execute the row's onRowTouch listener
				view._onRowTouch( newEvent )
			end
		end
	end
	
					
	-- Function to insert a row into a tableView
	function view:_insertRow( options, reRender )
		-- We haven't finished rendering all rows yet
		self._hasRenderedRows = false
		
		-- Are we re-rendering this row?
		local isReRender = reRender
		
		-- Create a new row, a row is a display group
		self._rows[#self._rows + 1] = display.newGroup()
		-- Set the row's index
		
		if isReRender then
			self._rows[#self._rows].index = options.index
		else
			self._rows[#self._rows].index = #self._rows
		end
		
		-- Retrieve passed in row customization variables
		local rowId = options.id or #self._rows
		local rowWidth = opt.width
		local rowHeight = options.rowHeight or 40
		local isRowCategory = options.isCategory or false
		local rowColor = options.rowColor or { default = { 255, 255, 255 }, over = { 30, 144, 255 } }
		local noLines = opt.noLines or false
		
		-- Set defaults for row color
		if not rowColor.default then
			rowColor.default = { 255, 255, 255 }
		end
		
		-- Set defaults for row over color
		if not rowColor.over then
			rowColor.over = { 30, 144, 255 }
		end
		
		local lineColor = options.lineColor or { 220, 220, 220 }
				
		-- Create the row's touch rectangle (ie it's border)
		local border = display.newRect( self._rows[#self._rows], 0, 0, rowWidth, rowHeight )
		border.x = border.contentWidth * 0.5
		border.y = border.contentHeight * 0.5
		border.strokeWidth = 1
		border:setFillColor( unpack( rowColor.default ) )
		border:setStrokeColor( unpack( rowColor.default ) )
				
		-- If the user want's lines between rows, set the stroke color accordingly
		if not noLines then
			border:setStrokeColor( unpack( lineColor ) )
		end
		
		-- Set the row's id
		self._rows[#self._rows].id = rowId

		-- Set the row's reference point to it's center point (just incase)
		self._rows[#self._rows]:setReferencePoint( display.CenterReferencePoint )
				
		-- Position the row
		self._rows[#self._rows].x = self.x + self._rows[#self._rows].contentWidth * 0.5
		
		-- Set the row's y position
		
		-- If we are re-rendering this row
		if isReRender then
			self._rows[#self._rows].y = options.previousYPosition
		else
			if #self._rows <= 1 then
				self._rows[#self._rows].y = rowHeight * #self._rows - ( rowHeight * 0.5 ) - 1
			else
				self._rows[#self._rows].y = self._rows[#self._rows - 1].y + ( self._rows[#self._rows - 1].contentHeight * 0.5 ) + ( self._rows[#self._rows].contentHeight * 0.5 ) - 1
			end
		end
				
		-- Assign private properties to the row
		self._rows[#self._rows]._border = border
		self._rows[#self._rows]._rowColor = rowColor
		self._rows[#self._rows]._lineColor = lineColor
		self._rows[#self._rows]._noLines = noLines
		self._rows[#self._rows]._width = rowWidth
		self._rows[#self._rows]._height = rowHeight
		
		-- Assign public properties to the row
		self._rows[#self._rows].isCategory = isRowCategory
		
		-- Add event listener to the row
		if not isRowCategory then
			self._rows[#self._rows]:addEventListener( "touch", _handleRowTouch )
			self._rows[#self._rows]:addEventListener( "tap", _handleRowTap )
		else
			-- If the row is a category, pass the touch event back to the view
			local function scrollList( event )
				-- Handle momentum scrolling (if the view isn't locked)
				if not self._isLocked then
					_momentumScrolling._touch( self, event )
				end
			
				return true
			end
			
			self._rows[#self._rows]:addEventListener( "touch", scrollList )
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
		
		-- Add this row to the overall height (if this isn't a pickerWheel and this row isn't being re-rendered)
		if not isReRender then
			self._scrollHeight = self._scrollHeight + rowHeight + border.strokeWidth
		end
		
		-- Add this row to the row properties table
		self._rowProperties[#self._rowProperties + 1] = 
		{
			contentHeight = self._rows[#self._rows].contentHeight,
			index = self._rows[#self._rows].index,
			y = self._rows[#self._rows].y
		}
		
		-- We have finished rendering the rows (unless we render another, in which case this gets reset)
		self._hasRenderedRows = true
	end
	
	-- Function to delete a row from the tableView
	function view:_deleteRow( rowIndex )
		if type( self._rows[rowIndex] ) ~= "table" then
			print( "WARNING: deleteRow( " .. rowIndex .. " ) - Row does not exist" )
			return
		end
		
		-- Deleting categories isn't currently supported
		if self._rows[rowIndex].isCategory then
			print( "Warning: deleting categories is not supported" )
			return
		end
		
		-- If the view is scrolling, don't allow a row to be deleted
		if mAbs( self._velocity ) > 0 then
			print( "Warning: A row cannot be deleted whilst the tableView is scrolling" )
			return
		end
		
		-- The row we want to delete
		local rowToDelete = nil
		-- Is the row we are deleting on screen
		local isRowOnScreen = true
		-- The height of the row we are deleting
		local rowHeight = 0
		
		----------------------------------------------------------------
		-- Check if the row we are deleting is on screen or off screen
		----------------------------------------------------------------
				
		-- If the row is on screen
		if self._rows[rowIndex].y then
			rowToDelete = self._rows[rowIndex]
			rowHeight = rowToDelete._height
		-- The row is off screen
		else
			for k, v in pairs( self._offScreenRows ) do
				local currentRow = self._offScreenRows[k]
			
				if rowIndex == currentRow.index then
					-- Set the rowHeight
					rowHeight = currentRow.rowHeight
		
					-- Nil out this row
					currentRow = nil
					
					-- Loop through the remaining off screen rows and move them up
					for k, v in pairs( self._offScreenRows ) do
						if self._offScreenRows[k].index > rowIndex then
							if self._offScreenRows[k].isCategory then
								if self._offScreenRows[k-1] ~= nil then
									self._offScreenRows[k].previousYPosition = self._offScreenRows[k].previousYPosition - self._offScreenRows[k-1].contentHeight
								end
							else
								self._offScreenRows[k].previousYPosition = self._offScreenRows[k].previousYPosition - self._offScreenRows[k].contentHeight
							end
						end
					end

					isRowOnScreen = false
					break
				end
			end
		end
						
		-- Re calculate the scrollHeight
		self._scrollHeight = self._scrollHeight - rowHeight
		
		-- If the row that is being deleted is on screen, transition it out then move up the remaining rows to fill the gap
		if isRowOnScreen then
			-- Transition out & delete the row in question
			transition.to( rowToDelete, { x = - ( rowToDelete.contentWidth * 0.5 ), transition = easing.inQuad, onComplete = function() display.remove( rowToDelete ); rowToDelete = nil end } )
		
			-- Loop through the remaining on screen rows, starting at the next row after the deleted one
			for i = rowIndex + 1, #self._rows do
				if self._rows[i].y then
					if self._rows[i].isCategory then
						if nil ~= self._rows[i-1] then
							transition.to( self._rows[i], { y = self._rows[i].y - ( self._rows[i-1].contentHeight ), transition = easing.outQuad } )
						end
					else
						transition.to( self._rows[i], { y = self._rows[i].y - ( self._rows[i].contentHeight ), transition = easing.outQuad } )
					end
				end
			end
		
			-- Move up the remaining off screen rows
			for k, v in pairs( self._offScreenRows ) do
				if self._offScreenRows[k].isCategory then
					if self._offScreenRows[k-1] ~= nil then
						self._offScreenRows[k].previousYPosition = self._offScreenRows[k].previousYPosition - self._offScreenRows[k-1].contentHeight
					end
				else
					self._offScreenRows[k].previousYPosition = self._offScreenRows[k].previousYPosition - self._offScreenRows[k].contentHeight
				end
			end
		end
		
		-- We have deleted the row
		self._isDeletingRow = false
	end
	
	-- Function to deleta all rows from the tableView
	function view:_deleteAllRows()
		local _tableView = self.parent
		
		-- Loop through all rows and delete each one
		for k, v in pairs( self._rows ) do
			display.remove( self._rows[k] )
			self._rows[k] = nil
		end
		
		-- Delete any stuck categories
		if self._currentCategory then
			display.remove( self._currentCategory )
			self._currentCategory = nil
			self._currentCategoryIndex = nil
		end
		
		-- Recreate the off screen rows table
		self._offScreenRows = nil
		self._offScreenRows = {}
	
		-- Nil out the categories table
		self._categories = nil
		
		-- Remove the scrollbar
		if self._scrollBar then
			display.remove( self._scrollBar )
			self._scrollBar = nil
		end
		
		-- Reset the view's y position
		self.y = _tableView.y - self._top + self._topPadding
		
		-- Reset the scrollHeight
		self._scrollHeight = 0
	end
	
	-- Function to scroll to a specific row
	function view:_scrollToIndex( ... )
		local arg = { ... }
		local rowIndex = nil
		local time = nil
		local executeOnComplete = nil
		
		if "number" == type( arg[1] ) then
			rowIndex = arg[1]
		end
		
		if "number" == type( arg[2] ) then
			time = arg[2]
		elseif "function" == type( arg[2] ) then
			executeOnComplete = arg[2]
		end
				
		if "function" == type( arg[3] ) then
			executeOnComplete = arg[3]
		elseif "function" == type( arg[4] ) then
			executeOnComplete = arg[4]
		end
		
		local scrollTime = time or 400
		
		if self._lastRowIndex == rowIndex then
			return
		end
				
		-- The new position to scroll to
		local newPosition = 0
				
		-- Set the new position to scroll to
		newPosition = -self._rowProperties[rowIndex].y + ( self._rowProperties[rowIndex].contentHeight * 0.5 )

		-- The calculation needs altering for pickerWheels
		if self._isUsedInPickerWheel then
			newPosition = self.y - self._rowProperties[rowIndex].y + ( self._rowProperties[rowIndex].contentHeight * 0.5 )
		end
			
		-- Transition the view to the row index	
		transition.to( self, { y = newPosition, time = scrollTime, transition = easing.outQuad, onComplete = executeOnComplete } )
		
		-- Update the last row index
		self._lastRowIndex = rowIndex
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
	opt.width = customOptions.width or 0
	opt.height = customOptions.height or 0
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
	opt.hideScrollBar = customOptions.hideScrollBar or false
	opt.isLocked = customOptions.isLocked or false
	opt.rowWidth = opt.width
	opt.rowHeight = customOptions.rowHeight or 40
	opt.onRowRender = customOptions.onRowRender
	opt.onRowUpdate = customOptions.onRowUpdate
	opt.onRowTouch = customOptions.onRowTouch
	
	-- ScrollBar options
	opt.scrollBarOptions =
	{
		sheet = customOptions.sheet,
		topFrame = customOptions.topFrame,
		middleFrame = customOptions.middleFrame,
		bottomFrame = customOptions.bottomFrame,
	}

	-------------------------------------------------------
	-- Create the tableView
	-------------------------------------------------------
		
	-- Create the tableView object
	local tableView = _widget._new
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