--****************************************************************************************
--
-- ====================================================================
-- Corona SDK Widget Module
-- ====================================================================
--
-- File: widget.lua
--
-- Copyright (C) 2012 Corona Labs Inc. All Rights Reserved.
--
--****************************************************************************************

local modname = ...
local widget = {}
package.loaded[modname] = widget
widget.version = "0.8"


-- modify factory function to ensure widgets are properly cleaned on group removal
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
-- All widget objects can add a finalize method for cleanup
local function _removeSelf( self )
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

-- set current theme from external .lua module
function widget.setTheme( themeModule )
	widget.theme = require( themeModule )	-- should return table w/ theme data
end

-- add 'setText()' method to display.newText (to be consistent with display.newEmbossed text)
local cached_newText = display.newText
function display.newText( ... )
	local text = cached_newText( ... )

	function text:setText( newString )
		self.text = newString
	end

	return text
end

-- creates very sharp text for high resolution/high density displays
function widget.retinaText( ... )
	text = display.newText( ... );
	return text
end; display.newRetinaText = display.newText --widget.retinaText

-- creates sharp (retina) text with an embossed/inset effect
function widget.embossedText( ... )
	local arg = { ... }
	
	-- parse arguments
	local parentG, w, h
	local argOffset = 0
	
	-- determine if a parentGroup was specified
	if arg[1] and type(arg[1]) == "table" then
		parentG = arg[1]; argOffset = 1
	end
	
	local string = arg[1+argOffset] or ""
	local x = arg[2+argOffset] or 0
	local y = arg[3+argOffset] or 0
	local w, h = 0, 0
	
	local newOffset = 3+argOffset
	if type(arg[4+argOffset]) == "number" then w = arg[4+argOffset]; newOffset=newOffset+1; end
	if w and #arg >= 7+argOffset then h = arg[5+argOffset]; newOffset=newOffset+1; end
	
	local font = arg[1+newOffset] or native.systemFont
	local size = arg[2+newOffset] or 12
	local color = { 0, 0, 0, 255 }
	
	---------------------------------------------
	
	local r, g, b, a = color[1], color[2], color[3], color[4]
	local textBrightness = ( r + g + b ) / 3
	
	local highlight = display.newText( string, 0.5, 1, w, h, font, size )
	if ( textBrightness > 127) then
		highlight:setTextColor( 255, 255, 255, 20 )
	else
		highlight:setTextColor( 255, 255, 255, 140 )
	end
	
	local shadow = display.newText( string, -0.5, -1, w, h, font, size )
	if ( textBrightness > 127) then
		shadow:setTextColor( 0, 0, 0, 128 )
	else
		shadow:setTextColor( 0, 0, 0, 20 )
	end
	
	local label = display.newText( string, 0, 0, w, h, font, size )
	label:setTextColor( r, g, b, a )
	
	-- create display group, insert all embossed text elements, and position it
	local text = display.newGroup()
	text:insert( highlight ); text.highlight = highlight
	text:insert( shadow ); text.shadow = shadow
	text:insert( label ); text.label = label
	text.x, text.y = x, y
	text:setReferencePoint( display.CenterReferencePoint )
	
	-- setTextColor method
	function text:setTextColor( ... )
		local r, g, b, a; local arg = { ... }
		
		if #arg == 4 then
			r = arg[1]; g = arg[2]; b = arg[3]; a = arg[4]
		elseif #arg == 3 then
			r = arg[1]; g = arg[2]; b = arg[3]; a = 255
		elseif #arg == 2 then
			r = arg[1]; g = r; b = r; a = arg[2]
		elseif #arg == 1 then
			if type(arg[1]) == "number" then
				r = arg[1]; g = r; b = r; a = 255
			end
		end
		
		local textBrightness = ( r + g + b ) / 3
		if ( textBrightness > 127) then
			self.highlight:setTextColor( 255, 255, 255, 20 )
			self.shadow:setTextColor( 0, 0, 0, 128 )
		else
			self.highlight:setTextColor( 255, 255, 255, 140 )
			self.shadow:setTextColor( 0, 0, 0, 20 )
		end
		self.label:setTextColor( r, g, b, a )
	end
	
	-- setText method
	function text:setText( newString )
		local newString = newString or self.text
		self.highlight.text = newString
		self.shadow.text = newString
		self.label.text = newString
		self.text = newString
	end
	
	-- setSize method
	function text:setSize ( newSize )
		local newSize = newSize or size
		self.highlight.size = newSize
		self.shadow.size = newSize
		self.label.size = newSize
		self.size = newSize
	end
	
	if parentG then parentG:insert( text ) end
	text.text = string
	return text
end; display.newEmbossedText = widget.embossedText

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--
-- button widget
--
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

function widget.newButton( options )
	-- this widget supports visual customization via themes
	local themeOptions
	if widget.theme then
		local buttonTheme = widget.theme.button
		
		if buttonTheme then
			if options and options.style then	-- style parameter optionally set by user
				
				-- for themes that support various "styles" per widget
				local style = buttonTheme[options.style]
				
				if style then themeOptions = style; end
			else
				-- if no style parameter set, use default style specified by theme
				themeOptions = buttonTheme
			end
		end
	end

	if options.emboss then
		options.textFunction = widget.embossedText
	end

	return require( "widget_button" ).createButton( options, themeOptions )
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--
-- slider widget
--
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

function widget.newSlider( options )
	-- this widget supports visual customization via themes
	local themeOptions
	if widget.theme then
		local sliderTheme = widget.theme.slider
		
		if sliderTheme then
			if options and options.style then	-- style parameter optionally set by user
				
				-- for themes that support various "styles" per widget
				local style = sliderTheme[options.style]
				
				if style then themeOptions = style; end
			else
				-- if no style parameter set, use default style specified by theme
				themeOptions = sliderTheme
			end
		end
	end
	
	return require( "widget_slider" ).createSlider( options, themeOptions )
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--
-- pickerWheel widget
--
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

function widget.newPickerWheel( options )
	-- this widget requires visual customization via themes to work properly
	local themeOptions
	if widget.theme then
		local pickerTheme = widget.theme.pickerWheel
		
		if pickerTheme then
			if options and options.style then	-- style parameter optionally set by user
				
				-- for themes that support various "styles" per widget
				local style = pickerTheme[options.style]
				
				if style then themeOptions = style; end
			else
				-- if no style parameter set, use default style specified by theme
				themeOptions = pickerTheme
			end
			
			return require( "widget_picker" ).createPickerWheel( options, themeOptions )
		else
			print( "WARNING: The widget theme you are using does not support the pickerWheel widget." )
			return
		end
	else
		print( "WARNING: The pickerWheel widget requires a visual theme. Use widget.setTheme()." )
		return
	end
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--
-- scrollView widget
--
-----------------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------
--
-- tabBar widget
--
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

function widget.newTabBar( options )
	-- this widget supports visual customization via themes
	local themeOptions
	if widget.theme then
		local tabBarTheme = widget.theme.tabBar
		
		if tabBarTheme then
			if options and options.style then	-- style parameter optionally set by user
				
				-- for themes that support various "styles" per widget
				local style = tabBarTheme[options.style]
				
				if style then themeOptions = style; end
			else
				-- if no style parameter set, use default style specified by theme
				themeOptions = tabBarTheme
			end
		end
	end
	
	return require( "widget_tabbar" ).createTabBar( options, themeOptions )
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--
-- tableView widget (based on scrollView widget)
--
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

function widget.newTableView( options )
	return require( "widget_tableview" ).createTableView( options )
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--
-- Spinner widget
--
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

function widget.newSpinner( options )
	-- this widget requires visual customization via themes to work properly
	local themeOptions
	if widget.theme then
		local spinnerTheme = widget.theme.spinner
				
		if spinnerTheme then
			if options and options.style then	-- style parameter optionally set by user
				
				-- for themes that support various "styles" per widget
				local style = spinnerTheme[options.style]
				
				if style then themeOptions = style; end
			else
				-- if no style parameter set, use default style specified by theme
				themeOptions = spinnerTheme
			end
			
			return require( "widget_spinner" ).new( options, themeOptions )
		else
			print( "WARNING: The widget theme you are using does not support the spinner widget." )
			return
		end
	else
		return require( "widget_spinner" ).new( options )
	end
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--
-- Switch widget
--
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

function widget.newSwitch( options )
	-- this widget requires visual customization via themes to work properly
	local themeOptions
	if widget.theme then
		local switchTheme = widget.theme.switch
				
		if switchTheme then
			if options and options.style then	-- style parameter optionally set by user
				
				-- for themes that support various "styles" per widget
				local style = switchTheme[options.style]
				
				if style then themeOptions = style; end
			else
				-- if no style parameter set, use default style specified by theme
				themeOptions = switchTheme
			end
			
			return require( "widget_switch" ).new( options, themeOptions )
		else
			print( "WARNING: The widget theme you are using does not support the switch widget." )
			return
		end
	else
		return require( "widget_switch" ).new( options )
	end
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

return widget