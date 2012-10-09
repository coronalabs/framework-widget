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

local M = {}
M._options = {}

-- Creates a new spinner from an image
local function newWithImage( self, options ) -- Self == spinnerObject (group)
	local opt = options
	
	-- The object
	local newObject = nil 
	local imageSheet = nil
	
	-- There is a sheet defined > Use display.newImageRect with an imageSheet
	if opt.sheet then
		imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
		newObject = display.newImageRect( imageSheet, opt.startFrame, opt.width, opt.height )
	else
		-- There isn't a sheet defined > Use display.newImageRect
		if opt.width and opt.height then
			newObject = display.newImageRect( opt.image, opt.width, opt.height )
		else
			-- There is no width/height specified > Use display.newImage
			newObject = display.newImage( opt.image, true )
		end
	end
	
	-- We need to assign these properties to the object
	newObject._deltaAngle = opt.deltaAngle
	newObject._increments = opt.increments
			
	-- Function to start the spinner's rotation
	function self:start() -- Self == Spinner	
		-- The spinner isn't a sprite > Start or resume it's timer
		local function rotateSpinner()
			newObject:rotate( newObject._deltaAngle )
		end
			
		-- If the timer doesn't exist > Create it
		if not newObject._timer then
			newObject._timer = timer.performWithDelay( newObject._increments, rotateSpinner, 0 )
		else
			-- The timer exists > Resume it
			timer.resume( newObject._timer )
		end
	end
	
	-- Function to pause the spinner's rotation
	function self:stop() -- Self == Spinner	
		-- Pause the spinner's timer
		if newObject._timer then
			timer.pause( newObject._timer )
		end
	end
	
	-- Create a reference to the imagesheet so we can remove it later
	newObject._imageSheet = imageSheet
	
	-- Finalize function
	function newObject:_finalize()
		if self._timer then
			timer.cancel( self._timer )
			self._timer = nil
		end
		
		-- Set spinners ImageSheet to nil
		self._imageSheet = nil
	end
			
	return newObject
end


-- Creates a new spinner from a sprite
local function newWithSprite( self, options ) -- Self == spinnerObject (group)
	local opt = options
	
	-- Animation options
	local sheetOptions = 
	{ 
		name = "default", 
		start = opt.startFrame, 
		count = opt.frameCount, 
		time = opt.animTime, 
	}
	
	local imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ).sheet )
	
	-- The object
	local newObject = display.newSprite( imageSheet, sheetOptions )
	newObject:setSequence( "default" )
	
	-- Function to start the spinner's animation
	function self:start() -- Self == Spinner	
		newObject:play()
	end
	
	-- Function to pause the spinner's animation
	function self:stop() -- Self == Spinner	
		newObject:pause()
	end
	
	-- Create a reference to the imagesheet so we can remove it later
	newObject._imageSheet = imageSheet
	
	-- Finalize function
	function newObject:_finalize()
		-- Set spinners ImageSheet to nil
		self._imageSheet = nil
	end
	
	return newObject
end


-- Function to create a new Spinner object ( widget.newSpinner)
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
	opt.baseDir = customOptions.baseDir
	opt.image = customOptions.image or theme.image
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.startFrame = customOptions.start or theme.start or 0
	opt.frameCount = customOptions.count or theme.count or 0
	opt.animTime = customOptions.time or theme.time or 1000
	opt.deltaAngle = customOptions.deltaAngle or theme.deltaAngle or 1
	opt.increments = customOptions.incrementEvery or theme.incrementEvery or 1
	
	-------------------------------------------------------
	-- Methods
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
	local spinnerIsAnimated = opt.frameCount and opt.frameCount > 1

	-- Create the spinner
	if spinnerIsAnimated then
		spinner.content = newWithSprite( spinner, opt )
	else
		spinner.content = newWithImage( spinner, opt )
	end
	
	-- Insert the spinners content into the spinner object
	spinner:insert( spinner.content )
	
	-- Finalize method for spinner 
	function spinner:_finalize()
		self.content:_finalize()
	end
	
	return spinner
end

return M
