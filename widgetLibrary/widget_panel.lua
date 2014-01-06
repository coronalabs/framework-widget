
local M = 
{
    _options = {},
    _widgetName = "widget.newPanel",
}


-- Require needed widget files
local _widget = require( "widget" )

-- define a default color set for both graphics modes
local panelDefault = {  0, 0, 0 }

local shapeStrokeDefault = {  0, 0, 0 };
local shapeFillDefault = { 0.8, 0.8, 0.8  };


-- Function to handle touches on a widget panel, function is common to all widget panel creation types (ie image files, imagesheet, and 9 slice panel creation)
local function managePanelTouch( view, event )
    local phase = event.phase
    
    -- If the panel isn't active, just return
    if not view._isEnabled then
        return
    end
    
    if "began" == phase then				
        -- Create the alpha fade if ios7
        
        -- If there is a onPress method ( and not a onEvent method )
        if view._onPress and not view._onEvent then
            view._onPress( event )
        end
        
        -- If the parent group still exists
        if "table" == type( view.parent ) then
            -- Set focus on the panel
            view._isFocus = true
            display.getCurrentStage():setFocus( view, event.id )
            
        end
        
    elseif view._isFocus then
        if "moved" == phase then
            if not _widget._isWithinBounds( view, event ) then
                
                
            else
                
            end
            
        elseif "ended" == phase or "cancelled" == phase then
            if _widget._isWithinBounds( view, event ) then
                -- If there is a onRelease method ( and not a onEvent method )
                if view._onRelease and not view._onEvent then
                    view._onRelease( event )
                end
            end
            
            -- Remove focus from the panel
            view._isFocus = false
            display.getCurrentStage():setFocus( nil )
        end
    end
    
    -- If there is a onEvent method ( and not a onPress or onRelease method )
    if view._onEvent and not view._onPress and not view._onRelease then
        if not _widget._isWithinBounds( view, event ) and "ended" == phase then
            event.phase = "cancelled"
            
        end
        
        view._onEvent( event )
    end
end


------------------------------------------------------------------------
-- Text only panel
------------------------------------------------------------------------
local function createUsingText( panel, options )
    -- Create a local reference to our options table
    local opt = options
    
    -- Forward references
    local view
    local rect = nil;
    local shape = opt.shape;
    if shape then	
        
        rect = display.newRoundedRect( panel, panel.x, panel.y, opt.width , opt.height , shape.cornerRadius);
        rect.strokeWidth = shape.strokeWidth or 1;
        rect:setStrokeColor(unpack(shape.strokeColor));
        rect:setFillColor(unpack(shape.fillColor));
    end
    local viewLabel;
    -- Create the label (either embossed or standard)
    if opt.embossedLabel then
        viewLabel = display.newEmbossedText( panel, opt.label, 0, 0, opt.font, opt.fontSize )
    else
        viewLabel = display.newText( panel, opt.label, 0, 0, opt.font, opt.fontSize )
    end
    
    if rect then
        view = rect;
        view._shapeColor = shape.fillColor;
        view._strokeColor = shape.strokeColor;
        view._label = viewLabel;
        
    else
        view = viewLabel;
    end
    viewLabel:setFillColor( unpack( opt.labelColor) )
    view._labelColor = opt.labelColor
    
    ----------------------------------
    -- Positioning
    ----------------------------------
    
    -- Labels position
    if "center" == opt.labelAlign then
        viewLabel.x = view.x + opt.labelXOffset
    elseif "left" == opt.labelAlign then
        viewLabel.x = view.x - ( view.contentWidth * 0.5 ) + ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    elseif "right" == opt.labelAlign then
        viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    end
    
    
    if "center" == opt.labelAlignY then
        viewLabel.y = view.y + opt.labelYOffset
    elseif "top" == opt.labelAlignY then
        viewLabel.y = view.y - ( view.contentHeight * 0.5 ) + ( viewLabel.contentHeight * 0.5 ) + opt.labelYOffset
    elseif "bottom" == opt.labelAlignY then
        
        viewLabel.y = view.y + ( view.contentHeight * 0.5 ) - ( viewLabel.contentHeight * 0.5 )  + opt.labelYOffset
    end
    
    
    -------------------------------------------------------
    -- Assign properties/objects to the view
    -------------------------------------------------------
    
    view._isEnabled = opt.isEnabled
    viewLabel._fontSize = opt.fontSize
    viewLabel._labelColor = view._labelColor
    
    -- Methods
    view._onPress = opt.onPress
    view._onRelease = opt.onRelease
    view._onEvent = opt.onEvent
    
    -------------------------------------------------------
    -- Assign properties/objects to the panel
    -------------------------------------------------------
    
    -- Assign objects to the panel
    panel._view = view
    
    ----------------------------------------------------------
    --	PUBLIC METHODS	
    ----------------------------------------------------------
    
    -- Function to set the panels text color
    function panel:setFillColor( ... )
	if self._label then
            self._view._label:setFillColor( ... )
        else  
            self._view:setFillColor( ... )
        end;
    end
    
    -- Function to set the panel's label
    function panel:setLabel( newLabel )
        return self._view:_setLabel( newLabel )
    end
    
    -- Function to get the panel's label
    function panel:getLabel()
        return self._view:_getLabel()
    end
    
    -- Function to set a panel as active
    function panel:setEnabled( isEnabled )
        self._view._isEnabled = isEnabled
    end
    
    -- Touch listener for our panel
    function view:touch( event )
        -- Set the target to the view's parent group (the panel object)
        event.target = self.parent
        
        -- Manage touch events on the panel
        managePanelTouch( self, event )
        
        return true
    end
    
    view:addEventListener( "touch" )
    
    ----------------------------------------------------------
    --	PRIVATE METHODS	
    ----------------------------------------------------------
    
    -- Function to set the panel's label
    function view:_setLabel( newLabel )
        -- Update the label's text
        if "function" == type( self.setText ) or self._label then
            if self._label then
                self._label:setText( newLabel )
            else  
                self:setText( newLabel )
            end  
        else
            self.text = newLabel
        end
    end
    
    -- Function to get the panel's label
    function view:_getLabel()
        return self._label.text
    end
    
    
    -- Finalize function
    function panel:_finalize()
    end
    
    return panel
end


------------------------------------------------------------------------
-- Image Files Panel
------------------------------------------------------------------------

-- Creates a new panel from single png images
local function createUsingImageFiles( panel, options )
    -- Create a local reference to our options table
    local opt = options
    
    -- Forward references
    local view,  viewLabel
    
    -- Create the view
    if opt.width and opt.height then
        view = display.newImageRect( panel, opt.defaultFile, opt.baseDir, opt.width, opt.height )
    else
        view = display.newImage( panel, opt.defaultFile, opt.baseDir )
    end
    
    
    -- Create the label (either embossed or standard)
    if opt.embossedLabel then
        viewLabel = display.newEmbossedText( panel, opt.label, 0, 0, opt.font, opt.fontSize )
    else
        viewLabel = display.newText( panel, opt.label, 0, 0, opt.font, opt.fontSize )
    end
    
    ----------------------------------
    -- Positioning
    ----------------------------------
    
    -- The view
    view.x = panel.x + ( view.contentWidth * 0.5 )
    view.y = panel.y + ( view.contentHeight * 0.5 )
    
    
    -- Setup the label
    viewLabel:setFillColor( unpack( opt.labelColor) )
    viewLabel._isLabel = true
    viewLabel._labelColor = opt.labelColor
    
    
        -- Labels position
    if "center" == opt.labelAlign then
        viewLabel.x = view.x + opt.labelXOffset
    elseif "left" == opt.labelAlign then
        viewLabel.x = view.x - ( view.contentWidth * 0.5 ) + ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    elseif "right" == opt.labelAlign then
        viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    end
    
    
    if "center" == opt.labelAlignY then
        viewLabel.y = view.y + opt.labelYOffset
    elseif "top" == opt.labelAlignY then
        viewLabel.y = view.y - ( view.contentHeight * 0.5 ) + ( viewLabel.contentHeight * 0.5 ) + opt.labelYOffset
    elseif "bottom" == opt.labelAlignY then
        
        viewLabel.y = view.y + ( view.contentHeight * 0.5 ) - ( viewLabel.contentHeight * 0.5 )  + opt.labelYOffset
    end
    
    -------------------------------------------------------
    -- Assign properties/objects to the view
    -------------------------------------------------------
    
    view._isEnabled = opt.isEnabled
    view._fontSize = opt.fontSize
    view._label = viewLabel
    view._labelColor = viewLabel._labelColor
    view._labelAlign = opt.labelAlign
    view._labelXOffset = opt.labelXOffset
    view._labelYOffset = opt.labelYOffset
    
    -- Methods
    view._onPress = opt.onPress
    view._onRelease = opt.onRelease
    view._onEvent = opt.onEvent
    
    -------------------------------------------------------
    -- Assign properties/objects to the panel
    -------------------------------------------------------
    
    -- Assign objects to the panel
    panel._view = view
    
    ----------------------------------------------------------
    --	PUBLIC METHODS	
    ----------------------------------------------------------
    
    -- Function to set the panels fill color
    function panel:setFillColor( ... )
        self._view:setFillColor( ... )
        
    end
    
    -- Function to set the panel's label
    function panel:setLabel( newLabel )
        return self._view:_setLabel( newLabel )
    end
    
    -- Function to get the panel's label
    function panel:getLabel()
        return self._view:_getLabel()
    end
    
    -- Function to set a panel as active
    function panel:setEnabled( isEnabled )
        self._view._isEnabled = isEnabled
    end
    
    -- Touch listener for our panel
    function view:touch( event )
        -- Set the target to the view's parent group (the panel object)
        event.target = self.parent
        
        -- Manage touch events on the panel
        managePanelTouch( self, event )
        
        return true
    end
    
    view:addEventListener( "touch" )
    
    ----------------------------------------------------------
    --	PRIVATE METHODS	
    ----------------------------------------------------------
    
    -- Function to set the panel's label
    function view:_setLabel( newLabel )
        -- Update the label's text
        if "function" == type( self._label.setText ) then
            self._label:setText( newLabel )
        else
            self._label.text = newLabel
        end
        
    -- Labels position
    if "center" == opt.labelAlign then
        viewLabel.x = view.x + opt.labelXOffset
    elseif "left" == opt.labelAlign then
        viewLabel.x = view.x - ( view.contentWidth * 0.5 ) + ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    elseif "right" == opt.labelAlign then
        viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    end
    
    
    if "center" == opt.labelAlignY then
        viewLabel.y = view.y + opt.labelYOffset
    elseif "top" == opt.labelAlignY then
        viewLabel.y = view.y - ( view.contentHeight * 0.5 ) + ( viewLabel.contentHeight * 0.5 ) + opt.labelYOffset
    elseif "bottom" == opt.labelAlignY then
        
        viewLabel.y = view.y + ( view.contentHeight * 0.5 ) - ( viewLabel.contentHeight * 0.5 )  + opt.labelYOffset
    end
   
    end
    
    -- Function to get the panel's label
    function view:_getLabel()
        return self._label.text
    end
    
    
    -- Finalize function
    function panel:_finalize()
    end
    
    return panel
end


------------------------------------------------------------------------
-- Image Sheet (2 Frame) Panel
------------------------------------------------------------------------

-- Creates a new panel from a sprite (imageSheet)
local function createUsingImageSheet( panel, options )
    -- Create a local reference to our options table
    local opt = options
    
    -- Animation options
    local sheetOptions = 
    {
        {
            name = "default", 
            start = opt.defaultFrame, 
            count = 1,
        },
    }
    
    -- Forward references
    local view, viewLabel, imageSheet
    
    -- Create a reference to the imageSheet
    imageSheet = opt.sheet
    
    -- Create the view
    view = display.newSprite( panel, imageSheet, sheetOptions )
    
    -- Create the label (either embossed or standard)
    if opt.embossedLabel then
        viewLabel = display.newEmbossedText( panel, opt.label, 0, 0, opt.font, opt.fontSize )
    else
        viewLabel = display.newText( panel, opt.label, 0, 0, opt.font, opt.fontSize )
    end
    
    ----------------------------------
    -- Positioning
    ----------------------------------
    
    -- The view
    view.x = panel.x + ( view.contentWidth * 0.5 )
    view.y = panel.y + ( view.contentHeight * 0.5 )
    
    -- Setup the label
    viewLabel:setFillColor( unpack( opt.labelColor) )
    viewLabel._isLabel = true
    viewLabel._labelColor = opt.labelColor
    
    
    -- Labels position
    if "center" == opt.labelAlign then
        viewLabel.x = view.x + opt.labelXOffset
    elseif "left" == opt.labelAlign then
        viewLabel.x = view.x - ( view.contentWidth * 0.5 ) + ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    elseif "right" == opt.labelAlign then
        viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    end
    
    
    if "center" == opt.labelAlignY then
        viewLabel.y = view.y + opt.labelYOffset
    elseif "top" == opt.labelAlignY then
        viewLabel.y = view.y - ( view.contentHeight * 0.5 ) + ( viewLabel.contentHeight * 0.5 ) + opt.labelYOffset
    elseif "bottom" == opt.labelAlignY then
        
        viewLabel.y = view.y + ( view.contentHeight * 0.5 ) - ( viewLabel.contentHeight * 0.5 )  + opt.labelYOffset
    end
    
    
    -------------------------------------------------------
    -- Assign properties/objects to the view
    -------------------------------------------------------
    
    view._isEnabled = opt.isEnabled
    view._fontSize = opt.fontSize
    view._label = viewLabel
    view._labelColor = viewLabel._labelColor
    view._labelAlign = opt.labelAlign
    
    view._labelXOffset = opt.labelXOffset
    view._labelYOffset = opt.labelYOffset
    
    -- Methods
    view._onPress = opt.onPress
    view._onRelease = opt.onRelease
    view._onEvent = opt.onEvent
    
    -------------------------------------------------------
    -- Assign properties/objects to the panel
    -------------------------------------------------------
    
    -- Assign objects to the panel
    panel._imageSheet = imageSheet
    panel._view = view
    
    ----------------------------------------------------------
    --	PUBLIC METHODS	
    ----------------------------------------------------------
    
    -- Function to set the panels fill color
    function panel:setFillColor( ... )
        self._view:setFillColor( ... )
    end
    
    -- Function to set the panel's label
    function panel:setLabel( newLabel )
        return self._view:_setLabel( newLabel )
    end
    
    -- Function to get the panel's label
    function panel:getLabel()
        return self._view:_getLabel()
    end
    
    -- Function to set a panel as active
    function panel:setEnabled( isEnabled )
        self._view._isEnabled = isEnabled
    end
    
    -- Touch listener for our panel
    function view:touch( event )
        -- Set the target to the view's parent group (the panel object)
        event.target = self.parent
        
        -- Manage touch events on the panel
        managePanelTouch( self, event )
        
        return true
    end
    
    view:addEventListener( "touch" )
    
    ----------------------------------------------------------
    --	PRIVATE METHODS	
    ----------------------------------------------------------
    
    -- Function to set the panel's label
    function view:_setLabel( newLabel )
        -- Update the label's text
        if "function" == type( self._label.setText ) then
            self._label:setText( newLabel )
        else
            self._label.text = newLabel
        end
        
    -- Labels position
    if "center" == opt.labelAlign then
        viewLabel.x = view.x + opt.labelXOffset
    elseif "left" == opt.labelAlign then
        self._label.x = view.x - ( view.contentWidth * 0.5 ) + ( self._label.contentWidth * 0.5 )  + opt.labelXOffset
    elseif "right" == opt.labelAlign then
        self._label.x = view.x + ( view.contentWidth * 0.5 ) - ( self._label.contentWidth * 0.5 )  + opt.labelXOffset
    end
    
    
    if "center" == opt.labelAlignY then
        self._label.y = view.y + opt.labelYOffset
    elseif "top" == opt.labelAlignY then
        self._label.y = view.y - ( view.contentHeight * 0.5 ) + ( self._label.contentHeight * 0.5 ) + opt.labelYOffset
    elseif "bottom" == opt.labelAlignY then
        
        self._label.y = view.y + ( view.contentHeight * 0.5 ) - ( self._label.contentHeight * 0.5 )  + opt.labelYOffset
    end
        
        -- Update the label's y position
        self._label.y = self._label.y
    end
    
    -- Function to get the panel's label
    function view:_getLabel()
        return self._label.text
    end
    
    -- Finalize function
    function panel:_finalize()
        -- Set the ImageSheet to nil
        self._imageSheet = nil
    end
    
    return panel
end


------------------------------------------------------------------------
-- Image Sheet (9 piece/slice) Panel
------------------------------------------------------------------------

-- Creates a new panel from a 9 piece sprite
local function createUsing9Slice( panel, options )
    -- Create a local reference to our options table
    local opt = options
    
    -- Forward references
    local imageSheet, view, viewLabel
    
    local viewTopLeft, viewMiddleLeft, viewBottomLeft
    local viewTopMiddle, viewMiddle, viewBottomMiddle
    local viewTopRight, viewMiddleRight, viewBottomRight
    local viewTopPointer, viewLabelLeft, viewLabelMiddle, viewLabelRight
    
    -- Create the imageSheet
    if opt.sheet then
        imageSheet = opt.sheet
    else
        local themeData = require( opt.themeData )
        imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
    end
    
    -- The view is the panel (group)
    view = panel
    
    -- Imagesheet options
    local sheetOptions =
    {
        -- Top Left 
        viewTopLeft =
        {
            {
                --name = "default",
                start = opt.topLeftFrame,
                count = 1,
            },
            
            
        },
        
        -- Middle Left
        viewMiddleLeft =
        {
            {
                --name = "default",
                start = opt.middleLeftFrame,
                count = 1,
            },
            
        },
        
        -- Bottom Left
        viewBottomLeft =
        {
            {
                --name = "default",
                start = opt.bottomLeftFrame,
                count = 1,
            },
            
        },
        
        -- Top Middle
        viewTopMiddle =
        {
            {
                --name = "default",
                start = opt.topMiddleFrame,
                count = 1,
            },
            
        },
        viewTopPointer=
        {
            {
                --name = "default",
                start = opt.topPointerFrame,
                count = 1,
            },
            
        },
        
        -- Middle
        viewMiddle =
        {
            {
                --name = "default",
                start = opt.middleFrame,
                count = 1,
            },
            
        },
        
        -- Bottom Middle
        viewBottomMiddle =
        {
            {
                --name = "default",
                start = opt.bottomMiddleFrame,
                count = 1,
            },
            
        },
        
        
        -- Top Right
        viewTopRight =
        {
            {
                --name = "default",
                start = opt.topRightFrame,
                count = 1,
            },
            
        },
        
        -- Middle Right
        viewMiddleRight =
        {
            {
                --name = "default",
                start = opt.middleRightFrame,
                count = 1,
            },
            
        },
        
        -- Bottom Right
        viewBottomRight =
        {
            {
                --name = "default",
                start = opt.bottomRightFrame,
                count = 1,
            },
            
        },
    }
    
    
    -- Create the left portion of the panel
    viewTopLeft = display.newSprite( panel, imageSheet, sheetOptions.viewTopLeft )
    viewMiddleLeft = display.newSprite( panel, imageSheet, sheetOptions.viewMiddleLeft )
    viewBottomLeft = display.newSprite( panel, imageSheet, sheetOptions.viewBottomLeft )
    
    -- Create the right portion of the panel
    viewTopRight = display.newSprite( panel, imageSheet, sheetOptions.viewTopRight )
    viewMiddleRight = display.newSprite( panel, imageSheet, sheetOptions.viewMiddleRight )
    viewBottomRight = display.newSprite( panel, imageSheet, sheetOptions.viewBottomRight )
    
    -- Create the middle portion of the panel
    viewTopMiddle = display.newSprite( panel, imageSheet, sheetOptions.viewTopMiddle )
    if opt.pointerX then
        viewTopMiddle2 = display.newSprite( panel, imageSheet, sheetOptions.viewTopMiddle )
        viewPointer = display.newSprite( panel, imageSheet, sheetOptions.viewTopPointer )
    end
    viewMiddle = display.newSprite( panel, imageSheet, sheetOptions.viewMiddle )
    viewBottomMiddle = display.newSprite( panel, imageSheet, sheetOptions.viewBottomMiddle )
    
    -- Create the label (either embossed or standard)
    if opt.embossedLabel then
        viewLabel = display.newEmbossedText( panel, opt.label, 0, 0, opt.font, opt.fontSize )
    else
        viewLabel = display.newText( panel, opt.label, 0, 0, opt.font, opt.fontSize )
    end
    
    ----------------------------------
    -- Positioning
    ----------------------------------
    
    -- Top
    viewTopLeft.x = panel.x + ( viewTopLeft.contentWidth * 0.5 )
    viewTopLeft.y = panel.y + ( viewTopLeft.contentHeight * 0.5 )
    local middleWidth = opt.width - ( viewTopLeft.contentWidth + viewTopRight.contentWidth );
    
    if opt.pointerX then
        viewPointer.x = panel.x + opt.pointerX;
        viewPointer.y = viewPointer.contentHeight / 2
        viewTopMiddle.width = math.max(opt.pointerX - viewTopLeft.contentWidth - viewPointer.contentWidth / 2,
                                        viewTopMiddle.contentWidth);

        
        viewTopMiddle2.width = opt.width - viewTopRight.contentWidth  - viewTopLeft.contentWidth - 
                               viewPointer.contentHeight -  viewTopMiddle.width;
                               
        viewTopMiddle2.x = viewPointer.x + viewPointer.contentWidth / 2 + viewTopMiddle2.contentWidth / 2;
        viewTopMiddle2.y = viewTopMiddle2.contentHeight / 2;
    else
    
        viewTopMiddle.width = middleWidth 
    end
    viewTopMiddle.y = viewTopMiddle.contentHeight / 2;
    viewTopMiddle.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewTopMiddle.contentWidth * 0.5 )
    viewTopRight.x = panel.x + opt.width - ( viewTopRight.contentWidth * 0.5 )
    viewTopRight.y = viewTopLeft.y
    
    -- Middle
    viewMiddleLeft.height = opt.height - ( viewTopLeft.contentHeight + viewTopRight.contentHeight )
    viewMiddleLeft.x = viewTopLeft.x
    viewMiddleLeft.y = viewTopLeft.y + ( viewMiddleLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )
    
    
    viewMiddle.width = middleWidth
    viewMiddle.height = opt.height - ( viewTopLeft.contentHeight + ( viewTopRight.contentHeight ) )
    viewMiddle.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + (viewMiddle.contentWidth * 0.5 )
    viewMiddle.y = viewTopMiddle.contentHeight  + ( viewMiddle.contentHeight * 0.5 )
    
    viewMiddleRight.height = opt.height - ( viewTopLeft.contentHeight + viewTopRight.contentHeight )
    viewMiddleRight.x = viewTopRight.x
    viewMiddleRight.y = viewTopRight.y + ( viewMiddleRight.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
    
    -- Bottom
    viewBottomLeft.x = viewTopLeft.x
    viewBottomLeft.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )
    
    viewBottomMiddle.width = middleWidth
    viewBottomMiddle.x = viewBottomLeft.x + ( viewBottomLeft.contentWidth * 0.5 ) + ( viewBottomMiddle.contentWidth * 0.5 )
    viewBottomMiddle.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 ) + ( viewBottomMiddle.contentHeight * 0.5 )
    
    viewBottomRight.x = viewTopRight.x
    viewBottomRight.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
    
    -- If the passed width is less than the topLeft & top right width then don't use the middle pieces
    if opt.width <= ( viewTopLeft.contentWidth + viewTopRight.contentWidth ) then
        -- Hide the middle slices
        viewTopMiddle.isVisible = false
        viewMiddle.isVisible = false
        viewBottomMiddle.isVisible = false
        viewTopMiddle2.isVisible = false
        viewPointer.isVisible = false
        -- Re-position slices
        viewTopRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
        viewMiddleRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
        viewBottomRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
    end
    
    -- If the passed height is less than the topLeft & top right height then don't use the middle pieces
    if opt.height <= ( viewTopLeft.contentHeight + viewTopRight.contentHeight ) then
        if opt.width <= ( viewTopLeft.contentWidth + viewTopRight.contentWidth )  then
            -- Hide the middle slices
            viewMiddleRight.isVisible = false
            viewMiddleLeft.isVisible = false
            viewMiddle.isVisible = false
            viewTopMiddle.isVisible = false
            viewTopMiddle2.isVisible = false
            viewPointer.isVisible = false
            viewBottomMiddle.isVisible = false
            
            -- Re-position slices
            viewTopRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewTopRight.contentWidth * 0.5 )
            viewBottomLeft.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )		
            viewBottomRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewTopRight.contentWidth * 0.5 )
            viewBottomRight.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
            
        else
            -- Hide the middle slices
            viewMiddle.isVisible = false
            viewMiddleRight.isVisible = false
            viewMiddleLeft.isVisible = false
            
            -- Re-position slices
            viewBottomLeft.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )
            viewBottomMiddle.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )			
            viewBottomRight.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
            
        end
    end
    
    -- Setup the Label
    viewLabel:setFillColor( unpack( opt.labelColor ) )
    viewLabel._isLabel = true
    viewLabel._labelColor = opt.labelColor
    
    
    -- Labels position
    if "center" == opt.labelAlign then
        viewLabel.x = view.x + ( opt.width * 0.5 ) + opt.labelXOffset
    elseif "left" == opt.labelAlign then
        viewLabel.x = view.x - ( opt.width * 0.5 ) + ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    elseif "right" == opt.labelAlign then
        viewLabel.x = view.x + ( opt.width * 0.5 ) - ( viewLabel.contentWidth * 0.5 )  + opt.labelXOffset
    end
    
    
    if "center" == opt.labelAlignY then
        viewLabel.y = view.y + opt.height / 2 + opt.labelYOffset
    elseif "top" == opt.labelAlignY then
        viewLabel.y = view.y + ( viewLabel.contentHeight * 0.5 ) + opt.labelYOffset
    elseif "bottom" == view.y + viewLabel.contentHeight -viewLabel.contentWidth * 0.5 -opt.labelAlignY then
        
        viewLabel.y = view.y + ( view.contentHeight * 0.5 ) - ( viewLabel.contentHeight * 0.5 )  + opt.labelYOffset
    end
    
    -- The label's y position
    local minHeight = opt.height
    if opt.height < 30 then
        minHeight = 30
    end
    
    
    -------------------------------------------------------
    -- Assign properties/objects to the view
    -------------------------------------------------------
    
    view._isEnabled = opt.isEnabled
    view._width = opt.width
    view._fontSize = opt.fontSize
    view._labelAlign = opt.labelAlign
    view._labelXOffset = opt.labelXOffset
    view._labelYOffset = opt.labelYOffset
    view._label = viewLabel
    
    -- Methods
    view._onPress = opt.onPress
    view._onRelease = opt.onRelease
    view._onEvent = opt.onEvent
    
    -------------------------------------------------------
    -- Assign properties/objects to the panel
    -------------------------------------------------------
    
    -- Assign objects to the panel
    panel._imageSheet = imageSheet
    panel._view = view
    
    ----------------------------------------------------------
    --	PUBLIC METHODS	
    ----------------------------------------------------------
    
    -- Function to set the panels fill color
    function panel:setFillColor( ... )		
        for i = self.numChildren, 1, -1 do
            if "function" == type( self[i].setFillColor ) then
                self[i]:setFillColor( ... )
            end
        end
    end
    
    -- Function to set the panel's label
    function panel:setLabel( newLabel )
        return self._view:_setLabel( newLabel )
    end
    
    -- Function to get the panel's label
    function panel:getLabel()
        return self._view:_getLabel()
    end
    
    -- Function to set a panel as active
    function panel:setEnabled( isEnabled )
        self._view._isEnabled = isEnabled
    end
    
    -- Touch listener for our panel
    function view:touch( event )
        -- Manage touch events on the panel
        managePanelTouch( self, event )
        
        return true
    end
    
    view:addEventListener( "touch" )
    
    ----------------------------------------------------------
    --	PRIVATE METHODS	
    ----------------------------------------------------------
    
    -- Function to set the panel's label
    function view:_setLabel( newLabel )
        if "function" == type( self._label.setText ) then
            self._label:setText( newLabel )
        else
            self._label.text = newLabel
        end
        
    -- Labels position
    if "center" == opt.labelAlign then
        self._label.x = view.x + opt.labelXOffset
    elseif "left" == opt.labelAlign then
        self._label.x = view.x - ( view.contentWidth * 0.5 ) + ( self._label.contentWidth * 0.5 )  + opt.labelXOffset
    elseif "right" == opt.labelAlign then
        self._label.x = view.x + ( view.contentWidth * 0.5 ) - ( self._label.contentWidth * 0.5 )  + opt.labelXOffset
    end
    
    
    if "center" == opt.labelAlignY then
        self._label.y = view.y + opt.labelYOffset
    elseif "top" == opt.labelAlignY then
        self._label.y = view.y - ( view.contentHeight * 0.5 ) + ( self._label.contentHeight * 0.5 ) + opt.labelYOffset
    elseif "bottom" == opt.labelAlignY then
        
        self._label.y = view.y + ( view.contentHeight * 0.5 ) - ( self._label.contentHeight * 0.5 )  + opt.labelYOffset
    end
    end
    
    -- Function to get the panel's label
    function view:_getLabel()
        return self._label.text
    end
    
    -- Finalize function
    function panel:_finalize()
        -- Set the ImageSheet to nil
        self._imageSheet = nil
    end
    
    return panel
end


-- Function to create a new panel object ( widget.newPanel )
function M.new( options, theme )	
    local customOptions = options or {}
    local themeOptions = theme or {}
    
    -- Create a local reference to our options table
    local opt = M._options
    
    -- Check if the requirements for creating a widget has been met (throws an error if not)
    _widget._checkRequirements( customOptions, themeOptions, M._widgetName )
    
    -------------------------------------------------------
    -- Properties
    -------------------------------------------------------
    
    -- Positioning & properties
    opt.left = customOptions.left or 0
    opt.top = customOptions.top or 0
    opt.x = customOptions.x or nil
    opt.y = customOptions.y or nil
    if customOptions.x and customOptions.y then
        opt.left = 0
        opt.top = 0
    end
    opt.width = customOptions.width or themeOptions.width
    opt.height = customOptions.height or themeOptions.height
    opt.id = customOptions.id
    opt.baseDir = customOptions.baseDir or system.ResourceDirectory
    opt.label = customOptions.label or ""
    opt.labelColor = customOptions.labelColor or panelDefault	
    opt.font = customOptions.font or themeOptions.font or native.systemFont
    opt.fontSize = customOptions.fontSize or themeOptions.fontSize or 14
    
    if _widget.isSeven() then
        opt.font = customOptions.font or themeOptions.font or "HelveticaNeue-Light"
        opt.fontSize = customOptions.fontSize or themeOptions.fontSize or 17
        opt.labelColor = customOptions.labelColor or themeOptions.labelColor or panelDefault
    end
    
    opt.labelAlign = customOptions.labelAlign or "center"
    opt.labelAlignY = customOptions.labelAlignY or "center"
    opt.labelXOffset = customOptions.labelXOffset or 0
    opt.labelYOffset = customOptions.labelYOffset or 0
    opt.embossedLabel = customOptions.emboss or themeOptions.emboss or false
    opt.isEnabled = customOptions.isEnabled
    opt.textOnlyPanel = customOptions.textOnly or false
    opt.pointerX = customOptions.pointerX or nil;
    
    opt.shape = customOptions.shape or nil;
    if opt.shape then
        
        opt.shape.cornerRadius = opt.shape.cornerRadius or 0;
        opt.shape.strokeWidth = opt.shape.strokeWidth or 1;
        opt.shape.strokeColor = opt.shape.strokeColor or shapeStrokeDefault;
        opt.shape.fillColor = opt.shape.fillColor or shapeFillDefault;
    end;  
    
    -- If the user didn't pass in a isEnabled flag, set it to true
    if nil == opt.isEnabled then
        opt.isEnabled = true
    end
    
    opt.onPress = customOptions.onPress
    opt.onRelease = customOptions.onRelease
    opt.onEvent = customOptions.onEvent
    
    -- Frames & Images
    opt.sheet = customOptions.sheet
    opt.themeSheetFile = themeOptions.sheet
    opt.themeData = themeOptions.data
    
    -- Single image files
    opt.defaultFile = customOptions.defaultFile
    
    if opt.defaultFile  then
        opt.width = customOptions.width
        opt.height = customOptions.height
    end 
    
    -- ImageSheet ( 2 frame panel )
    opt.defaultFrame = customOptions.defaultFrame or _widget._getFrameIndex( themeOptions, themeOptions.defaultFrame )
    
    -- Left ( 9 piece set )
    opt.topLeftFrame = customOptions.topLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.topLeftFrame )
    opt.middleLeftFrame = customOptions.middleLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleLeftFrame )
    
    opt.bottomLeftFrame = customOptions.bottomLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomLeftFrame )
    
    -- Right ( 9 piece set )
    opt.topRightFrame = customOptions.topRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.topRightFrame )
    
    opt.middleRightFrame = customOptions.middleRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleRightFrame )
    
    opt.bottomRightFrame = customOptions.bottomRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomRightFrame )
    
    -- Middle ( 9 piece set )
    opt.topMiddleFrame = customOptions.topMiddleFrame or _widget._getFrameIndex( themeOptions, themeOptions.topMiddleFrame )
    opt.topPointerFrame= customOptions.topPointerFrame or _widget._getFrameIndex( themeOptions, themeOptions.topPointerFrame )
    
    opt.middleFrame = customOptions.middleFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleFrame )
    
    opt.bottomMiddleFrame = customOptions.bottomMiddleFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomMiddleFrame )
    
    -- Are we using a nine piece panel?
    local using9PiecePanel = not opt.defaultFrame and not opt.defaultFile and not opt.textOnlyPanel and not opt.shape and opt.topLeftFrame and opt.middleLeftFrame and opt.bottomLeftFrame and 
    opt.topRightFrame and opt.middleRightFrame and opt.bottomRightFrame and
    opt.topMiddleFrame and opt.middleFrame and opt.bottomMiddleFrame 
    
    -- If we are using a 9-piece panel and have not passed in an imageSheet, throw an error
    local isUsingSheet = opt.sheet or opt.themeSheetFile
    
    -- If were using a 9 piece/slice panel and have not passed a width/height
    if using9PiecePanel and not opt.width then
        error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
    elseif using9PiecePanel and not opt.height then
        error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
    end
    
    if using9PiecePanel and not isUsingSheet then
        error( "ERROR: " .. M._widgetName .. ": 9 piece frame or default frame definition expected, got nil", 3 )
    end
    
    -- Are we using a 2 frame panel?
    local using2FramePanel = not using9PiecePanel and opt.defaultFrame
    
    -- If we are using a 2 frame panel and have not passed in an imageSheet, throw an error
    if using2FramePanel and not opt.sheet then
        error( "ERROR: " .. M._widgetName .. ": sheet definition expected, got nil", 3 )
    end
    
    
    -- Turn off theme setting for text emboss if the user isn't using a theme
    if "boolean" == type( customOptions.emboss ) then
        opt.embossedLabel = customOptions.emboss
    end
    
	--[[
	Notes: 
		*) A 9-piece/slice panel is favored over a 2 frame panel.
		*) A 2 frame panel is favored over a 2 file panel.
    --]]
    
    -- Favor nine piece panel over single image panel
    if using9PiecePanel then
        opt.defaultFrame = nil
        
    end
    
    -- Favor 2 frame panel over 2 file panel
    if using2FramePanel then
        opt.defaultFile = nil
        
    end
    
    -------------------------------------------------------
    -- Create the panel
    -------------------------------------------------------
    
    -- Create the panel object
    local panel = _widget._new
    {
        left = opt.left,
        top = opt.top,
        id = opt.id or "widget_panel",
        baseDir = opt.baseDir,
        widgetType = "panel",
    }
    
    -- Create the panel
    if using9PiecePanel then
        -- If we are using a 9 piece panel
        createUsing9Slice( panel, opt )
    else
        -- If using a 2 frame panel
        if using2FramePanel then
            createUsingImageSheet( panel, opt )
        end
        
        -- If using 2 images
        if opt.defaultFile then
            createUsingImageFiles( panel, opt )
        end
        
        -- Text only panel
        if opt.textOnlyPanel or opt.shape then
            createUsingText( panel, opt )
        end
    end
    
    -- Set the panel's position ( set the reference point to center, just to be sure )
    if ( isGraphicsV1 ) then
        panel:setReferencePoint( display.CenterReferencePoint )
    end
    
    local x, y = opt.x, opt.y
    if not opt.x or not opt.y then
        x = opt.left + panel.contentWidth * 0.5
        y = opt.top + panel.contentHeight * 0.5
    end
    panel.x, panel.y = x, y	
    
    return panel
end

return M
