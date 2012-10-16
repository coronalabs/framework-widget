--[[

ScrollView momentum scrolling logic:

User touches the scrollview content:
    onContentTouch() is invoked
    began phase: enterFrame listener that handle tracking velocity are removed,
                 and then added immediately after.
    moved phase: determine which direction user is scrolling
    ended phase: determine the distance and the time it took for user's finger
                 to travel (used for calculating velocity)
    
    enterFrame listener (onScrollViewUpdate):
        velocity is subtracted on every frame, until it reaches 0.
        content position is updated based on velocity.
        Upon reaching 0, the enterFrame listener is removed and content stops.

--]]


local m = {}
local mAbs = math.abs
local mFloor = math.floor
local scrollFriction = 0.935

local function dispatchBeganScroll( self, parent_widget )   -- self == content
    local e = {}
    e.name = "scrollEvent"
    e.type = "beganScroll"
    e.target = parent_widget or self.parent
    self.hasScrolled = true --Used to set whether the scrollview has actually being scrolled or just pressed
    if self.listener then self.listener( e ); end
end

local function dispatchEndedScroll( self )  -- self == content
    local e = {}
    e.name = "scrollEvent"
    e.type = "endedScroll"
    e.target = self.parent
    if self.listener then self.listener( e ); end
    --If the scrollbar isn't hidden
    if self.hideScrollBar == false then
        self.parent:hide_scrollbar()
    end
    
    
end

local function dispatchPickerSoftland( self )
    local e = {}
    e.target = self.parent
    
    --Make picker wheel softland
    if e.target._isPicker then
        require( "widget_picker" ).pickerSoftLand( self )
    end
end

local function limitScrollViewMovement( self, upperLimit, lowerLimit )  -- self == content
    local function endedScroll()
        self.tween = nil
        if self.listener then
            --Dispatch the picker soft land
            dispatchPickerSoftland( self )
            
            --If the scrollview has scrolled then dispatch the ended scroll event ( this will trigger when the content has stopped moving )
            if self.hasScrolled == true then
                dispatchEndedScroll( self )
                self.hasScrolled = false
            end
        else
            --If the scrollbar isn't hidden
            if self.hideScrollBar == false then
                self.parent:hide_scrollbar()
            end
        end
    end
    
    local tweenContent = function( limit )
        if self.tween then transition.cancel( self.tween ); end
        if not self.isFocus then  -- if content is not being touched by user
            self.tween = transition.to( self, { time=400, y=limit, transition=easing.outQuad, onComplete=endedScroll } )
        end
        
        --If the scrollbar isn't hidden         
        if self.hideScrollBar == false then
            Runtime:addEventListener( "enterFrame", self.scrollbar_listener )
        end
    end
    local moveProperty = "y"
    local e = { name="scrollEvent", target=self.parent }
    local eventMin = "movingToTopLimit"
    local eventMax = "movingToBottomLimit"
    
    if self.moveDirection == "horizontal" then
        tweenContent = function( limit )
            if self.tween then transition.cancel( self.tween ); end
            self.tween = transition.to( self, { time=400, x=limit, transition=easing.outQuad, onComplete=endedScroll } )
        end
        moveProperty = "x"
        eventMin = "movingToLeftLimit"
        eventMax = "movingToRightLimit"
    end
    
    if self[moveProperty] > upperLimit then

        -- Content has drifted above upper limit of scrollView
        -- Stop content movement and transition back down to upperLimit

        self.velocity = 0
        Runtime:removeEventListener( "enterFrame", self )
        tweenContent( upperLimit )
        
        -- dispatch scroll event
        if self.listener then
            e.type = eventMin
            self.listener( e )
        end

    elseif self[moveProperty] < lowerLimit and lowerLimit < 0 then

        -- Content has drifted below lower limit (in case lower limit is above screen bounds)
        -- Stop content movement and transition back up to lowerLimit

        self.velocity = 0
        Runtime:removeEventListener( "enterFrame", self )
        tweenContent( lowerLimit )
        
        -- dispatch scroll event
        if self.listener then
            e.type = eventMax
            self.listener( e )
        end
        
    elseif self[moveProperty] < lowerLimit then
        
        -- Top of content has went past lower limit (in positive-y direction)
        -- Stop content movement and transition content back to upperLimit
        
        self.velocity = 0
        Runtime:removeEventListener( "enterFrame", self )
        if not self.shortList then
            tweenContent( upperLimit )
        else
            tweenContent( lowerLimit )
        end
        
        -- dispatch scroll event
        if self.listener then
            e.type = eventMin
            self.listener( e )
        end
    end
end

local function onScrollViewUpdate( self, event )    -- self == content
    if not self.trackVelocity then
        local time = event.time
        local timePassed = time - self.lastTime
        self.lastTime = time

        -- stop scrolling when velocity gets close to zero
        if mAbs( self.velocity ) < .01 then
            self.velocity = 0
            
            if self.moveDirection ~= "horizontal" then
                self.y = mFloor( self.y )
            
                -- if pulled past upper/lower boundaries, tween content properly
                limitScrollViewMovement( self, self.upperLimit, self.lowerLimit )
            else
                self.x = mFloor( self.x )
                
                -- if pulled past left/right boundaries, tween content properly
                limitScrollViewMovement( self, self.leftLimit, self.rightLimit )
            end
            
            self.moveDirection = nil
            Runtime:removeEventListener( "enterFrame", self )
            
            if self.listener then
                --Dispatch the pickers soft land
                dispatchPickerSoftland( self )
                
                -- dispatch an "endedScroll" event.type to user-specified listener
                --If the scrollview has scrolled then dispatch the ended scroll event ( this will trigger when the content has stopped moving )
                if self.hasScrolled == true then
                    dispatchEndedScroll( self )
                    self.hasScrolled = false
                end
            end

            -- self.tween is a transition that occurs when content is above or below lower limits
            -- and calls hide_scrollbar(), so the method does not need to be called here if self.tween exists
            if not self.tween then 
                --If the scrollbar isn't hidden
                if self.hideScrollBar == false then
                    self.parent:hide_scrollbar(); 
                end
            end
        else
            -- update velocity and content location on every framestep
            local moveProperty = "y"
            if self.moveDirection == "horizontal" then moveProperty = "x"; end
            self.velocity = self.velocity * self.friction
            self[moveProperty] = self[moveProperty] + (self.velocity * timePassed)
            
            if moveProperty ~= "x" then
                limitScrollViewMovement( self, self.upperLimit, self.lowerLimit )
            else
                limitScrollViewMovement( self, self.leftLimit, self.rightLimit )
            end
        end
    else
        -- for timing how long user has finger held down
        if self.moveDirection == "vertical" then        
            if self.prevY == self.y then
                if self.eventStep > 5 then
                    -- if finger is held down for 5 frames, ensure velocity is reset to 0
                    self.prevY = self.y
                    self.velocity = 0
                    self.eventStep = 0
                else
                    self.eventStep = self.eventStep + 1
                end
            end
        elseif self.moveDirection == "horizontal" then
            if self.prevX == self.x then
                if self.eventStep > 5 then
                    -- if finger is held down for 5 frames, ensure velocity is reset to 0
                    self.prevX = self.x
                    self.velocity = 0
                    self.eventStep = 0
                else
                    self.eventStep = self.eventStep + 1
                end
            end
        end
    end

    --If the scrollbar isn't hidden
    if self.hideScrollBar == false then
        self.parent:update_scrollbar()
    end
end

local function onContentTouch( self, event )    -- self == content
    local scrollView = self.parent
    local phase = event.phase
    local time = event.time
    
    if phase == "began" then
        
        -- set focus on scrollView content
        display.getCurrentStage():setFocus( self )
        self.isFocus = true
                
        -- remove listener for auto-movement based on velocity
        Runtime:removeEventListener( "enterFrame", self )

        -- TODO: Restructure code into "transactions" that represent the different states
        -- of scrolling to "bottleneck" things like the following 'removeEventListener()' call
        -- so they are not sprinkled all over the place.

        Runtime:removeEventListener( "enterFrame", scrollView.content.scrollbar_listener )
        scrollView:cancel_scrollbar_hide()
        
        -- set some variables necessary movement/scrolling
        self.velocity = 0
        self.prevX = self.x
        self.prevY = self.y
        self.prevPositionX = event.x
        self.prevPositionY = event.y
        self.trackVelocity = true
        self.markTime = time
        self.eventStep = 0
        self.upperLimit = scrollView.topPadding or 0
        self.lowerLimit = self.maskHeight - self.contentHeight
        self.leftLimit = 0
        self.rightLimit = self.maskWidth - self.contentWidth
        
        -- determine whether or not to disable horizontal/vertical scrolling
        if self.contentWidth <= self.maskWidth or scrollView.isVirtualized then
            self.horizontalScrollDisabled = true
        end
        
        -- reset move direction
        self.moveDirection = nil
        
        -- for tableviews:
        if scrollView.isVirtualized then
            self.moveDirection = "vertical"
        end
        
        -- begin enterFrame listener (for velocity calculations)
        Runtime:addEventListener( "enterFrame", self )
        
        -- dispatch scroll event
        
        if self.listener then
            local event = event
            event.name = "scrollEvent"
            event.type = "contentTouch"
            event.phase = "press"
            event.target = scrollView
            self.listener( event )
        end
        
        
        -- change lowerLimit if scrollView is "virtualized" (used for tableViews)
        if scrollView.isVirtualized and scrollView.virtualContentHeight then
            self.lowerLimit = self.maskHeight - scrollView.virtualContentHeight
            if scrollView.bottomPadding then
                self.lowerLimit = self.lowerLimit - scrollView.bottomPadding
            end
        end
    
    elseif self.isFocus then
        if phase == "moved" and not scrollView.isLocked then
        
            -- ensure content isn't trying to move while user is dragging content
            if self.tween then transition.cancel( self.tween ); self.tween = nil; end
            
            -- determine if user is attempting to move content left/right or up/down
            if not self.moveDirection then
                if not self.verticalScrollDisabled or not self.horizontalScrollDisabled then
                    local dx = mAbs(event.x - event.xStart)
                    local dy = mAbs(event.y - event.yStart)
                    local moveThresh = 8
                    
                    if dx > moveThresh or dy > moveThresh then
                        if dx > dy then
                            self.moveDirection = "horizontal"
                        else
                            self.moveDirection = "vertical"
                        end
                        
                        --The content has actually started to scroll so dispatch the beganScroll event
                        dispatchBeganScroll( self, scrollView )
                        self.hasScrolled = true
                    end
                end
            else
                
                -- Finger movement and swiping; prevent content from sticking past boundaries
                
                if self.moveDirection == "vertical" and not self.verticalScrollDisabled then
                    -- VERTICAL movement
                    
                    self.delta = event.y - self.prevPositionY
                    self.prevPositionY = event.y
                    
                    -- do "elastic" effect when finger is dragging content past boundaries
                    if self.y > self.upperLimit or self.y < self.lowerLimit then
                        self.y = self.y + self.delta/2
                    else
                        self.y = self.y + self.delta
                    end
                    
                    -- modify velocity based on previous move phase
                    --self.eventStep = 0
                    --self.velocity = (self.y - self.prevY) / (time - self.markTime)
                   
                   	local deltaTime = ( time - self.markTime )
                    if deltaTime >= 1 then
                    	self.velocity = (self.y - self.prevY) / deltaTime
                    end
                   
                    self.markTime = time
                    self.prevY = self.y
                
                elseif self.moveDirection == "horizontal" and not self.horizontalScrollDisabled then
                    -- HORIZONTAL movement
                    
                    self.delta = event.x - self.prevPositionX
                    self.prevPositionX = event.x
                    
                    -- do "elastic" effect when finger is dragging content past boundaries
                    if self.x > self.leftLimit or self.x < self.rightLimit then
                        self.x = self.x + self.delta/2
                    else
                        self.x = self.x + self.delta
                    end
                    
                    -- modify velocity based on previous move phase
                    --self.eventStep = 0
                    --self.velocity = (self.x - self.prevX) / (time - self.markTime)
                    
                    local deltaTime = ( time - self.markTime )
                    if deltaTime >= 1 then
                    	self.velocity = (self.x - self.prevX) / deltaTime
                    end
                    
                    self.markTime = time
                    self.prevX = self.x
                end
            end
            
            -- dispatch scroll event 
            
            -- # NOTE # - 
            
            --[[
                If we can throttle this a bit the tableviews wouldn't appear to "jerk" when coming to a halt
            --]]
            if self.listener then
                local event = event
                event.name = "scrollEvent"
                event.type = "contentTouch"
                event.target = scrollView
                self.listener( event )
            end
            
        
        elseif phase == "ended" or phase == "cancelled" then
            
            self.lastTime = time        -- necessary for calculating scroll movement
            self.trackVelocity = nil    -- stop tracking velocity
            self.markTime = nil
            
            -- dispatch scroll event
            if self.listener then
                local event = event
                event.name = "scrollEvent"
                event.type = "contentTouch"
                event.phase = "release"
                event.target = scrollView
                self.listener( event )
            end
                            
            -- remove focus from tableView's content
            display.getCurrentStage():setFocus( nil )
            self.isFocus = nil
        end
    end

    return true
end

local function onBackgroundTouch( self, event )

    -- This function allows scrollView to be scrolled when only the background of the
    -- widget is being touched (rather than having to touch the content itself)

    if event.phase == "began" then
        local content = self.parent.content
        content:touch( event )  -- transfer touch event to content group's touch event
    end
end

local function getContentPosition( self )
    local content = self.content
    return content.x, content.y
end

local function takeFocus( self, event )
    local target = event.target.view or event.target
    
    -- if button, restore back to "default" state
    if target.default and target.over then
        target.default.isVisible = true
        target.over.isVisible = false
        local r, g, b, a = target.label.color.default[1] or 0, target.label.color.default[2] or target.label.color.default[1], target.label.color.default[3] or target.label.color.default[1], target.label.color.default[4] or 255
        target.label:setTextColor( r, g, b, a )
    end

    -- remove focus from target
    display.getCurrentStage():setFocus( nil )
    target.isFocus = false
    
    -- set event.target to scrollView and start back at "began" phase
    event.target = self
    event.phase = "began"
    self.content.touch( self.content, event )
end

local function scrollToX( self, x, timeInMs, onComplete )   -- PRIVATE; self == scrollView
    local content = self.content
    if not self then print( "WARNING: The correct way to call scrollToX is with a ':' not a '.'" ); return; end
    if not x then return; end
    local time = timeInMs or 500
    
    if content.tween then transition.cancel( content.tween ); end
    content.tween = transition.to( content, { x=x, time=time, transition=easing.inOutQuad, onComplete=onComplete } )
end

local function scrollToY( self, y, timeInMs, onComplete )   -- PRIVATE; self == scrollView
    local content = self.content
    if not self then print( "WARNING: The correct way to call scrollToY is with a ':' not a '.'" ); return; end
    if not y then return; end
    local time = timeInMs or 500
    
    if content.tween then transition.cancel( content.tween ); end
    content.tween = transition.to( content, { y=y, time=time, transition=easing.inOutQuad, onComplete=onComplete } )
end

local function scrollToPosition( ... )
    local self, x, y, timeInMs, onComplete  -- self == scrollView
    
    if arg[1] and type(arg[1]) == "table" then
        self = arg[1]
    end
    
    self = arg[1]
    x = arg[2]
    y = arg[3]
    
    if arg[4] and type(arg[4]) == "number" then
        timeInMs = arg[4]
    elseif arg[4] and type(arg[4]) == "function" then
        onComplete = arg[4]
    end
    
    if arg[5] and type(arg[5]) == "function" then
        onComplete = arg[5]
    end

    if not self then print( "WARNING: The correct way to call scrollToPosition is with a ':' not a '.'" ); return; end
    if not x and not y then return; end
    if x and not y then
        scrollToX( self, x, timeInMs, onComplete )
    end
    
    if y and not x then
        scrollToY( self, y, timeInMs, onComplete )
    end
    
    if x and y then
        local content = self.content
        timeInMs = timeInMs or 500
        if content.tween then transition.cancel( content.tween ); end
        content.tween = transition.to( content, { x=x, y=y, time=timeInMs, transition=easing.inOutQuad, onComplete=onComplete } )
    end
end

local function scrollToTop( ... )
    local self, timeInMs, onComplete
    
    self = arg[1]
    if arg[2] and type(arg[2]) == "number" then
        timeInMs = arg[2]
    elseif arg[2] and type(arg[2]) == "function" then
        onComplete = arg[2]
    end
    
    if arg[3] and type(arg[3]) == "function" then
        onComplete = arg[3]
    end
    
    local content = self.content
    timeInMs = timeInMs or 500
    
    
    if content.tween then transition.cancel( content.tween ); end
    content.tween = transition.to( content, { y=0, time=timeInMs, transition=easing.inOutQuad, onComplete=onComplete } )
end

local function scrollToBottom( ... )
    local self, timeInMs, onComplete
    
    self = arg[1]
    if arg[2] and type(arg[2]) == "number" then
        timeInMs = arg[2]
    elseif arg[2] and type(arg[2]) == "function" then
        onComplete = arg[2]
    end
    
    if arg[3] and type(arg[3]) == "function" then
        onComplete = arg[3]
    end
    
    local content = self.content
    timeInMs = timeInMs or 500
    local lowerLimit = content.maskHeight - content.contentHeight
    
    if content.tween then transition.cancel( content.tween ); end
    content.tween = transition.to( content, { y=lowerLimit, time=timeInMs, transition=easing.inOutQuad, onComplete=onComplete } )
end

local function scrollToLeft( ... )
    local self, timeInMs, onComplete
    
    self = arg[1]
    if arg[2] and type(arg[2]) == "number" then
        timeInMs = arg[2]
    elseif arg[2] and type(arg[2]) == "function" then
        onComplete = arg[2]
    end
    
    if arg[3] and type(arg[3]) == "function" then
        onComplete = arg[3]
    end
    
    local content = self.content
    timeInMs = timeInMs or 500
    
    if content.tween then transition.cancel( content.tween ); end
    content.tween = transition.to( content, { x=0, time=timeInMs, transition=easing.inOutQuad, onComplete=onComplete } )
end

local function scrollToRight( ... )
    local self, timeInMs, onComplete
    
    self = arg[1]
    if arg[2] and type(arg[2]) == "number" then
        timeInMs = arg[2]
    elseif arg[2] and type(arg[2]) == "function" then
        onComplete = arg[2]
    end
    
    if arg[3] and type(arg[3]) == "function" then
        onComplete = arg[3]
    end
    
    local content = self.content
    timeInMs = timeInMs or 500
    local rightLimit = content.maskWidth - content.contentWidth
    
    if content.tween then transition.cancel( content.tween ); end
    content.tween = transition.to( content, { x=rightLimit, time=timeInMs, transition=easing.inOutQuad, onComplete=onComplete } )
end

local function removeSelf( self )
    -- check to see if there is a clean method; if so, call it
    if self.clean then self:clean(); end
    
    -- remove scrollView content
    if self.content then
        -- cancel any active transitions
        if self.content.tween then transition.cancel( self.content.tween ); self.content.tween = nil; end
        if self.sb_tween then transition.cancel( self.sb_tween ); self.sb_tween = nil; end
        if self.sb_timer then timer.cancel( self.sb_timer ); self.sb_timer = nil; end
        
        -- remove runtime listener
        Runtime:removeEventListener( "enterFrame", self.content )
        Runtime:removeEventListener( "enterFrame", self.content.scrollbar_listener )
        
        -- remove all children from content group
        for i=self.content.numChildren,1,-1 do
            display.remove( self.content[i] )
        end
        
        display.remove( self.content )
        self.content = nil
    end
    
    -- removed fixed (non scrollable) content
    if self.fixed then
        -- remove all children from fixed group
        for i=self.fixed.numChildren,1,-1 do
            display.remove( self.fixed[i] )
        end
        
        display.remove( self.fixed )
        self.fixed = nil
    end
    
    -- remove all children from virtual group
    if self.virtual then
        for i=self.virtual.numChildren,1,-1 do
            display.remove( self.virtual[i] )
        end
        
        display.remove( self.virtual )
        self.virtual = nil
    end
    
    -- remove bitmap mask
    if self.mask then
        self:setMask( nil )
        self.mask = nil
    end
    
    -- call original removeSelf method
    self:cached_removeSelf()
end

local function createScrollBar( parent, manual_height, options )
    -- set initial variables
    local fixed_group = parent.fixed
    local scrollbar_width = 6
    local top = 6
    local min_height = 24
    local max_height = parent.widgetHeight-(top*2)

    -- calculate scrollbar height (based on total content height)
    local sb_height
    local content_height = manual_height or parent.content.contentHeight
    local content_bleed = content_height - parent.widgetHeight

    if content_bleed > parent.widgetHeight then
        sb_height = min_height

    elseif content_bleed > 0 then

        local bleed_percent = content_bleed/parent.widgetHeight
        sb_height = max_height-(max_height*bleed_percent)

    else
        display.remove( parent._scrollbar ); parent._scrollbar = nil
        return
    end

    -- calculate proper location of scrollbar (in case a start_percent wasn't provided)
    local amount_above_top = content_height-(content_height+parent.content.y)
    local calculated_percent = (amount_above_top/content_bleed)

    -- calculate scrollbar height and handle "squish" effect when content goes past boundaries
    local min_y = top
    local max_y = (top+max_height)-sb_height
    local scroll_range = max_y-min_y
    local scroll_percent = calculated_percent
    local x = parent.widgetWidth-3
    local y = top+(scroll_range*scroll_percent)
    if y < min_y then
        local difference = min_y - y
        sb_height = sb_height - difference
        if sb_height < min_height then sb_height = min_height; end

        -- don't allow scrollbar to go past minimum y position (even when content goes past boundary)
        y = min_y

    elseif y > max_y then
        
        local difference = y - max_y
        sb_height = sb_height - difference
        if sb_height < min_height then sb_height = min_height; end

        -- adjust y position since we adjusted scrollbar height
        y = (top+max_height)-sb_height
    end

    -- create the actual scrollbar from a rounded rectangle
    local sb = parent._scrollbar
    if not sb then
        sb = display.newRoundedRect( fixed_group, 0, 0, scrollbar_width, sb_height, 2 )         
    else
        sb.height = sb_height
    end
    sb:setReferencePoint( display.TopRightReferencePoint )
    
    if options and options.scrollBarColor and type( options.scrollBarColor ) == "table" then
        sb:setFillColor( unpack( options.scrollBarColor ) )
    else    
        sb:setFillColor( 0, 128 )
    end
    
    sb.x, sb.y = x, y
    sb.alpha = 1.0

    return sb
end

function m.createScrollView( options )
    -- extract parameters or use defaults
    local   options = options or {}
    local   id = options.id or "widget_scrollView"
    local   left = options.left or 0
    local   top = options.top or 0
    local   width = options.width or (display.contentWidth-left)
    local   height = options.height or (display.contentHeight-top)
    local   scrollWidth = options.scrollWidth or width
    local   scrollHeight = options.scrollHeight or height
    local   friction = options.friction or scrollFriction
    local   listener = options.listener
    local   bgColor = options.bgColor or {}
            bgColor[1] = bgColor[1] or 255
            bgColor[2] = bgColor[2] or bgColor[1]
            bgColor[3] = bgColor[3] or bgColor[1]
            bgColor[4] = bgColor[4] or 255
    local   maskFile = options.maskFile
    local   hideBackground = options.hideBackground
    local   isVirtualized = options.isVirtualized
    local   topPadding = options.topPadding
    local   bottomPadding = options.bottomPadding
    local   baseDir = options.baseDir or system.ResourceDirectory
    
    --Picker (used in the pickers soft landing function)
    local   isPicker = options.isPicker or nil
    local   pickerTop = options.pickerTop or nil
    
    -- create display groups
    local scrollView = display.newGroup()   -- display group for widget; will be masked
    local content = display.newGroup()      -- will contain scrolling content
    local virtual = display.newGroup()      -- will contain "virtual" content (such as tableView rows)
    local fixed = display.newGroup()        -- will contain 'fixed' content (that doesn't scroll)
    scrollView:insert( content )
    scrollView:insert( virtual )
    scrollView:insert( fixed )
    
    -- important references
    scrollView.content = content
    scrollView.virtual = virtual
    scrollView.fixed = fixed
    
    -- set some scrollView properties (private properties attached to content group)
    scrollView._isWidget = true
    --Exposed variables for use with picker softlanding function
    scrollView._isPicker = isPicker
    scrollView.pickerTop = pickerTop
    ----------------------------------
    scrollView.id = id
    scrollView.widgetWidth = width
    scrollView.widgetHeight = height
    scrollView.isVirtualized = isVirtualized
    scrollView.topPadding = topPadding
    scrollView.bottomPadding = bottomPadding
    content.hideScrollBar = options.hideScrollBar or false
    --Exposed for use with picker softlanding function
    content.selectionHeight = options.selectionHeight or nil
    content.maskWidth = width
    content.maskHeight = height
    content.friction = friction
    content.enterFrame = onScrollViewUpdate -- enterFrame listener function
    content.touch = onContentTouch; content:addEventListener( "touch", content )
    content.listener = listener
    content.hasScrolled = false
    
    -- scrollView methods
    scrollView.getContentPosition = getContentPosition
    scrollView.takeFocus = takeFocus
    scrollView.scrollToPosition = scrollToPosition
    scrollView.scrollToTop = scrollToTop
    scrollView.scrollToBottom = scrollToBottom
    scrollView.scrollToLeft = scrollToLeft
    scrollView.scrollToRight = scrollToRight
    
    -- create background rectangle for widget
    local bgRect = display.newRect( 0, 0, width, height )
    bgRect:setFillColor( bgColor[1], bgColor[2], bgColor[3], bgColor[4] )
    if hideBackground then bgRect.isVisible = false; end
    bgRect.isHitTestable = true
    bgRect.touch = onBackgroundTouch; bgRect:addEventListener( "touch", bgRect )
    scrollView:insert( 1, bgRect )
    
    -- create a background for actual content
    local contentBg = display.newRect( 0, 0, scrollWidth, scrollHeight )
    contentBg:setFillColor( 255, 100 )
    contentBg.isVisible = false
    content:insert( 1, contentBg )
    
    -- apply mask (if user set option)
    if maskFile then
        scrollView.mask = graphics.newMask( maskFile, baseDir )
        scrollView:setMask( scrollView.mask )

        scrollView.maskX = width * 0.5
        scrollView.maskY = height * 0.5
        scrollView.isHitTestMasked = false
    end

    -- position widget based on left/top options
    scrollView:setReferencePoint( display.TopLeftReferencePoint )
    scrollView.x, scrollView.y = left, top

    -- override removeSelf method for scrollView (to ensure widget is properly removed)
    scrollView.cached_removeSelf = scrollView.removeSelf
    scrollView.removeSelf = removeSelf

    function scrollView.content.scrollbar_listener( event )
        scrollView:update_scrollbar()
    end
    
    -- override insert method for scrollView to insert into content instead
    scrollView.cached_insert = scrollView.insert
    function scrollView:insert( arg1, arg2 )
        local index, obj
        
        if arg1 and type(arg1) == "number" then
            index = arg1
        elseif arg1 and type(arg1) == "table" then
            obj = arg1
        end
        
        if arg2 and type(arg2) == "table" then
            obj = arg2
        end
        
        if index then
            self.content:insert( index, obj )
        else
            self.content:insert( obj )
        end
    end

    -- cancels scrollbar fadeout effect
    function scrollView:cancel_scrollbar_hide()
        if self.sb_tween then transition.cancel( self.sb_tween ); self.sb_tween = nil; end
        if self.sb_timer then timer.cancel( self.sb_timer ); self.sb_timer = nil; end
    end

    -- function to update scrollbar height and position
    function scrollView:update_scrollbar()
        local content_height = self.virtualContentHeight
        self._scrollbar = createScrollBar( self, content_height, options )
    end

    function scrollView:hide_scrollbar()
        Runtime:removeEventListener( "enterFrame", self.content.scrollbar_listener )
        self:cancel_scrollbar_hide()

        local function fade_out()
            local function remove_scrollbar()
                display.remove( self._scrollbar )
                self._scrollbar = nil
                self.sb_tween = nil
            end
            if self.sb_tween then
                transition.cancel( self.sb_tween ); self.sb_tween = nil;
                self._scrollbar.alpha = 1.0
            end
            self.sb_tween = transition.to( self._scrollbar, { time=300, alpha=0, onComplete=remove_scrollbar } )
        end
        self.sb_timer = timer.performWithDelay( 300, fade_out, 1 )
    end
    
    return scrollView   -- returns a display group
end

return m