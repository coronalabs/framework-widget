--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_progressView.lua
		
	What is it?: 
		A widget object that can ..
	
	Features:
		
--]]

local M = 
{
	_options = {},
}

-- Creates a new progress bar from an image
local function initWithImage( progressView, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- If there is an image, don't attempt to use a sheet
	if opt.image then
		opt.sheet = nil
	end
	
	-- Forward references
	local imageSheet, view
	
	-- Create the view
	if opt.sheet then
		imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
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
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object

	
	-------------------------------------------------------
	-- Assign properties/objects to the progressView
	-------------------------------------------------------
	
	-- Assign objects to the progressView
	progressView._imageSheet = imageSheet
	progressView._view = view

	-- Insert the view into the parent group
	progressView:insert( view )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function for the progressView
	function progressView:_finalize()
		
		-- Set progressViews ImageSheet to nil
		self._imageSheet = nil
	end
			
	return progressView
end


-- Creates a new progressView from a sprite
local function initWithSprite( progressView, options )
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
	-- Assign properties/objects to the progressView
	-------------------------------------------------------
	
	-- Assign objects to the progressView
	progressView._imageSheet = imageSheet
	progressView._view = view
	
	-- Insert the view into the parent group
	progressView:insert( view )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------

	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function
	function progressView:_finalize()
		-- Set progressViews ImageSheet to nil
		self._view_imageSheet = nil
	end
		
	return progressView
end


-- Function to create a new progressView object ( widget.newProgressView)
function M.new( options, theme )	
	local customOptions = options or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support the progressView widget." )
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
	opt.fillOuter = customOptions.fillOuter
	opt.fillInner = customOptions.fillInner
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.fillOuterFrame = customOptions.fillOuterFrame or require( theme.data ):getFrameIndex( theme.fillOuterFrame )
	opt.fillInnerFrame = customOptions.fillInnerFrame or theme.fillInnerFrame
	
	-------------------------------------------------------
	-- Create the progressView
	-------------------------------------------------------
		
	-- Create the progressView object
	local progressView = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_progressView",
		baseDir = opt.baseDir,
	}
		
	-- Create the progressView
	
	return progressView
end

return M
