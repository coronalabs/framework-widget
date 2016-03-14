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

local Super = require "CoronaPrototype"
local lib = Super:newClass( "widget_momentumScrolling" )

-- Localize math functions
local mAbs = math.abs
local mFloor = math.floor

-- configuration variables
lib.scrollStopThreshold = 250

-- direction variable that has a non-nil value only as long as the scrollview is scrolled
lib._direction = nil

-- variable that establishes if the view limits were set ( they have to be called one time to position the scrollview correctly )
lib._didSetLimits = false

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

-- Function to set the view's limits
local function setLimits( self, view )
	-- Set the bottom limit
	local bottomLimit = view._topPadding
	if isGraphicsV1 then
		bottomLimit = bottomLimit - view._height * 0.5
	end
	self.bottomLimit = bottomLimit
	
	-- TODO: use local functions for the limits instead of ifs
	
	-- Set the upper limit
	if view._scrollHeight then
		local upperLimit = ( -view._scrollHeight + view._height ) - view._bottomPadding
		
		-- the lower limit calculation is not necessary. We shift the view up with half its height, so the only thing we need to calculate
		-- is the upper limit.
		
		if isGraphicsV1 then
			upperLimit = upperLimit - view._height * 0.5
		end
		self.upperLimit = upperLimit
	end
	
	-- Set the right limit
	local rightLimit = view._leftPadding
	if isGraphicsV1 then
		rightLimit = rightLimit - view._width * 0.5
	end
	self.rightLimit = rightLimit

	-- Set the left limit
	if view._scrollWidth then
		local leftLimit = ( - view._scrollWidth + view._width ) - view._rightPadding
		if isGraphicsV1 then
			leftLimit = leftLimit - view._width * 0.5
		end
		self.leftLimit = leftLimit
	end
end

-- Function to handle vertical "snap back" on the view
local function handleSnapBackVertical( self, view, snapBack )
	
	-- Set the limits now
	setLimits( lib, view )
	
	local limitHit = "none"
	local bounceTime = 400
	if not view.isBounceEnabled then
	    bounceTime = 0
	end
	
	-- Snap back vertically
	if not view._isVerticalScrollingDisabled then
		-- Put the view back to the top if it isn't already there ( and should be ), if we're not in a picker wheel
		if view.y > self.bottomLimit or ( view._scrollHeight < view.parent.height and not view._isUsedInPickerWheel ) then
			-- Set the hit limit
			limitHit = "bottom"
			
			-- Transition the view back to it's maximum position
			if "boolean" == type( snapBack ) then
				if snapBack == true then
					-- Ensure the scrollBar is at the bottom of the view
					if view._scrollBarVertical then
						view._scrollBarVertical:setPositionTo( "top" )
					end
					-- Put the view back to the top
					if view._tween then transition.cancel( view._tween ) end
					view._tween = transition.to( view, { time = bounceTime, y = self.bottomLimit, transition = easing.outQuad } )						
				end
			end
			
		-- Put the view back to the bottom if it isn't already there ( and should be )
		elseif view.y < self.upperLimit then		
			-- Set the hit limit
			limitHit = "top"
			
			-- Transition the view back to it's maximum position
			if "boolean" == type( snapBack ) then
				if snapBack == true then
					-- Ensure the scrollBar is at the bottom of the view
					if view._scrollBarVertical then
						view._scrollBarVertical:setPositionTo( "bottom" )			
					end
					-- Put the view back to the bottom
					if view._tween then transition.cancel( view._tween ) end
					view._tween = transition.to( view, { time = bounceTime, y = self.upperLimit, transition = easing.outQuad } )
				end
			end
		end
	end
	
	return limitHit
end
	
-- Function to handle horizontal "snap back" on the view
local function handleSnapBackHorizontal( self, view, snapBack )

	-- Set the limits now
	setLimits( lib, view )

	local limitHit = "none"
	local bounceTime = 400
	if not view.isBounceEnabled then
	    bounceTime = 0
	end
	
	-- Snap back horizontally
	if not view._isHorizontalScrollingDisabled then
		-- Put the view back to the left if it isn't already there ( and should be )
		if view.x < self.leftLimit then
			-- Set the hit limit
			limitHit = "left"
			
			-- Transition the view back to it's maximum position
			if "boolean" == type( snapBack ) then
				if snapBack == true then
					-- Ensure the scrollBar is at the left of the view
					if view._scrollBarHorizontal then
						view._scrollBarHorizontal:setPositionTo( "left" )
					end
					if view._tween then transition.cancel( view._tween ) end
					view._tween = transition.to( view, { time = bounceTime, x = self.leftLimit, transition = easing.outQuad } )
					
				end
			end
		
		-- Put the view back to the right if it isn't already there ( and should be )
		elseif view.x > self.rightLimit then
			-- Set the hit limit
			limitHit = "right"
			
			-- Transition the view back to it's maximum position
			if "boolean" == type( snapBack ) then
				if snapBack == true then
					-- Ensure the scrollBar is at the right of the view
					if view._scrollBarHorizontal then
						view._scrollBarHorizontal:setPositionTo( "right" )
					end
					if view._tween then transition.cancel( view._tween ) end
					view._tween = transition.to( view, { time = bounceTime, x = self.rightLimit, transition = easing.outQuad } )
				end
			end
		end
	end
	
	return limitHit
end

-- Function to clamp velocity to the maximum value
local function clampVelocity( view )
	-- Throttle the velocity if it goes over the max range
	if view._velocity_horizontal < -view._maxVelocity then
		view._velocity_horizontal = -view._maxVelocity
	elseif view._velocity_horizontal > view._maxVelocity then
		view._velocity_horizontal = view._maxVelocity
	end
	
	if view._velocity_vertical < -view._maxVelocity then
        view._velocity_vertical = -view._maxVelocity
    elseif view._velocity_vertical > view._maxVelocity then
        view._velocity_vertical = view._maxVelocity
    end
end


-- Handle momentum scrolling touch
function lib._touch( view, event )
	local phase = event.phase
	local time = event.time
	local limit
	
	
	-- only apply the focus reset if the view is not used by the picker widget and the touch phase is began
	if not view._isUsedInPickerWheel then
		-- if the touch is not inside the actual scrollview container, return and reset focus.
		-- this only has to happen on the began phase ( since we just want to treat a new touch that occurs outside the bounds )
		if phase == "began" and ( event.x < view.parent.contentBounds.xMin or event.x > view.parent.contentBounds.xMax or event.y < view.parent.contentBounds.yMin or event.y > view.parent.contentBounds.yMax ) then
			display.getCurrentStage():setFocus( nil )
			view._isFocus = nil
			
			-- handle snap back before losing focus. Because if the scrollview has snapping enabled with animation and we don't handle it, the scrollview won't snap back if the touch leaves the object's coordinate space.
			if view._moveDirection then
				if view._moveDirection == "horizontal" then
					handleSnapBackHorizontal( lib, view, true )
				elseif view._moveDirection == "vertical" then
					handleSnapBackVertical( lib, view, true )
				end
			end
			
			return true
		end
	end

	if "began" == phase then	
		-- Reset values	
		view._startXPos = event.x
		view._startYPos = event.y
		view._prevXPos = event.x
		view._prevYPos = event.y
		view._prevX = 0
		view._prevY = 0
		view._delta_horizontal = 0
		view._delta_vertical = 0
		view._velocity_horizontal = 0
		view._velocity_vertical = 0
		view._prevTime = 0
		view._moveDirection = nil
		view._trackVelocity = true
		view._updateRuntime_horizontal = false
		view._updateRuntime_vertical = false
		
		-- Set the limits now
		setLimits( lib, view )
		
		-- Cancel any active tween on the view
		if view._tween then
			transition.cancel( view._tween )
			view._tween = nil
		end				
		
		-- Set focus
		display.getCurrentStage():setFocus( event.target, event.id )
		view._isFocus = true
	
	elseif view._isFocus then
		if "moved" == phase then
			-- Set the move direction		
			if not view._moveDirection then
		        local dx = mAbs( event.x - event.xStart )
	            local dy = mAbs( event.y - event.yStart )
	            local moveThresh = 12
				
	            if dx > moveThresh or dy > moveThresh then
					-- If there is a scrollBar, show it
					if view._scrollBarVertical then
						if view._scrollBarVertical._viewHeight < view._scrollBarVertical._viewContentHeight then
							view._scrollBarVertical:show()
						end
					end
					if view._scrollBarHorizontal then
						if view._scrollBarHorizontal._viewWidth < view._scrollBarHorizontal._viewContentWidth then
							view._scrollBarHorizontal:show()
						end
					end
		
	                if dx > dy then
						-- If horizontal scrolling is enabled
						if not view._isHorizontalScrollingDisabled then
							-- The move was horizontal
	                    	view._moveDirection = "horizontal"
						
							-- Handle vertical snap back
							handleSnapBackVertical( lib, view, true )						
						end
	                else
						-- If vertical scrolling is enabled
						if not view._isVerticalScrollingDisabled then
							-- The move was vertical
		                    view._moveDirection = "vertical"
							-- Handle horizontal snap back
							handleSnapBackHorizontal( lib, view, true )						
	                	end
					end
				end
			end
			
			-- Horizontal movement

			-- If horizontal scrolling is enabled
			if not view._isHorizontalScrollingDisabled then					
				view._delta_horizontal = event.x - view._prevXPos
				view._prevXPos = event.x
			
				-- If the view is more than the limits
				if view.x < lib.leftLimit or view.x > lib.rightLimit then
					view.x = view.x + ( view._delta_horizontal * 0.5 )
				else
					view.x = view.x + view._delta_horizontal
					if view._listener and view._widgetType == "scrollView" then
					
						local actualDirection
					
						if view._delta_horizontal < 0 then
					
							actualDirection = "left"
					
						elseif view._delta_horizontal > 0 then

							actualDirection = "right"
						
						elseif view._delta_horizontal == 0 then
						
							if view._prevDeltaX and view._prevDeltaX < 0 then
						
								actualDirection = "left"
						
							elseif view._prevDeltaX and view._prevDeltaX > 0 then
						
								actualDirection = "right"
						
							end
					
						end
						-- if the scrollview is moving, assign the actual direction to the lib._direction variable
						lib._direction = actualDirection
						
					end

				end
				
				view._prevDeltaX = view._delta_horizontal
				
				if view.isBounceEnabled == true then
					if not view._isUsedInPickerWheel then
						limit = handleSnapBackHorizontal( lib, view, false )
					end
				else
					limit = handleSnapBackHorizontal( lib, view, true )
				end
				
			end
			

			-- If vertical scrolling is enabled
			if not view._isVerticalScrollingDisabled then
				view._delta_vertical = event.y - view._prevYPos
				view._prevYPos = event.y
				
				-- If the view is more than the limits
				if view.y < lib.upperLimit or view.y > lib.bottomLimit then
					view.y = view.y + ( view._delta_vertical * 0.5 )
					-- shrink the scrollbar if the view is out of bounds
					if view._scrollBarVertical then
						--view._scrollBar.yScale = 0.1 * - ( view.y - lib.bottomLimit )
					end
				else
					view.y = view.y + view._delta_vertical
					
					if view._listener and view._widgetType == "scrollView" then
					
						local actualDirection
					
						if view._delta_vertical < 0 then
					
							actualDirection = "up"
					
						elseif view._delta_vertical > 0 then

							actualDirection = "down"
						
						elseif view._delta_vertical == 0 then
						
							if view._prevDeltaY and view._prevDeltaY < 0 then
								
								actualDirection = "up"

							elseif view._prevDeltaY and view._prevDeltaY > 0 then
								
								actualDirection = "down"

							end
					
						end
						-- if the scrollview is moving, assign the actual direction to the lib._direction variable
						lib._direction = actualDirection
						
					end
					
				end
				
				view._prevDeltaY = view._delta_vertical
				
				-- Handle limits
				-- if bounce is true, then the snapback parameter has to be true, otherwise false
				
				if view.isBounceEnabled == true then
					if not view._isUsedInPickerWheel then
						limit = handleSnapBackVertical( lib, view, false )
					end
				else
					limit = handleSnapBackVertical( lib, view, true )
				end
				
				-- Move the scrollBar
				if limit ~= "top" and limit ~= "bottom" then
					if view._scrollBarVertical then						
						view._scrollBarVertical:move()
					end
					if view._scrollBarHorizontal then						
						view._scrollBarHorizontal:move()
					end
				end
				
				-- Set the time held
				--view._timeHeld = time				
			end

			
		elseif "ended" == phase or "cancelled" == phase then
			-- Reset values				
			view._lastTime = event.time
			view._trackVelocity = false			
			view._updateRuntime_horizontal = true
			view._updateRuntime_vertical = true
			lib._direction = nil
			
			-- we check if the view has a scrollStopThreshold value
			local stopThreshold = view.scrollStopThreshold or lib.scrollStopThreshold
			if event.time - view._timeHeld > stopThreshold then
			    view._velocity_horizontal = 0
			    view._velocity_vertical = 0
			end
			view._timeHeld = 0
			
			-- when tapping fast and the view is at the limit, the velocity changes sign. This ALWAYS has to be treated.
			if view._delta_horizontal > 0 and view._velocity_horizontal < 0 then
			    view._velocity_horizontal = - view._velocity_horizontal
			end
			
			if view._delta_horizontal < 0 and view._velocity_horizontal > 0 then
			    view._velocity_horizontal = - view._velocity_horizontal
			end
			
			if view._delta_vertical > 0 and view._velocity_vertical < 0 then
			    view._velocity_vertical = - view._velocity_vertical
			end
			
			if view._delta_vertical < 0 and view._velocity_vertical > 0 then
			    view._velocity_vertical = - view._velocity_vertical
			end
	
			-- Remove focus								
			display.getCurrentStage():setFocus( nil )
			view._isFocus = nil
		
			-- If on ended the scrollview is outside of the bounds, reposition it
			limit = handleSnapBackVertical( lib, view, true )
		end
	end
end


-- Handle runtime momentum scrolling events.
function lib._runtime( view, event )
	local limit
	-- If we are tracking runtime
	if view._updateRuntime_horizontal or view._updateRuntime_vertical then		
		local timePassed = event.time - view._lastTime
		view._lastTime = view._lastTime + timePassed
		
		-- Stop scrolling if velocity is near zero
		if mAbs( view._velocity_horizontal ) < 0.01 then
			view._velocity_horizontal = 0
			view._updateRuntime_horizontal = false
			
			-- Hide the scrollBar
			if view._scrollBarHorizontal and view.autoHideScrollBar then
				view._scrollBarHorizontal:hide()
			end
		end
		
		if mAbs( view._velocity_vertical ) < 0.01 then
			view._velocity_vertical = 0
			view._updateRuntime_vertical = false
			
			-- Hide the scrollBar
			if view._scrollBarVertical and view.autoHideScrollBar then
				view._scrollBarVertical:hide()
			end
		end
		
		-- Set the velocity
		view._velocity_horizontal = view._velocity_horizontal * view._friction
		view._velocity_vertical = view._velocity_vertical * view._friction
		
		-- Clamp the velocity if it goes over the max range
		clampVelocity( view )
	
		-- Horizontal movement
		-- If horizontal scrolling is enabled
		if not view._isHorizontalScrollingDisabled and view._updateRuntime_horizontal then
			-- Reset limit values
			view._hasHitLeftLimit = false
			view._hasHitRightLimit = false
			
			-- Move the view
			view.x = view.x + view._velocity_horizontal * timePassed
		
			-- Move the scrollBar
			if view._scrollBarHorizontal then						
				view._scrollBarHorizontal:move()
			end
		
			-- Handle limits
			if "horizontal" == view._moveDirection then
				limit = handleSnapBackHorizontal( lib, view, true )
			else
				limit = handleSnapBackHorizontal( lib, view, false )
			end
		
			-- Left
			if "left" == limit then					
				-- Stop updating the runtime now
				view._updateRuntime_horizontal = false
				
				-- We have hit the left limit
				view._hasHitLeftLimit = true
				
				-- Hide the scrollBar
				if view._scrollBarHorizontal and view.autoHideScrollBar then
					view._scrollBarHorizontal:hide()
				end
				
				-- If there is a listener specified, dispatch the event
				if view._listener then

					
					local newEvent = 
					{
						direction = "left",
						limitReached = true,
						target = view,
					}
					
					view._listener( newEvent )
				end
		
			-- Right
			elseif "right" == limit then					
				-- Stop updating the runtime now
				view._updateRuntime_horizontal = false

				-- We have hit the right limit
				view._hasHitRightLimit = true
				
				-- Hide the scrollBar
				if view._scrollBarHorizontal and view.autoHideScrollBar then
					view._scrollBarHorizontal:hide()
				end
				
				-- If there is a listener specified, dispatch the event
				if view._listener then

					
					local newEvent = 
					{
						direction = "right",
						limitReached = true,
						target = view,
					}
					
					view._listener( newEvent )
				end
			end
		end	
			
		-- Vertical movement		
		if not view._isVerticalScrollingDisabled and view._updateRuntime_vertical then

			-- Reset limit values
			view._hasHitBottomLimit = false
			view._hasHitTopLimit = false
			
			-- Move the view
			view.y = view.y + view._velocity_vertical * timePassed
			
			-- Move the scrollBar
			if view._scrollBarVertical then						
				view._scrollBarVertical:move()
			end

			-- Handle limits
			-- if we have motion, then we check for snapback. otherwise, we don't.
			
			if "vertical" == view._moveDirection then
				limit = handleSnapBackVertical( lib, view, true )
			else
				limit = handleSnapBackVertical( lib, view, false )
			end

			-- Top
			if "top" == limit then					
				-- Hide the scrollBar
				if view._scrollBarVertical and view.autoHideScrollBar then
					view._scrollBarVertical:hide()
				end
				
				-- We have hit the top limit
				view._hasHitTopLimit = true
									
				-- Stop updating the runtime now
				view._updateRuntime_vertical = false
									
				-- If there is a listener specified, dispatch the event
				if view._listener then
					local newEvent = 
					{
						direction = "up",
						limitReached = true,
						phase = event.phase,
						target = view,
					}
					
					view._listener( newEvent )
				end
						
			-- Bottom
			elseif "bottom" == limit then				
				-- Hide the scrollBar
				if view._scrollBarVertical and view.autoHideScrollBar then
					view._scrollBarVertical:hide()
				end
									
				-- We have hit the bottom limit
				view._hasHitBottomLimit = true
				
				-- Stop updating the runtime now
				view._updateRuntime_vertical = false
				
				-- If there is a listener specified, dispatch the event
				if view._listener then
					local newEvent = 
					{
						direction = "down",
						limitReached = true,
						target = view,
					}
					
					view._listener( newEvent )
				end
			end
		end
		
		if mAbs( view._velocity_vertical ) < 0.001 then
            view._updateRuntime_vertical = false
        end
        
        if mAbs( view._velocity_horizontal ) < 0.001 then
            view._updateRuntime_horizontal = false
        end

	end
	
	-- If we are tracking velocity
	if view._trackVelocity then	
		-- Calculate the time passed
		local newTimePassed = event.time - view._prevTime
		view._prevTime = view._prevTime + newTimePassed

		-- Horizontal movement
		-- If horizontal scrolling is enabled
		if not view._isHorizontalScrollingDisabled then
			if view._prevX and newTimePassed > 0 then
				local possibleVelocity = ( view.x - view._prevX ) / newTimePassed

				if possibleVelocity ~= 0 then
					view._velocity_horizontal = possibleVelocity

					-- Clamp the velocity if it goes over the max range
					clampVelocity( view )
				end
			end
	
			view._prevX = view.x
		end
		
		-- Vertical movement
		-- If vertical scrolling is enabled
		if not view._isVerticalScrollingDisabled then
			if view._prevY and newTimePassed > 0 then
				local possibleVelocity = ( view.y - view._prevY ) / newTimePassed
				
				if possibleVelocity ~= 0 then
					view._velocity_vertical = possibleVelocity
					-- Clamp the velocity if it goes over the max range
					clampVelocity( view )
				end
			end
	
			view._prevY = view.y
		end
	end
end


-- Function to create a scrollBar - vertical
function lib.createScrollBarVertical( view, options )
	-- Require needed widget files
	local _widget = require( "widget" )
	
	local opt = {}
	local customOptions = options or {}
	
	-- Setup the scrollBar's width/height
	--local parentGroup = view.parent.parent
	local scrollBarWidth = options.width or 5
	local viewHeight = view._height -- The height of the windows visible area
	local viewContentHeight = view._scrollHeight -- The height of the total content height
	local minimumScrollBarHeight = 24 -- The minimum height the scrollbar can be

	-- Set the scrollbar Height
	local scrollBarHeight = ( viewHeight * 100 ) / viewContentHeight
	
	-- If the calculated scrollBar height is below the minimum height, set it to it
	if scrollBarHeight < minimumScrollBarHeight then
		scrollBarHeight = minimumScrollBarHeight
	end
	
	-- Grab the theme options for the scrollBar
	local themeOptions = _widget.theme.scrollBar
	
	-- Get the theme sheet file and data
	opt.sheet = options.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	opt.width = options.frameWidth or options.width or themeOptions.width
	opt.height = options.frameHeight or options.height or themeOptions.height
	
	-- Grab the frames
	opt.topFrame = options.topFrame or _widget._getFrameIndex( themeOptions, themeOptions.topFrame )
	opt.middleFrame = options.middleFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleFrame )
	opt.bottomFrame = options.bottomFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomFrame )
	
	-- Create the scrollBar imageSheet
	local imageSheet
	
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
	 	imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- The scrollBar is a display group
	lib.scrollBarVertical = display.newGroup()
	
	-- Create the scrollBar frames ( 3 slice )
	lib.topFrameV = display.newImageRect( lib.scrollBarVertical, imageSheet, opt.topFrame, opt.width, opt.height )
	if not isGraphicsV1 then
		lib.topFrameV.anchorX = 0.5; lib.topFrameV.anchorY = 0.5
	end
	
	lib.middleFrameV = display.newImageRect( lib.scrollBarVertical, imageSheet, opt.middleFrame, opt.width, opt.height )
	if not isGraphicsV1 then
		lib.middleFrameV.anchorX = 0.5; lib.middleFrameV.anchorY = 0.5
	end
	
	lib.bottomFrameV = display.newImageRect( lib.scrollBarVertical, imageSheet, opt.bottomFrame, opt.width, opt.height )
	if not isGraphicsV1 then
		lib.bottomFrameV.anchorX = 0.5; lib.bottomFrameV.anchorY = 0.5
	end
	
	-- Set the middle frame's width
	lib.middleFrameV.height = scrollBarHeight - ( lib.topFrameV.contentHeight + lib.bottomFrameV.contentHeight )
	
	-- Positioning
	lib.middleFrameV.y = lib.topFrameV.y + lib.topFrameV.contentHeight * 0.5 + lib.middleFrameV.contentHeight * 0.5
	lib.bottomFrameV.y = lib.middleFrameV.y + lib.middleFrameV.contentHeight * 0.5 + lib.bottomFrameV.contentHeight * 0.5
	
	-- Setup the scrollBar's properties
	lib.scrollBarVertical._viewHeight = viewHeight
	lib.scrollBarVertical._viewContentHeight = viewContentHeight
	lib.scrollBarVertical.alpha = 0 -- The scrollBar is invisible initally
	lib.scrollBarVertical._tween = nil
	
	-- function to recalculate the scrollbar params, based on content height change
	function lib.scrollBarVertical:repositionY()
	
	    self._viewHeight = view._height
	    self._viewContentHeight = view._scrollHeight
	    -- Set the scrollbar Height
	    
	    local scrollBarHeight = ( self._viewHeight * 100 ) / self._viewContentHeight
	    
	    -- If the calculated scrollBar height is below the minimum height, set it to it
	    if scrollBarHeight < minimumScrollBarHeight then
		    scrollBarHeight = minimumScrollBarHeight
	    end
	
        lib.middleFrame.height = scrollBarHeight
        
        -- if we have topFrame and bottomFrame as non-collected objects, we use their dimensions to recalculate the position of the scrollbar
        if lib.topFrameV and lib.topFrameV.contentHeight and lib.bottomFrameV and lib.bottomFrameV.contentHeight then
        	lib.middleFrameV.height = lib.middleFrameV.height - ( lib.topFrameV.contentHeight + lib.bottomFrameV.contentHeight )
			-- Positioning of the middle and bottom frames according to the new scrollbar height
			lib.middleFrameV.y = lib.topFrameV.y + lib.topFrameV.contentHeight * 0.5 + lib.middleFrameV.contentHeight * 0.5
			lib.bottomFrameV.y = lib.middleFrameV.y + lib.middleFrameV.contentHeight * 0.5 + lib.bottomFrameV.contentHeight * 0.5 
    	end
    	
	end
	
	-- Function to move the scrollBar
	function lib.scrollBarVertical:move()
	
		local viewY = view.y
		if isGraphicsV1 then
			viewY = viewY + view.parent.contentHeight * 0.5
		end
	
		local moveFactor = ( viewY * 100 ) / ( self._viewContentHeight - self._viewHeight )		
		local moveQuantity = ( moveFactor * ( self._viewHeight - self.contentHeight ) ) / 100
				
		if viewY < 0 then
			-- Only move if not over the bottom limit
			if mAbs( view.y ) < ( self._viewContentHeight ) then
				self.y = view.parent.y - view._top - moveQuantity
			end
		end		
	end
	
	function lib.scrollBarVertical:setPositionTo( position )
		if "top" == position then
			self.y = view.parent.y - view._top
		elseif "bottom" == position then
			self.y = self._viewHeight - self.contentHeight
		end
	end
	
	-- Function to show the scrollBar
	function lib.scrollBarVertical:show()
		-- Cancel any previous transition
		if self._tween then
			transition.cancel( self._tween ) 
			self._tween = nil
		end
		
		-- Set the alpha of the bar back to 1
		self.alpha = 1
	end
	
	-- Function to hide the scrollBar
	function lib.scrollBarVertical:hide()
		-- If there already isn't a tween in progress
		if not self._tween then
			self._tween = transition.to( self, { time = 400, alpha = 0, transition = easing.outQuad } )
		end
	end
		
	-- Insert the scrollBar into the fixed group and position it
	view._fixedGroupV:insert( lib.scrollBarVertical )
	
	view._fixedGroupV.x = view._width * 0.5 - scrollBarWidth * 0.5
	--local viewFixedGroupY = view.parent.y - view._top - view._height * 0.5
	
	-- this has to be positioned at the yCoord - half the height, no matter what.
	local viewFixedGroupY = - view.parent.contentHeight * 0.5
	view._fixedGroupV.y = viewFixedGroupY
	
	-- calculate the limits. Fixes placement errors for the scrollbar.
	setLimits( lib, view )
	
	-- set the widget y coord according to the calculated limits
	if not lib._didSetLimits then
		view.y = lib.bottomLimit
		lib._didSetLimits = true
	end
	
	if not view.autoHideScrollBar then
		lib.scrollBarVertical:show()
	end

	
	return lib.scrollBarVertical
end

-- Function to create a scrollBar - horizontal
function lib.createScrollBarHorizontal( view, options )
	-- Require needed widget files
	local _widget = require( "widget" )
	
	local opt = {}
	local customOptions = options or {}
	
	-- Setup the scrollBar's width/height
	local scrollBarHeight = options.height or 5
	local viewWidth = view._width -- The height of the windows visible area
	local viewContentWidth = view._scrollWidth -- The height of the total content height
	local minimumScrollBarWidth = 24 -- The minimum height the scrollbar can be

	-- Set the scrollbar Height
	local scrollBarWidth = ( viewWidth * 100 ) / viewContentWidth
	
	-- If the calculated scrollBar height is below the minimum height, set it to it
	if scrollBarWidth < minimumScrollBarWidth then
		scrollBarWidth = minimumScrollBarWidth
	end
	
	-- Grab the theme options for the scrollBar
	local themeOptions = _widget.theme.scrollBar
	
	-- Get the theme sheet file and data
	opt.sheet = options.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	opt.width = options.frameWidth or options.width or themeOptions.width
	opt.height = options.frameHeight or options.height or themeOptions.height
	
	-- Grab the frames
	opt.topFrame = options.topFrame or _widget._getFrameIndex( themeOptions, themeOptions.topFrame )
	opt.middleFrame = options.middleFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleFrame )
	opt.bottomFrame = options.bottomFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomFrame )
	
	-- Create the scrollBar imageSheet
	local imageSheet
	
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
	 	imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- The scrollBar is a display group
	lib.scrollBarHorizontal = display.newGroup()
	
	-- Create the scrollBar frames ( 3 slice )
	lib.topFrameH = display.newImageRect( lib.scrollBarHorizontal, imageSheet, opt.topFrame, opt.width, opt.height )
	if not isGraphicsV1 then
		lib.topFrameH.anchorX = 0.5; lib.topFrameH.anchorY = 0.5
	end
	
	lib.middleFrameH = display.newImageRect( lib.scrollBarHorizontal, imageSheet, opt.middleFrame, opt.width, opt.height )
	if not isGraphicsV1 then
		lib.middleFrameH.anchorX = 0.5; lib.middleFrameH.anchorY = 0.5
	end
	
	lib.bottomFrameH = display.newImageRect( lib.scrollBarHorizontal, imageSheet, opt.bottomFrame, opt.width, opt.height )
	if not isGraphicsV1 then
		lib.bottomFrameH.anchorX = 0.5; lib.bottomFrameH.anchorY = 0.5
	end
	
	-- Set the middle frame's width
	lib.middleFrameH.width = scrollBarWidth - ( lib.topFrameH.contentWidth + lib.bottomFrameH.contentWidth )
	
	-- Positioning
	lib.middleFrameH.x = lib.topFrameH.y + lib.topFrameH.contentWidth * 0.5 + lib.middleFrameH.contentWidth * 0.5
	lib.bottomFrameH.x = lib.middleFrameH.y + lib.middleFrameH.contentWidth * 0.5 + lib.bottomFrameH.contentWidth * 0.5
	
	-- Setup the scrollBar's properties
	lib.scrollBarHorizontal._viewWidth = viewWidth

	lib.scrollBarHorizontal._viewContentWidth = viewContentWidth
	lib.scrollBarHorizontal.alpha = 0 -- The scrollBar is invisible initally
	lib.scrollBarHorizontal._tween = nil
	
	-- function to recalculate the scrollbar params, based on content height change
	function lib.scrollBarHorizontal:repositionX()
	
	    self._viewWidth = view._width
	    self._viewContentWidth = view._scrollWidth

	    -- Set the scrollbar Width
	    
	    local scrollBarWidth = ( self._viewWidth * 100 ) / self._viewContentWidth
	    
	    -- If the calculated scrollBar height is below the minimum height, set it to it
	    if scrollBarWidth < minimumScrollBarWidth then
		    scrollBarWidth = minimumScrollBarWidth
	    end
	
        lib.middleFrameH.width = scrollBarWidth
        
        -- if we have topFrame and bottomFrame as non-collected objects, we use their dimensions to recalculate the position of the scrollbar
        if lib.topFrameH and lib.topFrameH.contentWidth and lib.bottomFrameH and lib.bottomFrameH.contentWidth then
        	lib.middleFrameH.width = lib.middleFrameH.width - ( lib.topFrameH.contentWidth + lib.bottomFrameH.contentWidth )
			-- Positioning of the middle and bottom frames according to the new scrollbar width
			lib.middleFrameH.x = lib.topFrameH.x + lib.topFrame.contentWidth * 0.5 + lib.middleFrameH.contentWidth * 0.5
			lib.bottomFrameH.x = lib.middleFrameH.x + lib.middleFrameH.contentWidth * 0.5 + lib.bottomFrameH.contentWidth * 0.5 
    	end
    	
	end
	
	-- Function to move the scrollBar
	function lib.scrollBarHorizontal:move()
	
		local viewX = view.x
		if isGraphicsV1 then
			viewX = viewX + view.parent.contentWidth * 0.5
		end
	
		local moveFactor = ( viewX * 100 ) / ( self._viewContentWidth - self._viewWidth )		
		local moveQuantity = ( moveFactor * ( self._viewWidth - self.contentWidth ) ) / 100
				
		if viewX < 0 then
			-- Only move if not over the left limit
			if mAbs( view.x ) < ( self._viewContentWidth ) then
				self.x = - view._left - moveQuantity
			end
		end		
		
	end
	
	function lib.scrollBarHorizontal:setPositionTo( position )
		if "left" == position then
			self.x = self._viewWidth - self.contentWidth
		elseif "right" == position then
			self.x = - view._left
		end
	end
	
	-- Function to show the scrollBar
	function lib.scrollBarHorizontal:show()
		-- Cancel any previous transition
		if self._tween then
			transition.cancel( self._tween ) 
			self._tween = nil
		end
		
		-- Set the alpha of the bar back to 1
		self.alpha = 1
	end
	
	-- Function to hide the scrollBar
	function lib.scrollBarHorizontal:hide()
		-- If there already isn't a tween in progress
		if not self._tween then
			self._tween = transition.to( self, { time = 400, alpha = 0, transition = easing.outQuad } )
		end
	end
		
	-- Insert the scrollBar into the fixed group and position it
	view._fixedGroupH:insert( lib.scrollBarHorizontal )
	
	view._fixedGroupH.x = - view.parent.contentWidth * 0.5
	
	-- this has to be positioned at the yCoord - half the height, no matter what.
	local viewFixedGroupY = view.parent.contentHeight * 0.5 - scrollBarHeight * 0.5
	view._fixedGroupH.y = viewFixedGroupY
	
	-- calculate the limits. Fixes placement errors for the scrollbar.
	setLimits( lib, view )
	
	-- set the widget y coord according to the calculated limits
	if not lib._didSetLimits then
		view.x = lib.leftLimit
		lib._didSetLimits = true
	end
	
	if not view.autoHideScrollBar then
		lib.scrollBarHorizontal:show()
	end

	
	return lib.scrollBarHorizontal
end

return lib
