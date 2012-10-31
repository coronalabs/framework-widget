local m = {}
local mAbs = math.abs
local mFloor = math.floor
local pickerFriction = 0.88

--Function to handle the soft-landing of the picker wheel
function m.pickerSoftLand( self )
    local target = self.parent
    
    --Variables that equal the ones used in picker.getValues
    local height = self.height
    local selectionHeight = self.selectionHeight
    local top = self.parent.parent.parent.y --Get the actual pickers groups y position to use as the top position
    local selectionTop = target.topPadding
    
    --Index to scroll to                            
    local index = nil
    
    --Get row using same system at picker.getValues uses
    local realSelectionY = top + selectionTop + (selectionHeight*0.5)
    local nextSelectionY = top + selectionTop + (selectionHeight*0.6)
    if target:getRowAtCoordinate( realSelectionY ) then
        index = target:getRowAtCoordinate( realSelectionY ).index
    end
    if target:getRowAtCoordinate( nextSelectionY ) then
    	-- If the picker stops exactly between two selections then land on the one below
    	index = target:getRowAtCoordinate( nextSelectionY ).index
    end
    
    --If there is an index, scroll to it to give the impression of soft landing
    if index then
        target:scrollToIndex( index, 400 )
    end
end

-- get selection values of pickerWheel columns (returns table)
local function getValues( self )    -- self == pickerWheel
    local columnValues = {}
    local columns = self.columns
    local top = self.y
    local selectionTop = self.selectionTop or 255
    local selectionHeight = self.selectionHeight or 46
    
    --print( selectionTop)
                    
    for i=1,columns.numChildren do
        local col = columns[i]
        local realSelectionY = top + selectionTop + (selectionHeight*0.5)
        local row = col:getRowAtCoordinate( realSelectionY )
                    
        if row and row.value and row.index then
            columnValues[i] = {}
            columnValues[i].value = row.value
            columnValues[i].index = row.index
        end
    end
    
    return columnValues
end


-- creates new pickerWheel column
local function newPickerColumn( pickerWheel, parentGroup, columnData, params, newTableView )
    local column = newTableView( params, pickerFriction )
    
    -- create individual 'rows' for the column
    for i=1,#columnData do
        local labelX = 14
        local ref = display.CenterLeftReferencePoint
        
        if columnData.alignment and columnData.alignment ~= "left" then
            if columnData.alignment == "center" then
                labelX = params.width * 0.5
                ref = display.CenterReferencePoint
            elseif columnData.alignment == "right" then
                labelX = params.width - 14
                ref = display.CenterRightReferencePoint
            end
        end
        
        local function renderRow( event )
            local row = event.row
            local view = event.view
            local fc = params.fontColor
            
            local label = display.newText( columnData[i], 0, 0, params.font, params.fontSize )
            label:setTextColor( fc[1], fc[2], fc[3], fc[4] )
            label:setReferencePoint( ref )
            label.x = labelX
            label.y = row.height * 0.5
            
            row.value = columnData[i]
            view:insert( label )
        end
        
        
        column:insertRow{
            onRender = renderRow,
            width = params.width,
            height = params.rowHeight or 32,
            rowColor = params.bgColor or { 255, 255, 255, 255 },
            lineColor = params.bgColor or { 255, 255, 255, 255 },
            skipRender = true,
        }
    end
    
    parentGroup:insert( column )
    
    return column
end

-- subclassed removeSelf method for pickerWheel
local function removeSelf( self )   -- self == pickerWheel
    -- check to see if there is a clean method; if so, call it
    if self.clean then self:clean(); end
    
    -- remove mask if it exists
    if self.mask then
        self.columns:setMask( nil )
        self.mask = nil
    end
    
    -- remove each column one by one
    for i=self.columns.numChildren,1,-1 do
        self.columns[i]:removeSelf()
    end
    self.columns = nil
            
    -- remove pickerWheel widget
    self:cached_removeSelf()
end

function m.createPickerWheel( options, themeOptions )
    local options = options or {}
    local theme = themeOptions or {}

    -- parse parameters (options) or set defaults (or theme defaults)
    local id = options.id or "widget_pickerWheel"
    local left = options.left or 0
    local top = options.top or 0
    local width = options.width or theme.width or 296
    local height = options.height or theme.height or 222
    local bgWidth = options.bgWidth or options.totalWidth or theme.bgWidth or theme.totalWidth or display.contentWidth
    local selectionTop = options.selectionTop or theme.selectionTop or 90
    local selectionHeight = options.selectionHeight or theme.selectionHeight or 46
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
    local bgImage = options.bgImage or options.background or theme.bgImage or theme.background
    local bgImageWidth = options.bgImageWidth or options.backgroundWidth or theme.bgImageWidth or theme.backgroundWidth
    local bgImageHeight = options.bgImageHeight or options.backgroundHeight or theme.bgImageHeight or theme.backgroundHeight or height
    local overlayImage = options.overlayImage or options.glassFile or theme.overlayImage or theme.glassFile
    local overlayWidth = options.overlayWidth or options.glassWidth or theme.overlayWidth or theme.glassWidth
    local overlayHeight = options.overlayHeight or options.glassHeight or theme.overlayHeight or theme.glassHeight
    local separator = options.separator or theme.separator
    local separatorWidth = options.separatorWidth or theme.separatorWidth
    local separatorHeight = options.separatorHeight or theme.separatorHeight
    local baseDir = options.baseDir or theme.baseDir or system.ResourceDirectory
    
    local pickerWheel = display.newGroup()
    local columnGroup = display.newGroup()  -- will hold all column groups (tableViews)
    
    -- create background image
    if bgImage then
        local bg = display.newImageRect( pickerWheel, bgImage, baseDir, bgImageWidth, bgImageHeight )
        bg:setReferencePoint( display.TopLeftReferencePoint )
        bg.x, bg.y = 0, 0
        bg.xScale = bgWidth / bg.contentWidth
        
        local function disableTouchLeak() return true; end
        bg.touch = disableTouchLeak
        bg:addEventListener( "touch", bg )
    end
    
    -- insert the columns group into the pickerWheel widget group
    pickerWheel:insert( columnGroup )
    columnGroup.x = (bgWidth * 0.5) - width * 0.5
    columnGroup.y = 0
    
    local currentX = 0  -- variable that used for x-location of each column
    
    -- create all columns
    for i=1,#columns do
        local col = columns[i]
        
        -- set up tableView options (each column is a tableView widget)
        local params = {}
        -- tableView specific parameters
        params.id = "pickerColumn_" .. i
        params.renderThresh = (height - selectionTop) + selectionHeight
        params.left = 0
        params.top = 0
        params.topPadding = selectionTop
        params.bottomPadding = height - (selectionTop+selectionHeight)
        params.width = col.width or width/#columns
        params.height = height
        params.bgColor = columnColor
        params.friction = pickerFriction
        params.keepRowsPastTopVisible = true
        params.hideScrollBar = true
        
        --Used for controlling the pickers softlanding
        params.selectionHeight = selectionHeight
        params.isPicker = true
        params.pickerTop = top
        
        -- if last column, ensure width fills remaining space
        if i == #columns then params.width = width - currentX; end
        
        -- picker-specific parameters
        params.rowHeight = selectionHeight
        params.font = font
        params.fontSize = fontSize
        params.fontColor = fontColor
        
        -- create line separator that goes between the rows
        local separatorLine
        if separator and i ~= #columns then
            separatorLine = display.newImageRect( pickerWheel, separator, baseDir, separatorWidth, separatorHeight )
            separatorLine:setReferencePoint( display.TopLeftReferencePoint )
            separatorLine.x = (currentX + params.width) + columnGroup.x
            separatorLine.y = 0
            separatorLine.yScale = height / separatorLine.height
        end
        
        -- create the column
        local pickerColumn = newPickerColumn( pickerWheel, columnGroup, col, params, require( "widget_tableview" ).createTableView )
        pickerColumn.x = currentX
        if #col <= 2 then pickerColumn.content.shortList = true; end
        
        currentX = currentX + params.width
        
        -- scroll to startIndex if specified
        if col.startIndex and col.startIndex > 1 then
            pickerColumn:scrollToIndex( col.startIndex )
        else
            pickerColumn:scrollToIndex( 1 )
        end
    end
    
    -- apply mask to columnGroup
    if maskFile then
        pickerWheel.mask = graphics.newMask( maskFile )
        columnGroup:setMask( pickerWheel.mask )
        columnGroup.maskX = columnGroup.width * 0.5
        columnGroup.maskY = height * 0.5
        columnGroup.isHitTestMasked = false
    end
    
    -- create overlay to go above columns
    if overlayImage then
        local overlay
        if overlayWidth and overlayHeight then
            overlay = display.newImageRect( pickerWheel, overlayImage, overlayWidth, overlayHeight )
        else
            overlay = display.newImage( pickerWheel, overlayImage, true )
        end
        overlay:setReferencePoint( display.CenterReferencePoint )
        overlay.x = bgWidth * 0.5
        overlay.y = height * 0.5
    end
    
    -- properties and methods
    pickerWheel._isWidget = true
    pickerWheel._isPicker = true
    pickerWheel.id = id
    pickerWheel.columns = columnGroup
    pickerWheel.getValues = getValues
    pickerWheel.selectionTop = selectionTop
    pickerWheel.cached_removeSelf = pickerWheel.removeSelf
    pickerWheel.removeSelf = removeSelf
    
    -- position the widget
    pickerWheel.x, pickerWheel.y = left, top
    
    return pickerWheel
end

return m