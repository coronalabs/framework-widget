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
	local leftSegment = display.newSprite( imageSheet, leftSegmentOptions )
	leftSegment:setSequence( "leftSegmentOff" )
	leftSegment.width = opt.width
	
	-- The segment fill
	local middleSegment = display.newSprite( imageSheet, middleSegmentOptions )	middleSegment:setSequence( "middleSegmentOff" )
	middleSegment:setReferencePoint( display.CenterLeftReferencePoint )
	middleSegment.width = ( overallControlWidth ) - ( opt.width + opt.width * 0.5 )
	middleSegment.x = leftSegment.x + middleSegment.width * 0.5
	
	-- The right segment edge
	local rightSegment = display.newSprite( imageSheet, rightSegmentOptions )
	rightSegment:setSequence( "rightSegmentOff" )
	rightSegment.width = opt.width
	rightSegment:setReferencePoint( display.CenterRightReferencePoint )
	rightSegment.x = middleSegment.x + middleSegment.width * 0.5 + rightSegment.width
	
	-- Create the segment labels & dividers
	for i = 1, #segments do
		-- Create the labels
		local label = display.newEmbossedText( segments[i], 0, 0, opt.labelFont, opt.labelSize )
		label:setTextColor( 255 )
		label.x = segmentWidth * 0.5 + segmentWidth * ( i - 1 ) - leftSegment.x - leftSegment.width * 0.5
		label.y = leftSegment.y
		segmentLabels[i] = label

		-- Create the dividers
		if i < #segments then
			local divider = display.newImageRect( imageSheet, opt.dividerFrame, 1, 29 )
			divider.x = segmentWidth * i - leftSegment.x - leftSegment.width * 0.5 
			segmentDividers[i] = divider
		end
	end

	-- The "over" frame
	local segmentOver = display.newSprite( imageSheet, middleSegmentOptions )	segmentOver:setSequence( "middleSegmentOn" )
	segmentOver.width = opt.width
	
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
	
	-- Insert the segments into the view (group)
	view:insert( view._leftSegment )
	view:insert( view._middleSegment )
	view:insert( view._rightSegment )
	view:insert( view._segmentOver )
	
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
	segmentedControl.segmentName = view._segmentLabels[1].text
	segmentedControl.segmentNumber = view._segmentNumber
		
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	function view:touch( event )
		local phase = event.phase
		local _segmentedControl = event.target
		local firstSegment = 1
		local lastSegment = self._totalSegments
		
		if "began" == phase then
			-- Loop through the segments
			for i = 1, self._totalSegments do
				local segmentLeftEdge = self._segmentWidth * i - self._edgeWidth
				local segmentRightEdge = _segmentedControl.x + self._segmentWidth * i - ( self._edgeWidth / 2 )
				
				-- If the touch is within the segments range
				if event.x >= segmentLeftEdge and event.x <= segmentRightEdge then
					-- First segment (Far left)
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
					_segmentedControl.segmentName = self._segmentName
					
					-- Set the segment number
					_segmentedControl.segmentNumber = self._segmentNumber
					
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
		self._segmentName = self._segmentLabels[1].text
		
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
		self._segmentName = self._segmentLabels[self._totalSegments].text
		
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
		self._segmentName = self._segmentLabels[segmentNum].text
		
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
			view:setMiddleSegmentActive( self._segmentNumber )
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
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- If there isn't an options table and there isn't a theme set throw an error
	if not options and not theme then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support the segmentedControl widget." )
	end
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------	
	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.width = customOptions.width or theme.width
	opt.height = customOptions.height or theme.height
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.segments = customOptions.segments or { "One", "Two" }
	opt.defaultSegment = customOptions.defaultSegment or 1
	opt.labelSize = customOptions.labelSize or 12
	opt.labelFont = customOptions.labelFont or native.systemFont
	opt.labelXOffset = customOptions.labelXOffset or 0
	opt.labelYOffset = customOptions.labelYOffset or 0
	opt.segmentWidth = customOptions.segmentWidth or 50
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
	-- Constructor error handling
	-------------------------------------------------------
		
	-- Throw error if the user hasn't defined a sheet and has defined data or vice versa.
	if not customOptions.sheet and customOptions.data then
		error( M._widgetName .. ": Sheet expected, got nil" )
	elseif customOptions.sheet and not customOptions.data then
		error( M._widgetName .. ": Sheet data file expected, got nil" )
	end
	
	-- If the user has passed in a sheet but hasn't defined the width & height throw an error
	local hasProvidedSize = opt.width and opt.height
	
	if not hasProvidedSize then
		error( M._widgetName .. ": You must pass width & height parameters when using " .. M._widgetName .. " with an imageSheet" )
	end
	
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
	
	return segmentedControl
end

return M
