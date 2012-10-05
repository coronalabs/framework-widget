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
		
	Example Usage:
		-- Create a default spinner (created using theme file) (ANIMATION)
		local spinner = widget.newSpinner
		{
			left = 100,
			top = 200,
		}
		
		-- Create a custom spinner (ANIMATION)
		local spinnerCustom = widget.newSpinner
		{
			left = 200,
			top = 200,
			sheet = "assets/customSpinner.png",
			data = "assets.customSpinner",
			start = 1,
			count = 30,
			time = 1000,
		}
		
		-- Create a custom spinner that isn't animated and just rotates (SINGLE IMAGE)
		local spinnerCustomJustRotates = widget.newSpinner
		{
			left = 160,
			top = 350,
			width = 80,
			height = 80,
			image = "assets/loadingCog.png",
			deltaAngle = 1,
			incrementEvery = 30 -- Runs the rotation function every 30ms
		}	
		
		-- Create a custom spinner that isn't animated from an image sheet (SINGLE IMAGE)
		local spinnerCustomJustRotatesFromImageSheet = widget.newSpinner
		{
			left = 80,
			top = 350,
			width = 35,
			height = 35,
			sheet = "assets/customSpinner.png",
			data = "assets.customSpinner",
			start = 1,
			count = 1,
			deltaAngle = -1,
		}
	
--]]

local M = {}

function M.new( options, themeOptions )
	local options = options or {}
	local theme = themeOptions or {}
	
	local image = options.image or theme.image
	local sheet = options.sheet or theme.sheet
	local sheetData = options.data or theme.data
	local startFrame = options.start or theme.start or 0
	local frameCount = options.count or theme.count or 0
	local animTime = options.time or 1000
	local deltaAngle = options.deltaAngle or theme.deltaAngle or 1
	local increments = options.incrementEvery or theme.incrementEvery or 1
	local left = options.left or 0
	local top = options.top or 0
	local width = options.width or nil
	local height = options.height or nil
	
	-- If were using an imagesheet don't use a single image
	if sheet then image = nil end
	
	-- If there isn't a sheet or image defined (either by params or theme, throw error)
	if not sheet and not image then
		error( "widget.newSpinner requires either an image or imageSheet, or a visual theme set by widget.setTheme" )
	end
	
	-- The spinner object is a group
	local spinner = require( "widget" )._new
	{
		left = left,
		top = top,
		id = options.id or "widget_spinner",
		baseDirectory = options.baseDir,
	}
	
	-- The actual spinner object
	local spinnerObject 
	
	-- Is the spinner animated?
	local spinnerIsAnimated = not image and frameCount > 1 or nil
	
	-- Forward references
	local spinnerImageSheet, spinnerImageSheetOptions = nil, nil
	
	-- Only create an imagesheet if needed
	if sheet then
		-- Create the image sheet
		spinnerImageSheet = graphics.newImageSheet( sheet, require( sheetData ).sheet )
		-- Create the sequenceData table
		spinnerImageSheetOptions = 
		{ 
			name = "default", 
			start = startFrame, 
			count = frameCount, 
			time = animTime, 
		}
	end
	
	-- Create the spinner
	if sheet then
		-- Create spinner as sprite
		if spinnerIsAnimated then
			spinnerObject = display.newSprite( spinnerImageSheet, spinnerImageSheetOptions )
		else
			if width and height then
				spinnerObject = display.newImageRect( spinnerImageSheet, start, width, height )
			else
				error( "Widget.newSpinner - You must specify a width/height when using a single image from a imagesheet as your spinner object" )
			end
		end
	else
		if width and height then
			-- Create spinner as newImageRect
			if image then
				spinnerObject = display.newImageRect( image, width, height )
			end
		else
			-- Create spinner as newImage
			if image then
				spinnerObject = display.newImage( image, true )
			end
		end
	end
	
	-- Insert the spinner object into the spinner group object
	spinner:insert( spinnerObject )
	
	-- The spinner's content is the spinnerObject
	spinner.content = spinnerObject
	
	-- The spinner's timer or sequence
	if not spinnerIsAnimated then
		spinner.content.timer = nil
	else
		-- Set the default sequence
		spinner.content:setSequence( "default" )
	end
	
	--------------------------------------------------------------------------------------------------------------------
	--										PUBLIC METHODS															  --
	--------------------------------------------------------------------------------------------------------------------						
	
	-- Function to start the spinner animating or rotating
	function spinner:start()
		local content = self.content
		
		-- If the spinner is a sprite then play it's animation
		if spinnerIsAnimated then
			content:play()
		else
			-- The spinner isn't a sprite so start or resume it's timer
			local function rotateSpinner()
				content:rotate( deltaAngle )
			end
			
			-- If the content doesn't currently have a timer
			if not content.timer then
				content.timer = timer.performWithDelay( increments, rotateSpinner, 0 )
			else
			-- The content has a timer, so just resume it
				timer.resume( content.timer )
			end
		end
	end
	
	-- Function to pause the spinner's animation or rotation
	function spinner:pause()
		local content = self.content
		
		-- If the spinner is a sprite then pause it's animation
		if spinnerIsAnimated then
			content:pause()
		else
		-- The spinner isn't a sprite so just pause it's timer
			if content.timer then
				timer.pause( content.timer )
			end
		end
	end
	
	
	-- removeSelf() method for spinner widget
	local function removeSelf( self )
		-- If the spinner isn't a sprite then cancel it's timer
		if self.content.timer then
			timer.cancel( self.content.timer )
			self.content.timer = nil
		end
	
		-- Remove the spinner
		self:oldRemoveSelf()
		self = nil
		
		-- Set spinners ImageSheet to nil
		spinnerImageSheet = nil
	end
	
	-- Other properties
	spinner.oldRemoveSelf = spinner.removeSelf
	spinner.removeSelf = removeSelf
	
	return spinner
end

return M;
