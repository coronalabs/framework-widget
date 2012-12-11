--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_slider.lua
		
	What is it?: 
		A widget object that can be used to replicate native sliders.
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newSlider",
}

-- Creates a new horizontal slider from an imageSheet
local function createHorizontalSlider( slider, options )
	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local imageSheet, view, viewLeft, viewRight, viewMiddle, viewFill, viewHandle
		
	-- Create the view
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- The view is the slider (group)
	view = slider
	
	-- The slider's left frame
	viewLeft = display.newImageRect( slider, imageSheet, opt.leftFrame, opt.frameWidth, opt.frameHeight )
	
	-- The slider's middle frame
	viewMiddle = display.newImageRect( slider, imageSheet, opt.middleFrame, opt.frameWidth, opt.frameHeight )
	
	-- The slider's right frame
	viewRight = display.newImageRect( slider, imageSheet, opt.rightFrame, opt.frameWidth, opt.frameHeight )
	
	-- The slider's fill
	viewFill = display.newImageRect( slider, imageSheet, opt.fillFrame, opt.frameWidth, opt.frameHeight )
	
	-- The slider's handle
	viewHandle = display.newImageRect( slider, imageSheet, opt.handleFrame, opt.handleWidth, opt.handleHeight )
	
	-------------------------------------------------------
	-- Positioning
	-------------------------------------------------------
	
	-- Position the slider's left frame
	viewLeft.x = slider.x + ( viewLeft.contentWidth * 0.5 )
	viewLeft.y = slider.y + ( viewLeft.contentHeight * 0.5 )
	
	-- Position the slider's middle frame & set it's width
	viewMiddle.width = opt.width - ( viewLeft.contentWidth + viewRight.contentWidth )
	viewMiddle.x = viewLeft.x + ( viewLeft.contentWidth * 0.5 ) + ( viewMiddle.width * 0.5 )
	viewMiddle.y = viewLeft.y
	
	-- Position the slider's fill	
	viewFill.width = ( viewMiddle.width / 100 ) * opt.defaultValue
	viewFill.x = viewLeft.x + ( viewLeft.contentWidth * 0.5 ) + ( viewFill.width * 0.5 )
	viewFill.y = viewLeft.y
	
	-- Position the slider's right frame
	viewRight.x = viewMiddle.x + ( viewMiddle.contentWidth * 0.5 )
	viewRight.y = viewLeft.y
	
	-- Position the slider's handle
	viewHandle.x = viewFill.x + ( viewFill.width * 0.5 )
	viewHandle.y = viewLeft.y
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	view._left = viewLeft
	view._right = viewRight
	view._fill = viewFill
	view._handle = viewHandle
	view._currentPercent = 0
	view._width = opt.width
	view._listener = opt.listener
	
	-------------------------------------------------------
	-- Assign properties/objects to the slider
	-------------------------------------------------------
	
	-- Assign objects to the slider
	slider._imageSheet = imageSheet
	slider._view = view	
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------

	function view:touch( event )
		local phase = event.phase
		-- Set the target to the handle
		event.target = self._handle
	
		if "began" == phase then
			-- Did the touch begin on the Handle?
			local touchBeganOnHandle = event.x >= self._handle.x - ( self._handle.width * 0.5 ) and event.x <= self._handle.x + ( self._handle.width * 0.5 )
			
			-- If the touch began on the handle
			if touchBeganOnHandle then
				display.getCurrentStage():setFocus( event.target, event.id )
				self._isFocus = true
			
				-- Store the initial position
				self._handle.x0 = event.x - self._handle.x
			end
			
		elseif self._isFocus then
			if "moved" == phase then
				self._handle.x = event.x - self._handle.x0
								
				if self._handle.x <= self._left.x then
					self._handle.x = self._left.x
				elseif self._handle.x >= self._right.x then
					self._handle.x = self._right.x
				end
								
				-- Check the handle's position relative to the slider's width
				local handlePosition = self._handle.x - self._left.x
				local fillXPos = self._left.x + ( handlePosition * 0.5 )

				-- Calculate the current percent
				self._currentPercent = ( handlePosition * 100 ) / ( self._width - self._left.contentWidth - ( self._right.contentWidth * 0.5 ) )
				
				-- Set the fill's width & position
				self._fill.width = handlePosition
				self._fill.x = fillXPos
			
			elseif "ended" == phase or "cancelled" == phase then
				-- Remove focus
				display.getCurrentStage():setFocus( nil )
				self._isFocus = false
			end
			
			-- Execute the listener ( if any )
			if self._listener then
				event.value = math.round( self._currentPercent )
				self._listener( event )
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	-- Finalize function for the slider
	function slider:_finalize()
		-- Set slider's ImageSheet to nil
		self._imageSheet = nil
	end
			
	return slider
end


-- Function to create a new Slider object ( widget.newSlider )
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
	opt.width = customOptions.width or themeOptions.width --or error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
	opt.height = customOptions.height or themeOptions.height --or error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.defaultValue = customOptions.value or 50
	opt.orientation = customOptions.orientation or "horizontal"
	opt.listener = customOptions.listener
	
	-- Frames & Images
	opt.sheet = customOptions.sheet or themeOptions.sheet
	opt.sheetData = customOptions.data or themeOptions.data
	opt.leftFrame = customOptions.leftFrame or require( themeOptions.data ):getFrameIndex( themeOptions.leftFrame )
	opt.rightFrame = customOptions.rightFrame or require( themeOptions.data ):getFrameIndex( themeOptions.rightFrame )
	opt.middleFrame = customOptions.middleFrame or require( themeOptions.data ):getFrameIndex( themeOptions.middleFrame )
	opt.fillFrame = customOptions.fillFrame or require( themeOptions.data ):getFrameIndex( themeOptions.fillFrame )
	opt.frameWidth = customOptions.frameWidth or themeOptions.frameWidth
	opt.frameHeight = customOptions.frameHeight or themeOptions.frameHeight
	opt.handleFrame = customOptions.handleFrame or require( themeOptions.data ):getFrameIndex( themeOptions.handleFrame )
	opt.handleWidth = customOptions.handleWidth or theme.handleWidth
	opt.handleHeight = customOptions.handleHeight or theme.handleHeight
	
	-------------------------------------------------------
	-- Create the slider
	-------------------------------------------------------
		
	-- Create the slider object
	local slider = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_slider",
		baseDir = opt.baseDir,
	}

	-- Create the slider
	if "horizontal" == opt.orientation then
		createHorizontalSlider( slider, opt )
	else
		
	end
	
	-- Set the slider's position ( set the reference point to center, just to be sure )
	slider:setReferencePoint( display.CenterReferencePoint )
	slider.x = opt.left + slider.contentWidth * 0.5
	slider.y = opt.top + slider.contentHeight * 0.5
	
	slider._currentPosition = opt.defaultValue
	
	return slider
end

return M
