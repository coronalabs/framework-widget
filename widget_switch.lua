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
	
	-- Create the view
	if opt.sheet and opt.width and opt.height then
		self._imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
		self._view = display.newImageRect( switchImageSheet, defaultFrame, width, height )
		self._view.subView = display.newImageRect( switchImageSheet, selectedFrame, width, height )
	else
		self._view = display.newImage( opt.default, true )
		self._view.subView = display.newImage( opt.selected, true )
	end
	
	-- Set the views initial visibility based on the default state
	self._view.isVisible = not opt.defaultState
	self._view.subView.isVisible = opt.defaultState
	
	-- Assign properties to self
	self.isOn = opt.defaultState
	
	-- Insert the view into the parent group
	self:insert( self._view )
	self:insert( self._view.subView )
	
	return self
end

local function initWithSprite( self, options )
	local opt = options
	
	-- If were using an imagesheet don't use a single image
	if opt.sheet then opt.default = nil; opt.selected = nil end
	
	-- Create the image sheet
	self._imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
	
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
	self._view = display.newSprite( self._imageSheet, switchImageSheetOptions )
	self._view:setSequence( tostring( opt.defaultState ) )
	self._view._defaultFrame = opt.defaultFrame
	self._view._selectedFrame = opt.selectedFrame
	
	-- Assign properties to self
	self.isOn = opt.defaultState
	
	-- Insert the view into the parent group
	self:insert( self._view )
end


local function initWithOnOffSwitch( self, options )
end

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
	
	-- Assign properties/methods to self.
	self._onPress = opt.onPress
	self._onRelease = opt.onRelease
	self._onEvent = opt.onEvent
		
	--------------------------------------------------------------------------------------------------------------------
	--												METHODS															  --
	--------------------------------------------------------------------------------------------------------------------

	-- Handle touches on the switch
	function self._touch( event )
		local phase = event.phase
		
		if "began" == phase then
			-- Toggle the switch on/off
			self.isOn = not self.isOn
					
			-- Toggle the displayed sprite sequence
			if usingSprite then
				self._view:setSequence( tostring( self.isOn ) )
			else
				-- Toggle the view's visibility
				self._view.isVisible = not self.isOn
				self._view.subView.isVisible = self.isOn
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
	
	self:addEventListener( "touch", self._touch )
end


function M.new( options, theme )
	local customOptions = options or {}
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support the switch widget." )
	end
	
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.width = customOptions.width
	opt.height = customOptions.height
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir
	opt.switchType = customOptions.switchType or theme.switchType or "onOff"
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.default = customOptions.default or theme.default
	opt.selected = customOptions.selected or theme.selected
	opt.defaultFrame = customOptions.defaultFrame
	opt.selectedFrame = customOptions.selectedFrame
	
	-- If there isn't a default frame but a theme has been set and it includes a data property then grab the required start/end frames
	if not opt.defaultFrame and theme and theme.data then
		opt.defaultFrame = require( theme.data ):getFrameIndex( theme.defaultFrame ) or 0
		opt.selectedFrame = require( theme.data ):getFrameIndex( theme.selectedFrame ) or 0
	end
	
	opt.defaultState = customOptions.defaultState or false
	opt.onPress = customOptions.onPress
	opt.onRelease = customOptions.onRelease
	opt.onEvent = customOptions.onEvent
	
	-- The switch object is a group
	local switch = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_switch",
		baseDirectory = opt.baseDir,
	}
	
 	if "onOff" == opt.switchType then
 		
 	else
 		initWithStandardSwitch( switch, opt )
	end
	
	return switch
end

return M
