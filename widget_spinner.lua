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
	_widgetName = "widget.newSpinner",
}

-- Creates a new spinner from an image
local function initWithImage( spinner, options )
	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local imageSheet, view
	
	-- Create the view
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	view = display.newImageRect( imageSheet, opt.startFrame, opt.width, opt.height )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	view._deltaAngle = opt.deltaAngle
	view._increments = opt.increments
	
	-------------------------------------------------------
	-- Assign properties/objects to the spinner
	-------------------------------------------------------
	
	-- Assign objects to the spinner
	spinner._imageSheet = imageSheet
	spinner._view = view

	-- Insert the view into the parent group
	spinner:insert( view )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
			
	-- Function to start the spinner's rotation
	function spinner:start()
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
	function spinner:stop()
		-- Pause the spinner's timer
		if self._view._timer then
			timer.pause( self._view._timer )
		end
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function for the spinner
	function spinner:_finalize()
		if self._view._timer then
			timer.cancel( self._view._timer )
			self._view._timer = nil
		end
		
		-- Set spinners ImageSheet to nil
		self._imageSheet = nil
	end
			
	return spinner
end


-- Creates a new spinner from a sprite
local function initWithSprite( spinner, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Animation options
	local sheetOptions = 
	{ 
		name = "default", 
		start = opt.startFrame, 
		count = opt.frameCount,
		time = opt.animTime,
	}
	
	-- Forward references
	local imageSheet, view
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	view = display.newSprite( imageSheet, sheetOptions )
	view:setSequence( "default" )
	
	-------------------------------------------------------
	-- Assign properties/objects to the spinner
	-------------------------------------------------------
	
	-- Assign objects to the spinner
	spinner._imageSheet = imageSheet
	spinner._view = view
	
	-- Insert the view into the parent group
	spinner:insert( view )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to start the spinner's animation
	function spinner:start()
		self._view:play()
	end
	
	-- Function to pause the spinner's animation
	function spinner:stop()
		self._view:pause()
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function
	function spinner:_finalize()
		-- Set spinners ImageSheet to nil
		self._view_imageSheet = nil
	end
		
	return spinner
end


-- Function to create a new Spinner object ( widget.newSpinner)
function M.new( options, theme )	
	local customOptions = options or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not have a theme defined for the spinner widget." )
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
	opt.animTime = customOptions.time or theme.time or 1000
	opt.deltaAngle = customOptions.deltaAngle or theme.deltaAngle or 1
	opt.increments = customOptions.incrementEvery or theme.incrementEvery or 1
	
	-- Frames & Images
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.startFrame = customOptions.startFrame or require( theme.data ):getFrameIndex( theme.startFrame )
	opt.frameCount = customOptions.count or theme.count or 0
	
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
	local hasProvidedSize = opt.width and opt.height
	
	if not hasProvidedSize then
		error( M._widgetName .. ": You must pass width & height parameters when using " .. M._widgetName .. " with an imageSheet" )
	end
	
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
