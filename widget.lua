--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK Widget Module
-- ====================================================================
--
-- File: widget.lua
--
-- version 0.2.9 (BETA)
--
-- Copyright (C) 2011 ANSCA Inc. All Rights Reserved.
--
--*********************************************************************************************

local modname = ...
local widget = {}
package.loaded[modname] = widget
widget.version = "0.2.9 (BETA)"

--***************************************************************************************
--***************************************************************************************
--
-- button
--
--***************************************************************************************
--***************************************************************************************

function widget.button()
	local button = {
		__index = function(t,k)
			return t._view[k]
		end,

		__newindex = function(t,k,v)
			t._view[k] = v
		end
	}
	--package.loaded[modname] = button
	local button_mt = {
		__index = button.__index,
		__newindex = button.__newindex
	}

	-----------------------------------------------------------------------------------------
	
	local function setLabel( self, newLabel )
		if newLabel and self.label.text ~= newLabel then
			local x, y = self.label.x, self.label.y
			
			if self.label.setText then
				-- embossed text
				self.label:setText( newLabel )
			else
				self.label.text = newLabel
			end
			
			-- reposition text
			self.label:setReferencePoint( display.CenterReferencePoint )
			self.label.x, self.label.y = x, y
		end
	end

	local function onButtonTouch( self, event )
		local result = true
		local phase = event.phase
		local event = event
		event.name = "buttonEvent"
		event.target = self.parentObject

		if phase == "began" then
			display.getCurrentStage():setFocus( self )
			self.isFocus = true

			event.phase = "press"
			if self.onEvent then
				result = self.onEvent( event )
			elseif self.onPress then
				result = self.onPress( event )
			end

			self.default.isVisible = false
			self.over.isVisible = true
			local r, g, b, a = self.label.color.over[1] or 0, self.label.color.over[2] or self.label.color.over[1], self.label.color.over[3] or self.label.color.over[1], self.label.color.over[4] or 255
			self.label:setTextColor( r, g, b, a )

		elseif self.isFocus then
			local bounds = self.contentBounds
			local x, y = event.x, event.y
			local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

			if phase == "moved" then

				if not isWithinBounds then
					self.default.isVisible = true
					self.over.isVisible = false

					local r, g, b, a = self.label.color.default[1] or 0, self.label.color.default[2] or self.label.color.default[1], self.label.color.default[3] or self.label.color.default[1], self.label.color.default[4] or 255
					self.label:setTextColor( r, g, b, a )
				else
					self.default.isVisible = false
					self.over.isVisible = true

					local r, g, b, a = self.label.color.over[1] or 0, self.label.color.over[2] or self.label.color.over[1], self.label.color.over[3] or self.label.color.over[1], self.label.color.over[4] or 255
					self.label:setTextColor( r, g, b, a )
				end

				if self.onEvent then
					result = self.onEvent( event )
				elseif self.onDrag then
					result = self.onDrag( event )
				end

			elseif phase == "ended" or phase == "cancelled" then
				if self.default and self.over then
					self.default.isVisible = true
					self.over.isVisible = false
					local r, g, b, a = self.label.color.default[1] or 0, self.label.color.default[2] or self.label.color.default[1], self.label.color.default[3] or self.label.color.default[1], self.label.color.default[4] or 255
					self.label:setTextColor( r, g, b, a )
				end
				
				-- trigger appropriate event listener if released within bounds of button
				if isWithinBounds then
					event.phase = "release"
					if self.onEvent then
						result = self.onEvent( event )
					elseif self.onRelease then
						result = self.onRelease( event )
					end
				end

				-- remove focus from button
				display.getCurrentStage():setFocus( nil )
				self.isFocus = false
			end
		end

		return result
	end

	-----------------------------------------------------------------------------------------

	local function removeSelf( self )
		display.remove( self.default ); self.default = nil
		display.remove( self.over ); self.over = nil
		display.remove( self.label ); self.label = nil
		
		if self._view then
			self._view:cached_removeSelf()
			self.view = nil; self._view = nil
		else
			if self.cached_removeSelf then
				self:cached_removeSelf()
				self.view = nil; self._view = nil
			end
		end
	end

	-----------------------------------------------------------------------------------------

	local function createButton( params, themeOptions )

		local 	params = params or {}
		local 	theme = themeOptions or {}
		local	id = params.id
		local	left = params.left or 0
		local	top = params.top or 0
		local	offset = params.offset or theme.offset or 0		-- offsets y value of the label
		local	label = params.label or ""
		local 	font = params.font or theme.font or native.systemFont
		local 	fontSize = params.fontSize or theme.fontSize or 14
		local 	labelColor = params.labelColor or theme.labelColor or { default={ 0 }, over={ 255 } }
		local  	emboss = params.emboss or theme.emboss
		local   onPress = params.onPress
		local 	onRelease = params.onRelease
		local 	onDrag = params.onDrag
		local 	onEvent = params.onEvent
		local 	default = params.default or theme.default
		local 	over = params.over or theme.over
		local 	defaultColor = params.defaultColor or theme.defaultColor
		local 	overColor = params.overColor or theme.overColor
		local 	strokeColor = params.strokeColor or theme.strokeColor
		local 	strokeWidth = params.strokeWidth or theme.strokeWidth
		local 	cornerRadius = params.cornerRadius or theme.cornerRadius
		local 	width = params.width or theme.width
		local 	height = params.height or theme.height
		local 	baseDir = params.baseDir or theme.baseDir or system.ResourceDirectory

		---------------------------------------------

		local button = {}
		button._view = display.newGroup()

		if default then
			if not over then over = default; end

			-- user-provided image for default and over state
			if width and height then
				button.default = display.newImageRect( default, baseDir, width, height )
				button.default:setReferencePoint( display.TopLeftReferencePoint )
				button.default.x, button.default.y = 0, 0

				button.over = display.newImageRect( over, baseDir, width, height )
				button.over:setReferencePoint( display.TopLeftReferencePoint )
				button.over.x, button.over.y = 0, 0
			else
				button.default = display.newImage( default, baseDir )
				button.default:setReferencePoint( display.TopLeftReferencePoint )
				button.default.x, button.default.y = 0, 0

				button.over = display.newImage( over, baseDir )
				button.over:setReferencePoint( display.TopLeftReferencePoint )
				button.over.x, button.over.y = 0, 0
				
				width, height = button.default.width, button.default.height
			end

			button.over.isVisible = false
			button._view:insert( button.default )
			button._view:insert( button.over )

			if defaultColor then
				if defaultColor[1] then
					button.default:setFillColor( defaultColor[1], defaultColor[2] or defaultColor[1], defaultColor[3] or defaultColor[1], defaultColor[4] or 255 )
				end
			end

			if overColor then
				if overColor[1] then
					button.over:setFillColor( overColor[1], overColor[2] or overColor[1], overColor[3] or overColor[1], overColor[4] or 255 )
				end
			end
		else
			-- no images; button constructed using newRoundedRect
			if not width then width = 124; end
			if not height then height = 42; end
			if not cornerRadius then cornerRadius = 8; end

			button.default = display.newRoundedRect( 0, 0, width, height, cornerRadius )
			button.over = display.newRoundedRect( 0, 0, width, height, cornerRadius )
			button.over.isVisible = false
			button._view:insert( button.default )
			button._view:insert( button.over )

			if defaultColor and defaultColor[1] then
				button.default:setFillColor( defaultColor[1], defaultColor[2] or defaultColor[1], defaultColor[3] or defaultColor[1], defaultColor[4] or 255 )
			else
				button.default:setFillColor( 255 )
			end

			if overColor and overColor[1] then
				button.over:setFillColor( overColor[1], overColor[2] or overColor[1], overColor[3] or overColor[1], overColor[4] or 255 )
			else
				button.over:setFillColor( 128 )
			end

			if strokeColor and strokeColor[1] then
				button.default:setStrokeColor( strokeColor[1], strokeColor[2] or strokeColor[1], strokeColor[3] or strokeColor[1], strokeColor[4] or 255 )
				button.over:setStrokeColor( strokeColor[1], strokeColor[2] or strokeColor[1], strokeColor[3] or strokeColor[1], strokeColor[4] or 255 )
			else
				button.default:setStrokeColor( 0 )
				button.over:setStrokeColor( 0 )
			end

			if not strokeWidth then
				button.default.strokeWidth = 1
				button.over.strokeWidth = 1
			end
		end

		-- create the label
		if not labelColor then labelColor = {}; end
		if not labelColor.default then labelColor.default = { 0 }; end
		if not labelColor.over then labelColor.over = { 255 }; end
		local r, g, b, a = labelColor.default[1] or 0, labelColor.default[2] or labelColor.default[1], labelColor.default[3] or labelColor.default[1], labelColor.default[4] or 255
		if emboss then
			button.label = display.newEmbossedText( label, 0, 0, font, fontSize, { r, g, b, a }, offset )
		else
			button.label = display.newRetinaText( label, 0, 0+offset, font, fontSize )
			button.label:setTextColor( r, g, b, a)
		end
		button.label:setReferencePoint( display.CenterReferencePoint )
		button.label.x = width * 0.5
		button.label.y = (height * 0.5) + offset
		button.label.color = labelColor
		button._view:insert( button.label )

		-- references, methods, and touch listener
		button._view.id = id
		button.view = button._view
		button._view.parentObject = button
		button._view.label = button.label
		button._view.default = button.default
		button._view.over = button.over
		button._view.onPress = onPress
		button._view.onRelease = onRelease
		button._view.onEvent = onEvent
		button._view.onDrag = onDrag
		button._view.touch = onButtonTouch; button._view:addEventListener( "touch", button._view )
		button._view.cached_removeSelf = button._view.removeSelf
		button._view.removeSelf = removeSelf
		button._view.setLabel = setLabel

		-- position the button
		button._view:setReferencePoint( display.TopLeftReferencePoint )
		button._view.x, button._view.y = left, top
		button._view:setReferencePoint( display.CenterReferencePoint )
		
		return button
	end

	-----------------------------------------------------------------------------------------

	function button.new( widgetTheme, options )	-- constructor
		local themeOptions
		if widgetTheme then
			if options and options.style then
				themeOptions = widgetTheme.button[options.style]
			else
				themeOptions = widgetTheme.button
			end
		end

		local button_widget = createButton( options, themeOptions )

		return setmetatable( button_widget, button_mt )
	end

	-----------------------------------------------------------------------------------------

	return button
end

--***************************************************************************************
--***************************************************************************************
--
-- slider
--
--***************************************************************************************
--***************************************************************************************

function widget.slider()
	
	local slider = {}
	
	function slider.new( widgetTheme, params )

		-- override skinSetting if one is specified for this widget
		local sliderSkin = widgetTheme.slider
		local params = params or {}
		local currentStage = display.getCurrentStage()
		local mFloor = math.floor

		-- extract parameters or set defaults
		local	id = params.id or "uiSlider"
		local	initialValue = params.initialValue or params.value or 50
		local	x = params.x or 0
		local	y = params.y or 0
		local	width = params.width or sliderSkin.width
		local 	skinBase = params.baseDir or system.ResourceDirectory
		local	leftImage = params.leftImage or { sliderSkin.leftImage[1], sliderSkin.leftImage[2], sliderSkin.leftImage[3], skinBase }
		local	rightImage = params.rightImage or { sliderSkin.rightImage[1], sliderSkin.rightImage[2], sliderSkin.rightImage[3], skinBase }
		local	maskImage = params.maskImage or { sliderSkin.maskImage[1], sliderSkin.maskImage[2], sliderSkin.maskImage[3], skinBase }
		local	fillImage = params.fillImage or { sliderSkin.fillImage[1], sliderSkin.fillImage[2], sliderSkin.fillImage[3], skinBase }
		local	handleImage = params.handleImage or { sliderSkin.handleImage[1], sliderSkin.handleImage[2], sliderSkin.handleImage[3], skinBase }
		local	callBack = params.callback or params.callBack or params.onEvent

		-- don't let width go higher than 400 px
		if width > 400 then width = 400 end

		-- calculate xMin and xMax (contentBounds) based on width and x position of slider
		local halfW = (width * 0.5) + 2
		local xMin = x - halfW
		local xMax = x + halfW

		-- create groups
		local sliderControl = display.newGroup()	--> holds entire switch
		local maskGroup = display.newGroup()		--> will mask everything within this group
		local edgeGroup = display.newGroup()		--> will contain rounded edge images (underneath mask)

		-- set up table and metatable for intercepting property changes
		---local t = { _view = sliderControl, _value = initialValue }
		local t = { _view = sliderControl, _value = initialValue }
		local mt = {}

		-- set the id of the slider
		sliderControl.id = id

		-- assign a callback function to t if it exists
		if callBack then
			t._callBack = callBack
		end

		-- assign default properties to the table t
		t.sliderWidth = width

		-- insert mask group into the slider control group:
		sliderControl:insert( edgeGroup )
		sliderControl:insert( maskGroup )

		-- create the slider "fill" graphic
		local sliderFill = display.newImageRect( fillImage[1], fillImage[4], fillImage[2], fillImage[3] )

		-- determine position of fill depending on slider width
		local pixelPosition = ((initialValue * width) / 100) - (width * 0.5)
		sliderFill:setReferencePoint( display.CenterReferencePoint )
		sliderFill.x = pixelPosition

		maskGroup:insert( sliderFill )

		-- create the left and right rounded ends of the slider control
		local leftEdge = display.newImageRect( leftImage[1], leftImage[4], leftImage[2], leftImage[3] )
		leftEdge:setReferencePoint( display.CenterRightReferencePoint )

		local rightEdge = display.newImageRect( rightImage[1], rightImage[4], rightImage[2], rightImage[3] )
		rightEdge:setReferencePoint( display.CenterLeftReferencePoint )

		edgeGroup:insert( leftEdge )
		edgeGroup:insert( rightEdge )

		-- create the slider handle
		sliderControl.handle = display.newImageRect( handleImage[1], handleImage[4], handleImage[2], handleImage[3] )

		-- determine position and adjust accordingly
		sliderControl.handle:setReferencePoint( display.CenterReferencePoint )
		sliderControl.handle.x = pixelPosition

		sliderControl:insert( sliderControl.handle )

		-- create a bitmap mask and set it on the whole group
		local sliderMask = graphics.newMask( maskImage[1] )
		maskGroup:setMask( sliderMask )

		-- calculate the xScale of graphics mask depending on width of widget
		local widgetScale = width / 220
		maskGroup.maskScaleX = widgetScale * 0.5
		maskGroup.maskScaleY = 0.5

		-- localize math.floor
		local mFloor = mFloor

		-- TOUCH EVENT HANDLER

		function sliderFill:touch( event )
			local isWithinBounds = xMin-10 <= event.x and xMax+10 >= event.x

			if event.phase == "began" then

				if isWithinBounds then

					currentStage:setFocus( self, event.id )
					self.isFocus = true

					-- calculate the position things are supposed to be
					local positionCalc = event.x - x

					-- set the value of the control
					local mFloor = mFloor
					local newValue = mFloor(((( (width*0.5) + positionCalc) * 100) / width))

					if newValue < 0 then newValue = 0 end
					if newValue > 100 then newValue = 100 end

					t.value = newValue

					-- execute the callback listener if it exists (and if it's a function)
					if t._callBack and type( t._callBack ) == "function" then
						local newEvent = event
						sliderControl.value = newValue
						newEvent.target = sliderControl
						newEvent.value = newValue

						t._callBack( newEvent )
					end
				end

			elseif self.isFocus then

				if event.phase == "moved" then

					-- calculate the position things are supposed to be
					local positionCalc = event.x - x

					-- set the value of the control
					local mFloor = mFloor
					local newValue = mFloor(((( (width*0.5) + positionCalc) * 100) / width))

					if newValue < 0 then newValue = 0 end
					if newValue > 100 then newValue = 100 end

					t.value = newValue

					-- execute the callback listener if it exists (and if it's a function)
					if t._callBack and type( t._callBack ) == "function" then
						local newEvent = event
						sliderControl.value = t.value
						newEvent.target = sliderControl
						newEvent.value = newValue

						t._callBack( newEvent )
					end

				elseif event.phase == "ended" or event.phase == "cancelled" then

					currentStage:setFocus( nil )
					self.isFocus = false

				end
			end

			return true
		end

		-- assign touch listener to sliderFill object
		sliderFill:addEventListener( "touch", sliderFill )
		
		local function onHandleTouch( self, event )
			display.getCurrentStage():setFocus( sliderFill )
			sliderFill:touch( event )
			return true
		end
		sliderControl.handle.touch = onHandleTouch
		sliderControl.handle:addEventListener( "touch", sliderControl.handle )

		--==========================================================================

		-- PUBLIC METHODS

		--==========================================================================

		--

		function sliderControl:setValue( valueNum )
			sliderFill.x = ((valueNum * width) / 100) - (width * 0.5)
			self.handle.x = sliderFill.x
		end

		--

		function sliderControl:adjustWidth( newWidth )
			if not newWidth then return nil; end
			if newWidth > 400 then newWidth = 400; end

			width = newWidth

			halfW = (width * 0.5) + 2
			xMin = x - halfW
			xMax = x + halfW

			widgetScale = width / 220
			maskGroup.maskScaleX = widgetScale * 0.5

			leftEdge.x = -(x - xMin) + 20
			rightEdge.x = (x - xMin) - 20

			-- recalculate where the slider should be at
			positionCalc = ((t._value * width) / 100) - (width * 0.5)

			local newValue = mFloor(((( (width*0.5) + positionCalc) * 100) / width))


			-- reposition the handle and the slider fill
			sliderFill.x = ((newValue * width) / 100) - (width * 0.5)
			self.handle.x = sliderFill.x


			-- reposition the entire sliderControl
			self.x, self.y = x, y
		end

		--

		function t:removeSelf()

			display.remove( sliderControl )
			sliderControl = nil
			self = nil

			return nil
		end


		-- position the sliderControl group
		sliderControl.x, sliderControl.y = x, y

		--  - (x - (x - (width * 0.5)))
		-- position the left and right edges
		leftEdge.x = leftEdge.x - (x - xMin) + 9
		rightEdge.x = rightEdge.x + (x - xMin) - 9

		-- METAMETHODS to intercept property calls/assignments

		mt.__index = function( tb, key )
			if key == "value" then
				return rawget( tb, "_value" )

			elseif key == "view" then
				return rawget( tb, "_view" )

			elseif key == "width" then
				return width

			elseif key == "x" then
				return sliderControl.x

			elseif key == "y" then
				return sliderControl.y

			elseif key == "id" then
				return sliderControl.id

			end
		end

		mt.__newindex = function( tb, key, value )

			if key == "value" then

				if value < 0 then value = 0 end
				if value > 100 then value = 100 end

				t._value = value
				sliderControl:setValue( value )

			elseif key == "x" then
				x = value
				xMin = x - halfW
				xMax = x + halfW

				sliderControl.x = x

			elseif key == "y" then
				y = value
				sliderControl.y = y

			elseif key == "width" then

				sliderControl:adjustWidth( value )

			elseif key == "id" then

				sliderControl.id = value

			end
		end

		setmetatable( t, mt )

		-- assign properties to the table t
		t.value = initialValue

		-- return the sliderControl group
		return t
	end
	
	return slider
end

--***************************************************************************************
--***************************************************************************************
--
-- pickerWheel
--
--***************************************************************************************
--***************************************************************************************

function widget.pickerwheel()
	local picker = {
		__index = function(t,k)
			return t._view[k]
		end,

		__newindex = function(t,k,v)
			if k == "y" then
				-- update the 'top' property of the pickerWheel
				local top = t.top
				local yDiff = v - top
				t.top = top + yDiff
			end
			
			t._view[k] = v
		end
	}
	--package.loaded[modname] = picker
	local picker_mt = {
		__index = picker.__index,
		__newindex = picker.__newindex
	}

	-----------------------------------------------------------------------------------------
	
	local function getValues( self )
		local columnValues = {}
		
		for i=1,#self.columns do
			local row, rowIndex = self.columns[i]:getRowAtY( self.top + 112 )
			
			if row then
				columnValues[i] = {}
				columnValues[i].value = row.value
				columnValues[i].index = row.listIndex
			end
		end
		
		return columnValues
	end
	
	-----------------------------------------------------------------------------------------

	local function createColumn( columnData, options )
		local list = widget.tableview().new( nil, options )

		for i=1,#columnData do
			local labelX = 14
			local alignment = "left"
			local ref = display.CenterLeftReferencePoint
			
			if columnData.alignment then
				alignment = columnData.alignment
				
				if alignment == "center" then
					labelX = options.width * 0.5
					ref = display.CenterReferencePoint
				elseif alignment == "right" then
					labelX = options.width - 14
					ref = display.CenterRightReferencePoint
				end
			end
			
			local function renderRow( event )
				local label = display.newRetinaText( columnData[i], 0, 0, options.font, options.fontSize )
				label:setTextColor( options.fontColor[1], options.fontColor[2] or options.fontColor[1], options.fontColor[3] or options.fontColor[1], options.fontColor[4] or 255 )
				label:setReferencePoint( ref )
				label.x = labelX
				label.y = event.view.height * 0.5
				
				event.target.value = columnData[i]
				event.view:insert( label )
			end

			list:insertRow{
				onRender=renderRow,
				width = options.width,
				height=options.rowHeight or 32,
				rowColor=options.bgColor or { 255, 255, 255, 255 },
				lineColor=options.bgColor or { 255, 255, 255, 255 }
			}
		end

		return list
	end
	
	-----------------------------------------------------------------------------------------
	
	local function autoWidth( index, columnTable, maxWidth )
		local currentWidth = 0
		for i=1,index do
			local col = columnTable[i]
			
			if col.width then
				currentWidth = currentWidth + col.width
			else
				if index == 1 and #columnTable == 2 then
					currentWidth = maxWidth / #columnTable
				else
					currentWidth = maxWidth - currentWidth
					col.width = currentWidth
				end
			end
		end
		
		return currentWidth
	end
	
	-----------------------------------------------------------------------------------------
	
	local function removeSelf( self )
		for i=#self.columns,1,-1 do
			self.columns[i]:removeSelf()
			self.columns[i] = nil
		end
		self.columns = nil
		
		if self._view then self._view:cached_removeSelf(); end
		self._view = nil
		self.view = nil
		self = nil
	end

	-----------------------------------------------------------------------------------------

	local function createPicker( options, themeOptions )
		local options = options or {}
		local theme = themeOptions or {}

		-- parse parameters (options) or set defaults (or theme defaults)
		local id = options.id or ""
		local width = options.width or theme.width or 296 --252
		local height = options.height or theme.height or 222
		local left = options.left or 0
		local top = options.top or 0
		local totalWidth = options.totalWidth or theme.totalWidth or display.contentWidth
		local selectionHeight = options.selectionheight or theme.selectionHeight or 46
		local font = options.font or theme.font or system.nativeFontBold
		local fontSize = options.fontSize or theme.fontSize or 22
		local fontColor = options.fontColor or theme.fontColor or {}
			fontColor[1] = fontColor[1] or 0
			fontColor[2] = fontColor[2] or fontColor[1]
			fontColor[3] = fontColor[3] or fontColor[1]
			fontColor[4] = fontColor[4] or 255
		local columnColor = options.columnColor or theme.columnColor or {}
			columnColor[1] = columnColor[1] or 255
			columnColor[2] = columnColor[2] or columnColor[1]
			columnColor[3] = columnColor[3] or columnColor[1]
			columnColor[4] = columnColor[4] or 255
		local columns = options.columns or { { "One", "Two", "Three", "Four", "Five" } }
		local maskFile = options.maskFile or theme.maskFile
		local background = options.background or theme.background
		local backgroundWidth = options.backgroundWidth or theme.backgroundWidth
		local backgroundHeight = options.backgroundHeight or theme.backgroundHeight
		local glassFile = options.glassFile or theme.glassFile
		local glassWidth = options.glassWidth or theme.glassWidth
		local glassHeight = options.glassHeight or theme.glassHeight
		local separator = options.separator or theme.separator
		local separatorWidth = options.separatorWidth or theme.separatorWidth
		local separatorHeight = options.separatorHeight or theme.separatorHeight
		local baseDir = options.baseDir or theme.baseDir or system.ResourceDirectory

		---------------------------------------------

		local picker = {}
		picker._view = display.newGroup(); picker.view = picker._view
		picker._view.columns = {}

		local x = (totalWidth * 0.5)-(width * 0.5)
		
		if background then
			local bg = display.newImageRect( background, baseDir, backgroundWidth, backgroundHeight )
			bg:setReferencePoint( display.TopLeftReferencePoint )
			bg.x, bg.y = 0, 0
			bg.xScale = totalWidth / bg.width
			picker._view:insert( bg )
			
			local function disableTouchLeak() return true; end
			bg.touch = disableTouchLeak
			bg:addEventListener( "touch", bg )
		end
		
		local currentX = 0
		local function getRemainingWidth( currentX, maxCols, index )
			if columns[index].width then
				local w = columns[index].width
				currentX = currentX + w
				return w
			else
				local leftOver = width - currentX
				local newWidth = leftOver / (maxCols)
				currentX = currentX + newWidth
				return newWidth
			end
		end	

		for i=1,#columns do
			local col = columns[i]
			
			local params = {}
			params.bgColor = columnColor
			params.width = getRemainingWidth( currentX, #columns, i )	--autoWidth( i, columns, width ); col.width = params.width
			params.height = height
			params.topPadding = (height*0.5)-(selectionHeight*0.5)
			params.bottomPadding = (height*0.5)-(selectionHeight*0.5)
			params.friction = 0.88
			params.left = 0
			params.top = 0

			params.rowHeight = selectionHeight
			params.font = font
			params.fontSize = fontSize
			params.fontColor = fontColor
			params.maskFile = maskFile

			if #col < 3 then
				params.bottomPadding = params.topPadding + selectionHeight - (selectionHeight*2-5)
			end
			
			local separatorLine
			if separator and i ~= #columns then
				separatorLine = display.newImageRect( separator, baseDir, separatorWidth, separatorHeight )
				separatorLine:setReferencePoint( display.TopLeftReferencePoint )
				separatorLine.x = x + params.width - separatorLine.width*0.5
				separatorLine.y = 0
				separatorLine.yScale = height / separatorLine.height
				picker._view:insert( separatorLine )
			end

			picker._view.columns[i] = createColumn( col, params )
			picker._view:insert( picker._view.columns[i].view )
			picker._view.columns[i].x = x; x = x + params.width
			
			if col.startIndex then
				picker._view.columns[i]:scrollToIndex( col.startIndex, 0 )
			end
			
			if separatorLine then separatorLine:toFront(); end
		end
		
		if glassFile then
			local pickerGlass = display.newImageRect( glassFile, baseDir, glassWidth, glassHeight )
			pickerGlass:setReferencePoint( display.CenterReferencePoint )
			pickerGlass.x = totalWidth * 0.5
			pickerGlass.y = height * 0.5
			picker._view:insert( pickerGlass )
		end

		---------------------------------------------

		picker.id = id
		picker._view.x = left
		picker._view.y = top; picker.top = top
		
		
		-- methods
		picker._view.getValues = getValues
		
		-- subclass the tabBar._view.removeSelf() method
		picker._view.cached_removeSelf = picker._view.removeSelf
		picker._view.removeSelf = removeSelf

		return picker
	end

	-----------------------------------------------------------------------------------------

	function picker.new( widgetTheme, options )	-- constructor
		local themeOptions
		if widgetTheme then themeOptions = widgetTheme.pickerWheel; end

		local picker_widget = createPicker( options, themeOptions )

		return setmetatable( picker_widget, picker_mt )
	end

	-----------------------------------------------------------------------------------------
	
	return picker
end

--***************************************************************************************
--***************************************************************************************
--
-- scrollView
--
--***************************************************************************************
--***************************************************************************************

function widget.scrollview()
	local scrollView = {
		__index = function(t,k)
			return t._view[k]
		end,

		__newindex = function(t,k,v)
			t._view[k] = v
		end
	}
	--package.loaded[modname] = scrollView
	local scrollView_mt = {
		__index = scrollView.__index,
		__newindex = scrollView.__newindex
	}

	-----------------------------------------------------------------------------------------

	local function trackVelocity( self, event )
		local timePassed = event.time - self.prevTime
		self.prevTime = self.prevTime + timePassed
		self.velocity = (self.y - self.prevY) / timePassed
		self.prevY = self.y
	end

	-----------------------------------------------------------------------------------------

	local function limitMovement( self, upperLimit, lowerLimit )
		if self.y > upperLimit then

			-- Content has drifted above upper limit of scrollView
			-- Stop content movement and transition back down to upperLimit

			self.velocity = 0
			Runtime:removeEventListener( "enterFrame", self )
			if self.tween then transition.cancel( self.tween ); end
			self.tween = transition.to( self, { time=400, y=upperLimit, transition=easing.outQuad } )

		elseif self.y < lowerLimit and lowerLimit < 0 then

			-- Content has drifted below lower limit of scrollView (in case lower limit is above screen bounds)
			-- Stop content movement and transition back up to lower limit.

			self.velocity = 0
			Runtime:removeEventListener( "enterFrame", self )
			if self.tween then transition.cancel( self.tween ); end
			self.tween = transition.to( self, { time=400, y=lowerLimit, transition=easing.outQuad } )

		elseif self.y < lowerLimit then

			-- Top of content has went past lower limit of scrollView (in positive-y direction)
			-- Stop content movement and transition content back to upper limit.

			self.velocity = 0
			Runtime:removeEventListener( "enterFrame", self )
			if self.tween then transition.cancel( self.tween ); end
			self.tween = transition.to( self, { time=400, y=upperLimit, transition=easing.outQuad } )
		end
	end

	-----------------------------------------------------------------------------------------

	local function onUpdate( self, event )	-- Reference: self = scrollView._view.content
		if not self.trackVelocity then
			local timePassed = event.time - self.lastTime
			self.lastTime = self.lastTime + timePassed

			-- stop scrolling when velocity gets close to zero
			if math.abs( self.velocity ) < .01 then
				self.velocity = 0
				Runtime:removeEventListener( "enterFrame", self )
			end

			-- update velocity and content location on every framestep
			self.velocity = self.velocity * self.friction 	
			self.y = math.floor( self.y + (self.velocity * timePassed) )

			local upperLimit = self.topPadding --self.top
			local lowerLimit = self.widgetHeight - self.height - self.bottom

			limitMovement( self, upperLimit, lowerLimit )
		else
			trackVelocity( self, event )	-- track velocity if not ready to move
		end
	end

	-----------------------------------------------------------------------------------------

	local function onContentTouch( self, event )
		if event.phase == "began" then

			-- set focus on scrollView's content
			display.getCurrentStage():setFocus( self )
			self.isFocus = true

			-- set some variables necessary movement/scrolling
			self.delta, self.velocity = 0, 0
			self.prevTime, self.prevY = 0, 0
			self.prevPosition = event.y

			-- start enterFrame listener to track velocity, and to enact momentum-based scrolling
			Runtime:removeEventListener( "enterFrame", self )	-- remove in case listener is still active for whatever reason
			Runtime:addEventListener( "enterFrame", self )
			self.trackVelocity = true	-- start tracking velocity

		elseif self.isFocus then
			if event.phase == "moved" then

				-- This code handles finger movement, and prevents content from going
				-- too far past its upper and lower boundaries.

				local lowerLimit = self.widgetHeight - self.height - self.bottom

				self.delta = event.y - self.prevPosition
				self.prevPosition = event.y

				if self.y > self.top or self.y < lowerLimit then
					self.y = self.y + self.delta/2
				else
					self.y = self.y + self.delta
				end

			elseif event.phase == "ended" or event.phase == "cancelled" then

				self.lastTime = event.time	-- this is necessary for calculating scrolling movement (see onUpdate)
				self.trackVelocity = false	-- stop tracking velocity

				-- remove focus from scrollView's content
				display.getCurrentStage():setFocus( nil )
				self.isFocus = nil; self.oy = nil	-- clear un-needed variables
			end
		end

		return true
	end

	-----------------------------------------------------------------------------------------

	local function onBackgroundTouch( self, event )

		-- This function allows tableView/scrollView to be scrolled when only the background
		-- of the widget is being touched (rather than having to touch the content itself)

		if event.phase == "began" then
			local view = self.parent.content

			view:touch( event )	-- transfer touch event to content group's touch event

			return false
		end
	end

	-----------------------------------------------------------------------------------------

	local function insertIntoContent( self, obj )
		-- insert into the content group instead
		self.content:insert( obj )
	end

	-----------------------------------------------------------------------------------------

	local function getScrollPosition( self )
		return self.content.y
	end

	-----------------------------------------------------------------------------------------

	local function scrollToY( self, yPosition, timeInMs )
		yPosition = yPosition or 0
		timeInMs = timeInMs or 1500

		local svContent = self.content

		if timeInMs > 0 then
			transition.to( svContent, { y=yPosition, time=timeInMs, transition=easing.outQuad } )
		else
			-- no effect; move content instantly (timeInMs set to 0)
			svContent.y = yPosition
		end
	end

	-----------------------------------------------------------------------------------------

	local function removeSelf( self )
		if self._view then
			-- clean up content (to include event listeners, Runtime listeners, etc.)
			if self._view.content.tween then transition.cancel( self._view.content.tween ); self._view.content.tween = nil; end
			self._view.content:removeEventListener( "touch", self._view.content ); self._view.content.touch = nil
			Runtime:removeEventListener( "enterFrame", self._view.content ); self._view.content.enterFrame = nil
			for i=self._view.content.numChildren,1,-1 do
				display.remove( self._view.content[i] )
			end
			display.remove( self._view.content )

			-- clean up view
			for i=self._view.numChildren,1,-1 do
				display.remove( self._view[i] )
			end

			self._view.content = nil; self._view.parentObject = nil
			self._view:cached_removeSelf(); self._view = nil
			self._parentView:removeSelf(); self._parentView = nil
			self.view = nil
			self = nil
		end
	end

	-----------------------------------------------------------------------------------------

	local function createScrollView( options )
		local scrollView = {}

		-- to prevent errors if table parameters are not passed
		local options = options or {}
		options.bgColor = options.bgColor or {}

		-- extract parameters from options, or use default values
		local left = options.left or 0
		local top = options.top or 0
		local topPadding = options.topPadding or 0
		local bottomPadding = options.bottomPadding or 0
		local width = options.width or (display.contentWidth-left)
		local height = options.height or (display.contentHeight-top)
		local friction = options.friction or 0.935
		local r, g, b, a = options.bgColor[1] or 255, options.bgColor[2] or 255, options.bgColor[3] or 255, options.bgColor[4] or 255

		-- Create the "view" display object, its properties, and methods (will become scrollView._view)
		local parentView = display.newGroup()
		local view = display.newGroup(); parentView:insert( view )
		view.parentObject = scrollView
		view.content = display.newGroup(); parentView:insert( view.content )
		view.content.y = topPadding
		view.content.top = top
		view.content.topPadding = topPadding
		view.content.bottom = bottomPadding --display.contentHeight - height + topPadding - bottomPadding
		view.content.widgetHeight = height
		view.content.friction = friction
		view.content.enterFrame = onUpdate	-- enterFrame listener function
		view.content.touch = onContentTouch; view.content:addEventListener( "touch", view.content )

		-- Create background rectangle for widget
		local bgRect = display.newRect( view, 0, 0, width, height )
		bgRect:setFillColor( r, g, b, a )
		bgRect.touch = onBackgroundTouch
		bgRect:addEventListener( "touch", bgRect )

		-- Give scrollview a ._view property, to hold reference to the display group
		scrollView._view = view
		scrollView._view.trackVelocity = false	-- velocity is only tracked during a touch event

		-- subclass the scrollView._view.insert() method
		function scrollView._view:insert( obj )
			self.content:insert( obj )
		end

		-- subclass the scrollView._view.removeSelf() method
		scrollView._view.cached_removeSelf = scrollView._view.removeSelf
		scrollView._view.removeSelf = removeSelf

		-- Position the widget based on left/top coordinates
		scrollView._view:setReferencePoint( display.TopLeftReferencePoint )
		scrollView._view.x, scrollView._view.y = left, top

		scrollView._parentView = parentView
		scrollView.view = scrollView._parentView

		-- setup methods for the view object
		scrollView._view.getScrollPosition = getScrollPosition
		scrollView._view.scrollToY = scrollToY

		-- apply mask (if set as parameter)
		if options.maskFile then
			scrollView._parentView.mask = graphics.newMask( options.maskFile )
			scrollView._parentView:setMask( scrollView._parentView.mask )

			scrollView._parentView.maskX = left + (width * 0.5)
			scrollView._parentView.maskY = top + (height * 0.5)
		end

		return scrollView
	end

	-----------------------------------------------------------------------------------------

	function scrollView.new( widgetTheme, options )
		local scrollView_widget = createScrollView( options )

		return setmetatable( scrollView_widget, scrollView_mt )
	end

	-----------------------------------------------------------------------------------------

	return scrollView
end


--***************************************************************************************
--***************************************************************************************
--
-- tabBar
--
--***************************************************************************************
--***************************************************************************************

function widget.tabbar()
	local tabBar = {
		__index = function(t,k)
			return t._view[k]
		end,

		__newindex = function(t,k,v)
			t._view[k] = v
		end
	}
	--package.loaded[modname] = tabBar
	local tabBar_mt = {
		__index = tabBar.__index,
		__newindex = tabBar.__newindex
	}

	-----------------------------------------------------------------------------------------

	local mFloor = math.floor

	-----------------------------------------------------------------------------------------
	--
	--	PRIVATE FUNCTIONS
	--
	-----------------------------------------------------------------------------------------

	local function onButtonSelection( self )
		self.parentObject:deSelectAll()	-- deselect all tab buttons

		-- ensure overlay and down graphic are showing
		self.up.isVisible = false
		self.overlay.isVisible = true
		self.down.isVisible = true
		self.selected = true
		if self.label then self.label:setTextColor( 255, 255, 255, 255 ); end

		-- call listener function
		if self.onPress and type(self.onPress) == "function" then
			local event = {
				name = "tabButtonPress",
				target = self,
				targetParent = self.parentObject
			}
			self.onPress( event )
		end
	end

	-----------------------------------------------------------------------------------------

	local function onButtonTouch( self, event )
		if event.phase == "began" then

			-- call onButtonSelection()
			self:onSelection()

			return true
		end
	end

	-----------------------------------------------------------------------------------------

	local function createTabButton( params )

		local params = params or {}

		local id = params.id
		local label = params.label
		local labelFont = params.font or native.systemFontBold
		local labelFontSize = params.size or 10
		local labelColor = params.labelColor or { 124, 124, 124, 255 }
		local width = params.barWidth or display.contentWidth
		local height = params.barHeight or 50
		local cornerRadius = params.cornerRadius or 4
		local upGraphic = params.up or params.image
		local upWidth, upHeight = params.upWidth or params.width or 32, params.upHeight or params.height or 32
		local downGraphic = params.down
		local downWidth, downHeight = params.downWidth or upWidth, params.downHeight or upHeight
		local parentObject = params.parent
		local selected = params.selected
		local onPress = params.onPress
		local upGradient = params.upGradient
		local downGradient = params.downGradient
		local autoColor = params.autoColor
		local baseDir = params.baseDir or system.ResourceDirectory

		local button = display.newGroup()
		button.id = id

		button.overlay = display.newRoundedRect( 0, 0, width, height, cornerRadius )
		button.overlay:setFillColor( 255, 25 )
		button.overlay:setStrokeColor( 0, 75 )
		button.overlay.strokeWidth = 1
		button:insert( button.overlay )
		button.overlay.isVisible = false
		button.overlay.isHitTestable = true

		button.up = display.newImageRect( upGraphic, baseDir, upWidth, upHeight )
		button.up:setReferencePoint( display.CenterReferencePoint )
		button.up.x = button.overlay.width * 0.5
		button.up.y = button.overlay.height * 0.5
		button:insert( button.up )

		if upGraphic and not downGraphic then downGraphic = upGraphic; end
		button.down = display.newImageRect( downGraphic, baseDir, downWidth, downHeight )
		button.down:setReferencePoint( display.CenterReferencePoint )
		button.down.x = button.up.x
		button.down.y = button.up.y
		button:insert( button.down )
		button.down.isVisible = false

		if label then	-- label is optional
			-- shift icon up
			button.up.y = button.up.y - 7
			button.down.y = button.down.y - 7

			-- create label
			button.label = display.newRetinaText( label, 0, 0, labelFont, labelFontSize )
			local color = { labelColor[1] or 124, labelColor[2] or 124, labelColor[3] or 124, labelColor[4] or 255 }
			button.label:setTextColor( color[1], color[2], color[3], color[4] )
			button.label.color = color
			button.label:setReferencePoint( display.TopCenterReferencePoint )
			button.label.x = button.up.x
			button.label.y = button.up.contentBounds.yMax
			button:insert( button.label )
		end

		-- apply gradient to up and down graphics (if not set to disabled)
		if autoColor then
			-- "up" state fill ( grey )
			if not upGradient then
				button.up:setFillColor( 154 )
			end

			-- "down" state fill ( blue )
			if not downGradient then
				button.down:setFillColor( 52,175,241,255 )
			end
		end

		-- assign reference to tabBar object as button.parentObject
		if parentObject then button.parentObject = parentObject; end

		-- if selected, show overlay and 'down' graphic
		if selected then
			button.up.isVisible = false
			button.overlay.isVisible = true
			button.down.isVisible = true
			button.selected = true
			if button.label then button.label:setTextColor( 255, 255, 255, 255 ); end
		end

		-- touch event
		button.touch = onButtonTouch
		button:addEventListener( "touch", button )

		-- assign onPress event (user-specified listener function)
		button.onPress = onPress

		-- selection method to represent button visually and call listener
		button.onSelection = onButtonSelection

		return button
	end

	-----------------------------------------------------------------------------------------

	local function deSelectAll( self )
		for i=1,#self.buttons do
			local button = self.buttons[i]

			button.overlay.isVisible = false
			button.down.isVisible = false
			button.up.isVisible = true
			button.selected = false
			if button.label then button.label:setTextColor( button.label.color[1], button.label.color[2], button.label.color[3], button.label.color[4] ); end
		end
	end

	-----------------------------------------------------------------------------------------

	local function removeSelf( self )
		for i=1,#self.parentObject.buttons do
			display.remove( self.parentObject.buttons[i].overlay ); self.parentObject.buttons[i].overlay = nil
			display.remove( self.parentObject.buttons[i].up ); self.parentObject.buttons[i].up = nil
			display.remove( self.parentObject.buttons[i].down ); self.parentObject.buttons[i].down = nil
		end
		self.parentObject.buttons = nil

		-- remove all children of this ._view object
		for i=self.numChildren,1,-1 do
			display.remove( self[i] )
		end

		if self._view then self._view:cached_removeSelf(); end
		self.parentObject = nil
		self.deSelectAll = nil
		self._view = nil
		self.view = nil
		self = nil
	end

	-----------------------------------------------------------------------------------------

	local function createTabBar( options, themeOptions )
		local tabBar = {}

		local options = options or {}	-- to prevent errors if no options are passed
		local theme = themeOptions or {}
		local buttons = options.buttons or {}

		local width = options.width or theme.width or display.contentWidth
		local height = options.height or theme.height or 50
		local background = options.background or theme.background or nil
		local topGradient = options.topGradient or theme.topGradient or nil	-- if used, topGradient must be a gradient object created using graphics.newGradient()
		local bottomFill = options.bottomFill or theme.bottomFill or { 0, 0, 0, 255 }
		local left = options.left or 0
		local top = options.top or 0

		-- setup gradient
		if not background and not topGradient then
			topGradient = graphics.newGradient( { 39 }, { 0 }, "down" )
		end

		-- setup actual display object
		local view = display.newGroup()
		view.parentObject = tabBar
		local bg

		-- create background for tabBar
		if background then
			bg = display.newImageRect( "background", width, height )
		elseif topGradient then
			bg = display.newRect( 0, 0, width, height )
			bg:setFillColor( topGradient )
		end
		
		-- setup bottomFill parameter (if set)
		if bottomFill then
			bottomFill[1] = bottomFill[1] or 0
			bottomFill[2] = bottomFill[2] or bottomFill[1]
			bottomFill[3] = bottomFill[3] or bottomFill[1]
			bottomFill[4] = bottomFill[4] or 255
		end

		-- position background
		bg:setReferencePoint( display.TopLeftReferencePoint )
		bg.x, bg.y = 0, 0
		view:insert( bg )

		-- create bottom half of the background
		if not background then
			local bottomRect = display.newRect( 0, 0, width, height * 0.5 )
			bottomRect:setFillColor( bottomFill[1] or 0, bottomFill[2] or 0, bottomFill[3] or 0, bottomFill[4] or 255 )
			bottomRect:setReferencePoint( display.TopLeftReferencePoint )
			bottomRect.x, bottomRect.y = 0, height * 0.5
			view:insert( bottomRect )
		end

		-- set reference point for view and position it
		view:setReferencePoint( display.TopLeftReferencePoint )
		view.x, view.y = left, top

		-- create all of the tab buttons and space them out evenly
		tabBar.buttons = {}
		if buttons then
			local buttonWidth = mFloor((width/#buttons)-4)
			local buttonHeight = height-4
			local padding = mFloor(width/buttonWidth)*2

			for i=1,#buttons do
				buttons[i].id = buttons[i].id or i
				buttons[i].barWidth = buttonWidth
				buttons[i].barHeight = buttonHeight
				buttons[i].parent = tabBar

				tabBar.buttons[i] = createTabButton( buttons[i] )
				tabBar.buttons[i].x = (buttonWidth*i-buttonWidth) + padding
				tabBar.buttons[i].y = 2
				view:insert( tabBar.buttons[i] )
			end
		end

		-- methods
		tabBar.deSelectAll = deSelectAll

		-- assign a reference to the display object
		tabBar._view = view
		tabBar.view = tabBar._view

		-- subclass the tabBar._view.removeSelf() method
		tabBar._view.cached_removeSelf = tabBar._view.removeSelf
		tabBar._view.removeSelf = removeSelf

		return tabBar
	end

	-----------------------------------------------------------------------------------------
	--
	--	PUBLIC FUNCTIONS
	--
	-----------------------------------------------------------------------------------------

	function tabBar.new( widgetTheme, options, buttons ) -- constructor
		local themeOptions
		if widgetTheme then themeOptions = widgetTheme.tabBar; end

		local tabBar_widget = createTabBar( options, buttons, themeOptions )

		return setmetatable( tabBar_widget, tabBar_mt )
	end

	-----------------------------------------------------------------------------------------

	return tabBar
end

--***************************************************************************************
--***************************************************************************************
--
-- tableView
--
--***************************************************************************************
--***************************************************************************************

function widget.tableview()
	local tableView = {
		__index = function(t,k)
			return t._view[k]
		end,

		__newindex = function(t,k,v)
			if k == "y" then
				-- update the catGroup's y position whenever widget's 'y' is updated
				if t._view.content.catGroup then
					t._view.content.catGroup.y = v
				end
				
				-- update the 'top' property of the tableView
				local top = t._view.content.top
				local yDiff = v - top
				t._view.content.top = top + yDiff
				
				-- update the mask location
				t._parentView.maskY = v + (t._view.content.widgetHeight * 0.5)
			end
			t._view[k] = v
		end
	}
	--package.loaded[modname] = tableView
	local tableView_mt = {
		__index = tableView.__index,
		__newindex = tableView.__newindex
	}

	-----------------------------------------------------------------------------------------

	local function getRowIndex( row, rows )
		local result
		for i=1,#rows do
			if rows[i] == row then
				result = i; break
			end
		end
		return result
	end

	-----------------------------------------------------------------------------------------

	local function getTotalHeight( rows )
		local sum = 0
		for i=1,#rows do sum = sum + rows[i].height end
		return sum
	end

	-----------------------------------------------------------------------------------------

	local function checkRenderLimits( tbContent, row )
		if row.top <= tbContent.upperRenderBounds or row.top >= tbContent.lowerRenderBounds then
			row.isRendered = false
		else
			row.isRendered = true
		end
	end

	-----------------------------------------------------------------------------------------

	local function createRowBackgroundAndLine( row, parentGroup )
		local bg = display.newRect( 0, 0, row.width, row.height )
		local rowColor = row.rowColor or { 255, 255, 255, 255 }
			rowColor[1] = rowColor[1] or 255
			rowColor[2] = rowColor[2] or rowColor[1]
			rowColor[3] = rowColor[3] or rowColor[1]
			rowColor[4] = rowColor[4] or 255
		bg:setFillColor( rowColor[1], rowColor[2], rowColor[3], rowColor[4] )
		parentGroup:insert( bg )

		local line = display.newLine( 0, row.height-1, row.width, row.height-1 )
		line.width = 1
		line:setColor( row.lineColor[1], row.lineColor[2], row.lineColor[3], 255 )
		parentGroup:insert( line )
	end

	-----------------------------------------------------------------------------------------

	local function renderRow( tbContent, row, phase )
		-- set up event table
		local event = {}
		event.name = "tableView_onRender"
		event.tableView = tbContent.parentObject.parentObject	-- tableView (parent of view, which is parent of tbContent [tableView._view.content])
		event.target = row
		event.phase = phase or "render"		-- phases: render, selected, released, swipeLeft, swipeRight
		event.index = row.listIndex 		-- getRowIndex( row, tbContent.rows )

		if row._view then display.remove( row._view ); end; row._view = display.newGroup()
		createRowBackgroundAndLine( row, row._view )
		row._view.y = row.top
		event.view = row._view

		if row.onRender then row.onRender( event ); end

		tbContent.parentObject:cached_insert( row._view )
	end

	-----------------------------------------------------------------------------------------

	local function renderCategory( tbContent, row, index )
		-- setup event table
		local event = {}
		event.name = "tableView_onRender"
		event.tableView = tbContent.parentObject.parentObject	-- tableView (parent of view, which is parent of tbContent [tableView._view.content])
		event.target = row
		event.phase = "render"
		event.index = row.listIndex --getRowIndex( row, tbContent.rows )

		if tbContent.cat then

			-- If there is currently a category rendered, only re-render if it's a different category

			if index ~= tbContent.cat.index then
				display.remove( tbContent.cat )
				tbContent.cat = display.newGroup()
				createRowBackgroundAndLine( row, tbContent.cat )
				tbContent.cat.x = 0
				tbContent.cat.y = 0
				tbContent.cat.index = index
				event.view = tbContent.cat
				tbContent.catGroup:insert( tbContent.cat )	-- insert into category group

				if row.onRender then row.onRender( event ); end
			end
		else

			-- Render category (no category currently rendered)

			tbContent.cat = display.newGroup()
			createRowBackgroundAndLine( row, tbContent.cat )
			tbContent.cat.x = 0
			tbContent.cat.y = 0
			tbContent.cat.index = index
			event.view = tbContent.cat
			tbContent.catGroup:insert( tbContent.cat )	-- insert into category group

			if row.onRender then row.onRender( event ); end
		end
	end

	-----------------------------------------------------------------------------------------

	local function ensureRowIsRendered( tbContent, row )
		if not row._view then
			if row.onRender then
				renderRow( tbContent, row, "render" )
			end
		else
			row._view.y = row.top
		end
	end

	-----------------------------------------------------------------------------------------

	local function ensureRowIsNotRendered( tbContent, row )
		-- remove row._view (display object) if it exists
		if row._view then display.remove( row._view ); row._view = nil; end
	end

	-----------------------------------------------------------------------------------------

	local function getRowAtCoordinate( tbContent, yPosition, rows )
		for i=1,#rows do
			local row = rows[i]
			local top = row.top + tbContent.parentObject.y --tbContent.parentObject.top
			if tbContent.parentObject.parent.parent then
				-- picker wheel
				top = top + tbContent.parentObject.parent.parent.y
			end
			local bounds = { yMin=top, yMax=top+row.height }
			
			if yPosition >= bounds.yMin and yPosition <= bounds.yMax then
				return row, i
			end
		end
	end

	-----------------------------------------------------------------------------------------

	local function getRowAtY( self, yPosition )
		local tbContent = self.content
		local rows = tbContent.rows
		return getRowAtCoordinate( tbContent, yPosition, rows )
	end

	-----------------------------------------------------------------------------------------

	local function updateRowLocations( tbContent )
		local rows = tbContent.rows
		local topY = tbContent.y
		local view = tbContent.parentObject
		local y = topY
		local currentCategoryIndex

		-- update top (e.g. "y") location of each row
		for i=1,#rows do
			local row = rows[i]
			row.listIndex = i
			row.top = y
			
			local rowTop = row.top
			local viewTop = tbContent.top --view.top
			local viewY = view.y
			local cat = tbContent.cat
			
			-- next code block handles category "pushing" effect
			if row.isCategory and cat then
				local catBottom = viewTop + cat.height - 3
				if rowTop+viewTop <= catBottom and rowTop+viewTop > viewY then	
					tbContent.cat.y = rowTop - tbContent.catGroup.height + 3
				else
					tbContent.cat.y = 0
				end
			end

			-- check to see which category should be rendered
			if row.isCategory and rowTop+viewTop <= viewY then
				currentCategoryIndex = i
			end

			-- modify isRendered property depending on if row is above or below thresh
			checkRenderLimits( tbContent, row )

			if row.reRender then
				if row._view then display.remove( row._view ); row._view = nil; end
				row.reRender = false
			end
			
			if row.isRendered then
				ensureRowIsRendered( tbContent, row )		-- ROW *SHOULD* BE RENDERED
			else
				ensureRowIsNotRendered( tbContent, row )	-- ROW SHOULD *NOT* BE RENDERED
			end
			
			y = y + row.height	-- set the y-position for the next row
		end

		-- render proper category
		if currentCategoryIndex then
			renderCategory( tbContent, rows[currentCategoryIndex], currentCategoryIndex )
		else
			if tbContent.cat then
				display.remove( tbContent.cat )
				tbContent.cat = nil
			end
		end
	end

	-----------------------------------------------------------------------------------------

	local function deleteRow( self, rowOrIndex )
		local tbContent = self._view.content
		local rows = tbContent.rows

		if type(rowOrIndex) == "table" then
			table.remove( rows, rowOrIndex.listIndex )
		else
			table.remove( rows, rowOrIndex )
		end

		updateRowLocations( tbContent )
	end

	-----------------------------------------------------------------------------------------

	local function getNextRowTop( tbContent )

		-- FIND NEXT TOP TOP POSITION AFTER ULTIMATE ROW ITEM

		local rows = tbContent.rows
		local ultimateRow = rows[#rows]
		local currentTop

		if ultimateRow then
			currentTop = ultimateRow.top + ultimateRow.height
			return currentTop
		end
	end

	-----------------------------------------------------------------------------------------

	local function insertRowIntoTableView( self, params )	--REFERENCE: self = tableView
		local content = self._view.content
		local rows = content.rows
		local defaults = content.defaults

		params = params or {}	-- create "dummy" table if params not set

		-- extract parameters and/or set defaults
		local width = params.width or defaults.width
		local height = params.height or defaults.rowHeight
		local rowColor = params.rowColor or defaults.rowColor
			rowColor[1] = rowColor[1] or 255
			rowColor[2] = rowColor[2] or rowColor[1]
			rowColor[3] = rowColor[3] or rowColor[1]
			rowColor[4] = rowColor[4] or 255
		local lineColor = params.lineColor or defaults.lineColor
			lineColor[1] = lineColor[1] or 128
			lineColor[2] = lineColor[2] or lineColor[1]
			lineColor[3] = lineColor[3] or lineColor[1]
			lineColor[4] = 255
		local isCategory = params.isCategory or false
		local onEvent = params.onEvent
		local onRender = params.onRender
		local insertionPoint = params.position or #rows+1

		-- set up table for new row
		local row = {}

		-- row parameters (user-set)
		row.width = width
		row.height = height
		row.rowColor = rowColor
		row.lineColor = lineColor
		row.isCategory = isCategory
		row.onEvent = onEvent
		row.onRender = onRender

		-- row properties (non-userset)
		row.top = getNextRowTop( content ) or content.top - self._view.y
		row.isRendered = false

		-- insert new row at end of content.rows table
		table.insert( rows, insertionPoint, row )

		-- ensure row locations are up-to-date
		updateRowLocations( content )
	end

	-----------------------------------------------------------------------------------------

	local function trackVelocity( self, event )
		local timePassed = event.time - self.prevTime
		self.prevTime = self.prevTime + timePassed
		self.velocity = (self.y - self.prevY) / timePassed
		self.prevY = self.y
	end

	-----------------------------------------------------------------------------------------

	local function limitMovement( self, upperLimit, lowerLimit )
		local updateRows = function() updateRowLocations( self ); end
		local tweenRows = function( limit ) if self.tween then transition.cancel( self.tween ); end; self.tween = transition.to( self, { time=400, y=limit, transition=easing.outQuad } ); end
		local moveRowsWithTween = function() if self.rowTimer then timer.cancel( self.rowTimer ); end; self.rowTimer = timer.performWithDelay( 1, updateRows, 400 ); end

		if self.y > upperLimit then

			-- Content has drifted above upper limit of tableView
			-- Stop content movement and transition back down to upperLimit

			self.velocity = 0
			Runtime:removeEventListener( "enterFrame", self )
			tweenRows( upperLimit )
			moveRowsWithTween()

		elseif self.y < lowerLimit and lowerLimit < 0 then

			-- Content has drifted below lower limit of tableView (in case lower limit is above screen bounds)
			-- Stop content movement and transition back up to lower limit.

			self.velocity = 0
			Runtime:removeEventListener( "enterFrame", self )
			tweenRows( lowerLimit )
			moveRowsWithTween()

		elseif self.y < lowerLimit then

			-- Top of content has went past lower limit of tableView (in positive-y direction)
			-- Stop content movement and transition content back to upper limit.

			self.velocity = 0
			Runtime:removeEventListener( "enterFrame", self )
			tweenRows( upperLimit - self.bottom )
			moveRowsWithTween()
		end
	end

	-----------------------------------------------------------------------------------------

	local function initiateRowEvent( tbContent, row, phase )
		if tbContent and row then
			-- setup event table
			local event = {}
			event.name = "tableView_onEvent"
			event.tableView = tbContent.parentObject.parentObject	-- tableView (parent of view, which is parent of tbContent [tableView._view.content])
			event.target = row
			event.phase = phase or "render"		-- phases: render, selected, released, swipeLeft, swipeRight
			event.index = row.listIndex --getRowIndex( row, tbContent.rows )
			event.view = row._view

			if event.phase == "render" then
				if row._view then display.remove( row._view ); end; row._view = display.newGroup()
				createRowBackgroundAndLine( row, row._view )

				event.name = "tableView_onRender"
				if row.onRender then row.onRender( event ); end
			else
				if row.onEvent then row.onEvent( event ); end	-- call event listener function
			end
		end
	end

	-----------------------------------------------------------------------------------------

	local function deSelectAllRows( tbContent )
		for i=1,#tbContent.rows do
			local row = tbContent.rows[i]
			row.isTouched = false
			row.reRender = true	-- force re-render of row on next update
		end
	end

	-----------------------------------------------------------------------------------------

	local function checkSelectionStatus( tbContent )
		local timePassed = system.getTimer() - tbContent.startTime

		if timePassed > 75 then		-- finger has been held down for more than 50 milliseconds

			-- initiate "press" event if a row is being touched
			local row = getRowAtCoordinate( tbContent, tbContent.prevPosition, tbContent.rows )
			if row then
				row.isTouched = true
				initiateRowEvent( tbContent, row, "press" )
				tbContent.trackRowSelection = false
			end
		end
	end

	-----------------------------------------------------------------------------------------

	local function onUpdate( self, event )	-- Reference: self = tableView._view.content
		if self.trackRowSelection then checkSelectionStatus( self ); end

		if not self.trackVelocity then
			local timePassed = event.time - self.lastTime
			self.lastTime = self.lastTime + timePassed

			-- stop scrolling when velocity gets close to zero
			if math.abs( self.velocity ) < .01 then
				self.velocity = 0
				Runtime:removeEventListener( "enterFrame", self )
			end

			-- update velocity and content location on every framestep
			self.velocity = self.velocity * self.friction 	
			self.y = math.floor( self.y + (self.velocity * timePassed) )

			local upperLimit = self.topPadding --self.top
			local lowerLimit = self.widgetHeight - getTotalHeight( self.rows ) - self.bottom

			limitMovement( self, upperLimit, lowerLimit )
		else
			trackVelocity( self, event )	-- track velocity if not ready to move
		end

		updateRowLocations( self )	-- ensure virtual rows y position matches that of content group
	end

	-----------------------------------------------------------------------------------------

	local function beginContentTouch( self, event )	-- "began" phase for onContentTouch
		local tableView = self.parentObject.parentObject
		if not tableView.isLocked then	-- isLocked (true/false) determines whether rows can scroll or not
			-- set focus on tableView's content
			display.getCurrentStage():setFocus( self )
			self.isFocus = true

			-- set some variables necessary movement/scrolling
			self.delta, self.velocity = 0, 0
			self.prevTime, self.prevY = 0, 0
			self.prevPosition = event.y

			-- start enterFrame listener to track velocity, and to enact momentum-based scrolling
			Runtime:removeEventListener( "enterFrame", self )	-- remove in case listener is still active for whatever reason
			Runtime:addEventListener( "enterFrame", self )
			self.trackVelocity = true	-- start tracking velocity

			self.startTime = system.getTimer()
			self.trackRowSelection = true
		end
	end

	-----------------------------------------------------------------------------------------

	local function moveContent( self, event )	-- "moved" phase for onContentTouch
		if self.isFocus then
			-- This code handles finger movement, and prevents content from going
			-- too far past its upper and lower boundaries.

			self.trackRowSelection = false	-- stop tracking time user has their finger held down

			local lowerLimit = self.widgetHeight - getTotalHeight( self.rows ) - self.bottom

			self.delta = event.y - self.prevPosition
			self.prevPosition = event.y

			if self.y > self.top or self.y < lowerLimit then
				self.y = self.y + self.delta/2
			else
				self.y = self.y + self.delta
			end

			updateRowLocations( self )

			-- make sure if the row that is being touched is "press" (held down too long), to de-select and force re-render
			local row = getRowAtCoordinate( self, event.y, self.rows )
			if row and row.isTouched then row.isTouched = false; row.reRender = true; end
		end
	end

	-----------------------------------------------------------------------------------------

	local function endContentTouch( self, event )	-- "ended" phase for onContentTouch
		if self.isFocus then
			self.lastTime = event.time	-- this is necessary for calculating scrolling movement (see onUpdate)
			self.trackVelocity = false	-- stop tracking velocity

			-- check to see if a row was selected
			local row = getRowAtCoordinate( self, event.y, self.rows )
			if row and row.isTouched then
				initiateRowEvent( self, row, "release" )
				row.isTouched = false
			end

			-- remove focus from tableView's content
			display.getCurrentStage():setFocus( nil )
			self.isFocus = nil; self.oy = nil	-- clear un-needed variables
		end
	end

	-----------------------------------------------------------------------------------------

	local function onContentTouch( self, event )	-- REFERENCE: self = tableView._view.content
		if event.phase == "began" then

			beginContentTouch( self, event )

		elseif self.isFocus then
			if event.phase == "moved" then

				moveContent( self, event )

			elseif event.phase == "ended" or event.phase == "cancelled" then

				endContentTouch( self, event )
			end
		end

		return true
	end

	-----------------------------------------------------------------------------------------

	local function onBackgroundTouch( self, event )

		-- This function allows tableView/scrollView to be scrolled when only the background
		-- of the widget is being touched (rather than having to touch the content itself)

		if event.phase == "began" then
			local view = self.parent.content

			view:touch( event )	-- transfer touch event to content group's touch event

			return true
		end
	end

	-----------------------------------------------------------------------------------------

	local function insertIntoContent( self, obj )
		-- insert into the content group instead
		self.content:insert( obj )
	end

	-----------------------------------------------------------------------------------------

	local function getScrollPosition( self )
		return self.content.y
	end

	-----------------------------------------------------------------------------------------

	function scrollToY( self, yPosition, timeInMs )
		yPosition = yPosition or 0
		timeInMs = timeInMs or 1500

		local tbContent = self.content

		if timeInMs > 0 then
			transition.to( tbContent, { y=yPosition, time=timeInMs, transition=easing.outQuad } )
			local updateRows = function() updateRowLocations( tbContent ); end
			timer.performWithDelay( 1, updateRows, timeInMs )
		else
			-- no effect; move content instantly (timeInMs set to 0)
			tbContent.y = yPosition
			updateRowLocations( tbContent )
		end
	end

	-----------------------------------------------------------------------------------------

	function scrollToIndex( self, rowIndex, timeInMs )
		local tbContent = self.content
		local rows = tbContent.rows
		local yPosition = -(rows[rowIndex].top)
		
		if self.parentObject.parent.parent then
			-- picker wheel
			yPosition = -(rows[rowIndex].top) + 109 + rows[rowIndex].height * 1.45
		end
		
		if yPosition then scrollToY( self, yPosition, timeInMs ); end
	end

	-----------------------------------------------------------------------------------------

	local function removeSelf( self )
		-- clean up content (to include event listeners, Runtime listeners, etc.)
		if self._view then
			if self._view.content.tween then transition.cancel( self._view.content.tween ); self._view.content.tween = nil; end
			if self._view.content.rowTimer then timer.cancel( self._view.content.rowTimer ); self._view.content.rowTimer = nil; end
			if self._view.content.cat then display.remove( self._view.content.cat ); self._view.content.cat = nil; end
			self._view.content:removeEventListener( "touch", self._view.content ); self._view.content.touch = nil
			Runtime:removeEventListener( "enterFrame", self._view.content ); self._view.content.enterFrame = nil
			self._view.content.parentObject = nil	-- remove reference
			for i=self._view.content.numChildren,1,-1 do
				display.remove( self._view.content[i] )
			end
			self._view.content:removeSelf()

			-- clean up all children in view object (self)
			for i=self._view.numChildren,1,-1 do
				display.remove( self._view[i] )
			end


			if self._view.parentObject._parentView then
				-- remove mask, if it exists
				if self._view.parentObject._parentView.mask then
					self._view.parentObject._parentView:setMask( nil )
					self._view.parentObject._parentView.mask = nil
				end 

				for i=self._view.parentObject._parentView.numChildren,1,-1 do
					display.remove( self._view.parentObject._parentView[i] )
				end

				self._view.parentObject = nil
			end

			self._view.content = nil; self._view.parentObject = nil
			self._view:cached_removeSelf(); self._view = nil
			self._parentView:removeSelf(); self._parentView = nil
			self.isLocked = nil
			self.insertRow = nil
			self.view = nil
			self = nil
		end
	end

	-----------------------------------------------------------------------------------------

	local function createTableView( options )
		local tableView = {}

		-- to prevent errors if table parameters are not passed
		local options = options or {}
		options.bgColor = options.bgColor or {}

		-- extract parameters from options, or use default values
		local left = options.left or 0
		local top = options.top or 0
		local topPadding = options.topPadding or 0
		local bottomPadding = options.bottomPadding or 0
		local width = options.width or (display.contentWidth-left)
		local height = options.height or (display.contentHeight-top)
		local renderThresh = options.renderThresh or 150
		local friction = options.friction or 0.935
		local r, g, b, a = options.bgColor[1] or 255, options.bgColor[2] or 255, options.bgColor[3] or 255, options.bgColor[4] or 255

		-- Create the "view" display object, its properties, and methods (will become tableView._view)
		local parentView = display.newGroup()
		local view = display.newGroup(); parentView:insert( view )
		view.top = top
		view.parentObject = tableView
		view.content = display.newGroup(); view:insert( view.content )
		view.content.parentObject = view
		view.content.y = topPadding
		view.content.top = top --topPadding --view.content.y
		view.content.topPadding = topPadding
		view.content.bottom = bottomPadding
		view.content.widgetHeight = height
		view.content.friction = friction
		view.content.enterFrame = onUpdate	-- enterFrame listener function
		view.content.touch = onContentTouch; view.content:addEventListener( "touch", view.content )
		view.content.upperRenderBounds = view.content.top - renderThresh
		view.content.lowerRenderBounds = view.content.top + height + renderThresh
		view.content.trackRowSelection = false	-- used to determine whether or not a row should be selected

		-- set up table to hold row items, as well as default row values
		view.content.rows = {}
		view.content.defaults = {
			width = width, rowHeight = 64,
			rowColor = { 255, 255, 255, 255 },	-- r, g, b, alpha
			lineColor = { 128, 128, 128, 255 }	-- r, g, b, alpha
		}

		-- Create background rectangle for widget
		local bgRect = display.newRect( view, 0, 0, width, height )
		bgRect:setFillColor( r, g, b, a )
		bgRect.touch = onBackgroundTouch
		bgRect:addEventListener( "touch", bgRect )

		-- Give tableview a ._view property, to hold reference to the display group
		tableView._view = view
		tableView._view.bg = bgRect
		tableView._view.trackVelocity = false	-- velocity is only tracked during a touch event
		tableView.isLocked = false				-- when true, disables ability to scroll rows

		-- assign methods to tableView
		tableView.insertRow = insertRowIntoTableView
		tableView.deleteRow = deleteRow

		-- subclass the tableView._view.insert() method
		tableView._view.cached_insert = tableView._view.insert
		function tableView._view:insert( obj )
			self.content:insert( obj )
		end

		-- subclass the tableView._view.removeSelf() method
		tableView._view.cached_removeSelf = tableView._view.removeSelf
		tableView._view.removeSelf = removeSelf

		tableView._view:setReferencePoint( display.TopLeftReferencePoint )
		tableView._view.x, tableView._view.y = left, top

		-- Create group to hold categories:
		tableView._view.content.catGroup = display.newGroup()
		tableView._view.content.catGroup.x = left
		tableView._view.content.catGroup.y = top

		-- setup methods for view object
		tableView._view.getScrollPosition = getScrollPosition
		tableView._view.getRowAtY = getRowAtY
		tableView._view.scrollToY = scrollToY
		tableView._view.scrollToIndex = scrollToIndex

		-- add the category group to the parentView
		parentView:insert( tableView._view.content.catGroup )
		tableView._parentView = parentView
		tableView.view = tableView._parentView

		-- apply mask (if set as parameter)
		if options.maskFile then
			tableView._parentView.mask = graphics.newMask( options.maskFile )
			tableView._parentView:setMask( tableView._parentView.mask )

			tableView._parentView.maskX = left + (width * 0.5)
			tableView._parentView.maskY = top + (height * 0.5)
		end
		
		return tableView
	end

	-----------------------------------------------------------------------------------------

	function tableView.new( widgetTheme, options )
		local tableView_widget = createTableView( options )

		return setmetatable( tableView_widget, tableView_mt )
	end
	
	-----------------------------------------------------------------------------------------
	
	return tableView
end

-----------------------------------------------------------------------------------------

function widget.setTheme( themeModule )
	widget.theme = require( themeModule )	-- themeModule should return theme table
end

-----------------------------------------------------------------------------------------

function widget.new( widgetName, options, arg1, arg2 )
	local widgetType = widget[string.lower(widgetName)]()	-- old: local widgetMod = require( "widget_" .. string.lower( widgetName ) )
	local uiWidget = widgetType.new( widget.theme, options, arg1, arg2 ); widgetMod = nil
	return uiWidget
end

-----------------------------------------------------------------------------------------

function widget.newButton( options )
	if options.x then
		print( "WARNING: The 'x' parameter for widget.newButton() has been deprecated. Please set the 'left' parameter insetad.")
		options.left = options.x
	end
	
	if options.y then
		print( "WARNING: The 'y' parameter for widget.newButton() has been deprecated. Please set the 'top' parameter insetad.")
		options.top = options.y
	end
	
	if options.labelColor and options.labelColor.default == nil then
		print( "WARNING: The correct format for the 'labelColor' parameter is: { default={r,g,b,a}, over={r,g,b,a} }." )
	end
	
	if options.size then
		print( "WARNING: The 'size' parameter for widget.newButton() has been deprecated. Please set the 'fontSize' parameter instead." )
		options.fontSize = options.size
	end
	
	if options.buttonTheme then
		print( "WARNING: The 'buttonTheme' parameter for widget.newButton() has been deprecated. Please include a widget theme in your resource folder and use widget.setTheme()." )
	end
	
	return widget.new( "button", options )
end

-----------------------------------------------------------------------------------------

function widget.newTableView( options )
	if options.x then
		print( "WARNING: The 'x' parameter for widget.newTableView() has been deprecated. Please set the 'left' parameter insetad.")
		options.left = options.x
	end
	
	if options.y then
		print( "WARNING: The 'y' parameter for widget.newTableView() has been deprecated. Please set the 'top' parameter insetad.")
		options.top = options.y
	end
	
	if options.mask then
		print( "WARNING: The 'mask' parameter for widget.newTableView() has been deprecated. Please set the 'maskFile' parameter instead." )
		options.maskFile = options.mask
	end
	
	if options.background then
		print( "WARNING: The 'background' parameter for widget.newTableView() has been deprecated and is no longer functional in this version." )
	end
	
	if options.backgroundColor then
		print( "WARNING: The 'backgroundColor' parameter for widget.newTableView() has been deprecated. Please set the 'bgColor' parameter instead." )
		options.bgColor = options.backgroundColor
	end
	
	if options.isInfinite then
		print( "WARNING: The 'isInfinite' parameter for widget.newTableView() has been deprecated and is no longer functional in this version." )
	end
	
	return widget.new( "tableView", options )
end

-----------------------------------------------------------------------------------------

function widget.newScrollView( options )
	if options.x then
		print( "WARNING: The 'x' parameter for widget.newScrollView() has been deprecated. Please set the 'left' parameter insetad.")
		options.left = options.x
	end
	
	if options.y then
		print( "WARNING: The 'y' parameter for widget.newScrollView() has been deprecated. Please set the 'top' parameter insetad.")
		options.top = options.y
	end
	
	if options.mask then
		print( "WARNING: The 'mask' parameter for widget.newScrollView() has been deprecated. Please set the 'maskFile' parameter instead." )
		options.maskFile = options.mask
	end
	
	if options.background then
		print( "WARNING: The 'background' parameter for widget.newScrollView() has been deprecated and is no longer functional in this version." )
	end
	
	if options.backgroundColor then
		print( "WARNING: The 'backgroundColor' parameter for widget.newScrollView() has been deprecated. Please set the 'bgColor' parameter instead." )
		options.bgColor = options.backgroundColor
	end
	
	return widget.new( "scrollView", options )
end

-----------------------------------------------------------------------------------------

function widget.newTabBar( options )
	return widget.new( "tabBar", options )
end

-----------------------------------------------------------------------------------------

function widget.newSlider( options )
	return widget.new( "slider", options )
end

-----------------------------------------------------------------------------------------

function widget.newPickerWheel( options )
	if options.column1 then
		print( "WARNING: The widget.newPickerWheel() API has changed. Please see the updated documentation if you are having problems." )
	end
	
	return widget.new( "pickerWheel", options )
end

-----------------------------------------------------------------------------------------

function widget.newToolbar()
	print( "WARNING: widget.newToolbar() has been deprecated. Please use widget.newTabBar() with no buttons, in conjunction with display.newEmbossedText()." )
end

-----------------------------------------------------------------------------------------

function widget.newSegmentedControl()
	print( "WARNING: widget.newSegmentedControl() has been deprecated and is no longer functional in this version." )
end

-----------------------------------------------------------------------------------------

function widget.setSkin()
	print( "WARNING: widget.setSkin() has been deprecated and is no longer functional in this version. Please use widget.setTheme() instead (don't forget to place the specified theme module and assets directory in your project folder)." )
end

-----------------------------------------------------------------------------------------

return widget