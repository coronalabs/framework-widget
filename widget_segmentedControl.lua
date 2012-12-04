--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_segmentedControl.
		
	What is it?: 
		A widget object that can ..
	
	Features:
		
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newSegmentedControl",
}

-- Creates a new segmentedControl from an image
local function initWithImage( segmentedControl, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view, segmentLabels, segmentDividers
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	
	-- The view is the segmentedControl (group)
	view = segmentedControl
	
	-- Create the sequenceData table
	local leftSegmentOptions = 
	{ 
		{
			name = "leftSegmentOff",
			start = opt.leftSegmentFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "leftSegmentOn",
			start = opt.leftSegmentSelectedFrame,
			count = 1,
			time = 1,
		},
	}
	
	local rightSegmentOptions = 
	{ 
		{
			name = "rightSegmentOff",
			start = opt.rightSegmentFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "rightSegmentOn",
			start = opt.rightSegmentSelectedFrame,
			count = 1,
			time = 1,
		},
	}
	
	local middleSegmentOptions = 
	{ 
		{
			name = "middleSegmentOff",
			start = opt.middleSegmentFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "middleSegmentOn",
			start = opt.middleSegmentSelectedFrame,
			count = 1,
			time = 1,
		},
	}
	
	local dividerSegmentOptions = 
	{ 
		{
			name = "middleSegmentOff",
			start = opt.middleSegmentFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "middleSegmentOn",
			start = opt.middleSegmentSelectedFrame,
			count = 1,
			time = 1,
		},
	}
	
	-- Reference the passed in segments
	local segments = opt.segments
	
	-- Create the view's segments
	segmentLabels = {}
	segmentDividers = {}
	
	local overallControlWidth = ( opt.segmentWidth * #segments )
	local segmentWidth = overallControlWidth / #segments
	
	-- The left segment edge
	local leftSegment = display.newSprite( segmentedControl, imageSheet, leftSegmentOptions )
	leftSegment.x = segmentedControl.x + ( leftSegment.contentWidth * 0.5 )
	leftSegment.y = segmentedControl.y + ( leftSegment.contentHeight * 0.5 )
	leftSegment:setSequence( "leftSegmentOff" )
	leftSegment.width = opt.width
	
	-- The segment fill
	local middleSegment = display.newSprite( segmentedControl, imageSheet, middleSegmentOptions )	middleSegment:setSequence( "middleSegmentOff" )
	middleSegment:setReferencePoint( display.CenterLeftReferencePoint )
	middleSegment.width = ( overallControlWidth ) - ( opt.width + opt.width * 0.5 )
	middleSegment.x = leftSegment.x + ( middleSegment.width * 0.5 )
	middleSegment.y = segmentedControl.y + ( middleSegment.contentHeight * 0.5 )
	
	-- The right segment edge
	local rightSegment = display.newSprite( segmentedControl, imageSheet, rightSegmentOptions )
	rightSegment:setSequence( "rightSegmentOff" )
	rightSegment.width = opt.width
	rightSegment:setReferencePoint( display.CenterRightReferencePoint )
	rightSegment.x = middleSegment.x + ( middleSegment.width * 0.5 ) + rightSegment.width
	rightSegment.y = segmentedControl.y + ( rightSegment.contentHeight * 0.5 )
	
	-- Create the segment labels & dividers
	for i = 1, #segments do
		-- Create the labels
		local label = display.newEmbossedText( segmentedControl, segments[i], 0, 0, opt.labelFont, opt.labelSize )
		label:setTextColor( 255 )
		label.x = leftSegment.x + ( segmentWidth * 0.5 + segmentWidth * ( i - 1 ) ) - leftSegment.width * 0.5
		label.y = leftSegment.y
		segmentLabels[i] = label

		-- Create the dividers
		if i < #segments then
			local divider = display.newImageRect( segmentedControl, imageSheet, opt.dividerFrame, 1, 29 )
			divider.x = leftSegment.x + ( segmentWidth * i ) -  ( leftSegment.width * 0.5 )
			divider.y = leftSegment.y
			segmentDividers[i] = divider
		end
	end

	-- The "over" frame
	local segmentOver = display.newSprite( segmentedControl, imageSheet, middleSegmentOptions )	
	segmentOver:setSequence( "middleSegmentOn" )
	segmentOver.width = opt.width
	segmentOver.y = leftSegment.y
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Segment properties
	view._segmentWidth = segmentWidth
	view._edgeWidth = opt.width
	view._totalSegments = #segments
	
	-- Create a reference to the segments
	view._leftSegment = leftSegment
	view._middleSegment = middleSegment
	view._rightSegment = rightSegment
	view._segmentOver = segmentOver
	view._segmentLabels = segmentLabels
	view._segmentDividers = segmentDividers
	view._segmentNumber = opt.defaultSegment
	view._onPress = opt.onPress
	
	-- Insert the segment labels into the view
	for i = 1, #view._segmentLabels do
		view:insert( view._segmentLabels[i] )
	end
	
	-- Insert the segment dividers into the view
	for i = 1, #segmentDividers do
		view:insert( view._segmentDividers[i] )
	end
	
	-------------------------------------------------------
	-- Assign properties/objects to the segmentedControl
	-------------------------------------------------------
	
	-- Assign objects to the segmentedControl
	segmentedControl._imageSheet = imageSheet
	segmentedControl._view = view
	segmentedControl._onPress = opt.onPress
	
	-- Public properties
	segmentedControl.segmentLabel = view._segmentLabels[1].text
	segmentedControl.segmentNumber = view._segmentNumber
		
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	function view:touch( event )
		local phase = event.phase
		local firstSegment = 1
		local lastSegment = self._totalSegments

		if "began" == phase then
			-- Loop through the segments
			for i = 1, self._totalSegments do
				local segmentedControlXPosition = self.x - ( self.contentWidth * 0.5 )
				local currentSegment = i
				local segmentWidth = self._segmentWidth
				
				-- Work out the current segments position
				local currentSegmentLeftEdge = segmentedControlXPosition * currentSegment
				local currentSegmentRightEdge = segmentedControlXPosition + ( segmentWidth * currentSegment )
				
				-- If the touch is within the segments range
				if event.x >= currentSegmentLeftEdge and event.x <= currentSegmentRightEdge then
					-- First segment (Near left)
					if firstSegment == i then
						self:setLeftSegmentActive()
					-- Last segment (Far right)
					elseif lastSegment == i then
						self:setRightSegmentActive()
					-- Any other segment
					else
						self:setMiddleSegmentActive( i )
					end
					
					-- Set the segment name
					self.segmentLabel = self._segmentLabel
					
					-- Set the segment number
					self.segmentNumber = self._segmentNumber
					
					-- Execute onPress listener
					if self._onPress and "function" == type( self._onPress ) then
						self._onPress( event )
					end
					
					break
				end
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )

	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the left segment active
	function view:setLeftSegmentActive()
		-- Turn off the right segment
		self._rightSegment:setSequence( "rightSegmentOff" )
		-- Turn on the left segment
		self._leftSegment:setSequence( "leftSegmentOn" )
		-- Set the over segment's width
		segmentOver.width = opt.segmentWidth - self._leftSegment.width - 0.5
		-- Set the over segment's position
		segmentOver.x = self._leftSegment.x + self._leftSegment.width * 0.5 + segmentOver.width * 0.5
		
		-- Set the segment's name
		self._segmentLabel = self._segmentLabels[1].text
		
		-- Set the segment number
		self._segmentNumber = 1
	end
	
	-- Function to set the right segment active
	function view:setRightSegmentActive()
		-- Turn off the left segment
		self._leftSegment:setSequence( "leftSegmentOff" )
		-- Turn on the right segment
		self._rightSegment:setSequence( "rightSegmentOn" )
		-- Set the over segment's width
		segmentOver.width = opt.segmentWidth - self._rightSegment.width - 0.5
		-- Set the over segment's position
		segmentOver.x = self._rightSegment.x - self._rightSegment.width - segmentOver.width * 0.5 - self._segmentDividers[#self._segmentDividers].width * 0.5
	
		-- Set the segment's name
		self._segmentLabel = self._segmentLabels[self._totalSegments].text
		
		-- Set the segment number
		self._segmentNumber = self._totalSegments
	end
	
	-- Function to set the middle segment active
	function view:setMiddleSegmentActive( segmentNum )
		-- Turn off the left segment
		self._leftSegment:setSequence( "leftSegmentOff" )
		-- Turn off the right segment
		self._rightSegment:setSequence( "rightSegmentOff" )
		-- Set the over segment's width
		segmentOver.width = self._segmentWidth
		-- Set the over segment's position
		segmentOver.x = self._segmentDividers[segmentNum - 1].x + segmentOver.width * 0.5
		
		-- Set the segment's name
		self._segmentLabel = self._segmentLabels[segmentNum].text
		
		-- Set the segment number
		self._segmentNumber = segmentNum
	end
	
	-- Set the intial segment to active
	local function setDefaultSegment( segmentNum )
		if 1 == segmentNum then
			view:setLeftSegmentActive()
		elseif #segments == segmentNum then
			view:setRightSegmentActive()
		else
			view:setMiddleSegmentActive( view._segmentNumber )
		end
	end
	
	-- Finalize function for the segmentedControl
	function segmentedControl:_finalize()
		self._view._segments = nil
		self._view = nil
		
		-- Set segmentedControl's ImageSheet to nil
		self._imageSheet = nil
	end
	
	-- Set the default segment
	setDefaultSegment( view._segmentNumber )
	
	return segmentedControl
end


-- Function to create a new segmentedControl object ( widget.newSegmentedControl )
function M.new( options, theme )	
	local customOptions = options or {}
	local themeOptions = theme or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- Check if the requirements for creating a widget has been met (throws an error if not)
	require( "widget")._checkRequirements( customOptions, themeOptions, M._widgetName )
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------	
	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.width = customOptions.width or theme.width or error( "ERROR:" .. M._widgetName .. ": width expected, got nil", 3 )
	opt.height = customOptions.height or theme.height or error( "ERROR:" .. M._widgetName .. ": height expected, got nil", 3 )
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.segments = customOptions.segments or { "One", "Two" }
	opt.segmentWidth = customOptions.segmentWidth or 50
	opt.defaultSegment = customOptions.defaultSegment or 1
	opt.labelSize = customOptions.labelSize or 12
	opt.labelFont = customOptions.labelFont or native.systemFont
	opt.labelXOffset = customOptions.labelXOffset or 0
	opt.labelYOffset = customOptions.labelYOffset or 0
	opt.onPress = customOptions.onPress
	
	-- Frames & Images
	opt.sheet = customOptions.sheet or theme.sheet
	opt.sheetData = customOptions.data or theme.data
	opt.leftSegmentFrame = customOptions.leftSegmentFrame or require( theme.data ):getFrameIndex( theme.leftSegmentFrame )
	opt.leftSegmentSelectedFrame = customOptions.leftSegmentSelectedFrame or require( theme.data ):getFrameIndex( theme.leftSegmentSelectedFrame )
	opt.rightSegmentFrame = customOptions.rightSegmentFrame or require( theme.data ):getFrameIndex( theme.rightSegmentFrame )
	opt.rightSegmentSelectedFrame = customOptions.rightSegmentSelectedFrame or require( theme.data ):getFrameIndex( theme.rightSegmentSelectedFrame )
	opt.middleSegmentFrame = customOptions.middleSegmentFrame or require( theme.data ):getFrameIndex( theme.middleSegmentFrame )
	opt.middleSegmentSelectedFrame = customOptions.middleSegmentSelectedFrame or require( theme.data ):getFrameIndex( theme.middleSegmentSelectedFrame)
	opt.dividerFrame = customOptions.dividerFrame or require( theme.data ):getFrameIndex( theme.dividerFrame)

	-------------------------------------------------------
	-- Create the segmentedControl
	-------------------------------------------------------
		
	-- Create the segmentedControl object
	local segmentedControl = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_segmentedControl",
		baseDir = opt.baseDir,
	}
		
	-- Create the segmentedControl
	initWithImage( segmentedControl, opt )
	
	-- Set the segmentedControl's position ( set the reference point to center, just to be sure )
	segmentedControl:setReferencePoint( display.CenterReferencePoint )
	segmentedControl.x = opt.left + segmentedControl.contentWidth * 0.5
	segmentedControl.y = opt.top + segmentedControl.contentHeight * 0.5
	
	return segmentedControl
end

return M
