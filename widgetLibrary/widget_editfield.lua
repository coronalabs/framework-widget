local M = 
{
    _options = {},
    _widgetName = "widget.newEditField",
}


local labelDefault = {  0, 0, 0 }


-- Require needed widget files
local _widget = require( "widget" )
local _focusedField = nil;
-- Creates a new edit field from an image
local function initWithImage( editField, options )
    
    local opt = options
    
    -- Forward references
    local imageSheet, view, viewLeft, viewRight, viewMiddle, fieldDescription, viewTextField
    
    local themeData = require( opt.themeData ) 
    -- Create the imageSheet
    if opt.sheet then
        imageSheet = opt.sheet
    else
        imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
    end
    
    -- Create the view
    view = editField
    
    if ( opt.x ) then
        view.x = opt.x
    elseif ( opt.left ) then
        view.x = opt.left + opt.width * 0.5
    end
    if ( opt.y ) then
        view.y = opt.y
    elseif ( opt.top ) then
        view.y = opt.top + opt.height * 0.5
    end
    -- The left edge
    viewLeft = display.newImageRect( editField, imageSheet, opt.leftFrame, opt.edgeWidth, opt.edgeHeight )
    viewLeft.anchorX = 0;
    viewLeft.x = view.x ;
    viewLeft.y = view.y + ( view.contentHeight * 0.5 )    
    
    -- The right edge
    viewRight = display.newImageRect( editField, imageSheet, opt.rightFrame, opt.edgeWidth, opt.edgeHeight )
    viewRight.anchorX = 0;
    
    -- The middle fill
    viewMiddle = display.newImageRect( editField, imageSheet, opt.middleFrame, opt.edgeWidth, opt.edgeHeight )
    viewMiddle.anchorX = 0;
    viewMiddle.width = opt.width - viewLeft.contentWidth - viewRight.contentWidth;
    viewMiddle.x = viewLeft.x + viewLeft.contentWidth 
    viewMiddle.y = viewLeft.y    
    
    viewRight.x = viewMiddle.x + viewMiddle.width;
    viewRight.y = viewLeft.y    
    
    
    --add the widgets
    local widgetsWidthLeft = 0;
    local widgetsWidthRight = 0;
    local widgets = opt.widgets;
    for i = 1,#widgets do
        local widget = widgets[i]
        if widget.imageFrame or widget.style or widget.defaultFile then
            local wgt = nil;
            if widget.kind == "icon" then
                if widget.defaultFile then
                    wgt = display.newImage(widget.defaultFile)
                else
                    wgt = display.newImage(widget.imageSheet or imageSheet, 
                    widget.defaultFrame or themeData:getFrameIndex( opt.themeOptions[ widget.style] ))
                end    
            else
                wgt = _widget.newButton( 
                {sheet = widget.imageSheet or imageSheet,
                    defaultFrame = widget.defaultFrame or themeData:getFrameIndex( opt.themeOptions[ widget.style] ),
                    overFrame   = widget.overFrame or themeData:getFrameIndex( opt.themeOptions[tostring( widget.style).."_over"] ),
                    defaultFile = widget.defaultFile,
                    overFile = widget.overFile,
                    onPress = widget.onPress,
                    onRelease = widget.onRelease
                }
                )
            end    
            editField:insert(wgt)
            if widget.style == "clear" then
                view._clearButton = wgt;
                wgt.isVisible = false;
                
            end
            wgt.y = viewLeft.y + opt.buttonYOffset
            if widget.align == "left" then
                wgt.x = viewLeft.x + viewLeft.contentWidth+ widgetsWidthLeft + ( wgt.contentWidth * 0.5 )+ 
                opt.spacing + opt.buttonXOffset
                widgetsWidthLeft = opt.spacing + wgt.contentWidth + widgetsWidthLeft;
                
            else   
                --by default buttons are right aligned  
                wgt.x = viewRight.x  - widgetsWidthRight - opt.spacing -
                ( wgt.contentWidth * 0.5 ) + opt.buttonXOffset
                widgetsWidthRight = opt.spacing + wgt.contentWidth + widgetsWidthRight;
                
            end
        end   
        
    end
    
    -- create the label if needed
    local textLabelWidth = 0;
    local textLabelX = viewLeft.x + viewLeft.contentWidth;
    editField.label = opt.label;
    editField.placeholder = opt.placeholder;
    -- The label for the field
    if opt.label and opt.hideLabel == false then
        fieldDescription = display.newText( editField, opt.label, 0,0, opt.labelFont, opt.labelFontSize );
        fieldDescription:setFillColor(unpack(opt.labelColor));
        fieldDescription.anchorX = 0;
        fieldDescription.x = viewLeft.x + viewLeft.contentWidth + widgetsWidthLeft ;
        fieldDescription.y = viewLeft.y
        textLabelX = fieldDescription.x;
        textLabelWidth = fieldDescription.contentWidth
    end;   
    
    -- Create the textbox (that is contained within the editField)
    local textFieldWidth = opt.textFieldWidth;
    if textFieldWidth == 0 then
        textFieldWidth = opt.width - widgetsWidthLeft - widgetsWidthRight -opt.textFieldXOffset 
        - textLabelWidth - 2* opt.spacing - viewRight.contentWidth;
    end
    local textFieldHeight = (opt.height - 8) --* fontScale;
    local tHeight = textFieldHeight;
    if "Android" == system.getInfo("platformName") then
        tHeight = tHeight + 10; 
    end
    viewTextField = native.newTextField( -1000, -1000, textFieldWidth,tHeight )
    viewTextField.anchorX = 0;
    editField:insert(viewTextField);
    
    viewTextField.anchorX = 0;
    viewTextField.isEditable = true
    viewTextField.hasBackground = false
    viewTextField.align = "left"
    viewTextField.inputType = opt.inputType;
    viewTextField.isSecure  = opt.isSecure;
    viewTextField:setReturnKey(opt.returnKey);
    
    view._yOriginal = viewLeft.y + opt.textFieldYOffset
    view._xOriginal = textLabelX + textLabelWidth + opt.textFieldXOffset + widgetsWidthLeft 
    local deviceScale = ( display.pixelWidth / display.contentWidth ) * 0.5
    viewTextField.font = native.newFont( opt.editFont )
    viewTextField.size = opt.editFontSize * deviceScale
    
    viewTextField:setTextColor(opt.editFontColor[1]*255, opt.editFontColor[2]*255,
    opt.editFontColor[3]*255, opt.editFontColor[4]*255);	
    
    local fakeTextField = display.newText(editField, "", 0, 0, textFieldWidth-2*opt.fakeLabelShiftX, 
    textFieldHeight - 2* opt.fakeLabelShiftY , opt.editFont, opt.editFontSize)
    fakeTextField.anchorX = 0;
    fakeTextField.x = textLabelX + textLabelWidth + widgetsWidthLeft + opt.fakeLabelShiftX ;
    fakeTextField.y = viewLeft.y + opt.fakeLabelShiftY;
    fakeTextField:setFillColor(unpack(opt.editFontColor));	
    fakeTextField._viewTextField = viewTextField;
    fakeTextField._placeholder = opt.placeholder;
    view._fakeTextField = fakeTextField;
    fakeTextField._view = view;
    viewTextField._view = view;
    
    if ( opt.listener and type(opt.listener) == "function" ) then
        viewTextField._listener = opt.listener
    end
    if (  opt.onSubmit and type(opt.onSubmit) == "function" ) then
        view._onSubmit = opt.onSubmit
    end
    
    
    
    view._originalX = viewLeft.x
    view._originalY = viewLeft.y
    view._textField = viewTextField
    view._textLabelX = textLabelX
    view._textLabelWidth = textLabelWidth
    view._submitOnClear = opt.submitOnClear;
    view._maxChars = opt.maxChars;
    
    if "function" == type(opt.onClick) then
        view._onClick = opt.onClick;
    end;    
    
    -------------------------------------------------------
    -- Assign properties/objects to the editField
    -------------------------------------------------------
    
    editField._view = view
    
    local function onClearTap(event)
        local function onClearClicked(event)
            view._clearButton.isVisible = false;
            view:updateFakeContent()
            view._clearClicked = false;
            event.target = editField;
            if view._submitOnClear and view._onSubmit then
                view._onSubmit(event);
            end
            
            
        end
        view._clearClicked = true;
        view._textField.text = "";
        --android async handling of events
        timer.performWithDelay(5, onClearClicked, 1)
        
        return true;
    end
    
    if view._clearButton then
        view._clearButton:addEventListener( "tap" , onClearTap )
    end      
    ----------------------------------------------------------
    --	PUBLIC METHODS	
    ----------------------------------------------------------
    function view:updateFakeContent()
        if self._fakingIt then
            local fakeTextField =  self._fakeTextField; 
            local viewTextField = self._textField;
            local text = viewTextField.text;
            if text:len() > 0 then
                fakeTextField:setFillColor(unpack(opt.editFontColor));
                fakeTextField.text = viewTextField.text;
            else    
                fakeTextField:setFillColor(unpack(opt.editHintColor));
                fakeTextField.text = fakeTextField._placeholder;
            end
        end;     
    end
    
    function view:_swapFakeField( fakeIt )
        
        local fakeTextField =  self._fakeTextField; 
        local viewTextField = self._textField;
        if fakeIt then
            if not self._fakingIt then
                self._fakingIt = true;
                self:updateFakeContent()
                fakeTextField.isVisible = true;
                display.getCurrentStage():insert(viewTextField)
                viewTextField.x = -1000;
                viewTextField.y = -1000;
                
                
            end      
            if false and  self._clearButton and self._clearButton.isVisible then
                self._clearButton.isVisible = false
            end    
        else    
            
            _focusedField = viewTextField;
            self:insert(viewTextField)
            viewTextField.x = self._xOriginal;
            viewTextField.y = self._yOriginal;
            native.setKeyboardFocus( viewTextField )
            fakeTextField.isVisible = false;
            self._fakingIt = false;
            if self._clearButton then
                if viewTextField.text:len() > 0 then
                    self._clearButton.isVisible = true
                else
                    self._clearButton.isVisible = false
                end
            end;
            
        end
        
    end
    
    function fakeTextField:touch(event)
        if "began" == event.phase then  
            if self._view._onClick == nil then
                self._view:_swapFakeField( false )
            else    
                self._view._onClick(event)
            end
        end;  
        return true
    end
    
    
    fakeTextField:addEventListener( "touch" )
    view._fakingIt = false;
    view:_swapFakeField( true )
    
    
    -- Function to listen for textbox events
    function viewTextField:_inputListener( event )
        local function onHideField(event)
            
        end
        
        local phase = event.phase
        local view = self._view;
        if "editing" == phase then
            -- If there is one or more characters in the textField show the cancel button, if not hide it
            local sText = view._textField.text; 
            if view._maxChars > 0 then
                if sText:len() > view._maxChars then
                    view._textField.text = string.sub(sText, 1, view._maxChars)
                end 
            end
            if view._clearButton then
                if sText:len() > 0 then
                    view._clearButton.isVisible = true
                else
                    view._clearButton.isVisible = false
                end
            end;    
            
        elseif "submitted" == phase or 
            "ended" == phase then
            -- Hide keyboard
            if _focusedField == nil or _focusedField == self then
                native.setKeyboardFocus( nil )
            end;   
            _focusedField = nil;
            view:_swapFakeField( true )
            if view._onSubmit and (view._clearButton == nil or phase == "submitted") then
                event.target = editField;
                view._onSubmit(event);
            end
        end
        
        -- If there is a listener defined, execute it
        if self._listener then
            event.target = editField;
            self._listener( event )
        end
        return true;
    end
    
    viewTextField.userInput = viewTextField._inputListener
    viewTextField:addEventListener( "userInput" )
    
    ----------------------------------------------------------
    --	PRIVATE METHODS	
    ----------------------------------------------------------
    
    function editField:setText(value)
        self._view._textField.text = value 
        self._view:updateFakeContent()
    end
    
    function editField:getText()
        return self._view._textField.text
    end
    
    
    -- Finalize function
    function editField:_finalize()
        -- Remove the textField
        display.remove( self._view._textField )
        
        self._view._textField._view = nil;
        self._view._textField = nil
        self._view._fakeTextField._view = nil;
        self._view._fakeTextField = nil;
        self._view._cancelButton = nil
        
        
        
        self._view = nil
        
        
    end
    
    return editField
end


-- Function to create a new editfield object ( widget.newEditField)
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
    else
        opt.x = opt.left
        opt.y = opt.top
    end    
    opt.width = customOptions.width or 150
    opt.height = customOptions.height or 29
    opt.id = customOptions.id
    opt.baseDir = customOptions.baseDir or system.ResourceDirectory
    opt.placeholder = customOptions.placeholder or "";
    opt.inputType  = customOptions.inputType or "default"
    opt.isSecure    = customOptions.isSecure or false;
    opt.returnKey    = customOptions.returnKey or "done";
    opt.onClick      = customOptions.onClick;
    
    if "Android" == system.getInfo("platformName") then
        opt.textFieldYOffset = customOptions.textFieldYOffset or 4
        opt.textFieldXOffset = customOptions.textFieldXOffset or -5
        opt.fakeLabelShiftY = customOptions.fakeLabelShiftY or 0;
        opt.fakeLabelShiftX = customOptions.fakeLabelShiftX or 4;
    else
        opt.textFieldYOffset = customOptions.textFieldYOffset or -2
        opt.textFieldXOffset = customOptions.textFieldXOffset or 0
        opt.fakeLabelShiftX = customOptions.fakeLabelShiftX or 2;
        opt.fakeLabelShiftY = customOptions.fakeLabelShiftY or 1;
    end
    
    opt.textFieldWidth = customOptions.textFieldWidth or 0;
    opt.listener = customOptions.listener
    opt.onSubmit = customOptions.onSubmit
    opt.submitOnClear = customOptions.submitOnClear or false;
    opt.editFontColor = customOptions.editFontColor or themeOptions.editTextColor or {0,0,0,1}
    opt.editHintColor = customOptions.editHintColor or {0.5,0.5,0.5,1}
    
    
    -- Frames & Images
    opt.sheet = customOptions.sheet
    opt.themeSheetFile = themeOptions.sheet
    opt.themeData = themeOptions.data
    opt.themeOptions = themeOptions
    opt.label = customOptions.label
    opt.hideLabel = customOptions.hideLabel or false;
    opt.labelColor = customOptions.labelColor or labelDefault	
    opt.labelFont = customOptions.labelFont or themeOptions.font or native.systemFont
    opt.labelFontSize = customOptions.labelFontSize or themeOptions.fontSize or 14
    opt.spacing = customOptions.spacing or 5;    
    opt.widgets = customOptions.widgets or {};
    opt.listButton = customOptions.listButton or false;
    opt.maxChars = customOptions.maxChars or 0;
    opt.buttonXOffset = customOptions.buttonXOffset or 0
    opt.buttonYOffset = customOptions.buttonYOffset or 0
    
    opt.editFont = customOptions.editFont or opt.labelFont
    opt.editFontSize = customOptions.editFontSize or opt.labelFontSize
    opt.hasIcon = customOptions.hasIcon or false;
    
    opt.leftFrame = customOptions.leftFrame or _widget._getFrameIndex( themeOptions, themeOptions.leftFrame )
    opt.rightFrame = customOptions.rightFrame or _widget._getFrameIndex( themeOptions, themeOptions.rightFrame )
    opt.middleFrame = customOptions.middleFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleFrame )
    opt.edgeWidth = customOptions.edgeWidth or themeOptions.edgeWidth or error( "ERROR: " .. M._widgetName .. ": edgeFrameWidth expected, got nil", 3 )
    opt.edgeHeight = customOptions.edgeHeight or themeOptions.edgeHeight or error( "ERROR: " .. M._widgetName .. ": edgeFrameHeight expected, got nil", 3 )
    
    -------------------------------------------------------
    -- Create the editField
    -------------------------------------------------------
    
    -- Create the editField object
    local editField = _widget._new
    {
        left = opt.left,
        top = opt.top,
        id = opt.id or "widget_editField",
        baseDir = opt.baseDir,
    }
    
    
    initWithImage( editField, opt )
    
    -- Set the editField's position ( set the reference point to center, just to be sure )
    
    local x, y = opt.x, opt.y
    if not opt.x or not opt.y then
        x = opt.left + editField.contentWidth * 0.5
        y = opt.top + editField.contentHeight * 0.5
    end
    editField.x, editField.y = x, y
    
    return editField
end


return M
