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

local widget = require( "widget" )

local M = {}

-- Creates a new spinner from an image
local function newWithImage( self, options ) -- Self == spinnerObject (group)
	local options = options
	
	-- The object
	local newObject = nil 
	local imageSheet = nil
	
	-- There is a sheet defined > Use display.newImageRect with an imageSheet
	if options.sheet then
		imageSheet = graphics.newImageSheet( options.sheet, require( options.sheetData ).sheet )
		newObject = display.newImageRect( imageSheet, options.startFrame, options.width, options.height )
	else
		-- There isn't a sheet defined > Use display.newImageRect
		if options.width and options.height then
			newObject = display.newImageRect( options.image, options.width, options.height )
		else
			-- There is no width/height specified > Use display.newImage
			newObject = display.newImage( options.image, true )
		end
	end
	
	-- We need to assign these properties to the object
	newObject.deltaAngle = options.deltaAngle
	newObject.increments = options.increments
			
	-- Function to start the spinner's rotation
	function self:start()			
		-- The spinner isn't a sprite > Start or resume it's timer
		local function rotateSpinner()
			newObject:rotate( newObject.deltaAngle )
		end
			
		-- If the timer doesn't exist > Create it
		if not newObject._timer then
			newObject._timer = timer.performWithDelay( newObject.increments, rotateSpinner, 0 )
		else
			-- The timer exists > Resume it
			timer.resume( newObject._timer )
		end
	end
	
	-- Function to pause the spinner's rotation
	function self:stop()
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
	local options = options
	
	-- Animation options
	local sheetOptions = 
	{ 
		name = "default", 
		start = options.startFrame, 
		count = options.frameCount, 
		time = options.animTime, 
	}
	
	local imageSheet = graphics.newImageSheet( options.sheet, require( options.sheetData ).sheet )
	
	-- The object
	local newObject = display.newSprite( imageSheet, sheetOptions )
	newObject:setSequence( "default" )
	
	-- Function to start the spinner's animation
	function self:start()
		newObject:play()
	end
	
	-- Function to pause the spinner's animation
	function self:stop()
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
	--local options = options or {}
	--local theme = themeOptions or {}
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------
	
	-- Populate the widget_options table
	if options then
		widget._options.width = options.width or theme.width
		widget._options.height = options.height or theme.height
		widget._options.left = options.left or 100
		widget._options.top = options.top or 100
		widget._options.id = options.id
		widget._options.baseDir = options.baseDir
		widget._options.image = options.image or theme.image
		widget._options.sheet = options.sheet or theme.sheet
		widget._options.sheetData = options.data or theme.data
		widget._options.startFrame = options.start or theme.start
		widget._options.frameCount = options.count or theme.count
		widget._options.animTime = options.time or 1000
		widget._options.deltaAngle = options.deltaAngle or theme.deltaAngle or 1
		widget._options.increments = options.incrementEvery or theme.incrementEvery or 1
	else
		widget._options.left = 0
		widget._options.top = 0
		
		if theme then
			widget._options.width = theme.width
			widget._options.height = theme.height
			widget._options.image = theme.image
			widget._options.sheet = theme.sheet
			widget._options.sheetData = theme.data
			widget._options.startFrame = theme.start
			widget._options.frameCount = theme.count
			widget._options.animTime = 1000
			widget._options.deltaAngle = theme.deltaAngle or 1
			widget._options.increments = theme.incrementEvery or 1
		else
			error( "widget.newSpinner requires a theme to be set or to be provided with an image or sprite" )
		end
	end
		
	
	-------------------------------------------------------
	-- Methods
	-------------------------------------------------------
		
	-- Create the spinner object
	local spinner = widget._new
	{
		left = widget._options.left,
		top = widget._options.top,
		id = widget._options.id or "widget_spinner",
		baseDir = widget._options.baseDir,
	}
	
	-- Is the spinner animated?
	local spinnerIsAnimated = widget._options.frameCount and widget._options.frameCount > 1

	-- Create the spinner
	if spinnerIsAnimated then
		spinner.content = newWithSprite( spinner, widget._options )
	else
		spinner.content = newWithImage( spinner, widget._options )
	end
	
	-- Insert the spinners content into the spinner object
	spinner:insert( spinner.content )
	
	-- Finalize method for spinner 
	function spinner:_finalize()
		self.content:_finalize()
	end
	
	-- Clear the widget options table but don't remove it
	for k, v in pairs( widget._options ) do
		widget._options[k] = nil
	end
	
	return spinner
end

return M
