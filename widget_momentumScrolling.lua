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
	                if dx > moveThresh then
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
						upperLimit = -view._scrollHeight
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
						view._scrollBar.y = math.abs( view.y ) * view._scrollBar.yRatio + view._scrollBar.height * 0.5 + view._top
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
					upperLimit = -view._scrollHeight
				else
					upperLimit = view._background.y - ( view.contentHeight ) + ( view._background.contentHeight * 0.5 ) - view._bottomPadding
				end
	
				-- Top
				if view.y < upperLimit then
					-- Transition the view back to it's maximum position
					transition.to( view, { time = 400, y = upperLimit, transition = easing.outQuad } )
					
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
				elseif view.y > bottomLimit then
					-- Transition the view back to it's maximum position
					transition.to( view, { time = 400, y = bottomLimit, transition = easing.outQuad } )
					
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
						view._scrollBar.y = math.abs( view.y ) * view._scrollBar.yRatio + view._scrollBar.height * 0.5 + view._top
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
				if view._prevX then
					view._velocity = ( view.x - view._prevX ) / newTimePassed
				end
		
				view._prevX = view.x
			end
		
		-- Vertical movement
		else
			-- If vertical scrolling is enabled
			if not view._isVerticalScrollingDisabled then
				if view._prevY then
					view._velocity = ( view.y - view._prevY ) / newTimePassed
				end
		
				view._prevY = view.y
			end
		end
	end
end


-- Function to create a scrollBar
function M.createScrollBar( view, options )
	-- Set up the scrollBar color. - TODO: (change to use 3 slice image)
	local scrollBarColor = 
	{
		r = options.r or 0,
		g = options.g or 0,
		b = options.b or 0,
		a = options.a or 120,
	}
	
	-- Setup the scrollBar's width/height
	local scrollBarWidth = options.width or 5
	local viewRatio = 0
	
	if view._scrollHeight then
		viewRatio = view._scrollHeight - view.parent.contentHeight
	else
		viewRatio = view.contentHeight
	end
	
	local barSize = 80
	local scrollBarHeight = barSize * viewRatio
		
	-- Create the scrollBar. - TODO: (change to use 3 slice image)
	local scrollBar = display.newRoundedRect( display.contentWidth - 8, 0, scrollBarWidth, scrollBarHeight, 2 ) 
	scrollBar.y = ( scrollBar.contentHeight * 0.5 ) + view._top
	scrollBar:setFillColor( unpack( scrollBarColor ) )
	scrollBar.yRatio = viewRatio
	
	return scrollBar
end

return M
