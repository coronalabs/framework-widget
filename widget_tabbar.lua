local m = {}
local mFloor = math.floor

local function invokeTabButtonSelectionState( button )
    -- ensure overlay and down graphic are showing
    button.up.isVisible = false
    button.down.isVisible = true
    button.selected = true
    if button.label then button.label:setTextColor( 255 ); end
    
    -- if hideOverlay is not set to true, show overlay graphic (to represent selection)
    if not button.hideOverlay then
        button.overlay.isVisible = true
    end
end

local function onButtonSelection( self )    -- self == tab button
    local tabBar = self.parent.parent
    
    if tabBar and tabBar.deselectAll then
        tabBar:deselectAll()    -- deselect all tab buttons
    end

    invokeTabButtonSelectionState( self )

    -- call listener function
    if self.onPress and type(self.onPress) == "function" then
        local event = {
            name = "tabButtonPress",
            target = self,
        }
        self.onPress( event )
    end
end

local function onButtonTouch( self, event )     -- self == tab button
    if event.phase == "began" then
        self:onSelection()  -- see: onButtonSelection()
    end
    return true
end

local function createTabButton( params )
    local   params = params or {}
    local   id = params.id
    local   label = params.label
    local   labelFont = params.font or native.systemFontBold
    local   labelFontSize = params.size or 10
    local   labelColor = params.labelColor or { 124, 124, 124, 255 }
    local   overlayWidth = params.overlayWidth
    local   overlayHeight = params.overlayHeight
    local   disableOverlay = params.disableOverlay
    local   width = params.width or 32      -- corresponds to up/down image width
    local   height = params.height or 32    -- corresponds to up/down image height
    local   cornerRadius = params.cornerRadius or 4
    local   default = params.default or params.up or params.image   -- params.default is supported; others old/deprecated
    local   down = params.down or params.over -- params.down is supported; others old/deprecated
    local   parentObject = params.parent
    local   selected = params.selected
    local   onPress = params.onPress
    local   upGradient = params.upGradient
    local   downGradient = params.downGradient
    local   baseDir = params.baseDir or system.ResourceDirectory

    local button = display.newGroup()
    button.id = id
    button.hideOverlay = disableOverlay
    
    -- create overlay (which is the highlight when button is selected/down)
    button.overlay = display.newRoundedRect( button, 0, 0, overlayWidth, overlayHeight, cornerRadius )
    button.overlay:setFillColor( 255, 25 )
    button.overlay:setStrokeColor( 0, 75 )
    button.overlay.strokeWidth = 1
    button.overlay.isVisible = false
    button.overlay.isHitTestable = true

    button.up = display.newImageRect( button, default, baseDir, width, height )
    button.up:setReferencePoint( display.CenterReferencePoint )
    button.up.x = button.overlay.width * 0.5
    button.up.y = button.overlay.height * 0.5

    if default and not down then down = default; end
    button.down = display.newImageRect( button, down, baseDir, width, height )
    button.down:setReferencePoint( display.CenterReferencePoint )
    button.down.x = button.up.x
    button.down.y = button.up.y
    button.down.isVisible = false

    if label then   -- label is optional
        -- shift icon up
        button.up.y = button.up.y - (labelFontSize-3)
        button.down.y = button.down.y - (labelFontSize-3)

        -- create label
        button.label = display.newText( label, 0, 0, labelFont, labelFontSize )
        local color = { labelColor[1] or 124, labelColor[2] or 124, labelColor[3] or 124, labelColor[4] or 255 }
        button.label:setTextColor( color[1], color[2], color[3], color[4] )
        button.label.color = color
        button.label:setReferencePoint( display.TopCenterReferencePoint )
        button.label.x = button.up.x
        button.label.y = button.up.y + (button.up.contentHeight*0.5)    -- button.up's reference point is center
        button:insert( button.label )
    end

    -- if selected, show overlay and 'down' graphic
    if selected then
        invokeTabButtonSelectionState( button )
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

local function deselectAllButtons( self )   -- self == tabBar
    for i=1,self.buttons.numChildren do
        local button = self.buttons[i]

        button.overlay.isVisible = false
        button.down.isVisible = false
        button.up.isVisible = true
        button.selected = false
        if button.label then button.label:setTextColor( button.label.color[1], button.label.color[2], button.label.color[3], button.label.color[4] ); end
    end
end

local function pressButton( self, buttonIndex, invokeListener )     -- self == tabBar
    self:deselectAll()
    if invokeListener == nil then invokeListener = true; end
    
    local button = self.buttons[buttonIndex]
    if button then
        invokeTabButtonSelectionState( button )
        
        -- call listener function
        if invokeListener then
            if button.onPress and type(button.onPress) == "function" then
                local event = {
                    name = "tabButtonPress",
                    target = button
                }
                button.onPress( event )
            end
        end
    else
        print( "WARNING: Specified tab button '" .. buttonIndex .. "' does not exist." )
    end
end

local function removeSelf( self )   -- self == tabBar
    -- check to see if there is a clean method; if so, call it
    if self.clean then self:clean(); end
    
    -- remove all buttons
    for i=self.buttons.numChildren,1,-1 do
        display.remove( self.buttons[i] )
    end
    display.remove( self.buttons )
    
    -- remove gradient (if in use)
    if self.gradientRect then
        self.gradientRect:setFillColor( 0 ) -- so it's no longer using gradient image
        if self.gradient then
            self.gradient = nil
        end
    end
    
    -- remove tab bar widget itself
    self:cached_removeSelf()
end

function m.createTabBar( options, theme )
    local options = options or {}
    local theme = theme or {}
    local id = options.id or "widget_tabBar"
    local buttons = options.buttons
    local maxTabWidth = options.maxTabWidth or 120
    local width = options.width or theme.width or display.contentWidth
    local height = options.height or theme.height or 50
    local background = options.background or theme.background
    local gradient = options.gradient or options.topGradient or theme.gradient  -- gradient must be pre-created using graphics.newGradient
    local topFill = options.topFill or theme.topFill
    local bottomFill = options.bottomFill or theme.bottomFill
    local left = options.left or 0
    local top = options.top or 0
    local baseDir = options.baseDir or system.ResourceDirectory
    
    local tabBar = display.newGroup()
    local barBg = display.newGroup(); tabBar:insert( barBg )
    
    local halfW = width * 0.5
    local halfH = height * 0.5
    
    -- create tab bar background
    if topFill and bottomFill then
        -- background made from two equal halves (2 different fills)
        
        topFill[1] = topFill[1] or 0
        topFill[2] = topFill[2] or topFill[1]
        topFill[3] = topFill[3] or topFill[1]
        topFill[4] = topFill[4] or 255
        
        bottomFill[1] = bottomFill[1] or 0
        bottomFill[2] = bottomFill[2] or bottomFill[1]
        bottomFill[3] = bottomFill[3] or bottomFill[1]
        bottomFill[4] = bottomFill[4] or 255
        
        local topRect = display.newRect( barBg, 0, 0, width, halfH )
        topRect:setFillColor( topFill[1], topFill[2], topFill[3], topFill[4] )
        
        local bottomRect = display.newRect( barBg, 0, halfH, width, halfH )
        bottomRect:setFillColor( bottomFill[1], bottomFill[2], bottomFill[3], bottomFill[4] )
    
    elseif gradient and type(gradient) == "userdata" then
        -- background made from rectangle w/ gradient fill
        
        local bg = display.newRect( barBg, 0, 0, width, height )
        bg:setFillColor( gradient )
        
        if bottomFill then
            bottomFill[1] = bottomFill[1] or 0
            bottomFill[2] = bottomFill[2] or bottomFill[1]
            bottomFill[3] = bottomFill[3] or bottomFill[1]
            bottomFill[4] = bottomFill[4] or 255
            
            local bottomRect = display.newRect( barBg, 0, halfH, width, halfH )
            bottomRect:setFillColor( bottomFill[1], bottomFill[2], bottomFill[3], bottomFill[4] )
        end
        
    elseif background and type(background) == "string" then
        -- background made from user-provided image file
        
        local bg = display.newImageRect( barBg, background, baseDir, width, height )
        bg:setReferencePoint( display.TopLeftReferencePoint )
        bg.x, bg.y = 0, 0
    else
        -- no background or fills specified (default)
        
        -- create a gradient background
        tabBar.gradient = graphics.newGradient( { 39 }, { 0 }, "down" )
        tabBar.gradientRect = display.newRect( barBg, 0, 0, width, height )
        tabBar.gradientRect:setFillColor( tabBar.gradient )
        
        -- create solid black rect for bottom half of background
        local bottomRect = display.newRect( barBg, 0, halfH, width, halfH )
        bottomRect:setFillColor( 0, 0, 0, 255 )
    end
    
    -- background created; create tab buttons
    
    tabBar.buttons = display.newGroup()
    tabBar:insert( tabBar.buttons )
    
    if buttons and type(buttons) == "table" then
        local buttonWidth = mFloor((width/#buttons)-4)
        local buttonHeight = height-4
        local buttonPadding = mFloor(width/buttonWidth)*2
        
        -- ensure button width doesn't exceed maxButtonWidth
        if buttonWidth > maxTabWidth then buttonWidth = maxTabWidth; end
        
        -- construct each button and insert into tabBar.buttons group
        for i=1,#buttons do
            buttons[i].id = buttons[i].id or i
            buttons[i].overlayWidth = buttonWidth
            buttons[i].overlayHeight = buttonHeight
            buttons[i].parent = tabBar

            local tab = createTabButton( buttons[i] )
            tab:setReferencePoint( display.TopLeftReferencePoint )
            tab.x = (buttonWidth*i-buttonWidth) + buttonPadding
            tab.y = 0
            tabBar.buttons:insert( tab )
        end
        
        -- center the 'tabBar.buttons' group on the widget
        tabBar.buttons:setReferencePoint( display.CenterReferencePoint )
        tabBar.buttons.x, tabBar.buttons.y = halfW, halfH
    end
    
    -- position the widget
    tabBar:setReferencePoint( display.TopLeftReferencePoint )
    tabBar.x, tabBar.y = left, top
    tabBar:setReferencePoint( display.CenterReferencePoint )
    
    -- prevent touches from going through tabBar background
    local preventTouches = function( self, event ) return true; end
    barBg.touch = preventTouches
    barBg:addEventListener( "touch", barBg )
    
    -- override removeSelf method to ensure widget is properly freed from memory
    tabBar.cached_removeSelf = tabBar.removeSelf
    tabBar.removeSelf = removeSelf
    
    -- additional tabBar methods and properties
    tabBar._isWidget = true
    tabBar.id = id
    tabBar.deselectAll = deselectAllButtons
    tabBar.makeTabActive = pressButton
    tabBar.pressButton = pressButton    -- to remain compatible with previous version
    
    return tabBar
end

return m