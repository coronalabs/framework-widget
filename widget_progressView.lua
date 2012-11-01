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
	local imageSheet, view, viewFillLeft, viewFillMiddle, viewFillRight
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	view = display.newImageRect( imageSheet, opt.fillOuterFrame, opt.fillOuterWidth, opt.fillOuterHeight )
	
	-- The middle progress fill image
	viewFillMiddle = display.newImageRect( imageSheet, opt.fillInnerMiddleFrame, opt.fillInnerMiddleWidth, opt.fillInnerMiddleHeight )
	
	-- The left rounded edge of the progress fill
	viewFillLeft = display.newImageRect( imageSheet, opt.fillInnerLeftFrame, opt.fillInnerLeftWidth, opt.fillInnerLeftHeight )
	
	-- The right rounded edge of the progress fill
	viewFillRight = display.newImageRect( imageSheet, opt.fillInnerRightFrame, opt.fillInnerRightWidth, opt.fillInnerRightHeight )
	
	-- Properties
	local rangeFactor = 100
	local availableMoveSpace = view.width - viewFillLeft.width - viewFillRight.width
	local moveFactor = availableMoveSpace / rangeFactor
	local currentPercent = ( availableMoveSpace / rangeFactor ) * ( rangeFactor )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Properties
	view._isAnimated = opt.isAnimated
	view._currentProgress = 0.00
	
	-- Set the left fills position
	viewFillLeft.x = - view.contentWidth * 0.5 + viewFillLeft.contentWidth * 0.5 + opt.fillXOffset

	-- Set the fill's initial width
	viewFillMiddle.width = 1
	viewFillMiddle.x = viewFillLeft.x + viewFillMiddle.width * 0.5
	
	-- Set the right fills position
	viewFillRight.x = viewFillLeft.x + viewFillMiddle.width + viewFillRight.contentWidth * 0.5
	
	-- Objects
	view._fillMiddle = viewFillMiddle
	view._fillLeft = viewFillLeft
	view._fillRight = viewFillRight
	view._fillXOffset = opt.fillXOffset
	view._fillYOffset = opt.fillYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the progressView
	-------------------------------------------------------
	
	-- Assign objects to the progressView
	progressView._imageSheet = imageSheet
	progressView._view = view

	-- Insert the view into the parent group
	progressView:insert( view )
	progressView:insert( view._fillMiddle )
	progressView:insert( view._fillLeft )
	progressView:insert( view._fillRight )
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the progressView's current progress (ie fill)
	function progressView:setProgress( progress )
		-- Create a local reference to the view
		local view = self._view
		
		-- Only execute this if the progressView's view hasn't been removed
		if view then
			-- While the progress is less than the user specified progress, increase by 0.01
			while view._currentProgress < progress do
				local hasReachedLimit = view._currentProgress >= 1.0
				
				-- Increment the current progress
				view._currentProgress = view._currentProgress + 0.01
				
				-- If we haven't reached the limit yet (1.0) increase the fill
				if not hasReachedLimit then
					-- Set the current fill %
					currentPercent = ( availableMoveSpace / rangeFactor ) * ( view._currentProgress * rangeFactor ) + view._fillXOffset
				end	
			end
			
			-- If the fill is animated
			if view._isAnimated then
				transition.to( view._fillMiddle, { width = currentPercent, x = view._fillLeft.x + currentPercent * 0.5 } )
				transition.to( view._fillRight, { x = math.floor( view._fillLeft.x + currentPercent + view._fillRight.contentWidth * 0.5  ) } )
			else
			-- The fill isn't animated
				view._fillMiddle.width = currentPercent
				view._fillMiddle.x = view._fillLeft.x + currentPercent * 0.5
				view._fillRight.x = math.floor( view._fillLeft.x + currentPercent + view._fillRight.contentWidth * 0.5  )
			end
		end
 	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function for the progressView
	function progressView:_finalize()
		self._view._fillMiddle = nil
		self._view._fillLeft = nil
		self._view._fillRight = nil
		self._view = nil
		
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
	opt.isAnimated = customOptions.isAnimated or false
	opt.fillXOffset = customOptions.fillXOffset or theme.fillXOffset or 0
	opt.fillYOffset = customOptions.fillYOffset or theme.fillYOffset or 0
	
	-- Frames & Images
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.fillOuterFrame = customOptions.fillOuterFrame or require( theme.data ):getFrameIndex( theme.fillOuterFrame )
	opt.fillOuterWidth = customOptions.fillOuterWidth or theme.fillOuterWidth
	opt.fillOuterHeight = customOptions.fillOuterHeight or theme.fillOuterHeight
	
	opt.fillInnerLeftFrame = customOptions.fillInnerLeftFrame or require( theme.data ):getFrameIndex( theme.fillInnerLeftFrame )
	opt.fillInnerLeftWidth = customOptions.fillInnerLeftWidth or theme.fillInnerLeftWidth
	opt.fillInnerLeftHeight = customOptions.fillInnerLeftHeight or theme.fillInnerLeftHeight
	
	opt.fillInnerMiddleFrame = customOptions.fillInnerMiddleFrame or require( theme.data ):getFrameIndex( theme.fillInnerMiddleFrame )
	opt.fillInnerMiddleWidth = customOptions.fillInnerMiddleWidth or theme.fillInnerMiddleWidth
	opt.fillInnerMiddleHeight = customOptions.fillInnerMiddleHeight or theme.fillInnerMiddleHeight
	
	opt.fillInnerRightFrame = customOptions.fillInnerRightFrame or require( theme.data ):getFrameIndex( theme.fillInnerRightFrame )
	opt.fillInnerRightWidth = customOptions.fillInnerRightWidth or theme.fillInnerRightWidth
	opt.fillInnerRightHeight = customOptions.fillInnerRightHeight or theme.fillInnerRightHeight
	
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
	local hasProvidedOuterSize = opt.fillOuterWidth and opt.fillOuterHeight
	local hasProvidedInnerSize = opt.fillInnerLeftWidth and opt.fillInnerLeftHeight and opt.fillInnerMiddleWidth and opt.fillInnerMiddleHeight and opt.fillInnerRightWidth and opt.fillInnerRightHeight
	
	if not hasProvidedOuterSize and not hasProvidedInnerSize then
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
