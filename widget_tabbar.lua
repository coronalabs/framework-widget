--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_tabBar.lua
		
	What is it?: 
		A widget object that can be used to replicate native tab bar controllers.
--]]

local M = 
{
	_options = {},
	_widgetName = "widget.newTabBar",
}

-- Creates a new tabBar from an imageSheet
local function initWithImage( tabBar, options )
	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local imageSheet, view, viewSelected, viewSelectedLeft, viewSelectedRight, viewSelectedMiddle, viewButtons
	
	-- Create the view
	imageSheet = graphics.newImageSheet( opt.sheet, require( opt.sheetData ):getSheet() )
		
	-- Create the tab bar's background
	view = display.newImageRect( tabBar, imageSheet, opt.backgroundFrame, opt.backgroundFrameWidth, opt.backgroundFrameHeight )
	
	-- We need to assign the view some properties here.
	view._defaultTab = 1
	view._totalTabWidth = 0
	
	-- Create the tab selected group
	viewSelected = display.newGroup()
	tabBar:insert( viewSelected )
	
	-- Create the tab selected's left frame
	viewSelectedLeft = display.newImageRect( viewSelected, imageSheet, opt.tabSelectedLeftFrame, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
	
	-- Create the tab selected's middle frame
	viewSelectedMiddle = display.newImageRect( viewSelected, imageSheet, opt.tabSelectedMiddleFrame, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
		
	-- Create the tab selected's right frame
	viewSelectedRight = display.newImageRect( viewSelected, imageSheet, opt.tabSelectedRightFrame, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
	
	-- Create the viewButtons table
	viewButtons = {}
	
	-- Create the tab buttons
	for i = 1, #opt.tabButtons do
		local activeFrame = require( opt.sheetData ):getFrameIndex( opt.tabButtons[i].iconInactiveFrame ) or opt.iconActiveFrame
		local inActiveFrame = require( opt.sheetData ):getFrameIndex( opt.tabButtons[i].iconActiveFrame ) or opt.iconInActiveFrame
		
		local spriteOptions = 
		{
			{
				name = "inActive",
				start = inActiveFrame,
				count = 1,
			},
			{
				name = "active",
				start = activeFrame,
				count = 1,
			},	
		}
		
		-- Create the tab button
		viewButtons[i] = display.newSprite( tabBar, imageSheet, spriteOptions )
		
		-- Get the passed in properties if any
		local labelFont = opt.tabButtons[i].labelFont or opt.defaultLabelFont
		local labelSize = opt.tabButtons[i].labelSize or opt.defaultLabelSize
		local labelColor = opt.tabButtons[i].labelColor or opt.defaultLabelColor
		
		-- Create the tab button's label
		viewButtons[i].label = display.newText( tabBar, opt.tabButtons[i].label, 0, 0, labelFont, labelSize )
		viewButtons[i].label:setTextColor( unpack( labelColor.default ) )
		
		-- Set the default tab
		if opt.tabButtons[i].selected then
			view._defaultTab = i
			
			-- Set the selected tab's label to the over color
			viewButtons[i].label:setTextColor( unpack( labelColor.over ) )
		end	
		
		-- Keep a reference to the label's colors
		viewButtons[i].label._color = labelColor
	end
		
		
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- Set the tabBar's background width & position	
	view.width = opt.width
	view.height = opt.height
	view.x = tabBar.x + ( view.contentWidth * 0.5 )
	view.y = tabBar.y + ( view.contentHeight * 0.5 )
	
	-- Set the tab selected's left frame position
	viewSelectedLeft.x = tabBar.x + ( viewSelectedLeft.contentWidth * 0.5 )
	viewSelectedLeft.y = tabBar.y + ( viewSelectedLeft.contentHeight * 0.5 )
		
	-- Set the tab selected's middle frame width & position
	viewSelectedMiddle.width = ( opt.width / #opt.tabButtons ) - ( viewSelectedLeft.contentWidth + viewSelectedRight.contentWidth )
	viewSelectedMiddle.x = viewSelectedLeft.x + ( viewSelectedLeft.contentWidth * 0.5 ) + ( viewSelectedMiddle.contentWidth * 0.5 )
	viewSelectedMiddle.y = viewSelectedLeft.y
	
	-- Set the tab selected's right frame position
	viewSelectedRight.x = viewSelectedMiddle.x + ( viewSelectedLeft.contentWidth * 0.5 ) + ( viewSelectedMiddle.contentWidth * 0.5 )
	viewSelectedRight.y = viewSelectedLeft.y

	-- Loop through the view's buttons and set their positions
	for i = 1, #viewButtons do
		-- Set the buttons position
		viewButtons[i].x = tabBar.x + ( ( opt.width / #viewButtons ) * i ) - ( opt.width / #viewButtons ) / 2
		viewButtons[i].y = viewSelectedLeft.y - ( viewSelectedLeft.contentHeight * 0.1 )
		
		-- Set the button label position
		viewButtons[i].label.x = viewButtons[i].x
		viewButtons[i].label.y = ( viewSelectedLeft.y + ( viewSelectedLeft.contentHeight * 0.5 ) ) - ( viewButtons[i].label.contentHeight * 0.5 ) - 1
		
		-- Set the buttons id
		viewButtons[i]._id = opt.tabButtons[i].id or "button" .. i
		
		-- Assign the onPress listener to the button
		viewButtons[i]._onPress = opt.tabButtons[i].onPress
		
		-- By default the button isn't pressed
		viewButtons[i]._isPressed = false
		
		-- Set the view's total width
		view._totalTabWidth = view._totalTabWidth + viewButtons[i].width
	end
	
	-- Set the default tab to active
	viewButtons[view._defaultTab]:setSequence( "active" )
	
	-- Position the tab selected group
	viewSelected.x = viewButtons[view._defaultTab].x - ( viewSelected.contentWidth * 0.5 ) - tabBar.x
	
	-- Throw error if tabBar width is too small to hold all passed in tab items
	if ( view._totalTabWidth + 4 ) > opt.width then
		error( "ERROR: " .. M._widgetName .. ": width passed is too small to fit the tab items inside, you need a width of at least " .. ( totalTabWidth + 4 ) .. " to fit your tab items inside", 3 )
	end
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	view._width = opt.width
	view._selected = viewSelected
	view._tabs = viewButtons
	view._onPress = opt.onPress
	
	-------------------------------------------------------
	-- Assign properties/objects to the tabBar
	-------------------------------------------------------
	
	-- Assign objects to the tabBar
	tabBar._imageSheet = imageSheet
	tabBar._view = view
	tabBar._viewSelected = view._selected
	tabBar._viewButtons = view._tabs
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	function view:touch( event )
		local phase = event.phase
		local tabSize = ( self._width / #self._tabs ) 
		
		if "began" == phase then
			-- Loop through the tabs
			for i = 1, #self._tabs do
				local currentTab = self._tabs[i]
				
				-- Have we pressed within the current tab?
				local pressedWithinRange = event.x >= ( currentTab.x - tabSize * 0.5 ) and event.x <= ( currentTab.x + tabSize * 0.5 )
				
				-- If we have pressed a tab
				if pressedWithinRange then
					-- Activate the tab
					if not currentTab._isPressed then
						self:_setTabActive( i, true )
					end
					
					break
				end
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	-- Function to programatically set a tab button as active
	function tabBar:setTabActive( selectedTab )
		return self._view:_setTabActive( selectedTab )
	end
		
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set a tab as active
	function view:_setTabActive( selectedTab, invokeListener )
		for i = 1, #self._tabs do
			-- The pressed tab
			if selectedTab == i then
				-- Move the tab selected group to the newly selected tab
				self._selected.x = self._tabs[i].x - ( self._selected.contentWidth * 0.5 ) - self.x + ( self.contentWidth * 0.5 )
				
				-- Execute the tab buttons onPress method if it has one
				if self._tabs[i]._onPress then
					local newEvent = 
					{
						phase = "press",
						target = self._tabs[i],
					}
					
					-- Execute the onPress method, if it exists
					if self._tabs[i]._onPress then
						if invokeListener then
							self._tabs[i]._onPress( newEvent )
						end
					end
				end
				
				-- Set the tab to it's active state
				self._tabs[i]:setSequence( "active" )
				
				-- Set the tab as pressed
				self._tabs[i]._isPressed = true

				-- Set the label's color to 'over'
				self._tabs[i].label:setTextColor( unpack( self._tabs[i].label._color.over ) )

			-- Turn off all other tabs
			else
				-- Set the tab to it's inactive state
				self._tabs[i]:setSequence( "inActive" )
				
				-- Set the label's color to 'default'
				self._tabs[i].label:setTextColor( unpack( self._tabs[i].label._color.default ) )
				
				-- Set the tab as not pressed
				self._tabs[i]._isPressed = false
			end
		end
	end
	
	-- Finalize function for the tabBar
	function tabBar:_finalize()
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
			
	return tabBar
end

-- Function to create a new tabBar object ( widget.newTabBar)
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
	opt.width = customOptions.width or themeOptions.width or display.contentWidth
	opt.height = customOptions.height or themeOptions.height or 52
	opt.id = customOptions.id
	opt.tabButtons = customOptions.buttons
	opt.defaultLabelFont = native.systemFont
	opt.defaultLabelSize = 8
	opt.defaultLabelColor = { default = { 220, 220, 220 }, over = { 255, 255, 255 } }
	opt.onPress = customOptions.onPress
	
	-- Frames & Images
	opt.sheet = customOptions.sheet or themeOptions.sheet
	opt.sheetData = customOptions.data or themeOptions.data
	opt.backgroundFrame = customOptions.backgroundFrame or require( themeOptions.data ):getFrameIndex( themeOptions.backgroundFrame )
	opt.backgroundFrameWidth = customOptions.backgroundFrameWidth or themeOptions.backgroundFrameWidth
	opt.backgroundFrameHeight = customOptions.backgroundFrameHeight or themeOptions.backgroundFrameHeight
	opt.tabSelectedLeftFrame = customOptions.tabSelectedLeftFrame or require( themeOptions.data ):getFrameIndex( themeOptions.tabSelectedLeftFrame )
	opt.tabSelectedRightFrame = customOptions.tabSelectedRightFrame or require( themeOptions.data ):getFrameIndex( themeOptions.tabSelectedRightFrame )
	opt.tabSelectedMiddleFrame = customOptions.tabSelectedMiddleFrame or require( themeOptions.data ):getFrameIndex( themeOptions.tabSelectedMiddleFrame )
	opt.tabSelectedFrameWidth = customOptions.tabSelectedFrameWidth or themeOptions.tabSelectedFrameWidth
	opt.tabSelectedFrameHeight = customOptions.tabSelectedFrameHeight or themeOptions.tabSelectedFrameHeight
	
	if themeOptions then
		opt.iconActiveFrame = require( themeOptions.data ):getFrameIndex( themeOptions.iconActiveFrame )
		opt.iconInActiveFrame = require( themeOptions.data ):getFrameIndex( themeOptions.iconInActiveFrame )
	end
	
	-------------------------------------------------------
	-- Create the tabBar
	-------------------------------------------------------
		
	-- Create the tabBar object
	local tabBar = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_tabBar",
		baseDir = opt.baseDir,
	}

	-- Create the tabBar
	initWithImage( tabBar, opt )
	
	-- Set the tabBar's position ( set the reference point to center, just to be sure )
	tabBar:setReferencePoint( display.CenterReferencePoint )
	tabBar.x = opt.left + tabBar.contentWidth * 0.5
	tabBar.y = opt.top + tabBar.contentHeight * 0.5
	
	return tabBar
end

return M
