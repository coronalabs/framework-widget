local widget = require("widget");
local widgetExt = {};

-- Function to retrieve a widget's theme settings
local function _getTheme( widgetTheme, options )	
local widgetExt = {};

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


function widgetExt:newPanel( options )
	local theme = _getTheme( "panel", options );
  if theme == nil then
    --if the current theme does not have a panel, revert to button
    theme = _getTheme( "button", options )
  end;  
	local _panel = require( "widgets.widget_panel" )
	return _panel.new( options, theme )
end


function widgetExt:newButton( options )
	local theme = _getTheme( "button", options )
  
	local _button = require( "widgets.widget_button" )
	return _button.new( options, theme )
end

function widgetExt:newPageSlider( options )
	local theme = _getTheme( "pageslider", options )
  
	local _pageslider = require( "widgets.widget_pageslider" )
	return _pageslider.new( options, theme )
end

return widgetExt;
