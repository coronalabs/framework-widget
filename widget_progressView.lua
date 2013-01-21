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
	
	local view = progressView
	
	-- Forward references
	local imageSheet, view, viewBorderLeft, viewBorderMiddle, viewBorderRight, viewFillLeft, viewFillMiddle, viewFillRight
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, require( opt.themeData ):getSheet() )
	end
	
	-- The view is the segmentedControl (group)
	view = progressView
	
	-- Create the view
	viewOuterLeft = display.newImageRect( progressView, imageSheet, opt.fillOuterLeftFrame, opt.fillOuterWidth, opt.fillOuterHeight )
	viewOuterMiddle = display.newImageRect( progressView, imageSheet, opt.fillOuterMiddleFrame, opt.fillOuterWidth, opt.fillOuterHeight )
	viewOuterRight = display.newImageRect( progressView, imageSheet, opt.fillOuterRightFrame, opt.fillOuterWidth, opt.fillOuterHeight )
	
	-- The left rounded edge of the progress fill
	viewFillLeft = display.newImageRect( progressView, imageSheet, opt.fillInnerLeftFrame, opt.fillWidth, opt.fillHeight )
	
	-- The middle progress fill image
	viewFillMiddle = display.newImageRect( progressView, imageSheet, opt.fillInnerMiddleFrame, opt.fillWidth, opt.fillHeight )
	
	-- The right rounded edge of the progress fill
	viewFillRight = display.newImageRect( progressView, imageSheet, opt.fillInnerRightFrame, opt.fillWidth, opt.fillHeight )
	
	-- Properties
	local rangeFactor = 100
	local availableMoveSpace = opt.width - opt.padding
	local moveFactor = availableMoveSpace / rangeFactor
	local currentPercent = ( availableMoveSpace / rangeFactor ) * ( rangeFactor )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Properties
	view._isAnimated = opt.isAnimated
	view._currentProgress = 0.00
	
	-- Set the left fills position
	viewFillLeft.x = progressView.x + ( viewFillLeft.contentWidth * 0.5 ) + opt.fillXOffset
	viewFillLeft.y = progressView.y + ( viewFillLeft.contentHeight * 0.5 ) + opt.fillYOffset

	-- OUTER LEFT
	viewOuterLeft.x = progressView.x + ( viewOuterLeft.contentWidth * 0.5 )
	viewOuterLeft.y = progressView.y + ( viewOuterLeft.contentHeight * 0.5 )

	-- Set the fill's initial width
	viewFillMiddle.width = 1
	viewFillMiddle.x = viewFillLeft.x + viewFillMiddle.width * 0.5
	viewFillMiddle.y = progressView.y + ( viewFillMiddle.contentHeight * 0.5 ) + opt.fillYOffset
	
	-- OUTER MIDDLE
	viewOuterMiddle.width = ( opt.width - viewOuterLeft.width ) 
	if opt.fillXOffset and opt.fillXOffset > 0 then
		viewOuterMiddle.width = viewOuterMiddle.width + opt.padding
	end
	viewOuterMiddle.x = viewOuterLeft.x + ( ( viewOuterLeft.contentWidth * 0.5 ) + ( viewOuterMiddle.width * 0.5 ) )
	viewOuterMiddle.y = progressView.y + ( viewOuterMiddle.contentHeight * 0.5 )
	
	-- Set the right fills position
	viewFillRight.x = viewFillLeft.x + viewFillMiddle.width + ( viewFillRight.contentWidth * 0.5 )
	viewFillRight.y = progressView.y + ( viewFillRight.contentHeight * 0.5 ) + opt.fillYOffset
	
	-- OUTER RIGHT
	viewOuterRight.x = viewOuterMiddle.x + viewOuterMiddle.contentWidth * 0.5
	viewOuterRight.y = progressView.y + ( viewOuterRight.contentHeight * 0.5 )
	
	-------------------------------------------------------
	-- Assign objects to the view
	-------------------------------------------------------
	
	-- Outer frame
	view._outerLeft = viewOuterLeft
	view._outerMiddle = viewOuterMiddle
	view._outerRight = viewOuterRight
	
	-- Inner fill
	view._fillLeft = viewFillLeft
	view._fillMiddle = viewFillMiddle
	view._fillRight = viewFillRight
	
	-- Offsets
	view._fillXOffset = opt.fillXOffset
	view._fillYOffset = opt.fillYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the progressView
	-------------------------------------------------------
	
	-- Assign objects to the progressView
	progressView._imageSheet = imageSheet
	progressView._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the progressView's current progress (ie fill)
	function progressView:setProgress( progress )
		-- Create a local reference to the view
		local view = self._view
		
		-- If the progress is more than 100% just return
		if progress > 1.0 then
			return
		end

		-- Reset the bar if requested
		if progress <= 0 then
			view._fillLeft.isVisible = false
			view._fillMiddle.width = 1
			view._fillMiddle.isVisible = false
			view._fillRight.isVisible = false
			return
		elseif progress >= 0.1 then
			view._fillLeft.isVisible = true
			view._fillMiddle.isVisible = true
			view._fillRight.isVisible = true
		end
		
		-- Only execute this if the progressView's view hasn't been removed
		if view then
			-- While the progress is less than the user specified progress, increase by 0.01
			while view._currentProgress < progress do
				local hasReachedLimit = view._currentProgress > 1.0
				
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

	-- Function to get the progressView's current progress
	function progressView:getProgress()
		return self._currentProgress
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
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
			
	return progressView
end


-- Function to create a new progressView object ( widget.newProgressView )
function M.new( options, theme )	
	local customOptions = options or {}
	local themeOptions = theme or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- Check if the requirements for creating a widget has been met (throws an error if not)
	require( "widget" )._checkRequirements( customOptions, themeOptions, M._widgetName )
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------	
	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.width = customOptions.width or error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
	
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.isAnimated = customOptions.isAnimated or false
	opt.fillXOffset = customOptions.fillXOffset or themeOptions.fillXOffset or 0
	opt.fillYOffset = customOptions.fillYOffset or themeOptions.fillYOffset or 0
	opt.padding = customOptions.padding or themeOptions.fillOuterWidth or 0
	
	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	opt.fillWidth = customOptions.fillWidth or themeOptions.fillWidth or error( "ERROR: " .. M._widgetName .. ": fillWidth expected, got nil", 3 )
	opt.fillHeight = customOptions.fillHeight or themeOptions.fillHeight or error( "ERROR: " .. M._widgetName .. ": fillHeight expected, got nil", 3 )
	
	opt.fillOuterWidth = customOptions.fillOuterWidth or themeOptions.fillOuterWidth or error( "ERROR: " .. M._widgetName .. ": outerWidth expected, got nil", 3 )
	opt.fillOuterHeight = customOptions.fillOuterHeight or themeOptions.fillOuterHeight or error( "ERROR: " .. M._widgetName .. ": outerHeight expected, got nil", 3 )
	
	opt.fillOuterLeftFrame = customOptions.fillOuterLeftFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.fillOuterLeftFrame )
	opt.fillOuterMiddleFrame = customOptions.fillOuterMiddleFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.fillOuterMiddleFrame )
	opt.fillOuterRightFrame = customOptions.fillOuterRightFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.fillOuterRightFrame )
	
	opt.fillInnerLeftFrame = customOptions.fillInnerLeftFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.fillInnerLeftFrame )
	opt.fillInnerMiddleFrame = customOptions.fillInnerMiddleFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.fillInnerMiddleFrame )
	opt.fillInnerRightFrame = customOptions.fillInnerRightFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.fillInnerRightFrame )
	
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
	
	-- Set the progressView's position ( set the reference point to center, just to be sure )
	progressView:setReferencePoint( display.CenterReferencePoint )
	progressView.x = opt.left + progressView.contentWidth * 0.5
	progressView.y = opt.top + progressView.contentHeight * 0.5
	
	return progressView
end

return M
