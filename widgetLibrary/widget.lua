--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
	File: 
		widget.lua
--]]

local widget = 
{
	version = "2.0",
	_directoryPath = "widgetLibrary.",
}

---------------------------------------------------------------------------------
-- PRIVATE METHODS
---------------------------------------------------------------------------------

-- Modify factory function to ensure widgets are properly cleaned on group removal
local cached_displayNewGroup = display.newGroup
function display.newGroup()
	local newGroup = cached_displayNewGroup()
	
	-- Function to find/remove widgets within group
	local function removeWidgets( group )
		if group.numChildren then
			for i = group.numChildren, 1, -1 do
				if group[i]._isWidget then
					group[i]:removeSelf()
				
				elseif not group[i]._isWidget and group[i].numChildren then
					-- Nested group (that is not a widget)
					removeWidgets( group[i] )
				end
			end
		end
	end
	
	-- Store a reference to the original removeSelf method
	local cached_removeSelf = newGroup.removeSelf
	
	-- Subclass the removeSelf method
	function newGroup:removeSelf()
		-- Remove widgets first
		removeWidgets( self )
		
		-- Continue removing the group as usual
		if self.parent and self.parent.remove then
			self.parent:remove( self )
		end
	end
	
	return newGroup
end

-- Override removeSelf() method for new widgets
local function _removeSelf( self )
	-- All widget objects can add a finalize method for cleanup
	local finalize = self._finalize
	
	-- If this widget has a finalize function
	if type( finalize ) == "function" then
		finalize( self )
	end

	-- Remove the object
	self:_removeSelf()
	self = nil
end


-- Dummy function to remove focus from a widget, any widget can override this function to remove focus if needed.
function widget._loseFocus()
	return
end

-- Widget constructor. Every widget object is created from this method
function widget._new( options )
	local newWidget = display.newGroup() -- All Widget* objects are display groups
	newWidget.x = options.left or 0
	newWidget.y = options.top or 0
	newWidget.id = options.id or "widget*"
	newWidget.baseDir = options.baseDir or system.ResourceDirectory
	newWidget._isWidget = true
	newWidget._widgetType = options.widgetType
	newWidget._removeSelf = newWidget.removeSelf
	newWidget.removeSelf = _removeSelf
	newWidget._loseFocus = widget._loseFocus
	
	return newWidget
end

-- Function to retrieve a frame index from an imageSheet data file
function widget._getFrameIndex( theme, frame )
	if theme then
		if theme.data then
			if "function" == type( require( theme.data ).getFrameIndex ) then
				return require( theme.data ):getFrameIndex( frame )
			end
		end
	end
end

-- Function to check if the requirements for creating a widget have been met
function widget._checkRequirements( options, theme, widgetName )
	-- If we are using single images, just return
	if options.defaultFile or options.overFile then
		return
	end
	
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

-- Function to check if an object is within bounds
function widget._isWithinBounds( object, event )
	local bounds = object.contentBounds
    local x, y = event.x, event.y
	local isWithinBounds = true
		
	if "table" == type( bounds ) then
		if "number" == type( x ) and "number" == type( y ) then
			isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
		end
	end
	
	return isWithinBounds
end

------------------------------------------------------------------------------------------
-- PUBLIC METHODS
------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- newScrollView widget
-----------------------------------------------------------------------------------------

function widget.newScrollView( options )
	local _scrollView = nil
	
	-- Function to require the scrollview file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_scrollView = require( widget._directoryPath .. "widget_scrollview" )
	end

	-- If no scrollview file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_scrollView = require( "widget_scrollview" )
	end
	
	return _scrollView.new( options )
end

-----------------------------------------------------------------------------------------
-- newTableView widget
-----------------------------------------------------------------------------------------

function widget.newTableView( options )
	local _tableView = nil
	
	-- Function to require the tableview file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_tableView = require( widget._directoryPath .. "widget_tableview" )
	end

	-- If no tableview file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_tableView = require( "widget_tableview" )
	end
	
	return _tableView.new( options )	
end

-----------------------------------------------------------------------------------------
-- newPickerWheel widget
-----------------------------------------------------------------------------------------

function widget.newPickerWheel( options )
	local theme = _getTheme( "pickerWheel", options )
	
	local _pickerWheel = nil
	
	-- Function to require the pickerWheel file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_pickerWheel = require( widget._directoryPath .. "widget_pickerWheel" )
	end

	-- If no pickerWheel file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_pickerWheel = require( "widget_pickerWheel" )
	end
	
	return _pickerWheel.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newSlider widget
-----------------------------------------------------------------------------------------

function widget.newSlider( options )	
	local theme = _getTheme( "slider", options )
	
	local _slider = nil
	
	-- Function to require the slider file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_slider = require( widget._directoryPath .. "widget_slider" )
	end

	-- If no slider file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_slider = require( "widget_slider" )
	end
	
	return _slider.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newTabBar widget
-----------------------------------------------------------------------------------------

function widget.newTabBar( options )
	local theme = _getTheme( "tabBar", options )
	
	local _tabBar = nil
	
	-- Function to require the tabbar file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_tabBar = require( widget._directoryPath .. "widget_tabbar" )
	end

	-- If no tabbar file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_tabBar = require( "widget_tabbar" )
	end
	
	return _tabBar.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newButton widget
-----------------------------------------------------------------------------------------

function widget.newButton( options )
	local theme = _getTheme( "button", options )
	
	local _button = nil
	
	-- Function to require the button file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_button = require( widget._directoryPath .. "widget_button" )
	end

	-- If no button file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_button = require( "widget_button" )
	end
	
	return _button.new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSpinner widget
-----------------------------------------------------------------------------------------

function widget.newSpinner( options )
	local theme = _getTheme( "spinner", options )
	
	local _spinner = nil
	
	-- Function to require the spinner file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_spinner = require( widget._directoryPath .. "widget_spinner" )
	end

	-- If no spinner file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_spinner = require( "widget_spinner" )
	end
	
	return _spinner.new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSwitch widget
-----------------------------------------------------------------------------------------

function widget.newSwitch( options )
	local theme = _getTheme( "switch", options )
	
	local _switch = nil
	
	-- Function to require the switch file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_switch = require( widget._directoryPath .. "widget_switch" )
	end

	-- If no switch file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_switch = require( "widget_switch" )
	end
	
	return _switch.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newStepper widget
-----------------------------------------------------------------------------------------

function widget.newStepper( options )
	local theme = _getTheme( "stepper", options )
	
	local _stepper = nil
	
	-- Function to require the stepper file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_stepper = require( widget._directoryPath .. "widget_stepper" )
	end

	-- If no stepper file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_stepper = require( "widget_stepper" )
	end
	
	return _stepper.new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSearchField widget
-----------------------------------------------------------------------------------------

function widget.newSearchField( options )
	local theme = _getTheme( "searchField", options )
	
	local _searchField = nil
	
	-- Function to require the searchField file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_searchField = require( widget._directoryPath .. "widget_searchField" )
	end

	-- If no searchField file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_searchField = require( "widget_searchField" )
	end
	
	return _searchField.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newProgressView widget
-----------------------------------------------------------------------------------------

function widget.newProgressView( options )
	local theme = _getTheme( "progressView", options )
	
	local _progressView = nil
	
	-- Function to require the progressView file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_progressView = require( widget._directoryPath .. "widget_progressView" )
	end

	-- If no progressView file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_progressView = require( "widget_progressView" )
	end
	
	return _progressView.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newSegmentedControl widget
-----------------------------------------------------------------------------------------

function widget.newSegmentedControl( options )
	local theme = _getTheme( "segmentedControl", options )
	
	local _segmentedControl = nil
	
	-- Function to require the segmentedControl file from the widget directory path (if it exists)
	local function checkFileAtPath()
		_segmentedControl = require( widget._directoryPath .. "widget_segmentedControl" )
	end

	-- If no segmentedControl file exists in the widget directory path, require the one from the core
	if false == pcall( checkFileAtPath ) then
		_segmentedControl = require( "widget_segmentedControl" )
	end
	
	return _segmentedControl.new( options, theme )	
end


-- Get platform
local isAndroid = "Android" == system.getInfo( "platformName" )
local defaultTheme = "widget_theme_ios"

if isAndroid then
	defaultTheme = "widget_theme_android"
end

-- Set the default theme
widget.setTheme( defaultTheme )

return widget
