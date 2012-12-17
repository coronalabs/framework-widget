--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_button.lua
		
	What is it?: 
		A widget object that can be used to create button.
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newButton",
}

-- Creates a new button from a sprite
local function initWithTwoFrameButton( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Animation options
	local sheetOptions = 
	{
		{
			name = "default", 
			start = opt.defaultFrame, 
			count = 1,
		},
		{
			name = "over", 
			start = opt.overFrame, 
			count = 1,
		},
	}
	
	-- Forward references
	local imageSheet, view, viewLabel
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- Create the view
	view = display.newSprite( button, imageSheet, sheetOptions )

	-- Create the label (either embossed or standard)
	if opt.embossedLabel then
		viewLabel = display.newEmbossedText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	else
		viewLabel = display.newText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	end
	
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- The view
	view.x = button.x + ( view.contentWidth * 0.5 )
	view.y = button.y + ( view.contentHeight * 0.5 )
	
	-- Setup the label
	viewLabel:setTextColor( unpack( opt.labelColor.default ) )
	viewLabel._labelColor = opt.labelColor
	viewLabel._isLabel = true
	
	-- Labels position
	if "center" == opt.labelAlign then
		viewLabel.x = button.x + ( view.contentWidth * 0.5 ) + opt.labelXOffset
	elseif "left" == opt.labelAlign then
		viewLabel.x = button.x + ( viewLabel.contentWidth * 0.5 ) + 10 + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = button.x + ( button.contentWidth ) - ( viewLabel.contentWidth * 0.5 ) - 10 + opt.labelXOffset
	end
	
	viewLabel.y = button.y + ( opt.height * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._pressedState = "default"
	view._width = opt.width
	view._fontSize = opt.fontSize
	view._labelAlign = opt.labelAlign
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._imageSheet = imageSheet
	button._view = view
	button._viewLabel = viewLabel
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent

	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	function view:touch( event )
		local phase = event.phase
		
		if "began" == phase then
			-- Set the button to it's over image state
			self:_setState( "over" )
			
			-- If there is a onPress method ( and not a onEvent method )
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
			
			-- Set focus on the button
			self._isFocus = true
			display.getCurrentStage():setFocus( self, event.id )
			
		elseif self._isFocus then
			local bounds = self.contentBounds
	        local x, y = event.x, event.y
	        local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
			
			if "moved" == phase then
				if not isWithinBounds then
					-- Set the button to it's default image state
					self:_setState( "default" )
				else
					if self:_getState() ~= "over" then
						-- Set the button to it's over image state
						self:_setState( "over" )
					end
				end
			
			elseif "ended" == phase or "cancelled" == phase then
				if isWithinBounds then
					-- If there is a onRelease method ( and not a onEvent method )
					if self._onRelease and not self._onEvent then
						self._onRelease( event )
					end
				end
				
				-- Set the button to it's default image state
				self:_setState( "default" )
				
				-- Remove focus from the button
				self._isFocus = false
				display.getCurrentStage():setFocus( nil )
			end
		end
		
		-- If there is a onEvent method ( and not a onPress or onRelease method )
		if self._onEvent and not self._onPress and not self._onRelease then
			self._onEvent( event )
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	-- Function to set the button's label
	function view:setLabel( newLabel )
		self._viewLabel:setText( newLabel )
		self._viewLabel.x = self._viewLabel.x
		self._viewLabel.y = self._viewLabel.y
	end
	
	-- Function to get the button's label
	function view:getLabel()
		print( self._viewLabel.text )
		return self._viewLabel.text
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the buttons current state
	function view:_setState( state )
		local newState = state
		
		if "over" == newState then
			-- Set the button to the over image state
			self:setSequence( "over" )
			
			-- The pressedState is now "over"
			self._pressedState = "over"
		
		elseif "default" == newState then
			-- Set the piece to the default image state
			self:setSequence( "default" )
			
			-- The pressedState is now "default"
			self._pressedState = "default"
		end
	end
	
	-- Function to get the buttons current state
	function view:_getState()
		return self._pressedState
	end
	
	-- Finalize function
	function button:_finalize()
		-- Set buttons ImageSheet to nil
		self._view_imageSheet = nil
	end
	
	return button
end

-- Creates a new button from a 9 piece sprite
local function initWithNinePieceButton( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view
	
	local viewTopLeft, viewMiddleLeft, viewBottomLeft
	local viewTopMiddle, viewMiddle, viewBottomMiddle
	local viewTopRight, viewMiddleRight, viewBottomRight

	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- The view is the button (group)
	view = button
	
	-- Imagesheet options
	local sheetOptions =
	{
		-- Top Left 
		viewTopLeft =
		{
			{
				name = "default",
				start = opt.topLeftFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.topLeftFrameOver,
				count = 1,
			}
		},
		
		-- Middle Left
		viewMiddleLeft =
		{
			{
				name = "default",
				start = opt.middleLeftFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.middleLeftFrameOver,
				count = 1,
			}
		},
		
		-- Bottom Left
		viewBottomLeft =
		{
			{
				name = "default",
				start = opt.bottomLeftFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.bottomLeftFrameOver,
				count = 1,
			}
		},
		
		-- Top Middle
		viewTopMiddle =
		{
			{
				name = "default",
				start = opt.topMiddleFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.topMiddleOverFrame,
				count = 1,
			}
		},
		
		-- Middle
		viewMiddle =
		{
			{
				name = "default",
				start = opt.middleFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.middleOverFrame,
				count = 1,
			}
		},
		
		-- Bottom Middle
		viewBottomMiddle =
		{
			{
				name = "default",
				start = opt.bottomMiddleFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.bottomMiddleOverFrame,
				count = 1,
			}
		},
		
		
		-- Top Right
		viewTopRight =
		{
			{
				name = "default",
				start = opt.topRightFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.topRightFrameOver,
				count = 1,
			}
		},
		
		-- Middle Right
		viewMiddleRight =
		{
			{
				name = "default",
				start = opt.middleRightFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.middleRightOverFrame,
				count = 1,
			}
		},
		
		-- Bottom Right
		viewBottomRight =
		{
			{
				name = "default",
				start = opt.bottomRightFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.bottomRightOverFrame,
				count = 1,
			}
		},
	}
	
	
	-- Create the left portion of the button
	viewTopLeft = display.newSprite( button, imageSheet, sheetOptions.viewTopLeft )
	viewMiddleLeft = display.newSprite( button, imageSheet, sheetOptions.viewMiddleLeft )
	viewBottomLeft = display.newSprite( button, imageSheet, sheetOptions.viewBottomLeft )

	-- Create the right portion of the button
	viewTopRight = display.newSprite( button, imageSheet, sheetOptions.viewTopRight )
	viewMiddleRight = display.newSprite( button, imageSheet, sheetOptions.viewMiddleRight )
	viewBottomRight = display.newSprite( button, imageSheet, sheetOptions.viewBottomRight )
	
	-- Create the middle portion of the button
	viewTopMiddle = display.newSprite( button, imageSheet, sheetOptions.viewTopMiddle )
	viewMiddle = display.newSprite( button, imageSheet, sheetOptions.viewMiddle )
	viewBottomMiddle = display.newSprite( button, imageSheet, sheetOptions.viewBottomMiddle )
	
	-- Create the label (either embossed or standard)
	if opt.embossedLabel then
		viewLabel = display.newEmbossedText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	else
		viewLabel = display.newText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	end
	
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- Top
	viewTopLeft.x = button.x + ( viewTopLeft.contentWidth * 0.5 )
	viewTopLeft.y = button.y + ( viewTopLeft.contentHeight * 0.5 )
	
	viewTopMiddle.width = opt.width - ( viewTopLeft.contentWidth + viewTopRight.contentWidth )
	viewTopMiddle.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewTopMiddle.contentWidth * 0.5 )
	viewTopMiddle.y = viewTopLeft.y
	viewTopMiddle._width = viewTopMiddle.width
	
	viewTopRight.x = viewTopMiddle.x + ( viewTopMiddle.contentWidth * 0.5 ) + ( viewTopRight.contentWidth * 0.5 )
	viewTopRight.y = viewTopLeft.y
	
	-- Middle
	viewMiddleLeft.height = opt.height - ( viewTopLeft.contentHeight + viewTopRight.contentHeight )
	viewMiddleLeft.x = viewTopLeft.x
	viewMiddleLeft.y = viewTopLeft.y + ( viewMiddleLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )
	viewMiddleLeft._height = viewMiddleLeft.height
	
	viewMiddle.width = viewTopMiddle.width
	viewMiddle.height = opt.height - ( viewTopLeft.contentHeight + ( viewTopRight.contentHeight * 0.5 ) )
	viewMiddle.x = viewTopMiddle.x
	viewMiddle.y = viewTopMiddle.y + ( viewTopMiddle.contentHeight * 0.5 ) + ( viewMiddle.contentHeight * 0.5 )
	viewMiddle._width = viewMiddle.width
	viewMiddle._height = viewMiddle.height
	
	viewMiddleRight.height = opt.height - ( viewTopLeft.contentHeight + viewTopRight.contentHeight )
	viewMiddleRight.x = viewTopRight.x
	viewMiddleRight.y = viewTopRight.y + ( viewMiddleRight.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
	viewMiddleRight._height = viewMiddleRight.height
	
	-- Bottom
	viewBottomLeft.x = viewTopLeft.x
	viewBottomLeft.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 )
	
	viewBottomMiddle.width = viewTopMiddle.width
	viewBottomMiddle.x = viewTopMiddle.x
	viewBottomMiddle.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 )
	viewBottomMiddle._width = viewBottomMiddle.width
	
	viewBottomRight.x = viewTopRight.x
	viewBottomRight.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 )

	-- If the passed width is less than the topLeft & top right width then don't use the middle pieces
	if opt.width <= ( viewTopLeft.contentWidth + viewTopRight.contentWidth ) then
		viewTopMiddle.isVisible = false
		viewMiddle.isVisible = false
		viewBottomMiddle.isVisible = false
		
		viewTopRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
		viewMiddleRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
		viewBottomRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
	end
	
	-- If the passed height is less than the topLeft & top right height then don't use the middle pieces
	if opt.height <= ( viewTopLeft.contentHeight + viewTopRight.contentHeight ) then
		viewMiddleRight.isVisible = false
		viewMiddleLeft.isVisible = false
		viewMiddle.isVisible = false
		viewTopMiddle.isVisible = false
		viewBottomMiddle.isVisible = false
		
		viewBottomLeft.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )
		viewBottomRight.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
	end


	-- Setup the Label
	viewLabel:setTextColor( unpack( opt.labelColor.default ) )
	viewLabel._labelColor = opt.labelColor
	viewLabel._isLabel = true
	
	-- Label's position
	if "center" == opt.labelAlign then
		viewLabel.x = button.x + ( opt.width * 0.5 ) + opt.labelXOffset   
	elseif "left" == opt.labelAlign then
		viewLabel.x = viewTopLeft.x + ( viewLabel.contentWidth * 0.5 ) + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = viewTopRight.x - ( viewLabel.contentWidth * 0.5 ) + opt.labelXOffset
	end
	
	viewLabel.y = button.y + ( opt.height * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._pressedState = "default"
	view._width = opt.width
	view._fontSize = opt.fontSize
	view._labelAlign = opt.labelAlign
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._imageSheet = imageSheet
	button._view = view
	button._topLeft = viewTopLeft
	button._middleLeft = viewMiddleLeft
	button._bottomLeft = viewBottomLeft
	button._topMiddle = viewTopMiddle
	button._middle = viewMiddle
	button._bottomMiddle = viewBottomMiddle
	button._topRight = viewTopRight
	button._middleRight = viewMiddleRight
	button._bottomRight = viewBottomRight
	button._viewLabel = viewLabel
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	function view:touch( event )
		local phase = event.phase
		
		if "began" == phase then
			-- Set the button to it's over image state
			self:_setState( "over" )
			
			-- If there is a onPress method ( and not a onEvent method )
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
			
			-- Set focus on the button
			self._isFocus = true
			display.getCurrentStage():setFocus( self, event.id )
			
		elseif self._isFocus then
			local bounds = self.contentBounds
	        local x, y = event.x, event.y
	        local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
			
			if "moved" == phase then
				if not isWithinBounds then
					-- Set the button to it's default image state
					self:_setState( "default" )
				else
					if self:_getState() ~= "over" then
						-- Set the button to it's over image state
						self:_setState( "over" )
					end
				end
			
			elseif "ended" == phase or "cancelled" == phase then
				if isWithinBounds then
					-- If there is a onRelease method ( and not a onEvent method )
					if self._onRelease and not self._onEvent then
						self._onRelease( event )
					end
				end
				
				-- Set the button to it's default image state
				self:_setState( "default" )
				
				-- Remove focus from the button
				self._isFocus = false
				display.getCurrentStage():setFocus( nil )
			end
		end
		
		-- If there is a onEvent method ( and not a onPress or onRelease method )
		if self._onEvent and not self._onPress and not self._onRelease then
			self._onEvent( event )
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	-- Function to set the button's label
	function view:setLabel( newLabel )
		self._viewLabel:setText( newLabel )
		self._viewLabel.x = self._viewLabel.x
		self._viewLabel.y = self._viewLabel.y
	end
	
	-- Function to get the button's label
	function view:getLabel()
		return self._viewLabel.text
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the buttons current state
	function view:_setState( state )
		local newState = state
		
		if "over" == newState then
			-- Loop through the pieces and set them to the over image state
			for i = self.numChildren, 1, - 1 do
				local child = self[i]
				
				-- If the child is a label then set it's color
				if child._isLabel then
					child:setTextColor( unpack( child._labelColor.over ) )
				
				-- The child is a button piece 
				else
					-- Set the piece to the over image state
					child:setSequence( "over" )
				
					-- Set the width again. ( should i have to do this, a possible Corona bug? )
					if child._width then
						child.width = child._width
					end
				
					-- Set the height again. ( should i have to do this, a possible Corona bug? )
					if child._height then
						child.height = child._height
					end
				end
			end
			
			-- The pressedState is now "over"
			self._pressedState = "over"
		
		elseif "default" == newState then
			-- Loop through the pieces and set them to the default image state
			for i = self.numChildren, 1, - 1 do
				local child = self[i]
				
				-- If the child is a label then set it's color
				if child._isLabel then
					child:setTextColor( unpack( child._labelColor.default ) )
					
				-- The child is a button piece 
				else
					-- Set the piece to the default image state
					child:setSequence( "default" )
				
					-- Set the width again. ( should i have to do this, a possible Corona bug? )
					if child._width then
						child.width = child._width
					end
				
					-- Set the height again. ( should i have to do this, a possible Corona bug? )
					if child._height then
						child.height = child._height
					end
				end
			end
			
			-- The pressedState is now "default"
			self._pressedState = "default"
		end
	end
	
	-- Function to get the buttons current state
	function view:_getState()
		return self._pressedState
	end
		
	-- Finalize function
	function button:_finalize()
		-- Set buttons ImageSheet to nil
		self._view_imageSheet = nil
	end
		
	return button
end


-- Function to create a new button object ( widget.newButton )
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
	opt.width = customOptions.width or themeOptions.width or error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
	opt.height = customOptions.height or themeOptions.height or error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.label = customOptions.label
	opt.labelColor = customOptions.labelColor or { default = { 0, 0, 0 }, over = { 255, 0, 0 } }
	opt.font = customOptions.font or themeOptions.font or native.systemFont
	opt.fontSize = customOptions.fontSize or themeOptions.fontSize or 14
	opt.labelAlign = customOptions.labelAlign or "center"
	opt.labelXOffset = customOptions.labelXOffset or 0
	opt.labelYOffset = customOptions.labelYOffset or 0
	opt.embossedLabel = customOptions.embossedLabel or themeOptions.embossedLabel or false
	opt.onPress = customOptions.onPress
	opt.onRelease = customOptions.onRelease
	opt.onEvent = customOptions.onEvent
	
	-- Frames & Images
	opt.sheet = customOptions.sheet or themeOptions.sheet
	opt.sheetData = customOptions.data or themeOptions.data
	opt.defaultFrame = customOptions.defaultFrame or require( themeOptions.data ):getFrameIndex( themeOptions.defaultFrame )
	opt.overFrame = customOptions.overFrame or require( themeOptions.data ):getFrameIndex( themeOptions.overFrame )
	
	-- Left ( 9 piece set )
	opt.topLeftFrame = customOptions.topLeftFrame or require( themeOptions.data ):getFrameIndex( themeOptions.topLeftFrame )
	opt.topLeftFrameOver = customOptions.topLeftFrameOver or require( themeOptions.data ):getFrameIndex( themeOptions.topLeftFrameOver )
	opt.middleLeftFrame = customOptions.middleLeftFrame or require( themeOptions.data ):getFrameIndex( themeOptions.middleLeftFrame )
	opt.middleLeftFrameOver = customOptions.middleLeftFrameOver or require( themeOptions.data ):getFrameIndex( themeOptions.middleLeftFrameOver )
	opt.bottomLeftFrame = customOptions.bottomLeftFrame or require( themeOptions.data ):getFrameIndex( themeOptions.bottomLeftFrame )
	opt.bottomLeftFrameOver = customOptions.bottomLeftFrameOver or require( themeOptions.data ):getFrameIndex( themeOptions.bottomLeftFrameOver )
	
	-- Right ( 9 piece set )
	opt.topRightFrame = customOptions.topRightFrame or require( themeOptions.data ):getFrameIndex( themeOptions.topRightFrame )
	opt.topRightFrameOver = customOptions.topRightFrameOver or require( themeOptions.data ):getFrameIndex( themeOptions.topRightFrameOver )
	opt.middleRightFrame = customOptions.middleRightFrame or require( themeOptions.data ):getFrameIndex( themeOptions.middleRightFrame )
	opt.middleRightOverFrame = customOptions.middleRightOverFrame or require( themeOptions.data ):getFrameIndex( themeOptions.middleRightOverFrame )
	opt.bottomRightFrame = customOptions.bottomRightFrame or require( themeOptions.data ):getFrameIndex( themeOptions.bottomRightFrame )
	opt.bottomRightOverFrame = customOptions.bottomRightOverFrame or require( themeOptions.data ):getFrameIndex( themeOptions.bottomRightOverFrame )
	
	-- Middle ( 9 piece set )
	opt.topMiddleFrame = customOptions.topMiddleFrame or require( themeOptions.data ):getFrameIndex( themeOptions.topMiddleFrame )
	opt.topMiddleOverFrame = customOptions.topMiddleOverFrame or require( themeOptions.data ):getFrameIndex( themeOptions.topMiddleOverFrame )
	opt.middleFrame = customOptions.middleFrame or require( themeOptions.data ):getFrameIndex( themeOptions.middleFrame )
	opt.middleOverFrame = customOptions.middleOverFrame or require( themeOptions.data ):getFrameIndex( themeOptions.middleOverFrame )
	opt.bottomMiddleFrame = customOptions.bottomMiddleFrame or require( themeOptions.data ):getFrameIndex( themeOptions.bottomMiddleFrame )
	opt.bottomMiddleOverFrame = customOptions.bottomMiddleOverFrame or require( themeOptions.data ):getFrameIndex( themeOptions.bottomMiddleOverFrame )

	-- Are we using a nine piece button?
	local using9PieceButton = opt.topLeftFrame and opt.topLeftFrameOver and opt.middleLeftFrame and opt.middleLeftFrameOver and opt.bottomLeftFrame and opt.bottomLeftFrameOver and 
							opt.topRightFrame and opt.topRightFrameOver and opt.middleRightFrame and opt.middleRightOverFrame and opt.bottomRightFrame and opt.bottomRightOverFrame and
							opt.topMiddleFrame and opt.topMiddleOverFrame and opt.middleFrame and opt.middleOverFrame and opt.bottomMiddleFrame and opt.bottomMiddleOverFrame

	if not using9PieceButton and not opt.defaultFrame and not opt.overFrame then
		error( "ERROR: " .. M._widgetName .. ": 9 piece frame or default/over frame definition expected, got nil", 3 )
	end
	
	-- Favor nine piece button over single image button
	if using9PieceButton then
		opt.defaultFrame = nil
		opt.overFrame = nil
	end

	-------------------------------------------------------
	-- Create the button
	-------------------------------------------------------
		
	-- Create the button object
	local button = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_button",
		baseDir = opt.baseDir,
	}
	
	-- Create the button
	if using9PieceButton then
		initWithNinePieceButton( button, opt )
	else
		initWithTwoFrameButton( button, opt )
	end
	
	-- Set the button's position ( set the reference point to center, just to be sure )
	button:setReferencePoint( display.CenterReferencePoint )
	button.x = opt.left + button.contentWidth * 0.5
	button.y = opt.top + button.contentHeight * 0.5
	
	return button
end

return M
