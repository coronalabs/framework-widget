--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
	File: 
		widget_momentumScrolling.lua
		
	What is it?: 
		Used to provide momentum scrolling to any widget that requires it.
--]]


local M = {}

-- Handle momentum scrolling touch
function M._touch( view, event )
	local phase = event.phase
	local time = event.time
			
	if "began" == phase then	
		-- Reset values	
		view._startXPos = event.x
		view._startYPos = event.y
		view._prevXPos = event.x
		view._prevYPos = event.y
		view._prevX = 0
		view._prevY = 0
		view._delta = 0
		view._delta = 0
		view._velocity = 0
		view._prevTime = 0
		view._moveDirection = nil
		view._trackVelocity = true
		view._updateRuntime = false
		view._timeHeld = time
		
		-- If there is a scrollBar
		if view._scrollBar then
			-- Reset scrollbar position (if scrollView was moved)
			view._scrollBar:resetInitialPosition()
					
			-- Show the scrollBar
			view._scrollBar:show()
		end				
		
		-- Set focus
		display.getCurrentStage():setFocus( event.target, event.id )
		view._isFocus = true
	
	elseif view._isFocus then
		if "moved" == phase then
			-- Set the move direction		
			if not view._moveDirection then
		        local dx = math.abs( event.x - event.xStart )
	            local dy = math.abs( event.y - event.yStart )
	            local moveThresh = 12
				
	            if dx > moveThresh or dy > moveThresh then
	                if dx > dy then
	                    view._moveDirection = "horizontal"
	                else
	                    view._moveDirection = "vertical"
	                end
				end
			end
			
			-- Horizontal movement
			if "horizontal" == view._moveDirection then
				-- If horizontal scrolling is enabled
				if not view._isHorizontalScrollingDisabled then					
					view._delta = event.x - view._prevXPos
					view._prevXPos = event.x
				
					-- Limit movement
					local leftLimit = nil
					local rightLimit = 0
					
					-- Set the left limit
					if view._scrollWidth then
						leftLimit = -view._scrollWidth
					else
						leftLimit = view._background.x - ( view.contentWidth ) + ( view._background.contentWidth * 0.5 )
					end
		
					-- If the view is more than the limits
					if view.x < leftLimit or view.x > rightLimit then
						view.x = view.x + ( view._delta * 0.5 )
					else
						view.x = view.x + view._delta
					end
				end
				
			-- Vertical movement
			else
				-- If vertical scrolling is enabled
				if not view._isVerticalScrollingDisabled then
					view._delta = event.y - view._prevYPos
					view._prevYPos = event.y
							
					-- Limit movement
					local upperLimit = nil
					local bottomLimit = view._topPadding

					-- Set the upper limit
					if view._scrollHeight then
						upperLimit = ( -view._scrollHeight + view._height ) - view._bottomPadding
					else
						upperLimit = view._background.y - ( view.contentHeight ) + ( view._background.contentHeight * 0.5 ) - view._bottomPadding
					end
					
					-- If the view is more than the limits
					if view.y < upperLimit or view.y > bottomLimit then
						view.y = view.y + ( view._delta * 0.5 )
					else
						view.y = view.y + view._delta  
					end
					
					-- Set the time held
					view._timeHeld = time
				
					-- Move the scrollBar
					if view._scrollBar then						
						view._scrollBar:move()
					end
				end
			end
			
		elseif "ended" == phase or "cancelled" == phase then
			-- Reset values				
			view._lastTime = event.time
			view._trackVelocity = false
			view._updateRuntime = true
			view._timeHeld = 0
						
			-- Remove focus								
			display.getCurrentStage():setFocus( nil )
			view._isFocus = nil
		end
	end
end


-- Handle runtime momentum scrolling events.
function M._runtime( view, event )
	-- If we are tracking runtime
	if view._updateRuntime then
		local timePassed = event.time - view._lastTime
		view._lastTime = view._lastTime + timePassed
		
		-- Stop scrolling if velocity is near zero
		if math.abs( view._velocity ) < 0.01 then
			view._velocity = 0
			view._updateRuntime = false
			
			-- Hide the scrollBar
			if view._scrollBar then
				view._scrollBar:hide()
			end
						
			-- Dispatch a event.direction event
			if view._listener then
				local newEvent = 
				{
					direction = "right",
					target = view,
				}
			
				view._listener( newEvent )
			end
		end
		
		-- Set the velocity
		view._velocity = view._velocity * view._friction
		
		-- Throttle the velocity if it goes over the max range
		if view._velocity < -view._maxVelocity then
			view._velocity = -view._maxVelocity
		elseif view._velocity > view._maxVelocity then
			view._velocity = view._maxVelocity
		end
	
		-- Horizontal movement
		if "horizontal" == view._moveDirection then
			-- If horizontal scrolling is enabled
			if not view._isHorizontalScrollingDisabled then
				-- Reset limit values
				view._hasHitLeftLimit = false
				view._hasHitRightLimit = false
				
				-- Move the view
				view.x = view.x + view._velocity * timePassed
			
				local leftLimit = nil
				local rightLimit = view._leftPadding
				
				-- Set the left limit
				if view._scrollWidth then
					leftLimit = -view._scrollWidth
				else
					leftLimit = view._background.x - ( view.contentWidth ) + ( view._background.contentWidth * 0.5 ) - view._rightPadding
				end
			
				-- Left
				if view.x < leftLimit then
					-- Transition the view back to it's maximum position
					transition.to( view, { time = 400, x = leftLimit, transition = easing.outQuad } )
					view._updateRuntime = false
					
					-- If there is a listener specified, dispatch the event
					if view._listener then
						-- We have hit the left limit
						view._hasHitLeftLimit = true
						
						local newEvent = 
						{
							direction = "left",
							limitReached = true,
							target = view,
						}
						
						view._listener( newEvent )
					end
			
				-- Right
				elseif view.x > rightLimit then
					-- Transition the view back to it's maximum position
					transition.to( view, { time = 400, x = rightLimit, transition = easing.outQuad } )
					-- Stop updating the runtime now
					view._updateRuntime = false
					
					-- If there is a listener specified, dispatch the event
					if view._listener then
						-- We have hit the right limit
						view._hasHitRightLimit = true
						
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
		else
			-- If vertical scrolling is enabled
			if not view._isVerticalScrollingDisabled then
				-- Reset limit values
				view._hasHitBottomLimit = false
				view._hasHitTopLimit = false
				
				-- Move the view
				view.y = view.y + view._velocity * timePassed
	
				local upperLimit = nil
				local bottomLimit = view._topPadding
				
				-- Set the upper limit
				if view._scrollHeight then
					upperLimit = ( -view._scrollHeight + view._height ) - view._bottomPadding
				else
					upperLimit = view._background.y - ( view.contentHeight ) + ( view._background.contentHeight * 0.5 ) - view._bottomPadding
				end
	
				-- Top
				if view.y <= upperLimit then					
					-- Transition the view back to it's maximum position
					transition.to( view, { time = 400, y = upperLimit, transition = easing.outQuad } )
					
					-- Hide the scrollBar
					if view._scrollBar then
						view._scrollBar:hide()
					end
					
					-- We have hit the top limit
					view._hasHitTopLimit = true
										
					-- Stop updating the runtime now
					view._updateRuntime = false
					
					-- If there is a listener specified, dispatch the event
					if view._listener then
						local newEvent = 
						{
							direction = "up",
							limitReached = true,
							target = view,
						}
						
						view._listener( newEvent )
					end
							
				-- Bottom
				elseif view.y >= bottomLimit then
					-- Transition the view back to it's maximum position
					transition.to( view, { time = 400, y = bottomLimit, transition = easing.outQuad } )
					
					-- Hide the scrollBar
					if view._scrollBar then
						view._scrollBar:hide()
					end
					
					-- We have hit the bottom limit
					view._hasHitBottomLimit = true
					
					-- Stop updating the runtime now
					view._updateRuntime = false
					
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
				else
					-- Move the scrollBar
					if view._scrollBar then						
						view._scrollBar:move()
					end
				end
			end
		end
	end
	
	-- If we are tracking velocity
	if view._trackVelocity then
		-- Calculate the time passed
		local newTimePassed = event.time - view._prevTime
		view._prevTime = view._prevTime + newTimePassed
		
		-- Horizontal movement
		if "horizontal" == view._moveDirection then
			-- If horizontal scrolling is enabled
			if not view._isHorizontalScrollingDisabled then
				local possibleVelocity = ( view.x - view._prevX ) / newTimePassed

                if possibleVelocity ~= 0 then
                    view._velocity = possibleVelocity
                end
		
				view._prevX = view.x
			end
		
		-- Vertical movement
		else
			-- If vertical scrolling is enabled
			if not view._isVerticalScrollingDisabled then
				if view._prevY then
					local possibleVelocity = ( view.y - view._prevY ) / newTimePassed

                    if possibleVelocity ~= 0 then
                        view._velocity = possibleVelocity
                    end
				end
		
				view._prevY = view.y
			end
		end
	end
end


-- Function to create a scrollBar
function M.createScrollBar( view, options )
	-- Set up the scrollBar color. - TODO: (change to use 3 slice image)
	local scrollBarColor = { r = 0, g = 0, b = 0, a = 120 }
	
	-- If the user has passed in a color
	if options.color then
		scrollBarColor = 
		{
			r = options.color[1] or 0,
			g = options.color[2] or 0,
			b = options.color[3] or 0,
			a = options.color[4] or 120,
		}
	end
	
	-- Setup the scrollBar's width/height
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
	
	-- Create the scrollBar. - TODO: (change to use 3 slice image)
	local scrollBar = display.newRoundedRect( display.contentWidth - 8, 0, scrollBarWidth, scrollBarHeight, 2 ) 
	scrollBar:setReferencePoint( display.CenterReferencePoint )
	scrollBar.y = ( scrollBar.contentHeight * 0.5 ) + view._top
	scrollBar._viewHeight = viewHeight
	scrollBar._viewContentHeight = viewContentHeight
	scrollBar:setFillColor( unpack( scrollBarColor ) )
	scrollBar.alpha = 0 -- The scrollBar is invisible initally
	scrollBar._tween = nil
	
	-- Function to reset the scrollBar position
	function scrollBar:resetInitialPosition()
		if self.y - self.contentHeight * 0.5 < view._top  then
			self.y = view._top + self.contentHeight * 0.5
		end
	end
	
	-- Function to move the scrollBar
	function scrollBar:move()
		local moveFactor = ( view.y * 100 ) / ( self._viewContentHeight - self._viewHeight )
		local moveQuantity = ( moveFactor * self._viewHeight ) / 100
		
		if view.y < 0 then
			-- Move the scrollBar
			if view._delta < 0 then
				self.y = view._top + ( self.contentHeight * 0.5 ) - moveQuantity 
			elseif view._delta > 0 then
				self.y = view._top - ( self.contentHeight * 0.5 ) - moveQuantity
			end 
			
			-- Limit movement
			if self.y - self.contentHeight * 0.5 < view._top  then
				self.y = view._top + self.contentHeight * 0.5
			end
			
			if self.y + self.contentHeight * 0.5 > view._top + self._viewHeight then
				self.y = view._top + self._viewHeight - self.contentHeight * 0.5
			end
		end
	end
	
	-- Function to show the scrollBar
	function scrollBar:show()
		-- Cancel any previous transition
		if self._tween then
			transition.cancel( self._tween ) 
			self._tween = nil
		end
		
		-- Set the alpha of the bar back to 1
		self.alpha = 1
	end
	
	-- Function to hide the scrollBar
	function scrollBar:hide()
		-- If there already isn't a tween in progress
		if not self._tween then
			self._tween = transition.to( self, { time = 400, alpha = 0, transition = easing.outQuad } )
		end
	end
	
	return scrollBar
end

return M
