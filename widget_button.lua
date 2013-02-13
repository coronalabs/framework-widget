--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
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

------------------------------------------------------------------------
-- Image Files Button
------------------------------------------------------------------------

-- Creates a new button from single png images
local function createUsingImageFiles( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local view, viewOver, viewLabel
	
	-- Create the view
	if opt.width and opt.height then
		view = display.newImageRect( button, opt.defaultFile, opt.baseDir, opt.width, opt.height )
	else
		view = display.newImage( button, opt.defaultFile, opt.baseDir )
	end
		
	-- Create the view 'over' object
	if opt.width and opt.height then
		viewOver = display.newImageRect( button, opt.overFile, opt.baseDir, opt.width, opt.height )
	else
		viewOver = display.newImage( button, opt.overFile, opt.baseDir )
	end

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
	
	viewOver.x = view.x
	viewOver.y = view.y
	viewOver.isVisible = false
	
	-- Setup the label
	viewLabel:setTextColor( unpack( opt.labelColor.default ) )
	viewLabel._isLabel = true
	viewLabel._labelColor = opt.labelColor
	
	-- If there isn't an over color defined, fall back to default label color
	if not viewLabel._labelColor.over then
		viewLabel._labelColor.over = viewLabel._labelColor.default
	end
	
	-- Labels position
	if "center" == opt.labelAlign then
		viewLabel.x = view.x + opt.labelXOffset
	elseif "left" == opt.labelAlign then
		viewLabel.x = button.x + ( viewLabel.contentWidth * 0.5 ) + 10 + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 ) - 10 + opt.labelXOffset
	end
		
	-- Set the labels y position
	viewLabel.y = button.y + ( view.contentHeight * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._pressedState = "default"
	view._fontSize = opt.fontSize
	view._label = viewLabel
	view._labelColor = viewLabel._labelColor
	view._labelAlign = opt.labelAlign
	view._labelXOffset = opt.labelXOffset
	view._labelYOffset = opt.labelYOffset
	view._over = viewOver
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function button:setLabel( newLabel )
		return self._view:setLabel( newLabel )
	end
	
	-- Function to get the button's label
	function button:getLabel()
		return self._view:getLabel()
	end
	
	
	function view:touch( event )
		local phase = event.phase
		local _button = self.parent
		event.target = _button
		
		-- If the button is inside a scrollView, set it as so then return true
		if self._insertedIntoScrollView then	
			return true
		end
		
		if "began" == phase then
			-- Set the button to it's over image state
			self.isVisible = false
			self._over.isVisible = true
			
			-- Set the buttons label to it's over color
			self._label:setTextColor( unpack( self._labelColor.over ) )
			
			-- If there is a onPress method ( and not a onEvent method )
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
			
			-- Set focus on the button
			self._isFocus = true
						
			-- Don't set focus to a button inside a scrollView
			if not event._insideScrollView then
				display.getCurrentStage():setFocus( self, event.id )
			end
			
		elseif self._isFocus then
			local bounds = self.contentBounds
	        local x, y = event.x, event.y
	        local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
			
			if "moved" == phase then
				if not isWithinBounds then
					-- Set the button to it's default image state
					self.isVisible = true
					self._over.isVisible = false
					
					-- Set the buttons label to it's default color
					self._label:setTextColor( unpack( self._labelColor.default ) )
				else
					if self:_getState() ~= "over" then
						-- Set the button to it's over image state
						self.isVisible = false
						self._over.isVisible = true
						
						-- Set the buttons label to it's over color
						self._label:setTextColor( unpack( self._labelColor.over ) )
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
				self.isVisible = true
				self._over.isVisible = false
				
				-- Set the buttons label to it's default color
				self._label:setTextColor( unpack( self._labelColor.default ) )
				
				-- Remove focus from the button
				self._isFocus = false
				display.getCurrentStage():setFocus( nil )
							
				-- Reset ScrollView properties	(if this button is in a scrollView)
				if self._isInScrollView then
					self._insertedIntoScrollView = true
					self._isActive = false
				end
			end
		end
		
		-- If there is a onEvent method ( and not a onPress or onRelease method )
		if self._onEvent and not self._onPress and not self._onRelease then
			self._onEvent( event )
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function view:setLabel( newLabel )
		-- Update the label's text
		self._label:setText( newLabel )
		
		-- Labels position
		if "center" == self._labelAlign then
			self._label.x = self.x + self._labelXOffset
		elseif "left" == self._labelAlign then
			self._label.x = self.x - ( self.contentWidth * 0.5 ) + ( self._label.contentWidth * 0.5 ) + 10 + self._labelXOffset
		elseif "right" == self._labelAlign then
			self._label.x = self.x + ( self.contentWidth * 0.5 ) - ( self._label.contentWidth * 0.5 ) - 10 + self._labelXOffset
		end		
			
		-- Update the label's y position
		self._label.y = self._label.y + self._labelYOffset
	end
	
	-- Function to get the button's label
	function view:getLabel()
		return self._label.text
	end
	
	-- Function to set the buttons current state
	function view:_setState( state )
		local newState = state
		
		if "over" == newState then
			-- Set the button to the over image state
			self.isVisible = false
			self._over.isVisible = true
			
			-- The pressedState is now "over"
			self._pressedState = "over"
		
		elseif "default" == newState then
			-- Set the piece to the default image state
			self.isVisible = true
			self._over.isVisible = false
			
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
	end
	
	return button
end
 

------------------------------------------------------------------------
-- Image Sheet (2 Frame) Button
------------------------------------------------------------------------

-- Creates a new button from a sprite (imageSheet)
local function createUsingImageSheet( button, options )
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
	local view, viewLabel
		
	-- Create the view
	view = display.newSprite( button, opt.sheet, sheetOptions )

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
	viewLabel._isLabel = true
	viewLabel._labelColor = opt.labelColor
	
	-- If there isn't an over color defined, fall back to default label color
	if not viewLabel._labelColor.over then
		viewLabel._labelColor.over = viewLabel._labelColor.default
	end
	
	-- Labels position
	if "center" == opt.labelAlign then
		viewLabel.x = view.x + opt.labelXOffset
	elseif "left" == opt.labelAlign then
		viewLabel.x = view.x - ( view.contentWidth * 0.5 ) + ( viewLabel.contentWidth * 0.5 ) + 10 + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 ) - 10 + opt.labelXOffset
	end
	
	-- Set the labels y position
	viewLabel.y = button.y + ( view.contentHeight * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._pressedState = "default"
	view._fontSize = opt.fontSize
	view._label = viewLabel
	view._labelColor = viewLabel._labelColor
	view._labelAlign = opt.labelAlign
	view._labelXOffset = opt.labelXOffset
	view._labelYOffset = opt.labelYOffset
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function button:setLabel( newLabel )
		return self._view:setLabel( newLabel )
	end
	
	-- Function to get the button's label
	function button:getLabel()
		return self._view:getLabel()
	end
	
	
	function view:touch( event )
		local phase = event.phase
		local _button = self.parent
		event.target = _button
		
		-- If the button is inside a scrollView, set it as so then return true
		if self._insertedIntoScrollView then	
			return true
		end
		
		if "began" == phase then
			-- Set the button to it's over image state
			self:_setState( "over" )
			
			-- Set the buttons label to it's over color
			self._label:setTextColor( unpack( self._labelColor.over ) )
			
			-- If there is a onPress method ( and not a onEvent method )
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
			
			-- Set focus on the button
			self._isFocus = true
						
			-- Don't set focus to a button inside a scrollView
			if not event._insideScrollView then
				display.getCurrentStage():setFocus( self, event.id )
			end
			
		elseif self._isFocus then
			local bounds = self.contentBounds
	        local x, y = event.x, event.y
	        local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
			
			if "moved" == phase then
				if not isWithinBounds then
					-- Set the button to it's default image state
					self:_setState( "default" )
					
					-- Set the buttons label to it's default color
					self._label:setTextColor( unpack( self._labelColor.default ) )
				else
					if self:_getState() ~= "over" then
						-- Set the button to it's over image state
						self:_setState( "over" )
						
						-- Set the buttons label to it's over color
						self._label:setTextColor( unpack( self._labelColor.over ) )
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
				
				-- Set the buttons label to it's default color
				self._label:setTextColor( unpack( self._labelColor.default ) )
				
				-- Remove focus from the button
				self._isFocus = false
				display.getCurrentStage():setFocus( nil )
							
				-- Reset ScrollView properties	(if this button is in a scrollView)
				if self._isInScrollView then
					self._insertedIntoScrollView = true
					self._isActive = false
				end
			end
		end
		
		-- If there is a onEvent method ( and not a onPress or onRelease method )
		if self._onEvent and not self._onPress and not self._onRelease then
			self._onEvent( event )
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function view:setLabel( newLabel )
		-- Update the label's text
		self._label:setText( newLabel )
		
		-- Labels position
		if "center" == self._labelAlign then
			self._label.x = view.x + self._labelXOffset
		elseif "left" == self._labelAlign then
			self._label.x = view.x - ( self.contentWidth * 0.5 ) + ( self._label.contentWidth * 0.5 ) + 10 + self._labelXOffset
		elseif "right" == self._labelAlign then
			self._label.x = self.x + ( self.contentWidth * 0.5 ) - ( self._label.contentWidth * 0.5 ) - 10 + self._labelXOffset
		end
				
		-- Update the label's y position
		self._label.y = self._label.y + self._labelYOffset
	end
	
	-- Function to get the button's label
	function view:getLabel()
		return self._label.text
	end
	
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
	end
	
	return button
end


------------------------------------------------------------------------
-- Image Sheet (9 piece/slice) Button
------------------------------------------------------------------------

-- Creates a new button from a 9 piece sprite
local function createUsing9Slice( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view
	
	local viewTopLeft, viewMiddleLeft, viewBottomLeft
	local viewTopMiddle, viewMiddle, viewBottomMiddle
	local viewTopRight, viewMiddleRight, viewBottomRight

	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, require( opt.themeData ):getSheet() )
	end
	
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
	viewLabel._isLabel = true
	viewLabel._labelColor = opt.labelColor
	
	-- If there isn't an over color defined, fall back to default label color
	if not viewLabel._labelColor.over then
		viewLabel._labelColor.over = viewLabel._labelColor.default
	end
	
	-- Label's position
	if "center" == opt.labelAlign then
		viewLabel.x = button.x + ( opt.width * 0.5 ) + opt.labelXOffset   
	elseif "left" == opt.labelAlign then
		viewLabel.x = viewTopLeft.x + ( viewLabel.contentWidth * 0.5 ) + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = viewTopRight.x - ( viewLabel.contentWidth * 0.5 ) + opt.labelXOffset
	end
	
	-- The label's y position
	viewLabel.y = button.y + ( opt.height * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._pressedState = "default"
	view._width = opt.width
	view._fontSize = opt.fontSize
	view._labelAlign = opt.labelAlign
	view._labelXOffset = opt.labelXOffset
	view._labelYOffset = opt.labelYOffset
	view._label = viewLabel
	view._topLeft = viewTopLeft
	view._middleLeft = viewMiddleLeft
	view._bottomLeft = viewBottomLeft
	view._topMiddle = viewTopMiddle
	view._middle = viewMiddle
	view._bottomMiddle = viewBottomMiddle
	view._topRight = viewTopRight
	view._middleRight = viewMiddleRight
	view._bottomRight = viewBottomRight
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._imageSheet = imageSheet
	button._view = view
		
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------

	function view:touch( event )
		local phase = event.phase
		
		-- If the button is inside a scrollView, set it as so then return true
		if self._insertedIntoScrollView then
			self._isInScrollView = true	
			return true
		end	

		if "began" == phase then
			-- Set the button to it's over image state
			self:_setState( "over" )
			
			-- If there is a onPress method ( and not a onEvent method )
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
			
			-- Set focus on the button
			self._isFocus = true
			
			-- Don't set focus to a button inside a scrollView
			if not event._insideScrollView then
				display.getCurrentStage():setFocus( self, event.id )
			end
			
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
				
				-- Reset ScrollView properties(if this button is in a scrollView)
				if self._isInScrollView then
					self._insertedIntoScrollView = true
					self._isActive = false
				end
			end
		end
		
		-- If there is a onEvent method ( and not a onPress or onRelease method )
		if self._onEvent and not self._onPress and not self._onRelease then
			self._onEvent( event )
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function view:setLabel( newLabel )
		self._label:setText( newLabel )
		
		-- Labels position
		if "left" == self._labelAlign then
			self._label.x = self._topLeft.x + ( self._label.contentWidth * 0.5 ) + self._labelXOffset			
		elseif "right" == self._labelAlign then
			self._label.x = self._topRight.x - ( self._label.contentWidth * 0.5 ) - self._labelXOffset
		end

		-- Update the label's y position
		self._label.y = self._label.y + self._labelYOffset
	end
	
	-- Function to get the button's label
	function view:getLabel()
		return self._label.text
	end
	
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
		-- Set the ImageSheet to nil
		self._imageSheet = nil
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
	opt.width = customOptions.width or themeOptions.width
	opt.height = customOptions.height or themeOptions.height
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.label = customOptions.label or ""
	opt.labelColor = customOptions.labelColor or { default = { 0, 0, 0 }, over = { 255, 255, 255 } }	
	opt.font = customOptions.font or themeOptions.font or native.systemFont
	opt.fontSize = customOptions.fontSize or themeOptions.fontSize or 14
	opt.labelAlign = customOptions.labelAlign or "center"
	opt.labelXOffset = customOptions.labelXOffset or 0
	opt.labelYOffset = customOptions.labelYOffset or 0
	opt.embossedLabel = customOptions.emboss or themeOptions.emboss or false
	opt.onPress = customOptions.onPress
	opt.onRelease = customOptions.onRelease
	opt.onEvent = customOptions.onEvent
	
	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	-- Single image files
	opt.defaultFile = customOptions.defaultFile or require( "widget" )._getFrameIndex( themeOptions, themeOptions.defaultFile ) 
	opt.overFile = customOptions.overFile or opt.defaultFile or require( "widget" )._getFrameIndex( themeOptions, themeOptions.overFile )
	
	-- Handle width/height 
	
	-- ImageSheet ( 2 frame button )
	opt.defaultFrame = customOptions.defaultFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.defaultFrame )
	opt.overFrame = customOptions.overFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.overFrame )
	
	-- Left ( 9 piece set )
	opt.topLeftFrame = customOptions.topLeftFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.topLeftFrame )
	opt.topLeftFrameOver = customOptions.topLeftOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.topLeftOverFrame )
	opt.middleLeftFrame = customOptions.middleLeftFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.middleLeftFrame )
	opt.middleLeftFrameOver = customOptions.middleLeftOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.middleLeftOverFrame )
	opt.bottomLeftFrame = customOptions.bottomLeftFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.bottomLeftFrame )
	opt.bottomLeftFrameOver = customOptions.bottomLeftOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.bottomLeftOverFrame )
	
	-- Right ( 9 piece set )
	opt.topRightFrame = customOptions.topRightFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.topRightFrame )
	opt.topRightFrameOver = customOptions.topRightOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.topRightOverFrame )
	opt.middleRightFrame = customOptions.middleRightFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.middleRightFrame )
	opt.middleRightOverFrame = customOptions.middleRightOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.middleRightOverFrame )
	opt.bottomRightFrame = customOptions.bottomRightFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.bottomRightFrame )
	opt.bottomRightOverFrame = customOptions.bottomRightOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.bottomRightOverFrame )
	
	-- Middle ( 9 piece set )
	opt.topMiddleFrame = customOptions.topMiddleFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.topMiddleFrame )
	opt.topMiddleOverFrame = customOptions.topMiddleOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.topMiddleOverFrame )
	opt.middleFrame = customOptions.middleFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.middleFrame )
	opt.middleOverFrame = customOptions.middleOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.middleOverFrame )
	opt.bottomMiddleFrame = customOptions.bottomMiddleFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.bottomMiddleFrame )
	opt.bottomMiddleOverFrame = customOptions.bottomMiddleOverFrame or require( "widget" )._getFrameIndex( themeOptions, themeOptions.bottomMiddleOverFrame )

	-- Are we using a nine piece button?
	local using9PieceButton = not opt.defaultFrame and not opt.overFrame and not opt.defaultFile and not opt.overFile and opt.topLeftFrame and opt.topLeftFrameOver and opt.middleLeftFrame and opt.middleLeftFrameOver and opt.bottomLeftFrame and opt.bottomLeftFrameOver and 
							opt.topRightFrame and opt.topRightFrameOver and opt.middleRightFrame and opt.middleRightOverFrame and opt.bottomRightFrame and opt.bottomRightOverFrame and
							opt.topMiddleFrame and opt.topMiddleOverFrame and opt.middleFrame and opt.middleOverFrame and opt.bottomMiddleFrame and opt.bottomMiddleOverFrame
	
	-- If we are using a 9-piece button and have not passed in an imageSheet, throw an error
	local isUsingSheet = opt.sheet or opt.themeSheetFile
	
	-- If were using a 9 piece/slice button and have not passed a width/height
	if using9PieceButton and not opt.width then
		error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
	elseif using9PieceButton and not opt.height then
		error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
	end
	
	if using9PieceButton and not isUsingSheet then
		error( "ERROR: " .. M._widgetName .. ": 9 piece frame or default/over frame definition expected, got nil", 3 )
	end
	
	-- Are we using a 2 frame button?
	local using2FrameButton = not using9PieceButton and opt.defaultFrame and opt.overFrame
	
	-- If we are using a 2 frame button and have not passed in an imageSheet, throw an error
	if using2FrameButton and not opt.sheet then
		error( "ERROR: " .. M._widgetName .. ": sheet definition expected, got nil", 3 )
	end
	
	-- Ensure the user passed in both a default and over frame index.
	if not using9PieceButton and opt.defaultFrame and not opt.overFrame then
		error( "ERROR: " .. M._widgetName .. ": overFrame definition expected, got nil", 3 )
	elseif not using9PieceButton and opt.overFrame and not opt.defaultFrame then
		error( "ERROR: " .. M._widgetName .. ": defaultFrame definition expected, got nil", 3 )
	end
	
	-- If we are using single images, ensure BOTH files are specified
	if not using9PieceButton and not using2FrameButton and opt.defaultFile and not opt.overFile then
		error( "ERROR: " .. M._widgetName .. ": overFile definition expected, got nil", 3 )
	end
	if not using9PieceButton and not using2FrameButton and opt.overFile and not opt.defaultFile then
		error( "ERROR: " .. M._widgetName .. ": defaultFile definition expected, got nil", 3 )
	end
	
	--[[
	Notes: 
		*) A 9-piece/slice button is favored over a 2 frame button.
		*) A 2 frame button is favored over a 2 file button.
	--]]
		
	-- Favor nine piece button over single image button
	if using9PieceButton then
		opt.defaultFrame = nil
		opt.overFrame = nil
	end
	
	-- Favor 2 frame button over 2 file button
	if using2FrameButton then
		opt.defaultFile = nil
		opt.overFile = nil
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
		widgetType = "button",
	}
	
	-- Create the button
	if using9PieceButton then
		-- If we are using a 9 piece button
		createUsing9Slice( button, opt )
	else
		-- If using a 2 frame button
		if using2FrameButton then
			createUsingImageSheet( button, opt )
		end
		
		-- If using 2 images
		if opt.defaultFile and opt.overFile then
			createUsingImageFiles( button, opt )
		end
	end
	
	-- Set the button's position ( set the reference point to center, just to be sure )
	button:setReferencePoint( display.CenterReferencePoint )
	button.x = opt.left + button.contentWidth * 0.5
	button.y = opt.top + button.contentHeight * 0.5
	
	return button
end

return M
