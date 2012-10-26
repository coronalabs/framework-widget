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
	local imageSheet, view, viewSegments
	
	-- Create the imageSheet
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
	view = display.newGroup()
	
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
	
	-- Reference the passed in segments
	local segments = opt.segments
	
	-- Create the view's segments
	viewSegments = {}
	
	for i = 1, #segments do
		local frame, sequenceData, offSequence, onSequence
		
		-- For the first iteration set the frame & properties to the "left" segment
		if 1 == i then
			frame = opt.leftSegmentFrame
			sequenceData = leftSegmentOptions
			offSequence = "leftSegmentOff"
			onSequence = "leftSegmentOn"
		-- For all other iterations set the frame & properties to the "middle" segment
		else
			frame = opt.middleSegmentFrame
			sequenceData = middleSegmentOptions
			offSequence = "middleSegmentOff"
			onSequence = "middleSegmentOn"
		end
	
		-- If the iteration is at it's last index then set the frame & properties to the "right" segment
		if #segments == i then
			frame = opt.rightSegmentFrame
			sequenceData = rightSegmentOptions
			offSequence = "rightSegmentOff"
			onSequence = "rightSegmentOn"
		end	
		
		-- Create the segment
		viewSegments[i] = display.newSprite( imageSheet, sequenceData )
		viewSegments[i].x = ( viewSegments[i].contentWidth - 1 ) * i
		viewSegments[i].segment = i
		viewSegments[i].segmentName = segments[i]
		viewSegments[i].offSequence = offSequence
		viewSegments[i].onSequence = onSequence
		
		-- Set the default segment to active
		if opt.defaultSegment == i then
			viewSegments[i]:setSequence( viewSegments[i].onSequence )
		end

		-- Create the segment's label
		viewSegments[i].label = display.newEmbossedText( segments[i], 0, 0, opt.labelFont, opt.labelSize )
		viewSegments[i].label:setTextColor( 255 )
		viewSegments[i].label.x = viewSegments[i].x + opt.labelXOffset
		viewSegments[i].label.y = viewSegments[i].y + opt.labelYOffset
	end		

	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Create a reference to the segments
	view._segments = viewSegments
	
	-- Insert the segments into the view (group)
	for i = 1, #view._segments do
		view:insert( view._segments[i] )
		view:insert( view._segments[i].label )
	end
	
	-------------------------------------------------------
	-- Assign properties/objects to the segmentedControl
	-------------------------------------------------------
	
	-- Assign objects to the segmentedControl
	segmentedControl._imageSheet = imageSheet
	segmentedControl._view = view
	segmentedControl._onPress = opt.onPress

	-- Insert the view into the segmentedControl (group)
	segmentedControl:insert( view )
		
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	function view:touch( event )
		local phase = event.phase
		local target = event.target
		local firstSegment = 1 == target.segment
		local lastSegment = #self._segments == target.segment
		
		if "began" == phase then
			for i = 1, #self._segments do
				local currentSegment = self._segments[i]
				
				-- If the current segment isn't equal to the target segment then turn it off.
				if currentSegment.segment ~= target.segment then
					-- Set the segment to "deSelected"
					currentSegment:setSequence( currentSegment.offSequence )
				else
					-- If the segment isn't already selected then fire the _onPress event (if there is one)
					if currentSegment.sequence ~= currentSegment.onSequence then
						if segmentedControl._onPress then
							segmentedControl._onPress( event )
						end
					end
				
					-- Set the segment to "selected"
					currentSegment:setSequence( currentSegment.onSequence )
				end
			end
		end
		
		return true
	end
	
	-- Add an event listener for each segment
	for i = 1, #view._segments do
		view._segments[i]:addEventListener( "touch", view )
	end
		
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function for the segmentedControl
	function segmentedControl:_finalize()
		self._view._segments = nil
		self._view = nil
		
		-- Set segmentedControl's ImageSheet to nil
		self._imageSheet = nil
	end
			
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
