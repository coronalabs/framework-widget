local widget = require("widget");
local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

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

local function createWidget(createFunction, ...)
    local defAnchorX, defAnchorY
    if not isGraphicsV1 then
        defAnchorX = display.getDefault( "anchorX")
        defAnchorY = display.getDefault( "anchorY" )
        widget._oldAnchorX = defAnchorX
        widget._oldAnchorY = defAnchorY
        
        display.setDefault( "anchorX", 0.5)
        display.setDefault( "anchorY", 0.5 )
  
    end
    local w = createFunction(...)
    if not isGraphicsV1 then
        display.setDefault( "anchorX", defAnchorX)
        display.setDefault( "anchorY", defAnchorY )
        w.anchorX = defAnchorX
        w.anchorY = defAnchorY        
    end
    return w
end

local function newPanel( options )
    local theme = _getTheme( "panel", options );
    if theme == nil then
        --if the current theme does not have a panel, revert to button
        theme = _getTheme( "button", options )
    end;  
    local _panel = require( "widgets.widget_panel" )
    return createWidget(_panel.new, options, theme )
end

widget.newPanel = newPanel;

local function newButton( options )
    local theme = _getTheme( "button", options )
    
    local _button = require( "widgets.widget_button" )
    return createWidget(_button.new, options, theme )
end

widget.newButton = newButton;


local function newPageSlider( options )
    local theme = _getTheme( "pageslider", options )
    
    local _pageslider = require( "widgets.widget_pageslider" )
    return createWidget(_pageslider.new, options, theme )
end

widget.newPageSlider = newPageSlider;


local function newEditField( options )
    local theme;
    if options.theme then
        theme = require(options.theme)["editField"]
    else
        theme = _getTheme( "editField", options );
    end    
    if theme == nil then
        --if the current theme does not have a editfield, revert to searchfield
        theme = _getTheme( "searchField", options )
    end;  
    local _editField = require( "widgets.widget_editfield" )
    return createWidget(_editField.new, options, theme )
end

widget.newEditField = newEditField;

local function newSegmentedControl( options )
    local theme = _getTheme( "segmentedControl", options )
    local _segmentedControl = require( "widgets.widget_segmentedControl" )
    return createWidget(_segmentedControl.new, options, theme )	
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


local function newPickerWheel( options )
    local theme = _getTheme( "pickerWheel", options )
    local _pickerWheel = require( "widgets.widget_pickerWheel" )
    return _pickerWheel.new( options, theme )	
end
widget.newPickerWheel = newPickerWheel;

