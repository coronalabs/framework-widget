--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
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
	local view, viewBackground, viewMask
	
	-- Create the view
	view = display.newGroup()
	
	-- Create the view's background
	viewBackground = display.newRect( tableView, 0, 0, opt.width, opt.height )
	
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
	view._top = opt.top
	view._left = opt.left
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
	view._onRowTouch = opt.onRowTouch
	view._trackVelocity = false	
	view._updateRuntime = false
					
	-------------------------------------------------------
	-- Assign properties/objects to the tableView
	-------------------------------------------------------
	
	-- Assign objects to the tableView
	tableView._view = view
	tableView:insert( view )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to insert a row into a tableView
	function tableView:insertRow()
		return self._view:_insertRow()
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
	function tableView:scrollToIndex( rowIndex )
		return self._view:_scrollToIndex( rowIndex )
	end
	
	-- Function to scroll the tableView to a specific y position
	function tableView:scrollToY( options )
		return self._view:_scrollToY( options )
	end

	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
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
				}
				
				-- Set the row's border's fill color
				self._targetRow._border:setFillColor( 255, 255, 255 )
				
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
		-- Handle momentum @ runtime
		require( "widget_momentumScrolling" )._runtime( self, event )
		
		-- Calculate the time the touch was held
		local timeHeld = event.time - self._timeHeld
		
		-- Dispatch the "press" phase
		if "began" == self._phase then
			if timeHeld >= 110 then
				-- If there is a onRowTouch listener
				if self._onRowTouch then
					self._newPhase = "press"
					local newEvent =
					{
						phase = "press",
						target = self._targetRow,
					}
					
					-- Set the row's border fill color
					self._targetRow._border:setFillColor( 30, 144, 255 )
					
					-- Execute the row's onRowTouch listener
					self._onRowTouch( newEvent )
				end
				
				-- Set the phase to nil
				self._phase = nil
			end
		end
				
		-- Manage all row's lifeCycle
		self:_manageRowLifeCycle()
		
		return true
	end
	
	Runtime:addEventListener( "enterFrame", view )
	
	-- Function to manage all row's lifeCycle
	function view:_manageRowLifeCycle()
		local upperLimit = self._background.y - ( self._background.contentHeight * 0.5 )
		local lowerLimit = self._background.y + ( self._background.contentHeight * 0.5 )
		
		-- Loop through the rows and set any off screen ones to invisible, and on screen ones to visible
		for k, v in pairs( self._rows ) do
			local isRowOnScreen = ( self._rows[k].y + self.y ) + self._rows[k].contentHeight > upperLimit and ( self._rows[k].y + self.y ) - self._rows[k].contentHeight < lowerLimit
			
			-- Cull rows that are are currently not within our tableView's bounds
			if not isRowOnScreen then
				self._rows[k].isVisible = false
			-- Show rows that are within our tableView's bounds
			else
				self._rows[k].isVisible = true
			end
		end
	end
	
	-- Send row touch event's to the view
	local function _handleRowTouch( event )
		local phase = event.phase
		
		view:touch( event )

		return true
	end
					
	-- Row
	function view:_insertRow()
		-- Create a new rowGroup
		self._rows[#self._rows + 1] = display.newGroup()
		self._rows[#self._rows].index = #self._rows
		
		-- Create the row's touch rectangle
		local border = display.newRect( self._rows[#self._rows], 0, 0, opt.width, self._rowHeight )
		border.isVisible = true
		border.isHitTestable = true
		border.y = border.contentHeight * 0.5
		
		-- Create the row's border
		local frame = nil
		if not opt.noLines then
			frame = display.newLine( self._rows[#self._rows], 0, self._rowHeight, display.contentWidth, self._rowHeight )
	    	frame:setColor( 220, 220, 220 )
			frame.y = border.y + ( border.contentHeight * 0.5 )
		end

		-- Position the row
		self._rows[#self._rows].x = self.x
		self._rows[#self._rows].y = ( self._rowHeight ) * #self._rows - self._rowHeight
				
		-- Add event listener to the row
		self._rows[#self._rows]:addEventListener( "touch", _handleRowTouch )
		
		-- Insert the row into the view
		self._rows[#self._rows]._border = border
		self._rows[#self._rows].frame = frame
		self:insert( self._rows[#self._rows] )
		
		-- Create the event
		local event = 
		{
			name = "rowRender",
			row = self._rows[#self._rows],
		}

		-- If an onRowRender event exists, execute it
		if self._onRowRender then
			self._onRowRender( event )
		end		
	end
	
	-- Function to delete a row from the tableView
	function view:_deleteRow( rowIndex )
		-- Transition out the row in question
		transition.to( self._rows[rowIndex], { x = - ( self._rows[rowIndex].contentWidth * 0.5 ), transition = easing.inQuad, onComplete = function() self._rows[rowIndex] = nil end } )

		-- Loop through the remaining rows, starting at the next row after the deleted one
		for i = rowIndex + 1, #self._rows do
			if self._rows[i].y then
				--self._rows[i].y = self._rows[i].y - ( self._rows[i].contentHeight )
				transition.to( self._rows[i], { y = self._rows[i].y - ( self._rows[i]._border.contentHeight ), transition = easing.outQuad } )
			end
		end
	end
	
	-- Function to deleta all rows from the tableView
	function view:_deleteAllRows()
		-- Loop through all rows and delete each one
		for k, v in pairs( self._rows ) do
			display.remove( self._rows[k] )
			self._rows[k] = nil
		end
	end
	
	-- Function to scroll to a specific row
	function view:_scrollToIndex( rowIndex )
		transition.to( self, { y = self.y - self._rows[rowIndex].y + ( self._rows[rowIndex].contentHeight ), transition = easing.outQuad } )
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
	end
			
	return tableView
end


-- Function to create a new tableView object ( widget.newtableView )
function M.new( options, theme )	
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
	opt.rowWidth = opt.width
	opt.rowHeight = customOptions.rowHeight or 40
	opt.onRowRender = customOptions.onRowRender
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
