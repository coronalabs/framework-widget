--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_searchField.lua
		
	What is it?: 
		A widget object that can be used to present a searchField widget.
	
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
	local imageSheet, view, cancelButton, viewTextField
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	view = display.newImageRect( imageSheet, opt.defaultFrame, opt.defaultFrameWidth, opt.defaultFrameHeight )

	-- The SearchFields cancel button
	cancelButton = display.newImageRect( imageSheet, opt.cancelFrame, opt.cancelFrameWidth, opt.cancelFrameHeight )
	
	-- Create the textbox (that is contained within the searchField)
	viewTextField = native.newTextField( 0, 0, opt.textFieldWidth, opt.textFieldHeight )
	viewTextField:setReferencePoint( display.TopLeftReferencePoint )
	viewTextField.x = searchField.x + opt.textFieldXOffset
	viewTextField.y = searchField.y + opt.textFieldYOffset
	viewTextField.isEditable = true
	viewTextField.hasBackground = false
	viewTextField.align = "left"
	viewTextField.placeholder = opt.placeholder
	viewTextField._listener = opt.listener
	
	-- Set the cancel buttons position
	cancelButton.x = view.contentWidth * 0.4 + opt.cancelButtonXOffset
	cancelButton.y = opt.cancelButtonYOffset
	cancelButton.isVisible = false
	
	-- Objects
	view._textField = viewTextField
	view._cancelButton = cancelButton
	
	-------------------------------------------------------
	-- Assign properties/objects to the searchField
	-------------------------------------------------------
	
	searchField._imageSheet = imageSheet
	searchField._view = view

	-- Insert the view into the searchField (group)
	searchField:insert( view )
	searchField:insert( view._cancelButton )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Handle touch events on the Cancel button
	function cancelButton:touch( event )
		local phase = event.phase
		
		if "ended" == phase then
			-- Clear any text in the textField
			view._textField.text = ""
			
			-- Hide the cancel button
			view._cancelButton.isVisible = false
		end
		
		return true
	end
	
	cancelButton:addEventListener( "touch" )
	
	-- Handle tap events on the Cancel button
	function cancelButton:tap( event )
		-- Clear any text in the textField
		view._textField.text = ""
		
		-- Hide the cancel button
		view._cancelButton.isVisible = false
		
		return true
	end
	
	cancelButton:addEventListener( "tap" )
	
	-- Function to listen for textbox events
	function viewTextField:_inputListener( event )
		local phase = event.phase
		
		if "editing" == phase then
			-- If there is one or more characters in the textField show the cancel button, if not hide it
			if string.len( event.text ) >= 1 then
				view._cancelButton.isVisible = true
			else
				view._cancelButton.isVisible = false
			end
		
		elseif "submitted" == phase then
			-- Hide keyboard
			native.setKeyboardFocus( nil )
		end
		
		-- If there is a listener defined, execute it
		if self._listener then
			self._listener( event )
		end
	end
	
	viewTextField.userInput = viewTextField._inputListener
	viewTextField:addEventListener( "userInput" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function
	function searchField:_finalize()
		display.remove( self._view._textField )
		
		self._view._textField = nil
		self._view._cancelButton = nil
		self._view = nil
		
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
	opt.placeholder = customOptions.placeholder or ""
	opt.textFieldXOffset = customOptions.textFieldXOffset or 28
	opt.textFieldYOffset = customOptions.textFieldYOffset or 7
	opt.textFieldWidth = customOptions.textFieldWidth or theme.textFieldWidth
	opt.textFieldHeight = customOptions.textFieldHeight or theme.textFieldHeight
	opt.cancelButtonXOffset = customOptions.cancelButtonXOffset or 0
	opt.cancelButtonYOffset = customOptions.cancelButtonYOffset or 0
	opt.listener = customOptions.listener
	
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
	local hasProvidedSize = opt.defaultFrameWidth and opt.defaultFrameHeight and opt.cancelFrameWidth and opt.cancelFrameHeight
	
	if not hasProvidedSize then
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
	
	-- Set the search field's reference point to "topLeft"
	require( "widget" )._setTopLeftReference( searchField, opt )
	
	return searchField
end

return M
