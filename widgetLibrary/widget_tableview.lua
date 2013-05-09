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
	_widgetName = "widget.newtableView",
	_directoryPath = "widgetLibrary.",
}

-- Require needed widget files
local _widget = nil
local _momentumScrolling = nil

-- Function to require the widget file from the widget directory path (if it exists)
local function checkFileAtPath()
    _widget = require( M._directoryPath .. "widget" )
end

-- Function to require the momemtum scrolling file from the widget directory path (if it exists)
local function checkOtherFileAtPath()
	_momentumScrolling = require( M._directoryPath .. "widget_momentumScrolling" )
end

-- If we failed to find the widget file in the widget directory path.
if false == pcall( checkFileAtPath ) then
	_widget = require( "widget" )
end

-- If we failed to find the momentum scrolling file in the widget directory path.
if false == pcall( checkOtherFileAtPath ) then
	_momentumScrolling = require( "widget_momentumScrolling" )
end

-- Localize math functions
local mAbs = math.abs


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
	view._allowRowTouch = false
	view._hideScrollBar = opt.hideScrollBar
	view._rows = {}
	view._rowWidth = opt.rowWidth
	view._rowHeight = opt.rowHeight
	view._noLines = opt.noLines
	view._currentCategoryIndex = 0
	view._hasRenderedRows = false
	view._onRowRender = opt.onRowRender
	view._onRowTouch = opt.onRowTouch
	view._scrollHeight = 0
	view._trackVelocity = false	
	view._updateRuntime = false
		
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

	-- Function to retrieve the number of rows in a tableView
	function tableView:getNumRows()
		return #self._view._rows
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
			if "table" == type( currentRow._view ) then
				local bounds = currentRow._view.contentBounds
			
				local isWithinBounds = yPosition > bounds.yMin and yPosition < bounds.yMax + 1
			
				-- If we have hit the bottom limit, return the first row
				if self._hasHitBottomLimit then
					return self._rows[1]._view
				end
			
				-- If we have hit the top limit, return the last row
				if self._hasHitTopLimit then
					return self._rows[#self._rows]._view
				end
			
				-- If the row is within bounds
				if isWithinBounds then								
					transition.to( self, { time = 280, y = - currentRow.y - self.parent.y, transition = easing.outQuad } )
					
					return currentRow._view
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
			
			-- By default we allow touch events for our row's
			self._allowRowTouch = true
			
			-- If the velocity is over 0.05, we prevent touch events on the rows as press/tap events should only result in the view's momentum been stopped
			if mAbs( self._velocity ) > 0.05 then
				self._allowRowTouch = false
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
					if "table" == type( self._targetRow._cell ) then
						-- If the row isn't a category
						if not self._targetRow.isCategory then
							if self._targetRow._wasTouched then
								-- Set the row cell's fill color
								self._targetRow._cell:setFillColor( unpack( self._targetRow._rowColor.default ) )
								-- The row was no longer touched
								self._targetRow._wasTouched = false
							
								-- Setup a cancelled event for this row
								local newEvent =
								{
									phase = "cancelled",
									target = event.target,
									row = self._targetRow,
								}
							
								-- Execute the row's touch event 
								self._onRowTouch( newEvent )
							end
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
				
				-- Set the row cell's fill color
				self._targetRow._cell:setFillColor( unpack( self._targetRow._rowColor.default ) )
				
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
	
		
  	-- EnterFrame listener for our tableView
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
				if not self._isUsedInPickerWheel then
					if self._scrollHeight < self._height then
						self._scrollHeight = self._height
					end
				end
			end

			-- Set the renderedRows back to false
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
				if self._onRowTouch and self._allowRowTouch then
					-- If the row isn't a category
					if nil ~= self._targetRow.isCategory then
						self._newPhase = "press"
						local newEvent =
						{
							phase = "press",
							target = self._targetRow,
							row = self._targetRow,
						}
				
						-- Set the row cell's fill color
						self._targetRow._cell:setFillColor( unpack( self._targetRow._rowColor.over ) )
				
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
			
			-- Create the row's cell
			local rowCell = display.newRect( category, 0, 0, currentRow._width, currentRow._height )
			rowCell.x = rowCell.contentWidth * 0.5
			rowCell.y = rowCell.contentHeight * 0.5
			rowCell:setFillColor( unpack( currentRow._rowColor.default ) )
			
			-- If the user want's lines between rows, create a line to seperate them
			if not currentRow._noLines then
				-- Create the row's dividing line
				local rowLine = display.newLine( category, 0, rowCell.y, currentRow._width, rowCell.y )
				rowLine:setReferencePoint( display.CenterReferencePoint )
				rowLine.x = rowCell.x 
				rowLine.y = rowCell.y + ( rowCell.contentHeight * 0.5 ) + 0.5
				rowLine:setColor( unpack( currentRow._lineColor ) )					
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
			self._currentCategory.x = self.x + ( currentRow._width * 0.5 )
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
		if "table" ~= type( self._categories ) then
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
		for k, v in pairs( self._rows ) do
			local currentRow = self._rows[k]
			
			-- If this row's view property doesn't exist
			if type( currentRow._view ) ~= "table" then
				-- Is this row within the visible bounds of our view?				
				local isRowWithinBounds = ( currentRow.y + self.y ) + currentRow._height > upperLimit and ( currentRow.y + self.y ) - currentRow._height * 2 < lowerLimit
				
				-- If this row is within bounds, create it
				if isRowWithinBounds then
					self:_createRow( currentRow, true )
				end
			end
			
			-- Manage tableView categories (if there are any)
			if self._numCategories > 0 then
				-- If the currrent row has a view
				if type( currentRow._view ) == "table" then			
					-- Set the rows top position
					currentRow._top = self.y + currentRow._view.y - currentRow._view.contentHeight * 0.5
							
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
						self._currentCategoryIndex = k
						
						-- Hide the current row
						currentRow._view.isVisible = false
						
					elseif currentRow.isCategory and currentRow._top >= 0 and self._currentCategory and currentRow.index == self._currentCategory.index then
						-- Category moved below top of tableView, render previous category
						currentRow._view.isVisible = true
												
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
			if "table" == type( currentRow._view ) then
				-- Is this row within the visible bounds of our view?
				local isRowWithinBounds = ( currentRow.y + self.y ) + currentRow._height * 2 > upperLimit and ( currentRow.y + self.y ) - currentRow._height * 2 < lowerLimit
				
				-- If this row is a category, change the boundary to reflect it
				if currentRow.isCategory then
					isRowWithinBounds = ( currentRow.y + self.y ) - currentRow._height < lowerLimit
				end
				
				-- Remove rows that are are currently not within our view's visible bounds
				if not isRowWithinBounds then
					-- Remove this row
					display.remove( currentRow._view )
					currentRow._view = nil					
				end
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
		if not row._cannotTap and view._allowRowTouch then
			if "function" == type( view._onRowTouch ) then
				local newEvent =
				{
					phase = "tap",
					target = row,
				}

				-- Set the row cell's fill color
				row._cell:setFillColor( unpack( row._rowColor.over ) )
		
				-- After a little delay, set the row's fill color back to default
				timer.performWithDelay( 100, function()
					-- Set the row cell's fill color
					row._cell:setFillColor( unpack( row._rowColor.default ) )
				end)

				-- Execute the row's onRowTouch listener
				view._onRowTouch( newEvent )
			end
		end
	end
	
	
	-- Function to create a tableView row
	function view:_createRow( row, isReRender )
		local currentRow = row
		
		-- Set the upper and lower category limits
		local upperLimit = self._background.y - ( self._background.contentHeight * 0.5 )
		local lowerLimit = self._background.y + ( self._background.contentHeight * 0.5 )
		-- Is this row within the visible bounds of our view?
		local isRowWithinBounds = ( currentRow.y + self.y ) + currentRow._height > upperLimit and ( currentRow.y + self.y ) - currentRow._height * 2 < lowerLimit
	
		-- If the row is within the bounds of the view, create it
		if isRowWithinBounds then
			-- If the row's view property doesn't exist
			if type( currentRow._view ) ~= "table" then
				-- We haven't finished rendering all rows yet
				self._hasRenderedRows = false
								
				-- Create the row's view (a row is a display group)
				currentRow._view = display.newGroup()
				
				-- Create the row's cell
				local rowCell = display.newRect( currentRow._view, 0, 0, currentRow._width, currentRow._height )
				rowCell.x = rowCell.contentWidth * 0.5
				rowCell.y = rowCell.contentHeight * 0.5
				rowCell:setFillColor( unpack( currentRow._rowColor.default ) )

				-- If the user want's lines between rows, create a line to seperate them
				if not opt.noLines then
					-- Create the row's dividing line
					local rowLine = display.newLine( currentRow._view, 0, rowCell.y, currentRow._width, rowCell.y )
					rowLine:setReferencePoint( display.CenterReferencePoint )
					rowLine.x = rowCell.x 
					rowLine.y = rowCell.y + ( rowCell.contentHeight * 0.5 ) + 0.5
					rowLine:setColor( unpack( currentRow._lineColor ) )					
				end
			
				-- Set the row's reference point to it's center point (just incase)
				currentRow._view:setReferencePoint( display.CenterReferencePoint )

				-- Position the row
				currentRow._view.x = self.x + ( currentRow._width * 0.5 )
				currentRow._view.y = currentRow.y

				-- Assign properties to the row
				currentRow._view._cell = rowCell
				currentRow._view._rowColor = currentRow._rowColor
				currentRow._view.index = currentRow.index
				currentRow._view.id = currentRow.id
				currentRow._view._label = currentRow._label
				currentRow._view.isCategory = currentRow.isCategory
				
				-- Insert the row into the view
				self:insert( currentRow._view )				
				
				-- Add event listener to the row
				if not currentRow.isCategory then
					currentRow._view:addEventListener( "touch", _handleRowTouch )
					currentRow._view:addEventListener( "tap", _handleRowTap )
				else
					-- If the row is a category, pass the touch event back to the view
					local function scrollList( event )
						-- Handle momentum scrolling (if the view isn't locked)
						if not self._isLocked then
							_momentumScrolling._touch( self, event )
						end

						return true
					end

					currentRow._view:addEventListener( "touch", scrollList )
				end
				
				-- Row methods
				function currentRow._view:setRowColor( options )
					if "table" == type( options ) then
						if "table" == type( options.default ) then
							self._rowColor.default = options.default
						end
					
						if "table" == type( options.over ) then
							self._rowColor.over = options.over
						end
					else
						print( "WARNING: row:setRowColor - options table with default/over tables expected, got", type( options ) )
					end
				end
				
				-- Create the rowRender event
				local rowEvent = 
				{
					name = "rowRender",
					row = currentRow._view,
					target = self.parent,
				}

				-- If an onRowRender event exists, execute it
				if self._onRowRender and "function" == type( self._onRowRender ) then
					self._onRowRender( rowEvent )
				end

				-- We have finished rendering the rows (unless we render another, in which case this gets reset)
				self._hasRenderedRows = true
			end
		end
	end
	
					
	-- Function to insert a row into a tableView
	function view:_insertRow( options, reRender )
		-- Create the row
		self._rows[#self._rows + 1] = {}
		
		-- Are we re-rendering this row?
		local isReRender = reRender
		
		-- Retrieve passed in row customization variables
		local rowId = options.id or #self._rows
		local rowIndex = #self._rows	
		local rowWidth = self._width
		local rowHeight = options.rowHeight or 40
		local isRowCategory = options.isCategory or false
		local rowColor = options.rowColor or { default = { 255, 255, 255 }, over = { 30, 144, 255 } }
		local lineColor = options.lineColor or { 220, 220, 220 }
		local noLines = self._noLines or false
				
		-- Set defaults for row's color
		if not rowColor.default then
			rowColor.default = { 255, 255, 255 }
		end
		
		-- Set defaults for row's over color
		if not rowColor.over then
			rowColor.over = { 30, 144, 255 }
		end
		
		-- Assign public properties to the row
		self._rows[#self._rows].id = rowId
		self._rows[#self._rows].index = rowIndex
		self._rows[#self._rows].isCategory = isRowCategory
		
		-- Assign private properties to the row
		self._rows[#self._rows]._rowColor = rowColor
		self._rows[#self._rows]._lineColor = lineColor
		self._rows[#self._rows]._noLines = noLines
		self._rows[#self._rows]._width = rowWidth
		self._rows[#self._rows]._height = rowHeight
		self._rows[#self._rows]._label = options.label or ""
		self._rows[#self._rows]._view = nil
		
		-- Calculate and set the row's y position
		if #self._rows <= 1 then
			self._rows[#self._rows].y = ( self._rows[#self._rows]._height * 0.5 ) + 1
		else
			self._rows[#self._rows].y = ( self._rows[#self._rows - 1].y + ( self._rows[#self._rows - 1]._height * 0.5 ) ) + ( self._rows[#self._rows]._height * 0.5 ) + 1
		end
		
		-- Update the scrollHeight of our view
		self._scrollHeight = self._scrollHeight + self._rows[#self._rows]._height + 1
		
		-- Create the row
		self:_createRow( self._rows[#self._rows], reRender )
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
				
		----------------------------------------------------------------
		-- Check if the row we are deleting is on screen or off screen
		----------------------------------------------------------------
		
		-- Re calculate the scrollHeight
		self._scrollHeight = self._scrollHeight - self._rows[rowIndex]._height
		
		-- Function to remove the row from display
		local function removeRow()	
			-- Loop through the remaining rows, starting at the next row after the deleted one
			for i = rowIndex + 1, #self._rows do
				-- Move up the row's which are within our views visible bounds
				if "table" == type( self._rows[i]._view ) then
					if self._rows[i].isCategory then
						if nil ~= self._rows[i-1] then
							transition.to( self._rows[i]._view, { y = self._rows[i]._view.y - ( self._rows[i-1]._view.contentHeight ) + 1, transition = easing.outQuad } )
						end
					else
						transition.to( self._rows[i]._view, { y = self._rows[i]._view.y - ( self._rows[i]._view.contentHeight ) + 1, transition = easing.outQuad } )
					end
				-- We are now moving up the off screen rows
				else
					if self._rows[i].isCategory then
						if nil ~= self._rows[i-1] then
							self._rows[i].y = self._rows[i].y - ( self._rows[i-1]._height ) - 1
						end
					else
						self._rows[i].y = self._rows[i].y - ( self._rows[i]._height ) - 1
					end
				end
			end
			
			-- Remove the row from display
			display.remove( self._rows[rowIndex]._view )
			self._rows[rowIndex]._view = nil
							
			-- Remove the row from the row's table
			self._rows[rowIndex] = nil
		end
		
		-- If the row is within the visible view
		if "table" == type( self._rows[rowIndex]._view ) then
			-- Transition out & delete the row in question
			transition.to( self._rows[rowIndex]._view, { x = - ( self._rows[rowIndex]._view.contentWidth * 0.5 ), transition = easing.inQuad, onComplete = removeRow } )
		-- The row isn't within the visible bounds of our view
		else
			removeRow()
		end
	end
	
	-- Function to deleta all rows from the tableView
	function view:_deleteAllRows()
		local _tableView = self.parent
		
		-- Loop through all rows and delete each one
		for i = 1, #self._rows do
			if "table" == type( self._rows[i]._view ) then
				display.remove( self._rows[i]._view )
				self._rows[i]._view = nil
			end
		end
		
		-- Remove & reset the row's table
		self._rows = nil
		self._rows = {}
				
		-- Delete any stuck categories
		if self._currentCategory then
			display.remove( self._currentCategory )
			self._currentCategory = nil
			self._currentCategoryIndex = nil
		end
	
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
		newPosition = -self._rows[rowIndex].y + ( self._rows[rowIndex]._height * 0.5 )

		-- The calculation needs altering for pickerWheels
		if self._isUsedInPickerWheel then
			newPosition = self.y - self._rows[rowIndex].y + ( self._rows[rowIndex]._height * 0.5 )
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