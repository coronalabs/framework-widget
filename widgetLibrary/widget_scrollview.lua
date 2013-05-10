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
	_widgetName = "widget.newScrollView",
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


-- Creates a new scrollView
local function createScrollView( scrollView, options )
	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local view, viewFixed, viewBackground, viewMask
	
	-- Create the view
	view = display.newGroup()
	
	viewFixed = display.newGroup()
		
	-- Create the view's background
	viewBackground = display.newRect( scrollView, 0, 0, opt.width, opt.height )
	
	-- If there is a mask file, create the mask
	if opt.maskFile then
		viewMask = graphics.newMask( opt.maskFile, opt.baseDir )
	end
	
	-- If a mask was specified, set it
	if viewMask then
		scrollView:setMask( viewMask )
		scrollView.maskX = opt.width * 0.5
		scrollView.maskY = opt.height * 0.5
		scrollView.isHitTestMasked = true
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
	
	-- Set the platform
	view._isPlatformAndroid = "Android" == system.getInfo( "platformName" )
	
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
	view._scrollWidth = opt.scrollWidth
	view._scrollHeight = opt.scrollHeight
	view._trackVelocity = false	
	view._updateRuntime = false
			
	-------------------------------------------------------
	-- Assign properties/objects to the scrollView
	-------------------------------------------------------

	-- Assign objects to the view
	view._fixedGroup = viewFixed

	-- Assign objects to the scrollView
	scrollView._view = view	
	scrollView:insert( view )
	scrollView:insert( viewFixed )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to retrieve the x/y position of the scrollView's content
	function scrollView:getContentPosition()
		return self._view.x, self._view.y
	end
	
	-- Function to scroll the view to a specific position
	function scrollView:scrollToPosition( options )
		local newX = options.x or self._view.x
		local newY = options.y or self._view.y
		local transitionTime = options.time or 400
		local onTransitionComplete = options.onComplete
		
		-- Stop updating Runtime & tracking velocity
		self._view._updateRuntime = false
		self._view._trackVelocity = false
		-- Reset velocity back to 0
		self._view._velocity = 0		
	
		-- Transition the view to the new position
		transition.to( self._view, { x = newX, y = newY, time = transitionTime, transition = easing.inOutQuad, onComplete = onTransitionComplete } )
	end
	
	-- Function to scroll the view to a specified position from a list of constants ( i.e. top/bottom/left/right )
	function scrollView:scrollTo( position, options )
		local newPosition = position or "top"
		local newX = self._view.x
		local newY = self._view.y
		local transitionTime = options.time or 400
		local onTransitionComplete = options.onComplete
		
		-- Set the target x/y positions
		if "top" == newPosition then
			newY = self._view._topPadding
		elseif "bottom" == newPosition then
			newY = self._view._background.y - ( self._view.contentHeight ) + ( self._view._background.contentHeight * 0.5 ) - self._view._bottomPadding
		elseif "left" == newPosition then
			newX = self._view._leftPadding
		elseif "right" == newPosition then
			newX = self._view._background.x - ( self._view.contentWidth ) + ( self._view._background.contentWidth * 0.5 ) - self._view._rightPadding
		end
		
		-- Transition the view to the new position
		transition.to( self._view, { x = newX, y = newY, time = transitionTime, transition = easing.inOutQuad, onComplete = onTransitionComplete } )
	end
	
	function scrollView:takeFocus( event )
		local target = event.target
		
		-- Remove focus from the object
		display.getCurrentStage():setFocus( target, nil )
		
		-- Handle turning widget buttons back to their default state (visually, ie their default button images & labels)
		if "table" == type( target ) then
			if "string" == type( target._widgetType ) then
				-- Remove focus from the widget
				target:_loseFocus()
			end
		end
		
		-- Create our new event table
		local newEvent = {}
		
		-- Copy the event table's keys/values into our newEvent table
		for k, v in pairs( event ) do
			newEvent[k] = v
		end

		-- Set our new event's phase to began, and it's target to the view
		newEvent.phase = "began"
		newEvent.target = self._view
		
		-- Send a touch event to the view
		self._view:touch( newEvent )
	end
	
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------	

	-- Handle touch events on any inserted widget buttons
	local function _handleButtonTouch( event )
		local _targetButton = event.target
		
		-- If the target exists and is not active
		if _targetButton then
			if not _targetButton._isActive then
				local phase = event.phase
				
				view:touch( event )

				return true
			end
		end
	end

	-- Override scale function as scrollView's don't support it
	function scrollView:scale()
		print( M._widgetName, "Does not support scaling" )
	end

	-- Override the insert method for scrollView to insert into the view instead
    scrollView._cachedInsert = scrollView.insert

    function scrollView:insert( arg1, arg2 )
        local index, obj
        
        if arg1 and type( arg1 ) == "number" then
            index = arg1
        elseif arg1 and type( arg1 ) == "table" then
            obj = arg1
        end
        
        if arg2 and type( arg2 ) == "table" then
            obj = arg2
        end
        
        if index then
            self._view:insert( index, obj )
        else
            self._view:insert( obj )
        end

		local function updateScrollAreaSize()
			-- Update the scroll content area size (NOTE: Seems to need a 1ms delay for the group to reflect it's new content size? ) odd ...
			timer.performWithDelay( 1, function()
				-- Update the scrollWidth
				self._view._scrollWidth = self._view.width

				-- Update the scrollHeight
				self._view._scrollHeight = self._view.height
				
				-- Override the scroll height if it is less than the height of the window
				if "number" == type( self._view._scrollHeight ) and "number" == type( self._view._height ) then
					if self._view._scrollHeight < self._view._height then
						self._view._scrollHeight = self._view._height
					end
				end

				-- Override the scroll width if it is less than the width of the window
				if "number" == type( self._view._scrollWidth ) and "number" == type( self._view._width ) then
					if self._view._scrollWidth < self._view._width then
						self._view._scrollWidth = self._view._width
					end
				end
			end)
		end

		-- Override the removeself method for this object (so we can recalculate the content size after it is removed)
		-- If we haven't already over-ridden it
		if nil == obj._cachedRemoveSelf then
			obj._cachedRemoveSelf = obj.removeSelf
			
			local function removeSelf( self )
				self:_cachedRemoveSelf()
				
				-- Update the scroll area size
				updateScrollAreaSize()
			end
			
			obj.removeSelf = removeSelf
		end

		-- Update the scroll area size
		updateScrollAreaSize()
		
		-- Create the scrollBar
		if not opt.hideScrollBar then
			if self._view._scrollBar then
				display.remove( self._view._scrollBar )
				self._view._scrollBar = nil
			end
			
			if not self._view._isLocked then
				-- Need a delay here also..
				timer.performWithDelay( 2, function()
					--[[
					Currently only vertical scrollBar's are provided, so don't show it if they can't scroll vertically
					--]]
															
					if not self._view._isVerticalScrollingDisabled and self._view._scrollHeight > self._view._height then
						self._view._scrollBar = _momentumScrolling.createScrollBar( self._view, opt.scrollBarOptions )
					end
				end)
			end
		end	
    end

	-- Transfer touch from the view's background to the view's content
	function viewBackground:touch( event )		
		view:touch( event )
		
		return true
	end
	
	viewBackground:addEventListener( "touch" )
	
	-- Handle touches on the scrollview
	function view:touch( event )
		local phase = event.phase 
		local time = event.time
		
		-- Set the time held
		if "began" == phase then
			self._timeHeld = event.time
		end	
		
		-- Android fix for objects inserted into scrollView's
		if self._isPlatformAndroid then
			-- Distance moved
	        local dy = mAbs( event.y - event.yStart )
			local dx = mAbs( event.x - event.xStart )
			local moveThresh = 20

			-- If the finger has moved less than the desired range, set the phase back to began	(Android only fix, iOS doesn't exhibit this touch behavior..)
			if dy < moveThresh then
				if dx < moveThresh then
					if phase ~= "ended" and phase ~= "cancelled" then
						event.phase = "began"
					end
				end
			end
		end
						
		-- Handle momentum scrolling (and the view isn't locked)
		if not self._isLocked then
			_momentumScrolling._touch( self, event )
		end
		
		-- Execute the listener if one is specified
		if self._listener then
			local newEvent = {}
			
			for k, v in pairs( event ) do
				newEvent[k] = v
			end
			
			-- Set event.target to the scrollView object, not the view
			newEvent.target = self.parent
			
			-- Execute the listener
			self._listener( newEvent )
		end
				
		-- Set the view's phase so we can access it in the enterFrame listener below
		self._phase = event.phase
		
		-- Set the view's target object (the object we touched) so we can access it in the enterFrame listener below
		self._target = event.target
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	
  	-- EnterFrame listener for our scrollView
	function view:enterFrame( event )
		local _scrollView = self.parent

		-- Handle momentum @ runtime
		_momentumScrolling._runtime( self, event )		
		
		-- Constrain x/y scale values to 1.0
		if _scrollView.xScale ~= 1.0 then
			_scrollView.xScale = 1.0
			print( M._widgetName, "Does not support scaling" )
		end
		
		if _scrollView.yScale ~= 1.0 then
			_scrollView.yScale = 1.0
			print( M._widgetName, "Does not support scaling" )
		end

		-- Update the top position of the scrollView (if moved)
		if _scrollView.y ~= self._top then
			self._top = _scrollView.y
		end

		return true
	end
	
	Runtime:addEventListener( "enterFrame", view )
		
	-- Finalize function for the scrollView
	function scrollView:_finalize()		
		-- Remove the runtime listener
		Runtime:removeEventListener( "enterFrame", self._view )
				
		-- Remove scrollBar if it exists
		if self._view._scrollBar then
			display.remove( self._view._scrollBar )
			self._view._scrollBar = nil
		end
	end
			
	return scrollView
end


-- Function to create a new scrollView object ( widget.newScrollView )
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
	opt.isHorizontalScrollingDisabled = customOptions.horizontalScrollDisabled or false
	opt.isVerticalScrollingDisabled = customOptions.verticalScrollDisabled or false
	opt.friction = customOptions.friction
	opt.maxVelocity = customOptions.maxVelocity or 1.5
	opt.scrollWidth = customOptions.scrollWidth or opt.width
	opt.scrollHeight = customOptions.scrollHeight or opt.height
	opt.hideScrollBar = customOptions.hideScrollBar or false
	opt.isLocked = customOptions.isLocked or false
	
	-- Set the scrollView to locked if both horizontal and vertical scrolling are disabled
	if opt.isHorizontalScrollingDisabled and opt.isVerticalScrollingDisabled then
		opt.isLocked = true
	end
	
	-- Ensure scroll width/height values are at a minimum, equal to the scroll window width/height
	if opt.scrollHeight then
		if opt.scrollHeight < opt.height then
			opt.scrollHeight = opt.height
		end
	end
	
	if opt.scrollWidth then
		if opt.scrollWidth < opt.width then
			opt.scrollWidth = opt.width
		end
	end
	
	-- ScrollBar options
	opt.scrollBarOptions =
	{
		sheet = customOptions.sheet,
		topFrame = customOptions.topFrame,
		middleFrame = customOptions.middleFrame,
		bottomFrame = customOptions.bottomFrame,
	}
			
	-------------------------------------------------------
	-- Create the scrollView
	-------------------------------------------------------
		
	-- Create the scrollView object
	local scrollView = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_scrollView",
		baseDir = opt.baseDir,
	}

	-- Create the scrollView
	createScrollView( scrollView, opt )	

	return scrollView
end

return M
