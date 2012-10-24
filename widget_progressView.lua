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
	_widgetName = "widget.newProgressView",
}

-- Creates a new progress bar from an image
local function initWithImage( progressView, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object

	
	-------------------------------------------------------
	-- Assign properties/objects to the progressView
	-------------------------------------------------------
	
	-- Assign objects to the progressView
	progressView._imageSheet = imageSheet
	--progressView._view = view

	-- Insert the view into the parent group
	--progressView:insert( view )
	
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


-- Function to create a new progressView object ( widget.newProgressView )
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
	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	
	-- Frames & Images
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	--opt.fillOuterFrame = customOptions.fillOuterFrame or require( theme.data ):getFrameIndex( theme.fillOuterFrame )
	
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
	if not opt.width and not opt.height then
		error( M._widgetName .. ": You must pass width & height parameters when using " .. M._widgetName .. " with an imageSheet" )
	end
	
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
	initWithImage( progressView, opt )
	
	return progressView
end

return M
