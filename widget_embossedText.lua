--[[
	Copyright:
		Copyright (C) 2012 Corona Inc. All Rights Reserved.
		
	File: 
		widget_embossedText.lua
		
	What is it?: 
		A widget object that can be used to create embossed text.
--]]

local M = 
{
	_options = {},
	_widgetName = "display.newEmbossedText",
}


function M.new( ... )
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
end

return M
