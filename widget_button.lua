local m = {}

local function onButtonTouch( self, event ) -- self == button
    local result = true
    local phase = event.phase
    event.name = "buttonEvent"
    event.target = self

    if phase == "began" then
        display.getCurrentStage():setFocus( self, event.id )
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
            display.getCurrentStage():setFocus( self, nil )
            self.isFocus = false
        end
    end

    return result
end

local function setLabel( self, newLabel )   -- self == button
    if not newLabel then return; end
    
    if self.label.setText then
        self.label:setText( newLabel )
    else
        self.label.text = newLabel
    end
    
    -- re-center label on button
    self.label:setReferencePoint( display.CenterReferencePoint )
    self.label.x = (self.contentWidth*0.5) + self.label.xOffset
    self.label.y = (self.contentHeight*0.5) + self.label.yOffset
end

local function setLabelSize( self, newSize )
	if not newSize then return; end
	
	self.label.size = newSize / display.contentScaleX
end

local function getLabel( self )
    return self.label.text
end

local function removeSelf( self )   -- self == button
    -- check to see if there is a clean method; if so, call it
    if self.clean then self:clean(); end
    
    -- remove all children of default and over
    if self.default and self.default.numChildren then
        for i=self.default.numChildren,1,-1 do
            display.remove( self.default.numChildren[i] )
        end
        display.remove( self.default )
    end
    
    if self.over and self.over.numChildren then
        for i=self.over.numChildren,1,-1 do
            display.remove( self.over.numChildren[i] )
        end
        display.remove( self.over )
    end
    
    -- remove label
    display.remove( self.label )
    
    -- remove button group
    self:cached_removeSelf()
end

function m.createButton( options, theme )
    local   defaultBtnWidth = 124
    local   defaultBtnHeight = 42
    
    local   options = options or {}
    local   theme = theme or {}
    local   id = options.id or "widget_button"
    local   left = options.left or 0
    local   top = options.top or 0
    local   xOffset = options.xOffset or theme.xOffset or 0     -- offsets x value of the label text
    local   yOffset = options.yOffset or options.offset or theme.yOffset or theme.offset or 0       -- offsets y value of the label text
    local   label = options.label or ""
    local   font = options.font or theme.font or native.systemFont
    local   fontSize = options.fontSize or theme.fontSize or 14
    local   emboss = options.emboss or theme.emboss
    local   textFunction = options.textFunction or display.newText
    local   labelColor = options.labelColor or theme.labelColor or { default={ 0 }, over={ 255 } }
    local   onPress = options.onPress
    local   onRelease = options.onRelease
    local   onDrag = options.onDrag
    local   onEvent = options.onEvent
    local   default = options.default or theme.default
    local   defaultColor = options.defaultColor or theme.defaultColor
    local   over = options.over or theme.over
    local   overColor = options.overColor or theme.overColor
    local   strokeColor = options.strokeColor or theme.strokeColor
    local   strokeWidth = options.strokeWidth or theme.strokeWidth
    local   cornerRadius = options.cornerRadius or theme.cornerRadius
    local   width = options.width or theme.width
    local   height = options.height or theme.height
    local   sheet = options.sheet or theme.sheet
    local   defaultIndex = options.defaultIndex or theme.defaultIndex
    local   overIndex = options.overIndex or theme.overIndex
    local   baseDir = options.baseDir or theme.baseDir or system.ResourceDirectory
    
    local button = display.newGroup()
    
    if default or sheet then

        -- user-provided image for default and over state
        if sheet and defaultIndex and width and height then
            -- image sheet option
            button.default = display.newImageRect( button, sheet, defaultIndex, width, height )
            button.default:setReferencePoint( display.TopLeftReferencePoint )
            button.default.x, button.default.y = 0, 0

            local over = overIndex or defaultIndex
            button.over = display.newImageRect( button, sheet, over, width, height )
            button.over:setReferencePoint( display.TopLeftReferencePoint )
            button.over.x, button.over.y = 0, 0

        elseif width and height then
            -- display.newImageRect() option (non)
            button.default = display.newImageRect( button, default, baseDir, width, height )
            button.default:setReferencePoint( display.TopLeftReferencePoint )
            button.default.x, button.default.y = 0, 0

            local over = over or default
            button.over = display.newImageRect( button, over, baseDir, width, height )
            button.over:setReferencePoint( display.TopLeftReferencePoint )
            button.over.x, button.over.y = 0, 0
        else
            -- display.newImage() option
            button.default = display.newImage( button, default, baseDir, true )
            button.default:setReferencePoint( display.TopLeftReferencePoint )
            button.default.x, button.default.y = 0, 0

            local over = over or default
            button.over = display.newImage( button, over, baseDir, true )
            button.over:setReferencePoint( display.TopLeftReferencePoint )
            button.over.x, button.over.y = 0, 0
            
            width, height = button.default.contentWidth, button.default.contentHeight
        end

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
        -- no images; construct button using newRoundedRect
        if not width then width = defaultBtnWidth; end
        if not height then height = defaultBtnHeight; end
        if not cornerRadius then cornerRadius = 8; end

        button.default = display.newRoundedRect( button, 0, 0, width, height, cornerRadius )
        button.over = display.newRoundedRect( button, 0, 0, width, height, cornerRadius )

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
        else
            button.default.strokeWidth = strokeWidth
            button.over.strokeWidth = strokeWidth
        end
    end
    button.over.isVisible = false   -- hide "down/over" state of button
    
    -- create the label
    if not labelColor then labelColor = {}; end
    if not labelColor.default then labelColor.default = { 0 }; end
    if not labelColor.over then labelColor.over = { 255 }; end
    local r, g, b, a = labelColor.default[1] or 0, labelColor.default[2] or labelColor.default[1], labelColor.default[3] or labelColor.default[1], labelColor.default[4] or 255

    button.label = textFunction( button, label, 0, 0, font, fontSize )
    button.label:setTextColor( r, g, b, a )
    button.label:setReferencePoint( display.CenterReferencePoint )
    button.label.x = (button.contentWidth * 0.5) + xOffset
    button.label.y = (button.contentHeight * 0.5) + yOffset
    button.label.color = labelColor
    button.label.xOffset = xOffset
    button.label.yOffset = yOffset
    
    -- set properties and methods
    button._isWidget = true
    button.id = id
    button.onPress = onPress
    button.onDrag = onDrag
    button.onRelease = onRelease
    button.onEvent = onEvent
    button.touch = onButtonTouch; button:addEventListener( "touch", button )
    button.cached_removeSelf = button.removeSelf
    button.removeSelf = removeSelf
    button.setLabel = setLabel
    button.getLabel = getLabel
    button.setLabelSize = setLabelSize
    
    -- position the button
    button:setReferencePoint( display.TopLeftReferencePoint )
    button.x, button.y = left, top
    button:setReferencePoint( display.CenterReferencePoint )
    
    return button
end

return m