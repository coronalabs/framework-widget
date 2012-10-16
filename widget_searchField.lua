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
}

-- Creates a new search field from an image
local function initWithImage( self, options ) -- Self == searchField (group)
	local opt = options
	
	-- If there is an image, don't attempt to use a sheet
	if opt.imageDefault then
		opt.sheet = nil
	end
	
	-- Forward references
	local imageSheet, view
	
	-- Create the view
	if opt.sheet then
		imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
		view = display.newImageRect( imageSheet, opt.defaultFrame, opt.defaultFrameWidth, opt.defaultFrameHeight )
		view.cancel = display.newImageRect( imageSheet, opt.cancelFrame, opt.cancelFrameWidth, opt.cancelFrameHeight )
	else
		-- There isn't a sheet defined > Use display.newImageRect
		if opt.width and opt.height then
			view = display.newImageRect( opt.imageDefault, opt.defaultFrameWidth, opt.defaultFrameHeight )
			view.cancel = display.newImagRect( opt.imageCancel, opt.defaultFrameWidth, opt.defaultFrameHeight )
		else
			-- There is no width/height specified > Use display.newImage
			view = display.newImage( opt.imageDefault, true )
			view = display.newImage( opt.imageCancel, true )
		end
	end
	
	-- Set the cancel buttons position
	local parent = self
	view.cancel.x = parent.x + view.contentWidth * 0.4
	view.cancel.y = parent.y
	view.cancel.isVisible = false
	
	-- Test
	local resultsText = {}
	resultsText[1] = display.newText( "Results:", 0, 0, display.contentWidth - 20, display.contentHeight, native.systemFontBold, 18 )
	resultsText[1]:setTextColor( 0 )
	resultsText[1].x = display.contentCenterX
	resultsText[1].y = 500
	
	function view:inputListener( event )
		if event.phase == "began" then
			-- user begins editing textBox
			
	
		elseif event.phase == "ended" then
			-- do something with textBox's text
	
		elseif event.phase == "editing" then
			-- Remove old results
			for i = 2, #resultsText do
				display.remove( resultsText[i] )
				resultsText[i] = nil
			end
			
			for i = 1, #opt.searchInTable do
				if string.find( string.lower( opt.searchInTable[i] ), string.lower( event.text  ) ) then
					if string.len( event.text ) > 0 then
						--print( "found:", opt.searchInTable[i], "in searchInTable" )
						
						-- Add new result
						resultsText[#resultsText +1] = display.newText( opt.searchInTable[i], 0, 0, display.contentWidth - 20, display.contentHeight, native.systemFontBold, 18 )
						resultsText[#resultsText]:setTextColor( 0 )
						resultsText[#resultsText].x = display.contentCenterX
						resultsText[#resultsText].y = resultsText[#resultsText -1].y + 20
					end
				end
			end
		end
	end
	
	view.textBox = native.newTextBox( 0, 0, view.contentWidth - 36, view.contentHeight - 18 )
	view.textBox.x = view.x + 12
	view.textBox.y = view.y + 1
	view.textBox.isEditable = true
	view.textBox.hasBackground = false
	view.textBox.align = "left"
	view.textBox.text = "Search iPhone"
	view.textBox:addEventListener( "userInput", view )
	
	-- Finalize function
	function self:_finalize()
		-- Set searchField imageSheet to nil
		self._view._imageSheet = nil
	end

	-- We need to assign these properties to the object
	view._imageSheet = imageSheet

	-- Assign the view to self's view
	self._view = view
	self._view.cancel = view.cancel

	-- Insert the view into the parent group
	self:insert( view )
	-- Insert the textbox into the parent group
	self:insert( view.textBox )
			
	return self
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

	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.defaultFrameWidth = customOptions.defaultFrameWidth or theme.defaultFrameWidth
	opt.defaultFrameHeight = customOptions.defaultFrameHeight or theme.defaultFrameHeight
	opt.cancelFrameWidth = customOptions.cancelFrameWidth or theme.cancelFrameWidth
	opt.cancelFrameHeight = customOptions.cancelFrameHeight or theme.cancelFrameHeight
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.imageDefault = customOptions.image
	opt.imageCancel = customOptions.imageCancel
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.defaultFrame = customOptions.defaultFrame or require( theme.data ):getFrameIndex( theme.defaultFrame )
	opt.cancelFrame = customOptions.cancelFrame or require( theme.data ):getFrameIndex( theme.cancelFrame )
	opt.searchInTable = customOptions.searchInTable
	
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
