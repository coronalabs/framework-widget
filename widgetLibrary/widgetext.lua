local widget = require("widget");

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


-- Check if the theme is ios7
local function isSeven()
	return widget.themeName ~= "widget_theme_android" and
        widget.themeName ~= "widget_theme_ios";
end

--widget.isSeven = isSeven;

local function newPanel( options )
    local theme = _getTheme( "panel", options );
    if theme == nil then
        --if the current theme does not have a panel, revert to button
        theme = _getTheme( "button", options )
    end;  
    local _panel = require( "widgets.widget_panel" )
    return _panel.new( options, theme )
end

widget.newPanel = newPanel;

local function newButton( options )
    local theme = _getTheme( "button", options )
    
    local _button = require( "widgets.widget_button" )
    return _button.new( options, theme )
end

widget.newButton = newButton;


local function newPageSlider( options )
    local theme = _getTheme( "pageslider", options )
    
    local _pageslider = require( "widgets.widget_pageslider" )
    return _pageslider.new( options, theme )
end

widget.newPageSlider = newPageSlider;

local function newEditField( options )
    local theme = _getTheme( "editField", options );
    if theme == nil then
        --if the current theme does not have a editfield, revert to searchfield
        theme = _getTheme( "searchField", options )
    end;  
    local _editField = require( "widgets.widget_editfield" )
    return _editField.new( options, theme )
end

widget.newEditField = newEditField;

local function newSegmentedControl( options )
    local theme = _getTheme( "segmentedControl", options )
    local _segmentedControl = require( "widgets.widget_segmentedControl" )
    return _segmentedControl.new( options, theme )	
end

widget.newSegmentedControl = newSegmentedControl;


-----------------------------------------------------------------------------------------
-- newTableView widget
-----------------------------------------------------------------------------------------
local old_newTableView = nil;
local function newTableView( options )
	local _tableView = require( "widgets.widget_tableviewext" )
	return _tableView.new(old_newTableView, options )
end

if old_newTableView ~= widget.newTableView then
    old_newTableView = widget.newTableView;
end
widget.newTableView = newTableView;


local old_newScrollView = nil;
local function newScrollView( options )
	local _scrollView = require( "widgets.widget_scrollviewext" )
	return _scrollView.new(old_newScrollView, options )
end

if old_newScrollView ~= widget.newScrollView then
    old_newScrollView = widget.newScrollView;
end
widget.newScrollView = newScrollView;


local function newSwitch( options )
    local theme = _getTheme( "switch", options )
    local _switch = require( "widgets.widget_switch" )
    return _switch.new( options , theme)
end
widget.newSwitch = newSwitch;


function newPickerWheel( options )
	local theme = _getTheme( "pickerWheel", options )
	local _pickerWheel = require( "widgets.widget_pickerWheel" )
	return _pickerWheel.new( options, theme )	
end
widget.newPickerWheel = newPickerWheel;

