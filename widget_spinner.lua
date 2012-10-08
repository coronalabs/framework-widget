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
			
	-- Function to start the spinner's rotation
	function self:start()			
		-- The spinner isn't a sprite > Start or resume it's timer
		local function rotateSpinner()
			newObject:rotate( options.deltaAngle )
		end
			
		-- If the timer doesn't exist > Create it
		if not newObject._timer then
			newObject._timer = timer.performWithDelay( options.increments, rotateSpinner, 0 )
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
function M.new( options, themeOptions )
	local options = options or {}
	local theme = themeOptions or {}
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------
	
	-- Lets use a table to store common properties, neater and prevents loads of local variables
	local widgetOptions = 
	{
		width = options.width or theme.width,
		height = options.height or theme.height,
		left = options.left or 0,
		top = options.top or 0,
		id = options.id,
		image = options.image or theme.image,
		sheet = options.sheet or theme.sheet,
		sheetData = options.data or theme.data,
		startFrame = options.start or theme.start,
		frameCount = options.count or theme.count,
		animTime = options.time or 1000,
		deltaAngle = options.deltaAngle or theme.deltaAngle or 1,
		increments = options.incrementEvery or theme.incrementEvery or 1,
	}
	
	
	-------------------------------------------------------
	-- Methods
	-------------------------------------------------------
		
	-- Create the spinner object
	local spinner = require( "widget" )._new
	{
		left = widgetOptions.left,
		top = widgetOptions.top,
		id = widgetOptions.id or "widget_spinner",
		baseDir = options.baseDir,
	}
	
	-- Is the spinner animated?
	local spinnerIsAnimated = widgetOptions.frameCount and widgetOptions.frameCount > 1

	-- Create the spinner
	if spinnerIsAnimated then
		spinner.content = newWithSprite( spinner, widgetOptions )
	else
		spinner.content = newWithImage( spinner, widgetOptions )
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
