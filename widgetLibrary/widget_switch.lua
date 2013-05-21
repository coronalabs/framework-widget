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
	_widgetName = "widget.newSwitch",
	_directoryPath = "widgetLibrary.",
}

-- Require needed widget files
local _widget = nil

-- Function to require the widget file from the widget directory path (if it exists)
local function checkFileAtPath()
    _widget = require( M._directoryPath .. "widget" )
end

-- If we failed to find the widget file in the widget directory path.
if false == pcall( checkFileAtPath ) then
	_widget = require( "widget" )
end

-- Localize math functions
local mAbs = math.abs
local mRound = math.round


-- Initialize a switch with images
local function initWithImage( switch, options )
	-- Create a local reference to our options table
	local opt = options

	-- Forward references
	local imageSheet, viewOff, viewOn
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	viewOff = display.newImageRect( imageSheet, opt.frameOff, opt.width, opt.height )
	viewOff.x = switch.x + ( viewOff.contentWidth * 0.5 )
	viewOff.y = switch.y + ( viewOff.contentHeight * 0.5 )
	
	viewOn = display.newImageRect( imageSheet, opt.frameOn, opt.width, opt.height )
	viewOn.x = switch.x + ( viewOn.contentWidth * 0.5 )
	viewOn.y = switch.y + ( viewOn.contentHeight * 0.5 )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Set the view's on/off states initial visibility based on the default state
	viewOff.isVisible = not opt.initialSwitchState
	viewOn.isVisible = opt.initialSwitchState
	
	-------------------------------------------------------
	-- Assign properties/objects to the switch
	-------------------------------------------------------
	
	-- Assign properties to switch
	switch.isOn = opt.initialSwitchState
	
	-- Assign objects to the switch
	switch._imageSheet = imageSheet
	switch._viewOn = viewOn
	switch._viewOff = viewOff
	
	-- Insert the on/off view's into the switch (group)
	switch:insert( viewOn )
	switch:insert( viewOff )
	
	return switch
end

-- Initialize a switch with a sprite
local function initWithSprite( switch, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view
	
	-- Create the sequenceData table
	local switchSheetOptions = 
	{ 
		{
			name = "on",
			start = opt.frameOn,
			count = 1,
			time = 1,
		},
		
		{
			name = "off",
			start = opt.frameOff,
			count = 1,
			time = 1,
		},
	}
	
	-- Create the image sheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	view = display.newSprite( imageSheet, switchSheetOptions )
	view._animStates =
	{
		[1] = "on",
		[2] = "off",
	}
	view:setSequence( view._animStates[tonumber( opt.initialSwitchState )] )
	view.x = switch.x + ( view.contentWidth * 0.5 )
	view.y = switch.y + ( view.contentHeight * 0.5 )
	
	-------------------------------------------------------
	-- Assign properties/objects to the switch
	-------------------------------------------------------
	
	-- Assign properties to switch
	switch.isOn = opt.initialSwitchState
	
	-- Assign objects to the switch
	switch._view = view
		
	-- Insert the view into the switch (group)
	switch:insert( view )
	
	return switch
end



-- Create a on/off toggle switch
local function createOnOffSwitch( switch, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- This is measured from the pixels in the switch overlay image.
	local startRange = - mRound( opt.onOffOverlayWidth / 3.06 )
	local endRange = mAbs( startRange )
		
	-- Forward references
	local imageSheet, view, viewOverlay, viewHandle, viewMask
	
	-- Frame references
	local onFrame, offFrame, backgroundFrame, overlayFrame
	
	-- Setup which frames to use for the on/off images
	if opt.themeData then
		local themeData = require( opt.themeData )
		offFrame = themeData:getFrameIndex( opt.onOffHandleDefaultFrame )
		onFrame = themeData:getFrameIndex( opt.onOffHandleOverFrame )
		backgroundFrame = themeData:getFrameIndex( opt.onOffBackgroundFrame )
		overlayFrame = themeData:getFrameIndex( opt.onOffOverlayFrame )
	else
		offFrame = opt.onOffHandleDefaultFrame
		onFrame = opt.onOffHandleOverFrame
		backgroundFrame = opt.onOffBackgroundFrame
		overlayFrame = opt.onOffOverlayFrame
	end
	
	
	-- Image sheet options for the on/off switch's handle sprite
	local handleSheetOptions = 
	{
		{ 
			name = "off", 
			start = offFrame, 
			count = 1, 
			time = 1,
		},
		
		{ 
			name = "on", 
			start = onFrame, 
			count = 1, 
			time = 1, 
		},
	}
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- The view is the switches background image
	view = display.newImageRect( switch, imageSheet, backgroundFrame, opt.onOffBackgroundWidth, opt.onOffBackgroundHeight )
	
	-- The view's overlay is the "shine" effect
	viewOverlay = display.newImageRect( switch, imageSheet, overlayFrame, opt.onOffOverlayWidth, opt.onOffOverlayHeight )
	
	-- The view's handle
	viewHandle = display.newSprite( switch, imageSheet, handleSheetOptions )
	viewHandle:setSequence( "off" )
	
	-- The view's mask
	viewMask = graphics.newMask( opt.onOffMask, opt.baseDir )
	view:setMask( viewMask )

	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
		
	-- Properties
	view._transition = nil
	view._handleTransition = nil
	view._startRange = startRange
	view._endRange = endRange
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	
	-- Objects
	view._overlay = viewOverlay
	view._handle = viewHandle
	view._mask = viewMask
	
	-------------------------------------------------------
	-- Assign properties/objects to the switch
	-------------------------------------------------------
	
	-- Assign properties to the switch	
	switch.isOn = opt.initialSwitchState
	
	-- Set the switch position based on the chosen default value (ie on/off)
	if switch.isOn then
		view.x = view._endRange
		view._handle.x = view._endRange
		view.maskX = view._handle.x - mAbs( view._startRange ) - view._endRange
	else
		view.x = view._startRange
		view._handle.x = view._startRange
		view.maskX = view._handle.x + mAbs( view._startRange ) + view._endRange
	end
	
	-- Assign objects to the switch
	switch._imageSheet = imageSheet
	switch._view = view

	switch.x = switch.x + ( view.contentWidth * 0.5 )
	switch.y = switch.y + ( view.contentHeight * 0.5 )

	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the switches state (on/off) programatically
	function switch:setState( options )
		return self._view:_setState( options )
	end

	-- Handle taps on the switch
	function view:tap( event )
		local _switch = self.parent -- self.parent == switch
		-- Set the target to the switch
		event.target = _switch
				
		-- Toggle the switch
		_switch.isOn = not _switch.isOn
			
		-- Cancel current view transition if there is one
		if self._transition then
			transition.cancel( self._transition )
			self._transition = nil
		end
		
		if self._handleTransition then
			transition.cancel( self._handleTransition )
			self._handleTransition = nil
		end
						
		-- If self has a _onPress method execute it
		local function executeOnPress()
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
		end
				
		-- Set the switches transition time
		local switchTransitionTime = 200
		
		-- Transition the switch from on>off and vice versa
		if _switch.isOn then
			self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnPress } )
			self._handleTransition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
		else
			self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnPress } )
			self._handleTransition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
		end
		
		return true
	end
	
	view:addEventListener( "tap" )
	
	-- Handle touch/drag events on the switch
	function view:touch( event )
		local phase = event.phase
	
		if "began" == phase then
			-- Cancel current view transition if there is one
			if self._transition then
				transition.cancel( self._transition )
				self._transition = nil
			end
			
			if self._handleTransition then
				transition.cancel( self._handleTransition )
				self._handleTransition = nil
			end
					
			-- Set focus
			display.getCurrentStage():setFocus( self ) 
			self._isFocus = true
			
			-- Store initial position of the handle
			self._handle.x0 = event.x - self._handle.x 
			-- Set the handle to it's 'over' frame
			self._handle:setSequence( "on" )
	
		elseif self._isFocus then
			if "moved" == phase then
				self._handle.x = event.x - self._handle.x0 
				self.x = event.x - self._handle.x0
				self.maskX = - ( event.x - self._handle.x0 )
		
				-- limit movement to switch, left side
				if self._handle.x <= self._startRange then
					self._handle.x = self._startRange
					self.x = self._startRange
					self.maskX = self._endRange
				end
					
				--limit movement to switch, right side
				if self._handle.x >= self._endRange then
					self._handle.x = self._endRange
					self.x = self._endRange 
					self.maskX = self._startRange
				end
	
			elseif "ended" == phase or "cancelled" == phase then
				local _switch = self.parent
				-- Set the target to the switch
				event.target = _switch
				
				-- If self has a _onRelease method execute it
				local function executeOnRelease()
					if self._onRelease and not self._onEvent then
						self._onRelease( event )
					end
				end
				
				-- Set the switches transition time
				local switchTransitionTime = 200
				
				-- Transition the switch from on>off and vice versa
				if self._handle.x < 0 then
					_switch.isOn = false
					self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnRelease } )
					self._handleTransition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
				else
					_switch.isOn = true
					self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnRelease } )
					self._handleTransition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
				end
				
				-- Set the handle back to it's default frame
				self._handle:setSequence( "off" )
				
				-- Remove focus
				display.getCurrentStage():setFocus( nil )
				self._isFocus = false
			end
		end
		
		-- If self has a _onEvent method execute it
		if self._onEvent then
			self._onEvent( event )
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set a switch on/off programatically
	function view:_setState( options )
		local _switch = self.parent
		local _isSwitchOn = options.isOn
		local _isAnimated = options.isAnimated
		local _listener = options.onComplete
		
		-- If the user hasn't passed the isOn property, throw an error
		if _isSwitchOn == nil then
			error( "ERROR: " .. M._widgetName .. ": setState - isOn (true/false) expected, got nil", 3 )
		end
		
		-- If there is a onComplete method
		local function executeOnComplete()
			-- Set the switch isOn property
			_switch.isOn = _isSwitchOn
			
			-- Create the event
			local event = 
			{
				target = _switch,
				phase = "ended",
			}
				
			-- Execute the user listener
			if _listener then
				_listener( event )
			end
		end
		
		-- Set the switches transition time
		local switchTransitionTime = 200
		
		-- Set the switch to on/off visually
		if _isSwitchOn then
			if _isAnimated then
				self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnComplete } )
				self._handleTransition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
			else
				self.x = self._endRange
				self._handle.x = self._endRange
				self.maskX = self._startRange
				
				-- Execute the onComplete listener
				executeOnComplete()
			end
		else
			if _isAnimated then
				self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnComplete } )
				self._handleTransition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
			else
				self.x = self._startRange
				self._handle.x = self._startRange
				self.maskX = self._endRange
				
				-- Execute the onComplete listener
				executeOnComplete()
			end
		end
	end
	
	-- Finalize method for standard switch
	function switch:_finalize()
		-- Cancel current view transition if there is one
		if self._view._transition then
			transition.cancel( self._view._transition )
			self._view._transition = nil
		end
		
		if self._view._handleTransition then
			transition.cancel( self._view._handleTransition )
			self._view._handleTransition = nil
		end
		
		-- Remove the switch's mask
		self._view:setMask( nil )
				
		-- Set objects to nil
		self._view._overlay = nil
		self._view._handle = nil
		self._view._mask = nil
		self._view = nil
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end

	return switch
end


-- Initialize with a standard switch (ie radio/checkbox buttons)
local function createStandardSwitch( switch, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Are we using a sprite (assume false)
	local usingSprite = false
	
	-- Forward references
	local view
	
	-- If there is a default frame & a selected frame then init with sprite
	if opt.defaultFrame and opt.selectedFrame then
		view = initWithSprite( switch, opt )
		usingSprite = true
	else
		-- There isn't so init with image
		view = initWithImage( switch, opt )
	end
	
	-- Create local reference to the view
	local view = switch._view or switch._viewOn
	view.isHitTestable = true
	view.x = switch.x + ( view.contentWidth * 0.5 )
	view.y = switch.y + ( view.contentHeight * 0.5 )
	view._switchType = opt.switchType
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------

	-- Assign properties/methods to the view.
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-- Assign objects to the switch
	switch._imageSheet = imageSheet
	switch._view = view

	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the switches state (on/off) programatically
	function switch:setState( options )
		return self._view:_setState( options )
	end

	-- Handle touches on the switch
	function view:touch( event )
		local phase = event.phase
		local _switch = self.parent -- self.parent == switch
		-- Set the target to the switch
		event.target = _switch
		
		if "began" == phase then
			-- Toggle the switch on/off
			_switch.isOn = not _switch.isOn
			
			-- If this is a radio button
			if "radio" == self._switchType then
				-- Loop through all objects contained in the switches parent group
				for i = 1, _switch.parent.numChildren do
					local child = _switch.parent[i]
					
					-- Turn off all radio buttons in this group
					if "table" == type( child._view ) then
						if "string" == type( child._view._switchType ) then
							if "radio" == child._view._switchType then
								child._view:_setState( { isOn = false } )
							end
						end
					end
				end
				
				-- Set the pressed/selected radio switch to on
				self:_setState( { isOn = true } )
			end
				
			-- Toggle the displayed sprite sequence
			if usingSprite then
				if _switch.isOn then
					self:setSequence( "on" )
				else
					self:setSequence( "off" )
				end
			else
				-- Toggle the view's visibility
				switch._viewOn.isVisible = _switch.isOn
				switch._viewOff.isVisible = not _switch.isOn
			end
			
			-- If self has a _onPress method execute it
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
			
		elseif "ended" == phase or "cancelled" == phase then
			-- If self has a _onRelease method execute it
			if self._onRelease and not self._onEvent then
				self._onRelease( event )
			end
		end

		-- If self has a _onEvent method execute it
		if self._onEvent then
			self._onEvent( event )
		end
		
		return true
	end
		
	view:addEventListener( "touch" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set a switch on/off programatically
	function view:_setState( options )
		local _switch = self.parent
		local _isSwitchOn = options.isOn
		local _isAnimated = options.isAnimated
		local _listener = options.onComplete
		
		-- If the user hasn't passed the isOn property, throw an error
		if _isSwitchOn == nil then
			error( "ERROR: " .. M._widgetName .. ": setState - isOn (true/false) expected, got nil", 3 )
		end
		
		-- If there is a onComplete method
		local function executeOnComplete()
			-- Set the switch isOn property
			_switch.isOn = _isSwitchOn
						
			-- Create the event
			local event = 
			{
				target = _switch,
				phase = "ended",
			}
				
			-- Execute the user listener
			if _listener then
				_listener( event )
			end
		end
		
		-- Set the switch to on/off visually
		if _isSwitchOn then
			-- Toggle the view's visibility
			switch._viewOn.isVisible = true
			switch._viewOff.isVisible = false
		else
			-- Toggle the view's visibility
			switch._viewOn.isVisible = false
			switch._viewOff.isVisible = true
		end
		
		executeOnComplete()
	end
	
	-- Finalize method for standard switch
	function switch:_finalize()		
		-- Set objects to nil
		self._viewOff = nil
		self._viewOn = nil

		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
	
	return switch
end


function M.new( options, theme )
	local customOptions = options or {}
	local themeOptions = theme or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- Check if the requirements for creating a widget has been met (throws an error if not)
	_widget._checkRequirements( customOptions, themeOptions, M._widgetName )
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------	
	
	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.width = customOptions.width or themeOptions.width
	opt.height = customOptions.height or themeOptions.height
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.switchType = customOptions.style or "onOff"
	opt.initialSwitchState = customOptions.initialSwitchState or false
	opt.onPress = customOptions.onPress
	opt.onRelease = customOptions.onRelease
	opt.onEvent = customOptions.onEvent
	
	-- Frames & Images	
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	opt.frameOff = customOptions.frameOff
	opt.frameOn = customOptions.frameOn
		
	-- If the user hasn't set a on/off frame but a theme has been set and it includes a data property then grab the required start/end frames
	if not opt.frameOff and not opt.frameOn and theme and themeOptions.data then
		opt.frameOff = _widget._getFrameIndex( themeOptions, themeOptions.frameOff )
		opt.frameOn = _widget._getFrameIndex( themeOptions, themeOptions.frameOn )
	end	
			
	-- Options for the on/off switch only
	if "onOff" == opt.switchType then
		opt.onOffBackgroundFrame = customOptions.backgroundFrame or themeOptions.backgroundFrame
		opt.onOffBackgroundWidth = customOptions.backgroundWidth or themeOptions.backgroundWidth or error( "ERROR: " .. M._widgetName .. ": backgroundWidth expected, got nil", 3 )
		opt.onOffBackgroundHeight = customOptions.backgroundHeight or themeOptions.backgroundHeight or error( "ERROR: " .. M._widgetName .. ": backgroundHeight expected, got nil", 3 )
		opt.onOffOverlayFrame = customOptions.overlayFrame or themeOptions.overlayFrame
		opt.onOffOverlayWidth = customOptions.overlayWidth or themeOptions.overlayWidth or error( "ERROR: " .. M._widgetName .. ": overlayWidth expected, got nil", 3 )
		opt.onOffOverlayHeight = customOptions.overlayHeight or themeOptions.overlayHeight or error( "ERROR: " .. M._widgetName .. ": overlayHeight expected, got nil", 3 )
		opt.onOffHandleDefaultFrame = customOptions.handleDefualtFrame or themeOptions.handleDefaultFrame 
		opt.onOffHandleOverFrame = customOptions.handleOverFrame or themeOptions.handleOverFrame
		opt.onOffMask = customOptions.mask or themeOptions.mask
	else
		if not opt.width then 
			error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
		end
		
		if not opt.height then
			error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
		end
	end
	
	-------------------------------------------------------
	-- Create the switch
	-------------------------------------------------------
	
	-- The switch object is a group
	local switch = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_switch",
		baseDirectory = opt.baseDir,
	}
		
	-- Create the switch based on the given type
 	if "onOff" == opt.switchType then
 		createOnOffSwitch( switch, opt )
 	else
 		createStandardSwitch( switch, opt )

		-- Set the switch's position ( set the reference point to center, just to be sure )
		switch:setReferencePoint( display.CenterReferencePoint )
		switch.x = opt.left + switch.contentWidth * 0.5
		switch.y = opt.top + switch.contentHeight * 0.5
	end
	
	return switch
end

return M
