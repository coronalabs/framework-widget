--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_stepper.lua
		
	What is it?: 
		A widget object that can...
	
	Features:

--]]

local M = 
{
	_options = {},
}


-- Creates a new stepper from a sprite
local function initWithSprite( stepper, options )
	-- Create a local reference to our options table	
	local opt = options
	
	-- Animation options
	local sheetOptions = 
	{ 
		{
			name = "default", 
			start = opt.defaultFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "noMinus",
			start = opt.noMinusFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "noPlus",
			start = opt.noPlusFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "minusActive",
			start = opt.minusActiveFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "plusActive",
			start = opt.plusActiveFrame,
			count = 1,
			time = 1,
		},
		
	}
	
	-- Forward references
	local imageSheet, view
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
	
	-- Create the view
	view = display.newSprite( imageSheet, sheetOptions )
	view:setSequence( "default" )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Assign to the view
	view._timerIncrementSpeed = 1000
	view._changeIncrementSpeedAtTime = view._timerIncrementSpeed
	view._increments = 0
	view._changeSpeedAtIncrement = 5
	view._timer = nil
	view._minimumValue = opt.minimumValue
	view._maximumValue = opt.maximumValue
	view._currentNumber = opt.startNumber
	view._event = {} -- Our event table for the view
	view._previousX = 0
	view._onPress = opt.onPress
	
	-- If the startNumber is equal to/greater than the minimum or maxium values, set the steppers image sequence to reflect it
	if view._currentNumber <= 0 then
		view:setSequence( "noMinus" )
	elseif view._currentNumber >= view._maximumValue then
		view._currentNumber = view._maximumValue
		view:setSequence( "noPlus" )
	end
	
	-------------------------------------------------------
	-- Assign properties/objects to the switch
	-------------------------------------------------------
	
	-- Assign objects to the stepper
	stepper._imageSheet = imageSheet
	stepper._view = view
	
	-- Insert the view into the stepper (group)
	stepper:insert( view )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
		
	-- Handle touch events on the stepper
	function view:touch( event )
		local phase = event.phase
		local _stepper = self.parent
		event.target = stepper
		
		if "began" == phase then
			-- Set focus on the stepper (if focus isn't already on it)
			if not self._isFocus then
				display.getCurrentStage():setFocus( self, event.id )
       			self._isFocus = true
       		end
        
			-- If we have pressed the right side of the stepper (the plus)
			if event.x > _stepper.x then
				self:_dispatchIncrement()
			else
				-- We have pressed the left side of the stepper (the minus)
				self:_dispatchDecrement()
			end
			
			-- Set the previous x position of the event
			self._previousX = event.x
			
			-- Manage the steppers pressed state ( & animation )
			self:_manageStepperPressState()
			
			-- Exectute the onPress method if there is one
			if self._onPress then
				self._onPress( self._event )
			end
		
		elseif self._isFocus then
			if "moved" == phase then
				-- Handle switching from one side of the switch whilst still holding your finger on the screen
				if event.x >= _stepper.x then
					if self._event.phase ~= "increment" then
						self:dispatchEvent( { name = "touch", phase = "began", x = 160 } )
					end
				else
            		-- Dispatch a touch event to self
            		if self._event.phase ~= "decrement" then
						self:dispatchEvent( { name = "touch", phase = "began", x = 60 } )
					end
				end
		
			elseif "ended" == phase or "cancelled" == phase then
				-- Manage the steppers released state
				view:_manageStepperReleaseState()
				
				-- Remove focus from stepper
            	display.getCurrentStage():setFocus( self, nil )
            	self._isFocus = false
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------

	-- Function to dispatch a increment event for the stepper
	function view:_dispatchIncrement()
		local phase = nil
		
		-- If the currentNumber is less then the maxiumum value then set the phase to "increment"
		if self._currentNumber < self._maximumValue then
			phase = "increment"
			self._currentNumber = self._currentNumber + 1
		else
			-- The currentNumber is more then the maxiumum value, set the phase to "maxLimit"
			phase = "maxLimit"
		end
		
		-- Set the new event phase
		self._event.phase = phase
	end
	
	-- Function to dispatch a decrement event for the stepper
	function view:_dispatchDecrement()
		local phase = nil
		
		-- If the currentNumber is more then the minimum value then set the phase to "decrement"
		if self._currentNumber > self._minimumValue then
			phase = "decrement"
			self._currentNumber = self._currentNumber - 1
		else
			-- The currentNumber is less then the minimum value, set the phase to "minLimit"
			phase = "minLimit"
		end
		
		-- Set the new event phase
		self._event.phase = phase
	end
		
	-- Function to manage the steppers pressed/held touch state
	function view:_manageStepperPressState()
		local phase = self._event.phase
		
		-- Start the steppers timer		
		if not self._timer then
			self._timer = timer.performWithDelay( self._changeIncrementSpeedAtTime, self, 0 )
		end
		
		-- Set the steppers sequence according to the phase
		if "increment" == phase then
			self:setSequence( "plusActive" )
		elseif "decrement" == phase then
			self:setSequence( "minusActive" )
		elseif "maxLimit" == phase then
			self:setSequence( "noPlus" )
		elseif "minLimit" == phase then
			self:setSequence( "noMinus" )
		end
	end
	
	-- Function to manage the stepper's released touch state (released ie not being touched)
	function view:_manageStepperReleaseState()
		-- Set the steppers default sequence
		if self._currentNumber > self._minimumValue and self._currentNumber < self._maximumValue then
			self:setSequence( "default" )
		end
		
		-- Change the steppers sequence according to if it reaches it's max or min range
		if self._currentNumber >= self._maximumValue then
			self:setSequence( "noPlus" )
		elseif self._currentNumber <= self._minimumValue then
			self:setSequence( "noMinus" )
		end
		
		-- Cancel the timer and reset the changeTime
		if self._timer then
			self:_cancelTimer()
			self._changeIncrementSpeedAtTime = self._timerIncrementSpeed
		end
	end
	
	-- Function to increment/decrement the steppers values while touch on the stepper is held/active - Speed of the increment/decrement ramps up linearly
	function view:timer()
		-- Increase the increments
		self._increments = self._increments + 1
		
		-- If the current increment is more or equal to the requested change value
		if self._increments >= self._changeSpeedAtIncrement then
			-- Cancel any active timer
			self:_cancelTimer()
			
			-- Half the Increment speed
			self._changeIncrementSpeedAtTime = self._changeIncrementSpeedAtTime * 0.5
			
			-- Re-start the timer at the new incremental value
			if not self._timer then
				self._timer = timer.performWithDelay( self._changeIncrementSpeedAtTime, self, 0 )
			end
			
			-- Reset the increments back to 0
			self._increments = 0
		end
		
		-- Dispatch a touch event to self
		self:dispatchEvent( { name = "touch", phase = "began", x = self._previousX } )
	end
	
	-- Function to cancel the stepper's timer
	function view:_cancelTimer()
		if self._timer then
			timer.cancel( self._timer )
			self._timer = nil
		end
	end
	
	-- Finalize function
	function stepper:_finalize()
		-- Set steppers ImageSheet to nil
		self._imageSheet = nil
		
		-- Nil out the stepper's event table
		self._view._event = nil
		
		-- Cancel the timer
		self._view:_cancelTimer()
	end
	
	return self
end


-- Function to create a new Stepper object ( widget.newStepper)
function M.new( options, theme )	
	local customOptions = options or {}
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support the stepper widget." )
	end
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------	

	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.width = customOptions.width or theme.width
	opt.height = customOptions.height or theme.height
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.defaultFrame = customOptions.defaultFrame or require( theme.data ):getFrameIndex( theme.defaultFrame )
	opt.noMinusFrame = customOptions.noMinusFrame or require( theme.data ):getFrameIndex( theme.noMinusFrame )
	opt.noPlusFrame = customOptions.noPlusFrame or require( theme.data ):getFrameIndex( theme.noPlusFrame )
	opt.minusActiveFrame = customOptions.minusActiveFrame or require( theme.data ):getFrameIndex( theme.minusActiveFrame )
	opt.plusActiveFrame = customOptions.plusActiveFrame or require( theme.data ):getFrameIndex( theme.plusActiveFrame )

	opt.startNumber = customOptions.startNumber or 0
	opt.minimumValue = customOptions.minimumValue or 0
	opt.maximumValue = customOptions.maximumValue or math.huge
	opt.onPress = customOptions.onPress
	opt.onHold = customOptions.onHold

	-------------------------------------------------------
	-- Create the Stepper
	-------------------------------------------------------
		
	-- Create the stepper object
	local stepper = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_stepper",
		baseDir = opt.baseDir,
	}

	-- Create the stepper
	initWithSprite( stepper, opt )
	
	return stepper
end

return M
