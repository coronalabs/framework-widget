local M = {}

-- Handle momentum scrolling touch
function M._touch( view, event )
	local phase = event.phase
	local time = event.time
			
	if "began" == phase then		
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
					
					if view._scrollWidth then
						leftLimit = -view._scrollWidth
					else
						leftLimit = view._background.x - ( view.contentWidth ) + ( view._background.contentWidth * 0.5 )
					end
						
					local rightLimit = 0
				
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

					if view._scrollHeight then
						upperLimit = -view._scrollHeight
					else
						upperLimit = view._background.y - ( view.contentHeight ) + ( view._background.contentHeight * 0.5 ) - view._bottomPadding
					end
					
					local bottomLimit = view._topPadding
			
					if view.y < upperLimit or view.y > bottomLimit then
						view.y = view.y + ( view._delta * 0.5 )
					else
						view.y = view.y + view._delta  
					end
					
					view._timeHeld = time
				
					-- Move the scrollBar
				end
			end
			
		elseif "ended" == phase or "cancelled" == phase then				
			view._lastTime = event.time
			view._trackVelocity = false
			view._updateRuntime = true
			view._timeHeld = 0
														
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
				view.x = view.x + view._velocity * timePassed
			
				local leftLimit = nil
				
				if view._scrollWidth then
					leftLimit = -view._scrollWidth
				else
					leftLimit = view._background.x - ( view.contentWidth ) + ( view._background.contentWidth * 0.5 ) - view._rightPadding
				end
				
				local rightLimit = view._leftPadding
			
				-- Left
				if view.x < leftLimit then
					transition.to( view, { time = 400, x = leftLimit, transition = easing.outQuad } )
					view._updateRuntime = false
			
				-- Right
				elseif view.x > rightLimit then
					transition.to( view, { time = 400, x = rightLimit, transition = easing.outQuad } )
					view._updateRuntime = false
				end
			end	
			
		-- Vertical movement		
		else
			-- If vertical scrolling is enabled
			if not view._isVerticalScrollingDisabled then
				view.y = view.y + view._velocity * timePassed
	
				local upperLimit = nil
				
				if view._scrollHeight then
					upperLimit = -view._scrollHeight
				else
					upperLimit = view._background.y - ( view.contentHeight ) + ( view._background.contentHeight * 0.5 ) - view._bottomPadding
				end
	
				local bottomLimit = view._topPadding
	
				-- Top
				if view.y < upperLimit then
					transition.to( view, { time = 400, y = upperLimit, transition = easing.outQuad } )
					view._updateRuntime = false
							
				-- Bottom
				elseif view.y > bottomLimit then
					transition.to( view, { time = 400, y = bottomLimit, transition = easing.outQuad } )
					view._updateRuntime = false
				else
					-- Move the scrollBar
				end
			end
		end
	end
	
	-- If we are tracking velocity
	if view._trackVelocity then
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

return M
