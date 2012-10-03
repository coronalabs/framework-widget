--[[
	File: widget_constructor.lua
	What is it?: All widgets are constructed from this class.
	
	Copyright (C) 2012 Corona Inc. All Rights Reserved.
--]]

local M = {}

function M.new( options )
	local options = options or {}
	
	local widgetObject = display.newGroup() -- All Widget* objects are display groups
	widgetObject.x = options.left or 0
	widgetObject.y = options.top or 0
	widgetObject.id = options.id or "widget*"
	widgetObject.baseDirectory = options.baseDirectory or system.ResourceDirectory
	
	-- Private properties
	--widgetObject._previousEventType = nil
	--widgetObject._currentTween = nil
	
	-- Common Methods
	
	--[[
	-- Dispatch a widget event
	function widgetObject:dispatchWidgetEvent( event )
		if type( event ) ~= "table" then
			error( "Widget*:dispatchEvent - Table expected, got" .. type( event ) )
		end
		
		-- Only dispatch the event if we haven't just dispatched it
		if self._previousEventType ~= event.type then
			self:dispatchEvent( event )
		end
		
		-- Set the previous event
		self._previousEventType = event.type
	end
	
	
	-- Tweening
	function widgetObject:tween( arg1, arg2 )
		local targetObject = self
		local tweenOptions = nil
				
		-- If the first argument is a table and has a contentWidth property then it is a display object otherwise it isn't
		if type( arg1 ) == "table" and arg1.contentWidth then
			targetObject = arg1
			tweenOptions = arg2
		else
			tweenOptions = arg1
		end
		
		-- Tween Properties
		local time = tweenOptions.time or 400
		local x = tweenOptions.x or targetObject.x
		local y = tweenOptions.y or targetObject.y
		local alpha = tweenOptions.alpha or targetObject.alpha
		local xScale = tweenOptions.xScale or targetObject.xScale
		local yScale = tweenOptions.yScale or targetObject.yScale
		local maskX = tweenOptions.maskX or nil
		local maskY = tweenOptions.maskY or nil
		local transitionType = tweenOptions.transition or easing.outQuad
		
		-- If there is an active tween cancel it
		if targetObject._currentTween then
			transition.cancel( targetObject._currentTween )
			targetObject._currentTween = nil
		end
		
		-- Tween the object
		targetObject._currentTween = transition.to( targetObject, 
			{ time = time, x = x, y = y, alpha = alpha, 
				xScale = xScale, yScale = yScale,
				--maskX = maskX, maskY = maskY,
				transition = transitionType
			}
		)
	end
	--]]
	
	return widgetObject
end

return M;
