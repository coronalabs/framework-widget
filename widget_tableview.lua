local m = {}
local mAbs = math.abs
local mFloor = math.floor

-- creates group for row, as well as a background and bottom-line
local function newRowGroup( rowData )
    local row = display.newGroup()
    
    -- create background
    local bg = display.newRect( row, 0, 0, rowData.width, rowData.height )
    bg:setFillColor( rowData.rowColor[1], rowData.rowColor[2], rowData.rowColor[3], rowData.rowColor[4] )
    
    -- create bottom-line
    local line
    
    --Only create the line if the user hasn't specified noLines == true in options table.
    if options and not options.noLines == true or options and not options.noLines or options and options.noLines == false then
        line = display.newLine( row, 0, rowData.height, rowData.width, rowData.height )
        line:setColor( rowData.lineColor[1], rowData.lineColor[2], rowData.lineColor[3], rowData.lineColor[4] )
        row.line = line
    end
    
    row.background = bg
    
    --If the user has specified noLines == true then set row.line to nil
    if type( row.line ) ~= "table" then
        row.line = nil
    end
    
    return row
end

-- render row based on index in tableView.content.rows table
local function renderRow( self, row )   -- self == tableView
    local content = self.content
    if row.view then row.view:removeSelf(); end
    row.view = newRowGroup( row )
    self.virtual:insert( row.view )
    
    row.view.x = 0
    row.view.y = row.top
    
    if row.onRender then
        -- set up event table
        local e = {}
        e.name = "tableView_rowRender"
        e.type = "render"
        e.parent = self -- tableView that this row belongs to
        e.target = row
        e.row = row
        e.id = row.id
        e.view = row.view
        e.background = row.view.background
        e.line = row.view.line
        e.data = row.data
        e.phase = "render"      -- phases: render, press, release, swipeLeft, swipeRight
        e.index = row.index
        
        row.onRender( e )
    end
end

local function renderCategory( self, row )  -- self == tableView; row should be a table, not an index
    local content = self.content
    
    local newCategoryRender = function()
        if content.category then display.remove( content.category ); end
        
        content.category = newRowGroup( row )
        content.category.index = row.index
        content.category.x, content.category.y = 0, 0 ---row.height
        
        self.fixed:insert( content.category )   -- insert into tableView's 'fixed' group
        
        if row.onRender then
            -- set up event table
            local e = {}
            e.name = "tableView_rowRender"
            e.type = "render"
            e.parent = self -- tableView that this row belongs to
            e.target = row
            e.row = row
            e.id = row.id
            e.view = content.category
            e.background = content.category.background
            e.line = content.category.line
            e.data = row.data
            e.phase = "render"      -- phases: render, press, release, swipeLeft, swipeRight
            e.index = row.index
            
            row.onRender( e )
        end
    end
    
    if not content.category then
        -- new; no category currently rendered
        newCategoryRender()
        
    else
        -- there is currently a category; render only if it's different
        if content.category.index ~= row.index then
            newCategoryRender()
        end
    end
end

-- renders row if it does not have a 'view' property (display group)
local function ensureRowIsRendered( self, row ) -- self == tableView
    if not row.view then
        renderRow( self, row )
    else
        row.view.y = row.top
    end
end

-- render rows within the render range ( -renderThresh <-- widget height --> renderThresh )
local function renderVisibleRows( self ) -- self == tableView           
    local content = self.content
    
    -- if widget has been removed during scrolling, be sure to remove certain enterFrame listeners
    if not content or not content.y then
        if content then Runtime:removeEventListener( "enterFrame", content ); end
        Runtime:removeEventListener( "enterFrame", self.rowListener )
        return
    end
    
    local currentCategoryIndex
    local rows = content.rows
    
    -- ensure all rows that are marked .isRendered are rendered 
    for i=1,#rows do
        local row = rows[i]
        -- update top/bottom locations
        row.top = content.y + row.topOffset
        row.bottom = row.top + row.height
        
        -- category "pushing" effect
        if content.category and row.isCategory and row.index ~= content.category.index then
            if row.top < content.category.contentHeight-3 and row.top >= 0 then
                -- push the category upward
                content.category.y = row.top - (content.category.contentHeight-3)
            end
        end
        
        -- determine which category should be rendered (sticky category at top) 
        if row.isCategory and row.top <= 0 then
            currentCategoryIndex = i
        
        elseif row.isCategory and row.top >= 0 and content.category and row.index == content.category.index then
            -- category moved below top of tableView, render previous category
            
            -- render the previous category, if this is not the first current category
            if row.index ~= content.firstCategoryIndex then
                currentCategoryIndex = content.categories["cat-" .. row.index]  -- stores reference to previous category index
            else
                -- remove current category if the first category moved below top of tableView
                if content.category then
                    content.category:removeSelf()
                    content.category = nil
                    currentCategoryIndex = nil
                end
            end
        end
        
        -- check to see if row is within viewable area
        local belowTopThresh = row.bottom > -self.renderThresh
        local aboveBottomThresh = row.top < self.widgetHeight+self.renderThresh
        if belowTopThresh and aboveBottomThresh then
            row.isRendered = true
            
            -- ensures rows that are marked for rerendering and within render area get rendered
            if row.reRender then
                if row.view then row.view:removeSelf(); row.view = nil; end
                row.reRender = nil;
                row.isRendered = true
            end
            
            ensureRowIsRendered( self, row )
            
            -- hide row's view if it happens to be outside of viewable area; show it if in viewable bounds
            if row.bottom < 0 or row.top > self.widgetHeight then
                if row.view.isVisible then row.view.isVisible = false; end
            else
                if not row.view.isVisible then row.view.isVisible = true; end
            end
        else
            row.isRendered = false
            if row.view then row.view:removeSelf(); row.view = nil; end
        end

        -- hide row if it is the current category (category item will be rendered at top of widget)
        if row.index == currentCategoryIndex then
            if row.view then row.view.isVisible = false; end
        end
    end
    
    -- render current category
    if currentCategoryIndex then
        renderCategory( self, rows[currentCategoryIndex] )
    end
end

-- find the next row insert location (y-coordinate)
local function getNextRowTop( content )
    local rows = content.rows
    local top, nextIndex = content.y, #rows+1
    
    local final = rows[#rows]
    if final then
        -- return final row's top location + its height
        top = final.top + final.height
    end
    
    return top, nextIndex   -- returns next 'top' coordinate, & the next avail. index
end

-- iterate through all rows and update row data (such as content offset, total height, category info, etc)
local function updateRowData( self )    -- self == tableView
    local content = self.content
    local rows = content.rows
    local top = content.y
    local currentY = top
    local firstCategory
    local previousCategory
    local totalHeight = 0
    content.categories = {}
    
    for i=1,#rows do
        rows[i].topOffset = currentY - top
        
        -- update index while we're at it
        rows[i].index = i
        
        -- popuplate content.categories table
        if rows[i].isCategory then
            if not previousCategory then
                content.categories["cat-" .. i] = "first"
                previousCategory = i
            else
                content.categories["cat-" .. i] = previousCategory
                previousCategory = i
            end
            
            if not firstCategory then
                -- store reference to very first category index
                firstCategory = i
            end
        end
        local height = rows[i].height
        currentY = currentY + height + 1
        totalHeight = totalHeight + height + 1
    end
    
    -- make reference to first category
    content.firstCategoryIndex = firstCategory
    
    -- force re-calculation of top/bottom most rendered rows
    --self.topMostRendered = nil
    --self.bottomMostRendered = nil
    
    -- update total height of all rows
    self.virtualContentHeight = totalHeight
end

-- used to insert new rows into tableView.content.rows table
local function insertRow( self, params )    -- self == tableView
    local row = {}
    row.id = params.id      -- custom id
    row.data = params.data  -- custom data
    row.width = self.content.maskWidth
    row.height = params.height or 56    -- default row height is 56
    row.isCategory = params.isCategory
    row.onEvent = params.listener or params.onEvent
    row.onRender = params.onRender
    local rowColor = params.rowColor or {}
        rowColor[1] = rowColor[1] or 255
        rowColor[2] = rowColor[2] or rowColor[1]
        rowColor[3] = rowColor[3] or rowColor[1]
        rowColor[4] = rowColor[4] or 255
    local lineColor = params.lineColor or {}
        lineColor[1] = lineColor[1] or 128
        lineColor[2] = lineColor[2] or lineColor[1]
        lineColor[3] = lineColor[3] or lineColor[1]
        lineColor[4] = lineColor[4] or 255
    row.rowColor = rowColor
    row.lineColor = lineColor
    row.top, row.index = getNextRowTop( self.content )
    row.isRendered = false  -- will ensure row gets rendered on next update
    
    -- increase renderThresh property of tableView if row height is larger
    -- renderThresh is the limit above and below widget where rendering occurs
    if row.height >= self.renderThresh then
        self.renderThresh = row.height + 10
    end
    
    -- insert as final item in tableView.content.rows table
    table.insert( self.content.rows, row )
    updateRowData( self )
    if not params.skipRender then renderVisibleRows( self ); end    -- refresh locations/rendering
end

-- finds rendered row at on-screen y-coordinate and returns the row object
local function getRowAtCoordinate( self, yPosition )    -- self == tableView
    local top = self.y  -- y-coordinate of tableView, from top-left reference point
    local content = self.content
    --local firstRenderedRow = content.firstRenderedRow or 1
    local rows = content.rows
    local result
    
    for i=1,#rows do
        if rows[i].view then
            local viewBounds = rows[i].view.contentBounds
            local isWithinBounds = yPosition > viewBounds.yMin and yPosition < viewBounds.yMax
            
            -- if yPosition is within the row's view group, return this row
            if isWithinBounds then result = rows[i]; break; end
        end
    end
    
    return result
end

-- calls onEvent listener for row
local function dispatchRowTouch( row, phase, parentWidget )
    if row.onEvent then
        -- set up event table
        local e = {}
        e.name = "tableView_rowTouch"
        e.type = "touch"
        e.parent = parentWidget -- tableView that this row belongs to
        e.target = row
        e.row = row
        e.id = row.id
        e.view = row.view
        e.background = row.view.background
        e.line = row.view.line
        e.data = row.data
        e.phase = phase     -- phases: render, press, tap, release, swipeLeft, swipeRight
        e.index = row.index
        
        row.onEvent( e )
    end
end

--Function to invoke the users tableView listener if specified
local function invokeUserListener( self, event ) --Self == tableView
    if self.userListener and type( self.userListener ) == "function" then
        self.userListener( event )
    end
end


-- listens to scrollView events for tableView
local function scrollListener( event )
    local tableView = event.target
    local content = tableView.content
    local eType = event.type
    
    local moveRowsWithTween = function( self )  -- self == tableView
        local updateRows = function() renderVisibleRows( self ) end
        if self.rowTimer then timer.cancel( self.rowTimer ); end;
        self.rowTimer = timer.performWithDelay( 1, updateRows, 400 )
    end
    
    
    if eType == "contentTouch" then
                
        local tapThresh = 3     -- used to determine if touch was a "drag" or a quick tap
        local moveThresh = 10   -- do not allow swipes once user drags up/down past this amount
        local swipeThresh = 12  -- if finger moves left/right this amount, trigger swipe event
        
        if event.phase == "press" then
            
            -- tableView content has been touched   
            
            --Allow the user to stop the tableView scrolling by touching/tapping the tableView whilst it's scrolling, without dispatching a tap/touch event for a row
            if tableView.hasScrolled == true and tableView.eventType ~= "contentTouch" then
                event.phase = "cancelled"
                event.type = "endedScroll"
                
                invokeUserListener( tableView, event )      
                local row = tableView.currentSelectedRow
                    
                if row then
                    row.isTouched = false
                    row = nil
                    tableView.currentSelectedRow = nil
                    renderVisibleRows( tableView )
                    content.velocity = 0
                    content.trackRowSelection = false
                end
                
                tableView.hasScrolled = false
                return
            end
            
            
            if tableView.rowTimer then timer.cancel( tableView.rowTimer ); tableView.rowTimer = nil; end;
            Runtime:removeEventListener( "enterFrame", tableView.rowListener )
            
            -- find out which row the touch began on and store a reference to it
            tableView.currentSelectedRow = getRowAtCoordinate( tableView, event.y )
            tableView.renderFrameCount = 0
            tableView.renderFramePace = 0
            content.yDistance = 0
            content.canSwipe = true
            
            Runtime:addEventListener( "enterFrame", tableView.rowListener )
            content.trackRowSelection = true
            
        elseif event.phase == "moved" then
        
            --Dispatch contentTouch event
            event.type = "contentTouch"
            
            -- tableView content is being dragged
            local canDrag = content.canDrag
            local canSwipe = content.canSwipe
            local yDistance
            
            -- calculate distance traveled in y direction (only when needed)
            if not canDrag or canSwipe then
                yDistance = mAbs( event.y - event.yStart )
            end
            
            -- determine if this touch event could possibly be a "row tap"
            if not canDrag then
                if yDistance > tapThresh then
                    content.yDistance = yDistance
                    content.canDrag, canDrag = true, true
                    content.trackRowSelection = nil
                end
            end
            
            -- determine whether y distance traveled is low enough to allow left/right swipes
            if canSwipe then
                if yDistance > moveThresh then
                    canSwipe = nil
                    content.canSwipe = nil
                end
            else
                local selectedRow = tableView.currentSelectedRow
                
                if selectedRow and selectedRow.isTouched then
                    selectedRow.isTouched = false
                    selectedRow.reRender = true
                end
                
                -- ensure rows move with drag
                renderVisibleRows( tableView )
            end
            
            -- left/right swipes
            local row = tableView.currentSelectedRow
            if row and canSwipe then
                local xDistance = event.x - event.xStart
                
                -- check to see if a "swipe" event should be dispatched
                if xDistance > swipeThresh then
                    dispatchRowTouch( row, "swipeRight", tableView )
                    row.isTouched = false
                    row = nil
                    tableView.currentSelectedRow = nil
                    renderVisibleRows( tableView )
                    content.velocity = 0
                    content.trackRowSelection = false
                
                    -- remove focus from tableView's content
                    display.getCurrentStage():setFocus( nil )
                    content.isFocus = nil
                    
                elseif xDistance < -swipeThresh then
                    dispatchRowTouch( row, "swipeLeft", tableView )
                    row.isTouched = false
                    row = nil
                    tableView.currentSelectedRow = nil
                    renderVisibleRows( tableView )
                    content.velocity = 0
                    content.trackRowSelection = false
                
                    -- remove focus from tableView's content
                    display.getCurrentStage():setFocus( nil )
                    content.isFocus = nil
                end
            end
        
        elseif event.phase == "release" then
            
            local row = tableView.currentSelectedRow
            if row then
                if content.yDistance < tapThresh and content.trackRowSelection then
                    -- user tapped tableView content (dispatch row release event)
                    dispatchRowTouch( row, "tap", tableView )
                    row.isTouched = nil
                    row = nil
                    tableView.currentSelectedRow = nil
                else
                    if row and row.isTouched then
                        dispatchRowTouch( row, "release", tableView )
                        row.isTouched = nil
                        row = nil
                        tableView.currentSelectedRow = nil
                        renderVisibleRows( tableView )
                    end
                end
            end
            
            -- variables used during "moved" phase
            content.yDistance = nil
            content.canDrag = nil
            content.canSwipe = nil
            content.trackRowSelection = nil
            
            -- prevents categories from getting 'stuck' in the wrong position
            if content.category and content.category.y ~= 0 then content.category.y = 0; end
        end
    
    elseif eType == "movingToTopLimit" or eType == "movingToBottomLimit" then
        --Dispatch moving to top/bottom limit event
        invokeUserListener( tableView, event )
            
        -- prevents categories from getting 'stuck' in the wrong position
        if content.category and content.category.y ~= 0 then content.category.y = 0; end
        moveRowsWithTween( tableView )
    end
end

-- times how long finger has been held down on a specific row
local function checkSelectionStatus( self, time )   -- self == tableView
    local content = self.content
    if content.trackRowSelection then
        local timePassed = time - content.markTime
            
        if timePassed > 110 then        -- finger has been held down for more than 100 milliseconds
            content.trackRowSelection = false
            
            -- initiate "press" event if a row is being touched
            local row = self.currentSelectedRow
            if row then
                row.isTouched = true
                dispatchRowTouch( row, "press", tableView )
            end
        end
    end
end

-- enterFrame listener for tableView widget
local function rowListener( self, event )   -- self == tableView
    -- limit velocity to maximum amount (self.maxVelocity)
    local velocity = self.content.velocity
    if velocity < -self.maxVelocity then self.content.velocity = -self.maxVelocity; end
    if velocity > self.maxVelocity then self.content.velocity = self.maxVelocity; end
            
    --Dispatch began scroll event
    if velocity > 0 or velocity < 0 then
        if self.hasScrolled == false then
            event.type = "beganScroll"
            invokeUserListener( self, event )
            self.hasScrolled = true
        end
    end

    local isTrackingVelocity = self.content.trackVelocity
    if not isTrackingVelocity then
        if self.content.velocity == 0 then
            --Dispatch endedScroll event
            if self.hasScrolled == true then
                event.type = "endedScroll"
                invokeUserListener( self, event )
                self.hasScrolled = false
            end
            
            Runtime:removeEventListener( "enterFrame", self.rowListener )
        end
        -- prevents categories from getting 'stuck' in the wrong position
        local content = self.content
        if content.category and content.category.y ~= 0 then content.category.y = 0; end
        
        -- renderFramePace and renderFrameCount will skip rendering frames if velocity (list travel speed) is too high
        -- [[
        local velocity = mAbs( velocity )
        if velocity >= 4 then
            self.renderFramePace = 1
            
        elseif velocity >= 6 then
            self.renderFramePace = 2
        
        elseif velocity >= 8 then
            self.renderFramePace = 3
        
        elseif velocity >= 10 then
            self.renderFramePace = 4
            
        else
            self.renderFramePace = 0
        end
        
        if self.renderFrameCount >= self.renderFramePace then
            self.renderFrameCount = 0
            renderVisibleRows( self )
        else
            self.renderFrameCount = self.renderFrameCount + 1
        end
        --]]
        
        --renderVisibleRows( self )
    else
        -- check to see if current row should be selected
        checkSelectionStatus( self, event.time )
    end
end

-- force re-render of all rows
local function forceReRender( self )    -- self == tableView
    local content = self.content
    local rows = content.rows
    
    --self.topMostRendered, self.bottomMostRendered = nil, nil
    for i=1,#rows do
        local r = rows[i]
        if r.view then r.view:removeSelf(); r.view = nil; end
        r.isRendered = nil
    end
end

-- find proper category in proportion to specific row being at very top of list
local function renderProperCategory( self, rows, rowIndex )     -- self == tableView
    local categoryIndex
            
    if rows[rowIndex].isCategory then
        categoryIndex = rowIndex
    else
        -- loop backwards to find the current category
        for i=rowIndex,1,-1 do
            if rows[i].isCategory then
                categoryIndex = i
                break
            end
        end
    end
    
    -- category found; render it and return the index
    if categoryIndex then
        renderCategory( self, rows[categoryIndex] )
        return categoryIndex
    end
end

-- scroll content to specified y-position
local function scrollToY( self, yPosition, timeInMs )       -- self == tableView
    yPosition = yPosition or 0
    timeInMs = timeInMs or 1500
            
    if yPosition > 0 and not self._isPicker then
        print( "WARNING: You must specify a y-value less than zero (negative) when using tableView:scrollToY()." )
        return
    end

    local content = self.content
    
    -- called once content is in desired location
    local function contentInPosition()
        local row = getRowAtCoordinate( self, self.y )
        if row then 
            renderProperCategory( self, content.rows, row.index )
        end
    end

    if timeInMs > 0 then
        local updateTimer
        local cancelUpdateTimer = function() timer.cancel( updateTimer ); updateTimer = nil; contentInPosition(); end
        if content.tween then transition.cancel( content.tween ); end
        content.tween = transition.to( content, { y=yPosition, time=timeInMs, transition=easing.outQuad, onComplete=cancelUpdateTimer } )
        local updateRows = function() renderVisibleRows( self ); end
        updateTimer = timer.performWithDelay( 1, updateRows, timeInMs )
    else
        content.y = yPosition
        forceReRender( self )
        renderVisibleRows( self )
        contentInPosition()
    end
end

-- scroll content to place specific row at top of tableView
local function scrollToIndex( self, rowIndex, timeInMs )    -- self == tableView
    local content = self.content
    local rows = content.rows
    local padding = self.topPadding or 0
    local yPosition = -(rows[rowIndex].topOffset) + padding
    
    if yPosition then
        if timeInMs then
            scrollToY( self, yPosition, timeInMs )
        else
            content.y = yPosition
            forceReRender( self )
            renderVisibleRows( self )
            renderProperCategory( self, rows, rowIndex ) -- render the appropriate category
        end
    end
end

-- returns y-position of content
local function getContentPosition( self )   -- self == tableView
    return self.content.y
end

-- clear all rows from tableview (method)
local function deleteAllRows( self ) -- self == tableView
    local content = self.content
    local rows = content.rows

    for i=#rows,1,-1 do
        local r = rows[i]
        display.remove( r.view ); r.view = nil
        table.remove( rows, r.index )

        if r.isCategory and content.category then
            if content.category.index == r.index then
                display.remove( content.category )
                content.category = nil
            end
        end
    end
    self.content.rows = {}
end

-- permanently remove specified row from tableView
local function deleteRow( self, rowOrIndex )    -- self == tableView
    local content = self.content
    local rows = content.rows
    local row
    
    -- function accepts row table or index integer
    if type(rowOrIndex) == "table" then
        row = rowOrIndex
    else
        row = rows[rowOrIndex]
    end
    
    if row then
        if row.isRendered then
            if row.view then display.remove( row.view ); row.view = nil; end
        end
        table.remove( content.rows, row.index )

        if row.isCategory and content.category then
            if content.category.index == row.index then
                display.remove( content.category )
                content.category = nil
            end
        end
    end
    
    updateRowData( self )
    renderVisibleRows( self )
end

-- cleanup function (automatically called prior to calling removeSelf)
local function cleanTableView( self )   -- self == tableView
    -- remove tableView's enterframe listener
    Runtime:removeEventListener( "enterFrame", self.rowListener )
    self.rowListener = nil
    
    -- cancel any potentially active timers/transitions
    if self.rowTimer then timer.cancel( self.rowTimer ); self.rowTimer = nil; end
    if self.content and self.content.tween then
        transition.cancel( self.content.tween ); self.content.tween = nil
    end
    
    -- remove category object if it exists
    if self.content.category then
        self.content.category:removeSelf()
        self.content.category = nil
    end
end

function m.createTableView( options, scrollFriction )
    local options = options or {}
    
    -- tableView-specific parameters
    local   id = options.id or "widget_tableView"
    local   renderThresh = options.renderThresh or 100  -- px amount above and below to begin rendering rows
    
    -- shared scrollView parameters (if not specified will use scrollView defaults)
    local   left = options.left or 0
    local   top = options.top or 0
    local   width = options.width or (display.contentWidth-left)
    local   height = options.height or (display.contentHeight-top)
    local   scrollWidth = width
    local   scrollHeight = height
    local   friction = options.friction or scrollFriction
    local   bgColor = options.bgColor
    local   maskFile = options.maskFile
    local   hideBackground = options.hideBackground
    local   keepRowsPastTopVisible = options.keepRowsPastTopVisible
    local   topPadding = options.topPadding
    local   bottomPadding = options.bottomPadding
    local   maxVelocity = options.maxVelocity or 10
    local   baseDir = options.baseDir or system.ResourceDirectory
    local   hideScrollBar = options.hideScrollBar or false
    local   scrollBarColor = options.scrollBarColor
    local   userListener = options.listener or nil
    
    --Picker - Variables used by the picker soft landing function
    local   selectionHeight = options.selectionHeight or nil
    local   isPicker = options.isPicker or false
    local   pickerTop = options.pickerTop or nil
            
    -- tableView foundation is a scrollView widget
    local tableView = require( "widget_scrollview" ).createScrollView{
        id = id,
        left = left,
        top = top,
        width = width,
        height = height,
        scrollWidth = scrollWidth,
        scrollHeight = scrollHeight,
        friction = friction,
        bgColor = bgColor,
        maskFile = maskFile,
        hideBackground = hideBackground,
        listener = scrollListener,
        isVirtualized = true,
        topPadding = topPadding,
        bottomPadding = bottomPadding,
        baseDir = baseDir,
        hideScrollBar = hideScrollBar,
        scrollBarColor = scrollBarColor,
        selectionHeight = selectionHeight,
    }
    tableView.userListener = userListener;
    tableView.hasScrolled = false
    tableView.eventType = nil
    
    -- properties and methods
    tableView._isWidget = true
    --Variables exposed for picker soft landing function
    tableView._isPicker = isPicker
    tableView.pickerTop = pickerTop
    -------------------------------------
    function tableView.rowListener( event ) rowListener( tableView, event ); end
    tableView.content.rows = {} -- holds row data
    tableView.insertRow = insertRow
    tableView.deleteRow = deleteRow
    tableView.deleteAllRows = deleteAllRows
    tableView.renderThresh = renderThresh
    tableView.scrollToY = scrollToY
    tableView.scrollToIndex = scrollToIndex
    tableView.getRowAtCoordinate = getRowAtCoordinate
    tableView.getContentPosition = getContentPosition
    tableView.keepRowsPastTopVisible = keepRowsPastTopVisible
    tableView.maxVelocity = maxVelocity
    tableView.renderFramePace = 0
    tableView.renderFrameCount = 0
    
    -- clean method will be called whenever 'removeSelf' is called
    tableView.clean = cleanTableView
    
    -- position the content based on 'topPadding' variable
    tableView.content.y = topPadding or 0
    
    return tableView
end

return m