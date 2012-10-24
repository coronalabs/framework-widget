--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File:
		widget_newSwitch.lua
		
	What is it?:
		A widget object that can create a checkbox, radioButton or a on/off style switch.
	
	Features:
		*) A switch can be a sprite, newRect or newImage.
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newSwitch",
}

-- Initialize a switch with images
local function initWithImage( switch, options )
	-- Create a local reference to our options table
	local opt = options

	-- Forward references
	local imageSheet, viewOff, viewOn
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	viewOff = display.newImageRect( imageSheet, opt.frameOff, opt.width, opt.height )
	viewOn = display.newImageRect( imageSheet, opt.frameOn, opt.width, opt.height )
	
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
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	view = display.newSprite( imageSheet, switchSheetOptions )
	view._animStates =
	{
		[1] = "on",
		[2] = "off",
	}
	view:setSequence( view._animStates[tonumber( opt.initialSwitchState )] )
	
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
	local startRange = - math.round( opt.onOffOverlayWidth / 3.06 )
	local endRange = math.abs( startRange )
		
	-- Forward references
	local imageSheet, view, viewOverlay, viewHandle, viewMask
	
	-- Image sheet options for the on/off switch's handle sprite
	local handleSheetOptions = 
	{
		{ 
			name = "off", 
			start = require( opt.sheetData ):getFrameIndex( opt.onOffHandleDefaultFrame ), 
			count = 1, 
			time = 1,
		},
		
		{ 
			name = "on", 
			start = require( opt.sheetData ):getFrameIndex( opt.onOffHandleOverFrame ), 
			count = 1, 
			time = 1, 
		},
	}
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- The view is the switches background image
	view = display.newImageRect( imageSheet, require( opt.sheetData ):getFrameIndex( opt.onOffBackgroundFrame ), opt.onOffBackgroundWidth, opt.onOffBackgroundHeight )
	
	-- The view's overlay is the "shine" effect
	viewOverlay = display.newImageRect( imageSheet, require( opt.sheetData ):getFrameIndex( opt.onOffOverlayFrame ), opt.onOffOverlayWidth, opt.onOffOverlayHeight )
	
	-- The view's handle
	viewHandle = display.newSprite( imageSheet, handleSheetOptions )
	viewHandle:setSequence( "off" )
	
	-- The view's mask
	viewMask = graphics.newMask( opt.onOffMask, opt.baseDir )
	view:setMask( viewMask )

	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
		
	-- Properties
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
		view.maskX = view._handle.x - math.abs( view._startRange ) - view._endRange
	else
		view.x = view._startRange
		view._handle.x = view._startRange
		view.maskX = view._handle.x + math.abs( view._startRange ) + view._endRange
	end
	
	-- Assign objects to the switch
	switch._imageSheet = imageSheet
	switch._view = view
		
	-- Insert the view's into the switch (group)
	switch:insert( view )
	switch:insert( view._overlay )
	switch:insert( view._handle )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Handle taps on the switch
	function view:tap( event )
		local _switch = self.parent -- self.parent == switch
		-- Set the target to the switch
		event.target = _switch
		
		-- Toggle the switch
		_switch.isOn = not _switch.isOn
				
		-- If self has a _onPress method execute it
		local function executeOnPress()
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
		end
		
		-- Set the switches transition time
		local switchTransitionTime = 300
		
		-- Transition the switch from on>off and vice versa
		if _switch.isOn then
			self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnPress } )
			self._transition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
		else
			self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnPress } )
			self._transition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
		end
		
		return true
	end
	
	view:addEventListener( "tap" )
	
	-- Handle touch/drag events on the switch
	function view:touch( event )
		local phase = event.phase
	
		if "began" == phase then
			-- Set focus
			display.getCurrentStage():setFocus( self ) 
			self.isFocus = true
			
			-- Store initial position of the handle
			self._handle.x0 = event.x - self._handle.x 
			-- Set the handle to it's 'over' frame
			self._handle:setSequence( "on" )
	
		elseif self.isFocus then
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
				local _switch = self.parent -- self.parent == switch
				-- Set the target to the switch
				event.target = _switch
						
				-- If self has a _onRelease method execute it
				local function executeOnRelease()	
					if self._onRelease and not self._onEvent then
						self._onRelease( event )
					end
				end
				
				-- Set the switches transition time
				local switchTransitionTime = 300
									
				-- Transition the switch from on>off and vice versa
				if self._handle.x < 0 then
					_switch.isOn = false
					self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnRelease } )
					self._transition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
				else
					_switch.isOn = true
					self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnRelease } )
					self._transition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
				end
				
				-- Set the handle back to it's default frame
				self._handle:setSequence( "off" )
				
				-- Remove focus
				display.getCurrentStage():setFocus( nil )
				self.isFocus = false
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
	
	-- Finalize method for standard switch
	function switch:_finalize()
		-- Cancel current transition if there is one
		if self._view_transition then
			transition.cancel( self._view._transition )
			self._view._transition = nil
		end
		
		-- Remove the switch's mask
		self._view:setMask( nil )
				
		-- Set objects to nil
		self._view._overlay = nil
		self._view._handle = nil
		self._view._mask = nil
		self._view = nil
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
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Assign properties/methods to the view.
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent

	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------

	-- Handle touches on the switch
	function view:touch( event )
		local phase = event.phase
		local _switch = self.parent -- self.parent == switch
		-- Set the target to the switch
		event.target = _switch
		
		if "began" == phase then
			-- Toggle the switch on/off
			_switch.isOn = not _switch.isOn
					
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
	
	-- Finalize method for standard switch
	function switch:_finalize()		
		-- Set objects to nil
		self._viewOff = nil
		self._viewOn = nil

		self._imageSheet = nil
	end
	
	return switch
end


function M.new( options, theme )
	local customOptions = options or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not have a theme defined for the switch widget." )
	end
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------	
	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.width = customOptions.width or theme.width
	opt.height = customOptions.height or theme.height
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.switchType = customOptions.style or "onOff"
	opt.initialSwitchState = customOptions.initialSwitchState or false
	opt.onPress = customOptions.onPress
	opt.onRelease = customOptions.onRelease
	opt.onEvent = customOptions.onEvent
	
	-- Frames & Images	
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.frameOff = customOptions.frameOff
	opt.frameOn = customOptions.frameOn
		
	-- If the user hasn't set a on/off frame but a theme has been set and it includes a data property then grab the required start/end frames
	if not opt.frameOff and not opt.frameOn and theme and theme.data then
		opt.frameOff = require( theme.data ):getFrameIndex( theme.frameOff )
		opt.frameOn = require( theme.data ):getFrameIndex( theme.frameOn )
	end	
			
	-- Options for the on/off switch only
	opt.onOffBackgroundFrame = customOptions.backgroundFrame or theme.backgroundFrame
	opt.onOffBackgroundWidth = customOptions.backgroundWidth or theme.backgroundWidth
	opt.onOffBackgroundHeight = customOptions.backgroundHeight or theme.backgroundHeight
	opt.onOffOverlayFrame = customOptions.overlayFrame or theme.overlayFrame
	opt.onOffOverlayWidth = customOptions.overlayWidth or theme.overlayWidth
	opt.onOffOverlayHeight = customOptions.overlayHeight or theme.overlayHeight
	opt.onOffHandleDefaultFrame = customOptions.handleDefualtFrame or theme.handleDefaultFrame
	opt.onOffHandleOverFrame = customOptions.handleOverFrame or theme.handleOverFrame
	opt.onOffMask = customOptions.mask or theme.mask
	
	-------------------------------------------------------
	-- Constructor error handling
	-------------------------------------------------------
	
	-- Throw error if the user hasn't defined a sheet and has defined data or vice versa.
	if not customOptions.sheet and customOptions.data then
		error( M._widgetName .. ": Sheet expected, got nil" )
	elseif customOptions.sheet and not customOptions.data then
		error( M._widgetName .. ": Sheet data file expected, got nil" )
	end
	
	-- If the user has passed in a sheet but hasn't defined the width & height throw an error
	if not opt.width and not opt.height then
		if opt.switchType ~= "onOff" then
			error( M._widgetName .. ": You must pass width & height parameters when using " .. M._widgetName .. " with an imageSheet" )
		end
	end

	-------------------------------------------------------
	-- Create the switch
	-------------------------------------------------------
	
	-- The switch object is a group
	local switch = require( "widget" )._new
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
	end
	
	return switch
end

return M
