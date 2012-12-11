--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget.lua
--]]

local modname = ...
local widget = {}
package.loaded[modname] = widget
widget.version = "0.9"

---------------------------------------------------------------------------------
-- PRIVATE METHODS
---------------------------------------------------------------------------------

-- Modify factory function to ensure widgets are properly cleaned on group removal
local cached_displayNewGroup = display.newGroup
function display.newGroup()
	local g = cached_displayNewGroup()
	
	-- function to find/remove widgets within group
	local function removeWidgets( group )
		if group.numChildren then
			for i=group.numChildren,1,-1 do
				if group[i]._isWidget then
					group[i]:removeSelf()
				
				elseif not group[i]._isWidget and group[i].numChildren then
					-- nested group (that is not a widget)
					removeWidgets( group[i] )
				end
			end
		end
	end
	
	-- store reference to original removeSelf method
	local cached_removeSelf = g.removeSelf
	
	-- subclass removeSelf method
	function g:removeSelf()
		removeWidgets( self )	-- remove widgets first
		
		-- continue removing group as usual
		if self.parent and self.parent.remove then
			self.parent:remove( self )
		end
	end
	
	return g
end

-- Override removeSelf() method
local function _removeSelf( self )
	-- All widget objects can add a finalize method for cleanup
	local finalize = self._finalize
	
	if type( finalize ) == "function" then
		finalize( self )
	end

	self:_removeSelf()
	self = nil
end

-- Widget constructor. Every widget object is created from this method
function widget._new( options )
	local newWidget = display.newGroup() -- All Widget* objects are display groups
	newWidget.x = options.left or 0
	newWidget.y = options.top or 0
	newWidget.id = options.id or "widget*"
	newWidget.baseDir = options.baseDir or system.ResourceDirectory
	newWidget._isWidget = true
	newWidget._removeSelf = newWidget.removeSelf
	newWidget.removeSelf = _removeSelf
	
	return newWidget
end

-- Function to check if the requirements for creating a widget has been met.
function widget._checkRequirements( options, theme, widgetName )
	-- If there isn't an options table and there isn't a theme set, throw an error
	local noParams = not options and not theme
	
	if noParams then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support " .. widgetName, 3 )
	end
	
	-- If the user hasn't provided the necessary image sheet lua file (either via custom sheet or widget theme)
	local noData = not options.data and not theme.data

	if noData then
		if widget.theme then
			error( "ERROR: " .. widgetName .. ": theme data file expected, got nil", 3 )
		else
			error( "ERROR: " .. widgetName .. ": Attempt to create a widget with no custom imageSheet data set and no theme set, if you want to use a theme, you must call widget.setTheme( theme )", 3 )
		end
	end
	
	-- Throw error if the user hasn't defined a sheet and has defined data or vice versa.
	local noSheet = not options.sheet and not theme.sheet
	
	if noSheet then
		if widget.theme then
			error( "ERROR: " .. widgetName .. ": Theme sheet expected, got nil", 3 )
		else
			error( "ERROR: " .. widgetName .. ": Attempt to create a widget with no custom imageSheet set and no theme set, if you want to use a theme, you must call widget.setTheme( theme )", 3 )
		end
	end		
end

-- Set the current theme from a lua theme file
function widget.setTheme( themeModule )
	-- Returns table with theme data
	widget.theme = require( themeModule )
end

-- Function to retrieve a widget's theme settings
local function _getTheme( widgetTheme, options )	
	local theme = nil
		
	-- If a theme has been set
	if widget.theme then
		theme = widget.theme[widgetTheme]
	end
	
	-- If a theme exists
	if theme then
		-- Style parameter optionally set by user
		if options and options.style then
			local style = theme[options.style]
			
			-- For themes that support various "styles" per widget
			if style then
				theme = style
			end
		end
	end
	
	return theme
end

------------------------------------------------------------------------------------------
-- PUBLIC METHODS
------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- newEmbossedText widget
-----------------------------------------------------------------------------------------

-- Add 'setText()' method to display.newText (to be consistent with display.newEmbossed text)
local cached_newText = display.newText

function display.newText( ... )
	local text = cached_newText( ... )

	function text:setText( newString )
		self.text = newString
	end

	return text
end

display.newEmbossedText = require( "widget_embossedText" ).new
widget.embossedText = display.newEmbossedText

-----------------------------------------------------------------------------------------
-- newPickerWheel widget
-----------------------------------------------------------------------------------------

function widget.newPickerWheel( options )
	local theme = _getTheme( "pickerWheel", options )
	
	if theme then
		return require( "widget_picker" ).createPickerWheel( options, theme )
	else
		print( "WARNING: The pickerWheel widget requires a visual theme. Use widget.setTheme()." )
	end
end

-----------------------------------------------------------------------------------------
-- newScrollView widget
-----------------------------------------------------------------------------------------

function widget.newScrollView( options )
	if options and (not options.friction) then
		options.friction = scrollFriction
	elseif not options then
		options = { friction=scrollFriction }
	end
	return require( "widget_scrollview" ).createScrollView( options )
end

-----------------------------------------------------------------------------------------
-- newTableView widget
-----------------------------------------------------------------------------------------

function widget.newTableView( options )
	return require( "widget_tableview" ).createTableView( options )
end

-----------------------------------------------------------------------------------------
-- newSlider widget
-----------------------------------------------------------------------------------------

function widget.newSlider( options )	
	local theme = _getTheme( "slider", options )
	
	return require( "widget_slider" ).new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newTabBar widget
-----------------------------------------------------------------------------------------

function widget.newTabBar( options )
	local theme = _getTheme( "tabBar", options )
	
	return require( "widget_tabBar" ).new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newButton widget
-----------------------------------------------------------------------------------------

function widget.newButton( options )
	local theme = _getTheme( "button", options )
	
	return require( "widget_button" ).new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSpinner widget
-----------------------------------------------------------------------------------------

function widget.newSpinner( options )
	local theme = _getTheme( "spinner", options )

	return require( "widget_spinner" ).new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSwitch widget
-----------------------------------------------------------------------------------------

function widget.newSwitch( options )
	local theme = _getTheme( "switch", options )
	
	return require( "widget_switch" ).new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newStepper widget
-----------------------------------------------------------------------------------------

function widget.newStepper( options )
	local theme = _getTheme( "stepper", options )
	
	return require( "widget_stepper" ).new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSearchField widget
-----------------------------------------------------------------------------------------

function widget.newSearchField( options )
	local theme = _getTheme( "searchField", options )
	
	return require( "widget_searchField" ).new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newProgressView widget
-----------------------------------------------------------------------------------------

function widget.newProgressView( options )
	local theme = _getTheme( "progressView", options )
	
	return require( "widget_progressView" ).new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSegmentedControl widget
-----------------------------------------------------------------------------------------

function widget.newSegmentedControl( options )
	local theme = _getTheme( "segmentedControl", options )
	
	return require( "widget_segmentedControl" ).new( options, theme )
end

return widget
