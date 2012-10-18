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
local function initWithImage( searchField, options )
	local opt = options
	
	-- If there is an image, don't attempt to use a sheet
	if opt.imageDefault then
		opt.sheet = nil
	end
	
	-- Forward references
	local imageSheet, view, cancelButton, viewTextbox
	
	-- Create the view
	if opt.sheet then
		imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
		view = display.newImageRect( imageSheet, opt.defaultFrame, opt.defaultFrameWidth, opt.defaultFrameHeight )
		cancelButton = display.newImageRect( imageSheet, opt.cancelFrame, opt.cancelFrameWidth, opt.cancelFrameHeight )
	else
		-- There isn't a sheet defined > Use display.newImageRect
		if opt.width and opt.height then
			view = display.newImageRect( opt.imageDefault, opt.defaultFrameWidth, opt.defaultFrameHeight )
			cancelButton = display.newImagRect( opt.imageCancel, opt.defaultFrameWidth, opt.defaultFrameHeight )
		else
			-- There is no width/height specified > Use display.newImage
			view = display.newImage( opt.imageDefault, true )
			cancelButton = display.newImage( opt.imageCancel, true )
		end
	end
	
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
	
	-- TEST CODE
	local resultsText = {}
	resultsText[1] = display.newText( "Results:", 0, 0, display.contentWidth - 20, display.contentHeight, native.systemFontBold, 18 )
	resultsText[1]:setTextColor( 0 )
	resultsText[1].x = display.contentCenterX
	resultsText[1].y = 500
	--END TEST CODE
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to listen for textbox events
	function viewTextbox:_inputListener( event )
		if event.phase == "began" then
			-- user begins editing textBox
			
	
		elseif event.phase == "ended" then
			-- do something with textBox's text
	
		elseif event.phase == "editing" then
			-- TEST CODE
			-- Remove old results
			for i = 2, #resultsText do
				display.remove( resultsText[i] )
				resultsText[i] = nil
			end
			--END TEST CODE
			
			-- Loop through the passed in table and see if we find any results
			for i = 1, #opt.searchInTable do
				if string.find( string.lower( opt.searchInTable[i] ), string.lower( event.text  ) ) then
					if string.len( event.text ) > 0 then
						--print( "found:", opt.searchInTable[i], "in searchInTable" )
						
						-- TEST CODE
						-- Add new result
						resultsText[#resultsText +1] = display.newText( opt.searchInTable[i], 0, 0, display.contentWidth - 20, display.contentHeight, native.systemFontBold, 18 )
						resultsText[#resultsText]:setTextColor( 0 )
						resultsText[#resultsText].x = display.contentCenterX
						resultsText[#resultsText].y = resultsText[#resultsText -1].y + 20
						--END TEST CODE
					end
				end
			end
		end
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
