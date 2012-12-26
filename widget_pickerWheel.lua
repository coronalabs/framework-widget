--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_pickerWheel.lua
		
	What is it?: 
		A widget object that can be used to replicate native pickerWheels.
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newpickerWheel",
}

-- Creates a new pickerWheel
local function createPickerWheel( pickerWheel, options )
	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local view
	
	-- Create the view
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	--pickerWheel._velocity = 0
	
	-------------------------------------------------------
	-- Assign properties/objects to the pickerWheel
	-------------------------------------------------------
	
	-- Assign objects to the pickerWheel
	--pickerWheel._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------

	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function for the pickerWheel
	function pickerWheel:_finalize()
	end
			
	return pickerWheel
end


-- Function to create a new pickerWheel object ( widget.newpickerWheel )
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
	opt.maskFile = customOptions.maskFile
		
	-- Frames & Images
	opt.sheet = customOptions.sheet or themeOptions.sheet
	opt.sheetData = customOptions.data or themeOptions.data
	opt.startFrame = customOptions.startFrame or require( themeOptions.data ):getFrameIndex( themeOptions.startFrame )
	opt.frameCount = customOptions.count or themeOptions.count or 0

	-------------------------------------------------------
	-- Create the pickerWheel
	-------------------------------------------------------
		
	-- Create the pickerWheel object
	local pickerWheel = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_pickerWheel",
		baseDir = opt.baseDir,
	}

	-- Create the pickerWheel
	createpickerWheel( pickerWheel, opt )
	
	-- Set the pickerWheel's position ( set the reference point to center, just to be sure )
	pickerWheel:setReferencePoint( display.CenterReferencePoint )
	pickerWheel.x = opt.left + pickerWheel.contentWidth * 0.5
	pickerWheel.y = opt.top + pickerWheel.contentHeight * 0.5
	
	return pickerWheel
end

return M
