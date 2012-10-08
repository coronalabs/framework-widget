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

-- Function to create a new Spinner object ( widget.newSpinner)
function M.new( options, themeOptions )
	local options = options or {}
	local theme = themeOptions or {}
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------
	
	local image = options.image or theme.image
	local sheet = options.sheet or theme.sheet
	local sheetData = options.data or theme.data
	local width = options.width or theme.width
	local height = options.height or theme.height
	local startFrame = options.start or theme.start or 0
	local frameCount = options.count or theme.count or 0
	local animTime = options.time or 1000
	local deltaAngle = options.deltaAngle or theme.deltaAngle or 1
	local increments = options.incrementEvery or theme.incrementEvery or 1
	local left = options.left or 0
	local top = options.top or 0
		
	-------------------------------------------------------
	-- Methods
	-------------------------------------------------------
	
	-- Creates a new spinner from an image
	local function newWithImage( self ) -- Self == spinnerObject (group)
		-- The object
		local newObject = nil 
		local imageSheet = nil
		
		if sheet then
			image = nil
		 	imageSheet = graphics.newImageSheet( sheet, require( sheetData ).sheet )
			newObject = display.newImageRect( imageSheet, startFrame, width, height )
		else
			newObject = display.newImageRect( image, width, height )
		end
				
		-- Function to start the spinner's rotation
		function self:start()			
			-- The spinner isn't a sprite so start or resume it's timer
			local function rotateSpinner()
				newObject:rotate( deltaAngle )
			end
				
			-- If the timer doesn't exist, create it
			if not newObject._timer then
				newObject._timer = timer.performWithDelay( increments, rotateSpinner, 0 )
			else
				-- The timer exists, resume it
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
				
		return newObject
	end


	-- Creates a new spinner from a sprite
	local function newWithSprite( self ) -- Self == spinnerObject (group)
		-- Animation options
		local sheetOptions = 
		{ 
			name = "default", 
			start = startFrame, 
			count = frameCount, 
			time = animTime, 
		}
		
		local imageSheet = graphics.newImageSheet( sheet, require( sheetData ).sheet )
		
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
		
		return newObject
	end
	
	
	-- Create the spinner object
	local spinner = require( "widget" )._new
	{
		left = left,
		top = top,
		id = options.id or "widget_spinner",
		baseDirectory = options.baseDir,
	}
	
	-- Is the spinner animated?
	local spinnerIsAnimated = frameCount > 1

	-- Create the spinner
	if spinnerIsAnimated then
		spinner.content = newWithSprite( spinner )
	else
		spinner.content = newWithImage( spinner )
	end
	
	-- Insert the spinners content into the spinner object
	spinner:insert( spinner.content )
	
	-- Finalize method for spinner 
	function spinner:finalize()
		-- If the spinner isn't a sprite then cancel it's timer
		if self.content._timer then
			timer.cancel( self.content._timer )
			self.content._timer = nil
		end
		
		-- Set spinners ImageSheet to nil
		self.content._imageSheet = nil
	end
	
	return spinner
end

return M
