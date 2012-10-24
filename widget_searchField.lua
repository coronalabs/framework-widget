--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_searchField.lua
		
	What is it?: 
		A widget object that can.....
	
	Features:
		
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newSearchField",
}

-- Creates a new search field from an image
local function initWithImage( searchField, options )
	local opt = options
	
	-- If there is an image, don't attempt to use a sheet
	if opt.imageDefault then
		opt.sheet = nil
	end
	
	-- Forward references
	local imageSheet, view, cancelButton, viewTextbox
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	view = display.newImageRect( imageSheet, opt.defaultFrame, opt.defaultFrameWidth, opt.defaultFrameHeight )
	cancelButton = display.newImageRect( imageSheet, opt.cancelFrame, opt.cancelFrameWidth, opt.cancelFrameHeight )
	
	-- Create the textbox (that is contained within the searchField)
	viewTextbox = native.newTextField( 0, 0, view.contentWidth - 36, view.contentHeight - 14 )
	viewTextbox.x = view.x + 12
	viewTextbox.y = view.y - 2
	viewTextbox.isEditable = true
	viewTextbox.hasBackground = false
	viewTextbox.align = "left"
	viewTextbox.placeholder = "Search iPhone"
	
	-- Set the cancel buttons position
	cancelButton.x = searchField.x + view.contentWidth * 0.4
	cancelButton.y = searchField.y
	cancelButton.isVisible = false
	
	-------------------------------------------------------
	-- Assign properties/objects to the searchField
	-------------------------------------------------------
	
	searchField._imageSheet = imageSheet
	searchField._view = view
	searchField._cancelButton = cancelButton

	-- Insert the view into the searchField (group)
	searchField:insert( view )
	searchField:insert( cancelButton )
	searchField:insert( viewTextbox )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to listen for textbox events
	function viewTextbox:_inputListener( event )
		
	end
	
	viewTextbox.userInput = viewTextbox._inputListener
	viewTextbox:addEventListener( "userInput" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function
	function searchField:_finalize()
		-- Set searchField imageSheet to nil
		self._imageSheet = nil
	end
			
	return searchField
end


-- Function to create a new searchField object ( widget.newSearchField)
function M.new( options, theme )	
	local customOptions = options or {}
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support the searchField widget." )
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
	opt.defaultFrame = customOptions.defaultFrame or require( theme.data ):getFrameIndex( theme.defaultFrame )
	opt.cancelFrame = customOptions.cancelFrame or require( theme.data ):getFrameIndex( theme.cancelFrame )
	opt.defaultFrameWidth = customOptions.defaultFrameWidth or theme.defaultFrameWidth
	opt.defaultFrameHeight = customOptions.defaultFrameHeight or theme.defaultFrameHeight
	opt.cancelFrameWidth = customOptions.cancelFrameWidth or theme.cancelFrameWidth
	opt.cancelFrameHeight = customOptions.cancelFrameHeight or theme.cancelFrameHeight
	
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
	-- Create the searchField
	-------------------------------------------------------
		
	-- Create the searchField object
	local searchField = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_searchField",
		baseDir = opt.baseDir,
	}

	-- Create the searchField
	initWithImage( searchField, opt )
	
	return searchField
end

return M
