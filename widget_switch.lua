--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File:
		widget_newSwitch.lua
		
	What is it?:
		A widget object that can...
	
	Features:

		
	Example Usage:
		
	
--]]

local M = {}

function M.new( options, themeOptions )
	local options = options or {}
	local theme = themeOptions or {}
	
	local style = options.style or theme.style or "onOff"
	local default = options.default or theme.default
	local selected = options.selected or theme.selected
	local sheet = options.sheet or theme.sheet
	local startFrame = options.start or theme.start or 0
	local frameCount = options.count or theme.count or 0
	
	local left = options.left or 0
	local top = options.top or 0
	local width = options.width or nil
	local height = options.height or nil
	
	-- If were using an imagesheet don't use a single image
	if sheet then default = nil; selected = nil end
	
	-- If there isn't a sheet or image defined (either by params or theme, throw error)
	if not sheet and not default and not selected then
		error( "widget.newSwitch requires either an image or imageSheet, or a visual theme set by widget.setTheme" )
	end
	
	-- The switch object is a group
	local switch = require( "widget_constructor" ).new
	{
		left = left,
		top = top,
		id = options.id or "widget_switch",
		baseDirectory = options.baseDir,
	}
	
	
	
	--------------------------------------------------------------------------------------------------------------------
	--										PUBLIC METHODS															  --
	--------------------------------------------------------------------------------------------------------------------						
	
	
	
	return switch
end

return M;
