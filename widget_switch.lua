--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File:
		widget_newSwitch.lua
		
	What is it?:
		A widget object that can...
	
	Features:
--]]

local M = 
{
	_options = {},
}


local function initWithImage( self, options )
	local opt = options
	
	-- If were using an imagesheet don't use a single image
	if opt.sheet then opt.default = nil; opt.selected = nil end
	local imageSheet, view
	
	-- Create the view
	if opt.sheet and opt.width and opt.height then
		imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
		view = display.newImageRect( imageSheet, opt.defaultFrame, opt.width, opt.height )
		view.subView = display.newImageRect( imageSheet, opt.selectedFrame, opt.width, opt.height )
	else
		view = display.newImage( opt.default, true )
		view.subView = display.newImage( opt.selected, true )
	end
	
	-- Set the views initial visibility based on the default state
	view.isVisible = not opt.defaultState
	view.subView.isVisible = opt.defaultState
	-- Assign properties to the view
	view._imageSheet = imageSheet
	view.isOn = opt.defaultState
	
	-- Assign properties to self
	self._imageSheet = view._imageSheet
	self._view = view
	self._view.subView = view.subView
	self.isOn = view.isOn
	
	-- Insert the view into the parent group
	self:insert( view )
	self:insert( view.subView )
	
	return self
end

local function initWithSprite( self, options )
	local opt = options
	
	-- If were using an imagesheet don't use a single image
	if opt.sheet then opt.default = nil; opt.selected = nil end
	
	-- Create the image sheet
	local imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the sequenceData table
	switchImageSheetOptions = 
	{ 
		{
			name = "true",
			start = opt.selectedFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "false",
			start = opt.defaultFrame,
			count = 1,
			time = 1,
		},
	}
	
	-- Create the view
	local view = display.newSprite( imageSheet, switchImageSheetOptions )
	view:setSequence( tostring( opt.defaultState ) )
	view._defaultFrame = opt.defaultFrame
	view._selectedFrame = opt.selectedFrame
	view.isOn = opt.defaultState
	
	-- Assign properties to self
	self._view = view
	self.isOn = view.isOn
	
	-- Insert the view into the parent group
	self:insert( view )
	
	return self
end






-- Initialize with a on/off toggle switch
local function initWithOnOffSwitch( self, options )
	local opt = options
	
	-- This is measured from the pixels in the switch overlay image.
	local startRange = - math.round( require( opt.sheetData ):getSheet().frames[require( opt.sheetData ):getFrameIndex( opt.overlay )].width / 3.06 )
	local endRange = math.abs( startRange )
	
	-- The imageSheet
	local imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
	
	-- The view is the switches background image
	local view = display.newImageRect( imageSheet, require( opt.sheetData ):getFrameIndex( opt.background ), opt.backgroundWidth, opt.backgroundHeight )
	self:insert( view )
	
	-- The view's overlay is the "shine" effect
	view.overlay = display.newImageRect( imageSheet, require( opt.sheetData ):getFrameIndex( opt.overlay ), opt.overlayWidth, opt.overlayHeight )
	self:insert( view.overlay )
	
	local handleOptions = 
	{
		{ 
			name = "false", 
			start = require( opt.sheetData ):getFrameIndex( opt.handle ), 
			count = 1, 
			time = 1,
		},
		
		{ 
			name = "true", 
			start = require( opt.sheetData ):getFrameIndex( opt.handleOver ), 
			count = 1, 
			time = 1, 
		},
	}
	
	-- The view's handle
	view.handle = display.newSprite( imageSheet, handleOptions )
	view.handle:setSequence( opt.handle )
	self:insert( view.handle )
	
	-- The view's mask
	view.mask = graphics.newMask( opt.mask, opt.baseDir )
	view:setMask( view.mask )

	--------------------------------------------------------------------------------------------------------------------
	--												METHODS															  --
	--------------------------------------------------------------------------------------------------------------------
	
	-- Handle taps on the switch
	function view:tap( event )
		-- Toggle the switch
		self.isOn = not self.isOn
		
		-- If self has a _onPress method execute it
		if self._onPress and not self._onEvent then
			self._onPress( event )
		end
		
		if self.isOn then
			transition.to( self, { x = self._endRange, maskX = self._startRange, time = 300 } )
			transition.to( self.handle, { x = self._endRange, time = 300 } )
		else
			transition.to( self, { x = self._startRange, maskX = self._endRange, time = 300 } )
			transition.to( self.handle, { x = self._startRange, time = 300 } )
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
			self.handle.x0 = event.x - self.handle.x 
			-- Set the handle to it's 'over' frame
			self.handle:setSequence( "true" )
	
		elseif self.isFocus then
			if "moved" == phase then
				self.handle.x = event.x - self.handle.x0 
				self.x = event.x - self.handle.x0
				self.maskX = - ( event.x - self.handle.x0 )
		
				-- limit movement to switch, left side
				if self.handle.x <= self._startRange then
					self.handle.x = self._startRange
					self.x = self._startRange
					self.maskX = self._endRange
				end
					
				--limit movement to switch, right side
				if self.handle.x >= self._endRange then
					self.handle.x = self._endRange
					self.x = self._endRange 
					self.maskX = self._startRange
				end
	
			elseif "ended" == phase or "cancelled" == phase then
				-- If self has a _onRelease method execute it
				if self._onRelease and not self._onEvent then
					self._onRelease( event )
				end
				
				if self.handle.x < 0 then
					transition.to( self, { x = self._startRange, maskX = self._endRange, time = 300 } )
					transition.to( self.handle, { x = self._startRange, time = 300 } )
				else
					transition.to( self, { x = self._endRange, maskX = self._startRange, time = 300 } )
					transition.to( self.handle, { x = self._endRange, time = 300 } )
				end
				
				-- Set the handle back to it's default frame
				self.handle:setSequence( "false" )
				
				-- Remove focus
				display.getCurrentStage():setFocus( nil )
				self.isFocus = false
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	-- Properties
	view._imageSheet = imageSheet
	view.isOn = opt.defaultState
	view._startRange = startRange
	view._endRange = endRange
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	
	-- Set the buttons positions based on the chosen default value (ie on/off)
	if view.isOn then
		view.x = view._endRange
		view.handle.x = view._endRange
		view.maskX = view.handle.x - math.abs( view._startRange ) - view._endRange
	else
		view.x = view._startRange
		view.handle.x = view._startRange
		view.maskX = view.handle.x + math.abs( view._startRange ) + view._endRange
	end
	
	-- Assign properties to self	
	self._view = view
	self.isOn = view.isOn

	return self
end


-- Initialize with a standard switch (ie radio/checkbox buttons)
local function initWithStandardSwitch( self, options )
	local opt = options
	local usingSprite = false
	
	-- If there is a default frame & a selected frame then init with sprite
	if opt.defaultFrame and opt.selectedFrame then
		initWithSprite( self, opt )
		usingSprite = true
	else
		-- There isn't so init with image
		initWithImage( self, opt )
	end
	
	-- 
	local view = self._view
	
	-- Assign properties/methods to the view.
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent

	--------------------------------------------------------------------------------------------------------------------
	--												METHODS															  --
	--------------------------------------------------------------------------------------------------------------------

	-- Handle touches on the switch
	function view:touch( event )
		local phase = event.phase
		
		if "began" == phase then
			-- Toggle the switch on/off
			self.isOn = not self.isOn
					
			-- Toggle the displayed sprite sequence
			if usingSprite then
				self:setSequence( tostring( self.isOn ) )
			else
				-- Toggle the view's visibility
				self.isVisible = not self.isOn
				self.subView.isVisible = self.isOn
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
	
	return self
end


function M.new( options, theme )
	local customOptions = options or {}
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support the switch widget." )
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
	opt.switchType = customOptions.switchType or theme.switchType or "onOff"
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.default = customOptions.default or theme.default
	opt.selected = customOptions.selected or theme.selected
	opt.defaultFrame = customOptions.defaultFrame
	opt.selectedFrame = customOptions.selectedFrame
		
	opt.background = customOptions.background or theme.background
	opt.backgroundWidth = customOptions.backgroundWidth or theme.backgroundWidth
	opt.backgroundHeight = customOptions.backgroundHeight or theme.backgroundHeight
	opt.overlay = customOptions.overlay or theme.overlay
	opt.overlayWidth = customOptions.overlayWidth or theme.overlayWidth
	opt.overlayHeight = customOptions.overlayHeight or theme.overlayHeight
	opt.handle = customOptions.handle or theme.handle
	opt.handleOver = customOptions.handleOver or theme.handleOver
	opt.mask = customOptions.mask or theme.mask
	
	-- If there isn't a default frame but a theme has been set and it includes a data property then grab the required start/end frames
	if not opt.defaultFrame and theme and theme.data then
		opt.defaultFrame = require( theme.data ):getFrameIndex( theme.defaultFrame ) or 0
		opt.selectedFrame = require( theme.data ):getFrameIndex( theme.selectedFrame ) or 0
	end
	
	opt.defaultState = customOptions.defaultState or false
	opt.onPress = customOptions.onPress
	opt.onRelease = customOptions.onRelease
	opt.onEvent = customOptions.onEvent
	
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
 		initWithOnOffSwitch( switch, opt )
 	else
 		initWithStandardSwitch( switch, opt )
	end
	
	return switch
end

return M
