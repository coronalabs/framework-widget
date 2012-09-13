local m = {}

local mFloor = math.floor

-- set slider value from 0 to 100
local function setSliderValue( self, value )    -- self == slider
    -- make sure value is not less than 0 or greater than 100
    if value < 0 then
        value = 0
    elseif value > 100 then
        value = 100
    else
        value = mFloor( value ) -- round to the nearest whole number
    end
    
    local width = self.max - self.min
    
    -- calculate percentage based on slidable width
    local percent = value / 100
    
    -- move handle to new position
    local x = (width * percent) + self.min
    self.handle.x = x
    
    -- stretch fill image from left side to handle
    local fillScaleX = (self.handle.x - self.min) / self.fillWidth
    if fillScaleX <= 0 then fillScaleX = 0.1; end
    self.fill.xScale = fillScaleX
    
    -- update reference to value
    self.value = value
end

-- dispatch slider event
local function dispatchSliderEvent( self )  -- self == slider
    if self.listener then
        local e = {}
        e.name = "sliderEvent"
        e.type = "sliderMoved"
        e.target = self
        e.value = self.value
        
        self.listener( e )
    end
end

-- slider touch event
local function onSliderTouch( self, event ) -- self == slider
    if event.phase == "began" then
        display.getCurrentStage():setFocus( self )
        self.isFocus = true
        self:setReferencePoint( display.CenterReferencePoint )
        
        local sliderX = (self.contentBounds.xMin + (self.contentWidth*0.5))
        local x = event.x - sliderX
        local width = self.max - self.min
        local percent = mFloor(((( (width*0.5) + x) * 100) / width))
        self:setValue( percent )
        
        dispatchSliderEvent( self )
        
    elseif self.isFocus then
        local isWithinBounds = self.min <= event.x and self.max >= event.x
        
        if event.phase == "moved" then
            
            local sliderX = (self.contentBounds.xMin + (self.contentWidth*0.5))
            local x = event.x - sliderX
            local width = self.max - self.min
            local percent = mFloor(((( (width*0.5) + x) * 100) / width))
            self:setValue( percent )
            
            dispatchSliderEvent( self )
        
        elseif event.phase == "ended" or event.phase == "cancelled" then
            
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end
    
    return true
end

-- removeSelf() method for slider widget
local function removeSelf( self )
    if self.clean and type(self.clean) == "function" then self:clean(); end
    
    if self.fill then self.fill:removeSelf(); self.fill = nil; end
    if self.handle then self.handle:removeSelf(); self.handle = nil; end
    self.fillWidth = nil
    self.value = nil
    
    self:cached_removeSelf()
end

function m.createSlider( options, theme )
    local options = options or {}
    local theme = theme or {}
    local id = options.id or "widget_slider"
    
    local left = options.left or 0
    local top = options.top or 0
    local width = options.width or theme.width or 200
    local height = options.height or theme.height or 10
    local background = options.background or theme.background
    local handleImage = options.handle or theme.handle
    local handleWidth = options.handleWidth or theme.handleWidth
    local handleHeight = options.handleHeight or theme.handleHeight
    local leftImage = options.leftImage or theme.leftImage
    local leftWidth = options.leftWidth or theme.leftWidth or 16
    local fillImage = options.fillImage or theme.fillImage
    local fillWidth = options.fillWidth or theme.fillWidth or 2
    local cornerRadius = options.cornerRadius or theme.cornerRadius or 5
    local value = options.value or 50
    local listener = options.listener or options.callback
    local baseDir = options.baseDir or theme.baseDir or system.ResourceDirectory
    
    local fillColor = options.fillColor or theme.fillColor or {}
            fillColor[1] = fillColor[1] or 0
            fillColor[2] = fillColor[2] or 100
            fillColor[3] = fillColor[3] or 230
            fillColor[4] = fillColor[4] or 255
    
    local handleColor = options.handleColor or theme.handleColor or {}
            handleColor[1] = handleColor[1] or 189
            handleColor[2] = handleColor[2] or 189
            handleColor[3] = handleColor[3] or 189
            handleColor[4] = handleColor[4] or 255
    
    local handleStroke = options.handleStroke or theme.handleStroke or {}
            handleStroke[1] = handleStroke[1] or 143
            handleStroke[2] = handleStroke[2] or 143
            handleStroke[3] = handleStroke[3] or 143
            handleStroke[4] = handleStroke[4] or 255
    
    local bgFill = options.bgFill or theme.bgFill or {}
            bgFill[1] = bgFill[1] or 225
            bgFill[2] = bgFill[2] or 225
            bgFill[3] = bgFill[3] or 225
            bgFill[4] = bgFill[4] or 255
    
    local bgStroke = options.bgStroke or theme.bgStroke or {}
            bgStroke[1] = bgStroke[1] or 102
            bgStroke[2] = bgStroke[2] or 102
            bgStroke[3] = bgStroke[3] or 102
            bgStroke[4] = bgStroke[4] or 255
    
    -- construct slider widget based on provided parameters (or defaults)
    local slider = display.newGroup()
    local bg, leftSide, fill, handle
    
    if not background and not fillImage then        
        bg = display.newRoundedRect( slider, 0, 0, width, height, cornerRadius )
        bg.strokeWidth = 1
        bg:setStrokeColor( bgStroke[1], bgStroke[2], bgStroke[3], bgStroke[4] )
        bg:setFillColor( bgFill[1], bgFill[2], bgFill[3], bgFill[4] )
        
        leftSide = display.newRoundedRect( slider, 0, 0, leftWidth, height, cornerRadius )
        leftSide:setReferencePoint( display.CenterReferencePoint )
        leftSide:setFillColor( fillColor[1], fillColor[2], fillColor[3], fillColor[4] )
        
        fill = display.newRect( slider, leftWidth*0.5, 0, fillWidth, height )
        fill:setReferencePoint( display.CenterLeftReferencePoint )
        fill:setFillColor( fillColor[1], fillColor[2], fillColor[3], fillColor[4] )
    
    elseif background and fillImage then
        bg = display.newImageRect( slider, background, baseDir, width, height )
        bg:setReferencePoint( display.TopLeftReferencePoint )
        bg.x, bg.y = 0, 0
        
        fill = display.newImageRect( slider, fillImage, baseDir, fillWidth, height )
        fill:setReferencePoint( display.CenterLeftReferencePoint )
        fill.x, fill.y = leftWidth, height * 0.5
    else
        if background and not fillImage then
            print( "WARNING: You must also specify a fillImage when using a custom background with the slider widget." )
            return
        elseif fillImage and not background then
            print( "WARNING: You must specify a custom background when using a custom fillImage with the slider widget." )
            return
        end
    end
    
    slider.fill = fill
    slider.fillWidth = fillWidth
    
    if not handleImage or not handleWidth or not handleHeight then
        handle = display.newCircle( slider, width*0.5, height*0.5, height )
        handle:setReferencePoint( display.CenterReferencePoint )
        handle:setFillColor( handleColor[1], handleColor[2], handleColor[3], handleColor[4] )
        handle.strokeWidth = 1
        handle:setStrokeColor( handleStroke[1], handleStroke[2], handleStroke[3], handleStroke[4] )
    else
        handle = display.newImageRect( slider, handleImage, handleWidth, handleHeight )
        handle:setReferencePoint( display.CenterReferencePoint )
        handle.x, handle.y = width*0.5, height*0.5
    end
    slider.handle = handle
    
    -- properties and methods
    slider._isWidget = true
    slider.id = id
    slider.min = leftWidth*0.5
    slider.max = width - (leftWidth * 0.5)
    slider.setValue = setSliderValue
    slider.touch = onSliderTouch
    slider:addEventListener( "touch", slider )
    slider.listener = listener
    
    slider.cached_removeSelf = slider.removeSelf
    slider.removeSelf = removeSelf
    
    local fillScaleX = (handle.x - slider.min) / fillWidth
    fill.xScale = fillScaleX
    
    -- position the widget and set reference point to center
    slider.x, slider.y = left, top
    slider:setReferencePoint( display.CenterReferencePoint )
    
    -- set initial value
    slider:setValue( value )
    
    return slider
end

return m