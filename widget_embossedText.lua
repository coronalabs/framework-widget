--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
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


local function initWithEmbossedText( embossedText, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local view, textHighLight, textShadow, textColor
	
	-- Create the text's highlight
	textHighlight = display.newText( embossedText, opt.string, 0, 0, opt.width, opt.height, opt.font, opt.fontSize )
	
	-- Create the text's shadow
	textShadow = display.newText( embossedText, opt.string, 0, 0, opt.width, opt.height, opt.font, opt.fontSize )
	
	-- Create the view
	view = display.newText( embossedText, opt.string, 0, 0, opt.width, opt.height, opt.font, opt.fontSize )

	----------------------------------
	-- Positioning
	----------------------------------
	
	-- The view
	view.x = embossedText.x + ( view.contentWidth * 0.5 )
	view.y = embossedText.y + ( view.contentHeight * 0.5 )
	
	-- The view's highlight
	textHighlight.x = view.x + 0.5
	textHighlight.y = view.y + 1
	
	-- The view's shadow
	textShadow.x = view.x - 0.5
	textShadow.y = view.y - 1

	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._highlight = textHighlight
	view._shadow = textShadow
	view._fontSize = opt.fontSize
	
	-------------------------------------------------------
	-- Assign properties/objects to the embossedText
	-------------------------------------------------------
	
	-- Assign objects to the embossedText
	embossedText._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the text's color
	function embossedText:setTextColor( ... )
		return self._view:_setTextColor( ... )
	end
	
	-- Function to set the text's emboss color
	function embossedText:setEmbossColor( embossColor )
		return self.view:_setEmbossColor( embossColor )
	end

	-- Function to update the text's string
	function embossedText:setText( newString )
		return self._view:_setText( newString )
	end
	
	-- Function to set the text's size
	function embossedText:setSize( newSize )
		return self._view:_setSize( newSize )
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the text's color
	function view:_setTextColor( ... )
		local arg = { ... }
		local color = { r = 0, g = 0, b = 0, a = 0 }
					
		-- Set the color
		if 4 == #arg then
			color.r = arg[1]
			color.g = arg[2]
			color.b = arg[3]
			color.a = arg[4]
		elseif 3 == #arg then
			color.r = arg[1]
			color.g = arg[2]
			color.b = arg[3]
			color.a = 255
		elseif 2 == #arg then
			color.r = arg[1]
			color.g = color.r
			color.b = color.r
			color.a = arg[2]
		elseif 1 == #arg then
			color.r = arg[1]
			color.g = color.r
			color.b = color.r
			color.a = 255
		end
					
		-- Set the textBrightness
		self._textBrightness = ( color.r + color.g + color.b ) / 3
		
		-- Set the highlight and shadow colors
		if self._textBrightness > 127 then
			self._highlight:setTextColor( 255, 255, 255, 20 )
			self._shadow:setTextColor( 0, 0, 0, 128 )
		else
			self._highlight:setTextColor( 255, 255, 255, 140 )
			self._shadow:setTextColor( 0, 0, 0, 20 )
		end
		
		-- Set the text objects color
		self:setTextColor( color.r, color.g, color.b, color.a )
	end
	
	-- Set the text color initially
	view:_setTextColor( 0, 0, 0, 255 )
		
	-- Function to set the emboss color
	function view:_setEmbossColor( embossColor )
		-- Setup the color table
		local color = 
		{
			highlight = 
			{
				r = embossColor.highlight.r or 255,
				g = embossColor.highlight.g or embossColor.highlight.r,
				b = embossColor.highlight.b or embossColor.highlight.r,
				a = embossColor.highlight.a or 255,
			},
			shadow =
			{
				r = embossColor.shadow.r or 255,
				g = embossColor.shadow.g or embossColor.shadow.r,
				b = embossColor.shadow.b or embossColor.shadow.r,
				a = embossColor.shadow.a or 255,
			},
		}
		
		-- Set the highlight color
		self._highlight:setTextColor( color.highlight.r, color.highlight.g, color.highlight.b, color.highlight.a  )
		
		-- Set the shadow color
		self._shadow:setTextColor( color.shadow.r, color.shadow.g, color.shadow.b, color.shadow.a )
	end	
		
	-- Function to update the text's string
	function view:_setText( newString )
		local string = newString or self.text
		
		-- Update the text string
		self.text = newString
		self._highlight.text = self.text
		self._shadow.text = self.text
	end
	
	
	-- Function to set the text's size
	function view:_setSize( newSize )
		local size = newSize or self._fontSize
	
		-- Update the text size
		self.size = size
		self._highlight.size = self.size
		self._shadow.size = self.size
	end

	-- Insert the embossedText group into a parent group if specified
	if opt.parentGroup then 
		opt.parentGroup:insert( embossedText ) 
	end
	
	-- Finalize function
	function embossedText:_finalize()
		-- 
	end

	return embossedText
end

	
-- Function to create a new EmbossedText object ( display.newEmbossedText )
function M.new( ... )
	-- Create a table to hold the passed in arguments
	local arg = { ... }
	
	-- Create our options table
	local opt = {}
	
	-- Create variables to hold the current argument offset
	local argOffset, newArgOffset = 0, 0
	
	-- Get parent group if passed
	if arg[1] and type( arg[1] ) == "table" then
		opt.parentGroup = arg[1]
		argOffset = 1
	end
	
	-- Get the text string
	opt.string = arg[1+argOffset] or ""
	
	-- Get left/top positions
	opt.left = arg[2+argOffset] or 0
	opt.top = arg[3+argOffset] or 0
	
	-- Set width/height to 0 initally
	opt.width = 0
	opt.height = 0
	
	-- Set the new offset
	newArgOffset = 3 + argOffset
	
	-- Get width
	if type( arg[4+argOffset] ) == "number" then 
		opt.width = arg[4+argOffset]
		newArgOffset = newArgOffset + 1
	end
	
	-- Get Height
	if opt.width and #arg >= 7 + argOffset then 
		opt.height = arg[5+argOffset]
		newArgOffset = newArgOffset 
	end
	
	-- Get font, fontSize & fontColor
	opt.font = arg[1+newArgOffset] or native.systemFont
	opt.fontSize = arg[2+newArgOffset] or 12
		
	-------------------------------------------------------
	-- Create the Embossed Text
	-------------------------------------------------------
		
	-- Create the EmbossedText object
	local embossedText = require( "widget" )._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_embossedText",
		baseDir = opt.baseDir,
	}

	-- Create the embossedText
	initWithEmbossedText( embossedText, opt )
	
	-- Set the embossedText's position ( set the reference point to center, just to be sure )
	embossedText:setReferencePoint( display.CenterReferencePoint )
	embossedText.x = opt.left + embossedText.contentWidth * 0.5
	embossedText.y = opt.top + embossedText.contentHeight * 0.5
	
	return embossedText	
end

return M
