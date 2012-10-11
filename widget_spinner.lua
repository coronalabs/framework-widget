--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_spinner.lua
		
	What is it?: 
		A widget object that can be used to replicate native activity indicators, custom activity indicators or loading wheels.
	
	Features:
		*) A spinner can be a sprite, newRect or newImage.
		*) A spinner can be an animation (Sprite) or just a image that rotates (ie. rotating cog to visually show loading progress)
		*) A spinner that just rotates (ie. single image) can be created from an image sheet or single png/jpg image.
		*) A spinner can be started/paused at any time.
--]]

local M = 
{
	_options = {},
}

-- Creates a new spinner from an image
local function initWithImage( self, options ) -- Self == spinnerObject (group)
	local opt = options
	
	-- If there is an image, don't attempt to use a sheet
	if opt.image then
		opt.sheet = nil
	end
	
	-- Forward references
	local imageSheet, view
	
	-- Create the view
	if opt.sheet then
		imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
		view = display.newImageRect( imageSheet, opt.startFrame, opt.width, opt.height )
	else
		-- There isn't a sheet defined > Use display.newImageRect
		if opt.width and opt.height then
			view = display.newImageRect( opt.image, opt.width, opt.height )
		else
			-- There is no width/height specified > Use display.newImage
			view = display.newImage( opt.image, true )
		end
	end
			
	-- Function to start the spinner's rotation
	function self:start() -- Self == Spinner	
		-- The spinner isn't a sprite > Start or resume it's timer
		local function rotateSpinner()
			self._view:rotate( self._view._deltaAngle )
		end
			
		-- If the timer doesn't exist > Create it
		if not self._view._timer then
			self._view._timer = timer.performWithDelay( self._view._increments, rotateSpinner, 0 )
		else
			-- The timer exists > Resume it
			timer.resume( self._view._timer )
		end
	end
	
	-- Function to pause the spinner's rotation
	function self:stop() -- Self == Spinner	
		-- Pause the spinner's timer
		if self._view._timer then
			timer.pause( self._view._timer )
		end
	end
	
	-- Finalize function
	function self:_finalize()
		if self._view._timer then
			timer.cancel( self._view._timer )
			self._view._timer = nil
		end
		
		-- Set spinners ImageSheet to nil
		self._view._imageSheet = nil
	end

	-- We need to assign these properties to the object
	view._deltaAngle = opt.deltaAngle
	view._increments = opt.increments
	view._imageSheet = imageSheet

	-- Assign the view to self's view
	self._view = view

	-- Insert the view into the parent group
	self:insert( view )
			
	return self
end


-- Creates a new spinner from a sprite
local function initWithSprite( self, options ) -- Self == spinnerObject (group)
	local opt = options
	
	-- Animation options
	local sheetOptions = 
	{ 
		name = "default", 
		start = opt.startFrame, 
		count = opt.frameCount,
		time = opt.animTime,
	}
	
	-- Create the view
	local imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
	local view = display.newSprite( imageSheet, sheetOptions )
	view:setSequence( "default" )
	
	-- Function to start the spinner's animation
	function self:start() -- Self == Spinner	
		self._view:play()
	end
	
	-- Function to pause the spinner's animation
	function self:stop() -- Self == Spinner	
		self._view:pause()
	end
	
	-- Finalize function
	function self:_finalize()
		-- Set spinners ImageSheet to nil
		self._imageSheet = nil
	end
	
	-- Assign the view to self's view
	self._view = view
	
	-- Insert the view into the parent group
	self:insert( view )
	
	return self
end


-- Function to create a new Spinner object ( widget.newSpinner)
function M.new( options, theme )	
	local customOptions = options or {}
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support the spinner widget." )
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
	opt.image = customOptions.image
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.startFrame = customOptions.start or require( theme.data ):getFrameIndex( theme.start ) or 0
	opt.frameCount = customOptions.count or theme.count or 0
	opt.animTime = customOptions.time or theme.time or 1000
	opt.deltaAngle = customOptions.deltaAngle or theme.deltaAngle or 1
	opt.increments = customOptions.incrementEvery or theme.incrementEvery or 1
	
	-------------------------------------------------------
	-- Create the spinner
	-------------------------------------------------------
		
	-- Create the spinner object
	local spinner = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_spinner",
		baseDir = opt.baseDir,
	}
		
	-- Is the spinner animated?
	local spinnerIsAnimated = opt.frameCount > 1

	-- Create the spinner
	if spinnerIsAnimated then
		initWithSprite( spinner, opt )
	else
		initWithImage( spinner, opt )
	end
	
	return spinner
end

return M
