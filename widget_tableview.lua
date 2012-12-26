--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_tableView.lua
		
	What is it?: 
		A widget object that can be used to replicate native tableViews.
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newtableView",
}

-- Creates a new tableView
local function createTableView( tableView, options )
	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local view
	
	-- Create the view
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	--tableView._velocity = 0
	
	-------------------------------------------------------
	-- Assign properties/objects to the tableView
	-------------------------------------------------------
	
	-- Assign objects to the tableView
	--tableView._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------

	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function for the tableView
	function tableView:_finalize()
	end
			
	return tableView
end


-- Function to create a new tableView object ( widget.newtableView )
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


	-------------------------------------------------------
	-- Create the tableView
	-------------------------------------------------------
		
	-- Create the tableView object
	local tableView = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_tableView",
		baseDir = opt.baseDir,
	}

	-- Create the tableView
	createtableView( tableView, opt )
	
	-- Set the tableView's position ( set the reference point to center, just to be sure )
	tableView:setReferencePoint( display.CenterReferencePoint )
	tableView.x = opt.left + tableView.contentWidth * 0.5
	tableView.y = opt.top + tableView.contentHeight * 0.5
	
	return tableView
end

return M
