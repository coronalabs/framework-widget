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
	
	local switchType = options.switchType or theme.switchType or "onOff"
	local default = options.default or theme.default
	local selected = options.selected or theme.selected
	local sheet = options.sheet or theme.sheet
	local defaultFrame = options.defaultFrame or theme.defaultFrame or 0
	local selectedFrame = options.selectedFrame or theme.selectedFrame or 0
	local defaultState = options.defaultState or "unselected"
	
	local left = options.left or 0
	local top = options.top or 0
	local width = options.width or nil
	local height = options.height or nil
	local onPress = options.onPress or nil
	local onRelease = options.onRelease or nil
	local onEvent = options.onEvent or nil
	
	-- If were using an imagesheet don't use a single image
	if sheet then default = nil; selected = nil end
	
	-- If there isn't a sheet or image defined (either by params or theme, throw error)
	if not sheet and not default and not selected then
		error( "widget.newSwitch requires either an image or imageSheet, or a visual theme set by widget.setTheme" )
	end
	
	-- The switch object is a group
	local switch = require( "widget" )._new
	{
		left = left,
		top = top,
		id = options.id or "widget_switch",
		baseDirectory = options.baseDir,
	}
	
	-- Switch state
	switch.state = "none"
	
	-- The actual switch object
	local switchObject 
	
	-- Forward references
	local switchImageSheet, switchImageSheetOptions = nil, nil
	
	-- Only create an imagesheet if needed
	if sheet then
		-- Create the image sheet
		switchImageSheet = graphics.newImageSheet( sheet, require( sheetData ).sheet )
		-- Create the sequenceData table
		switchImageSheetOptions = 
		{ 
			name = "default", 
			frames = { defaultFrame, selectedFrame }, 
			time = 1, 
		}
	end
	
	-- Create the switch
	if sheet then
		switchObject = display.newSprite( switchImageSheet, switchImageSheetOptions )
		-- Insert the switch object into the switch group object
		switch:insert( switchObject )
	else
		if width and height then
			switchObject = display.newImageRect( switchImageSheet, defaultFrame, width, height )
			switchObject.selected = display.newImageRect( switchImageSheet, selectedFrame, width, height )
		else
			switchObject = display.newImage( default, true )
			switchObject.selected = display.newImage( selected, true )
		end
		
		-- Set the switch state displayed by default
		if "selected" == defaultState then
			switchObject.isVisible = false
		else
			switchObject.selected.isVisible = false
		end
		
		-- Insert the switch object into the switch group object
		switch:insert( switchObject )
		switch:insert( switchObject.selected )
	end
	
	-- The switch's content is the switchObject
	switch.content = switchObject
	
	-- The switch's toggle
	switch.toggle = 0

	--------------------------------------------------------------------------------------------------------------------
	--										PRIVATE METHODS															  --
	--------------------------------------------------------------------------------------------------------------------
	
	-- Sets the switches state per switch type
	local function setSwitchState( toggle )
		-- Set switch state
		if toggle == 0 then
			if "radio" == switchType then
				-- Switch state
				switch.state = "selected"
			elseif "checkbox" == switchType then
				-- Switch state
				switch.state = "checked"
			elseif "onOff" == switchType then
				-- Switch state
				switch.state = "on"
			end
		else
			if "radio" == switchType then
				-- Switch state
				switch.state = "unselected"
			elseif "checkbox" == switchType then
				-- Switch state
				switch.state = "unchecked"
			elseif "onOff" == switchType then
				-- Switch state
				switch.state = "off"
			end
		end
	end
	
	
	-- If the switch has been set to selected then change the toggle to selected
	if "selected" == defaultState then
		switch.toggle = 1
	end
	
	-- Set the default switch state
	setSwitchState( switch.toggle )
	
	-- Toggles the switches state
	function toggleSwitch( event )
		local defaultSwitch = switchObject
		local selectedSwitch = switchObject.selected
		
		-- Toggle the switch on/off
		switch.toggle = 1 - switch.toggle
		
		-- Toggle the images visibility
		if switch.toggle == 1 then
			defaultSwitch.isVisible = false
			selectedSwitch.isVisible = true
			
			-- Set switch state
			setSwitchState( switch.toggle )
		else
			defaultSwitch.isVisible = true
			selectedSwitch.isVisible = false
			
			-- Set switch state
			setSwitchState( switch.toggle )
		end
		
		return true
	end
	
	switch:addEventListener( "tap", toggleSwitch )
	
	
	--------------------------------------------------------------------------------------------------------------------
	--										PUBLIC METHODS															  --
	--------------------------------------------------------------------------------------------------------------------
	
	-- Get the switches state
	function switch:getState()
		return switch.state
	end
	
	
	-- Handle touches on the switch
	function switch:touch( event )
		local phase = event.phase
		
		if "began" == phase then
			if onPress and not onEvent then
				onPress( event )
			end
		elseif "ended" == phase or "cancelled" == phase then
			if onRelease and not onEvent then
				onRelease( event )
			end
		end
		
		if onEvent then
			onEvent( event )
		end
		
		return true
	end
	
	switch:addEventListener( "touch" )
			
	
	
	return switch
end

return M;
