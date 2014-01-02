-- Require needed widget files
local _widget = require( "widget" )
local _storyboard = require("storyboard")
local efDefaults = require("widgets.editfield_defaults")

local M = 
{
    _options = {},
    _widgetName = "widget.newEditField",
}


local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

local labelDefault = {  0, 0, 0 }

local frameStrokeDefault;
if isGraphicsV1 then
    frameStrokeDefault = { 0, 0, 0 }
else
    frameStrokeDefault = { 0, 0, 0 }
end


local frameFillDefault;
if isGraphicsV1 then
    frameFillDefault = {  255, 255, 255}
else
    frameFillDefault = { 1, 1, 1 }
end

local frameErrorStrokeDefault;
if isGraphicsV1 then
    frameErrorStrokeDefault = { .9, 0, 0 }
else
    frameErrorStrokeDefault = { 240, 0, 0 }
end

local frameErrorFillDefault;
if isGraphicsV1 then
    frameErrorFillDefault = { 0, 0, 0, 0 }
else
    frameErrorFillDefault = { 0, 0, 0, 0 }
end



local _focusedField = nil;

local function getKeyboardHeight()
    local function isLandscape()
        return system.orientation == "landscapeLeft" or 
        system.orientation == "landscapeRight"
    end
    
    if  system.getInfo("model") == "iPad" then
        if isLandscape() then
            return 352
        else    
            return 264
        end
    elseif system.getInfo("model") == "iPhone" or
        system.getInfo("model") == "iPod"  then
        if isLandscape() then
            return 162
        else    
            return 216 
        end
        
    else
        --dear android
        return math.min(efDefaults.androidKeyboardHeight, display.contentHeight / 2);
    end
end
-- Creates a new edit field from an image
local function initEditField( editField, options )
    
    local opt = options
    
    
    
    local themeData = require( opt.themeData ) 
    
    local yCenter = opt.height / 2 
    local imageSheet
    
    --default values for start, end
    local xStart = 0;
    local xEnd   =  opt.width 
    local height, width = opt.height, opt.width
    local function create9SliceFrame()
        local viewTopLeft, viewMiddleLeft, viewBottomLeft
	local viewTopMiddle, viewMiddle, viewBottomMiddle
	local viewTopRight, viewMiddleRight, viewBottomRight  
        local sheet
        
        
	local themeData = require( opt.themeData )
        sheet = themeData:getSheet()
	imageSheet = graphics.newImageSheet( opt.themeSheetFile, sheet )
        
        --top left
        local index = themeData:getFrameIndex(opt.themeOptions.topLeftFrame)
        local frame = sheet.frames[index]
        viewTopLeft = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewTopLeft.x = frame.width / 2
        viewTopLeft.y = frame.height / 2
        
        --middle left
        local index = themeData:getFrameIndex(opt.themeOptions.middleLeftFrame)
        local frame = sheet.frames[index]
        viewMiddleLeft = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewMiddleLeft.x = frame.width / 2
        viewMiddleLeft.y =  opt.height / 2
        
        --bottom left
        local index = themeData:getFrameIndex(opt.themeOptions.bottomLeftFrame)
        local frame = sheet.frames[index]
        viewBottomLeft = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewBottomLeft.x = frame.width / 2
        viewBottomLeft.y =  opt.height - frame.height / 2
        viewMiddleLeft.height = viewBottomLeft.y - viewBottomLeft.height / 2 - (viewTopLeft.y + viewTopLeft.height / 2)
        
        --top middle
        local index = themeData:getFrameIndex(opt.themeOptions.topMiddleFrame)
        local frame = sheet.frames[index]
        viewTopMiddle = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewTopMiddle.x =  opt.width / 2
        viewTopMiddle.y = frame.height / 2
        
        --top right
        local index = themeData:getFrameIndex(opt.themeOptions.topRightFrame)
        local frame = sheet.frames[index]
        viewTopRight = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewTopRight.x =  opt.width - frame.width / 2
        viewTopRight.y = frame.height / 2
        viewTopMiddle.width = viewTopRight.x - viewTopRight.width / 2 - (viewTopLeft.x + viewTopLeft.width / 2) 
        
        --middle right
        local index = themeData:getFrameIndex(opt.themeOptions.middleRightFrame)
        local frame = sheet.frames[index]
        viewMiddleRight = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewMiddleRight.x = opt.width - frame.width / 2
        viewMiddleRight.y = opt.height / 2
        
        --bottom right
        local index = themeData:getFrameIndex(opt.themeOptions.bottomRightFrame)
        local frame = sheet.frames[index]
        viewBottomRight = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewBottomRight.x =  opt.width - frame.width / 2
        viewBottomRight.y =  opt.height - frame.height / 2
        viewMiddleRight.height = viewBottomRight.y - viewBottomRight.height / 2 - (viewTopRight.y + viewTopRight.height / 2)
        
        --bottom middle
        local index = themeData:getFrameIndex(opt.themeOptions.bottomMiddleFrame)
        local frame = sheet.frames[index]
        viewBottomMiddle = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewBottomMiddle.x =  opt.width  / 2
        viewBottomMiddle.y =  opt.height  - frame.height / 2
        viewBottomMiddle.width = viewBottomRight.x - viewBottomRight.width / 2 - (viewBottomLeft.x + viewBottomLeft.width / 2) 
        
        --middle
        local index = themeData:getFrameIndex(opt.themeOptions.middleFrame)
        local frame = sheet.frames[index]
        viewMiddle = display.newImageRect( editField, imageSheet, index, frame.width, frame.height )
        viewMiddle.x =  opt.width  / 2
        viewMiddle.y =  opt.height / 2
        viewMiddle.width = viewMiddleRight.x - viewMiddleRight.width / 2 - (viewBottomLeft.x + viewBottomLeft.width / 2) 
        viewMiddle.height = viewBottomMiddle.y - viewBottomMiddle.height / 2 - (viewTopMiddle.y + viewTopMiddle.height / 2)
        
        xStart = viewMiddleLeft.contentWidth ;
        xEnd   = opt.width -  viewMiddleRight.contentWidth ;
        height = opt.height - (viewBottomMiddle.height + viewTopMiddle.height) + 2;
    end
    
    local function create3SliceFrame()
        -- Create the imageSheet
        if opt.sheet then
            imageSheet = opt.sheet
        else
            imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
            
        end
        local viewLeft, viewRight, viewMiddle 
        -- The left edge
        viewLeft = display.newImageRect( editField, imageSheet, opt.leftFrame, opt.edgeWidth, opt.edgeHeight )
        viewLeft.x =  opt.edgeWidth / 2
        viewLeft.y = yCenter
        
        -- The right edge
        viewRight = display.newImageRect( editField, imageSheet, opt.rightFrame, opt.edgeWidth, opt.edgeHeight )
        
        
        -- The middle fill
        viewMiddle = display.newImageRect( editField, imageSheet, opt.middleFrame, opt.edgeWidth, opt.edgeHeight )
        viewMiddle.width = width - viewLeft.contentWidth - viewRight.contentWidth;
        
        viewMiddle.x = viewLeft.x + viewLeft.contentWidth * 0.5 + ( viewMiddle.width * 0.5 )    
        viewMiddle.y = yCenter   
        
        viewRight.x = viewMiddle.x + ( viewMiddle.width * 0.5 ) + viewRight.width * 0.5
        viewRight.y = yCenter    
        
        xStart = viewLeft.x + viewLeft.contentWidth / 2 ;
        xEnd   = viewRight.x - viewRight.contentWidth / 2 ;
        height = opt.height - 2*4 ;
    end
    
    local function createErrorFrame()
        local frame = opt.errorFrame;
        local rect = display.newRoundedRect(editField, width / 2 , height / 2 , width+2 * frame.offset, height +  2 * frame.offset, frame.cornerRadius)
        editField._errorFrame = rect
        rect.strokeWidth = frame.strokeWidth ;
        rect:setStrokeColor(unpack(frame.strokeColor));
        rect:setFillColor(unpack(frameErrorFillDefault));
        xStart = 0;
        xEnd   = opt.width;
        
        rect.isVisible = false;
    end
    
    local function createRectFrame()
        local frame = opt.frame;
        local rect = display.newRoundedRect(editField, opt.width / 2, opt.height / 2, opt.width, opt.height, frame.cornerRadius)
        rect.strokeWidth = frame.strokeWidth ;
        rect:setStrokeColor(unpack(frame.strokeColor));
        rect:setFillColor(unpack(frame.fillColor));
        xStart = math.max(frame.strokeWidth, frame.cornerRadius);
        xEnd   = opt.width - math.max(frame.strokeWidth, frame.cornerRadius);
        height = opt.height - 2*frame.strokeWidth - 2;
    end
    
    --if there is an "validation error" frame, create it and subtract from height/width
    if opt.errorFrame then
        createErrorFrame()
    end
    --create with a rectangle frame or slice frame
    if opt.frame then
        createRectFrame()
    else
        if opt.topLeftFrame and opt.middleLeftFrame and opt.bottomLeftFrame and 
            opt.topRightFrame and opt.middleRightFrame and opt.bottomRightFrame and
            opt.topMiddleFrame and opt.middleFrame and opt.bottomMiddleFrame then
            
            create9SliceFrame()
        else
            create3SliceFrame()
        end    
    end 
    local  fieldDescription, viewTextField
    
    --add the widgets
    local widgetsWidthLeft = 0;
    local widgetsWidthRight = 0;
    local widgets = opt.widgets;
    for i = 1,#widgets do
        local widget = widgets[i]
        if widget.imageFrame or widget.style or widget.defaultFile then
            local wgt = nil;
            if (widget.kind == "icon") or (widget.kind == "clear") then
                if widget.defaultFile then
                    wgt = display.newImage(widget.defaultFile)
                else
                    wgt = display.newImage(widget.imageSheet or imageSheet, 
                    widget.defaultFrame or themeData:getFrameIndex( opt.themeOptions[ widget.style] ))
                end    
                if widget.kind == "clear" then
                    editField._clearButton = wgt;
                    wgt.isVisible = false;
                    
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
            if wgt then
                editField:insert(wgt)
                wgt.y = yCenter + opt.buttonYOffset
                if widget.align == "left" then
                    wgt.x = xStart + widgetsWidthLeft + ( wgt.contentWidth * 0.5 )+ 
                    opt.spacing + opt.buttonXOffset
                    widgetsWidthLeft = opt.spacing + wgt.contentWidth + widgetsWidthLeft;
                    
                else   
                    --by default buttons are right aligned  
                    wgt.x = xEnd  - widgetsWidthRight - opt.spacing -
                    ( wgt.contentWidth * 0.5 ) + opt.buttonXOffset
                    widgetsWidthRight = opt.spacing + wgt.contentWidth + widgetsWidthRight;
                    
                end
            end;    
        end   
        
    end
    -- create the label if needed
    local textLabelWidth = 0;
    local textLabelX = xStart;
    editField.label = opt.label;
    editField.placeholder = opt.placeholder;
    -- The label for the field
    if opt.label and opt.hideLabel == false then
        fieldDescription = display.newText( editField, opt.label, 0,0, opt.labelFont, opt.labelFontSize );
        fieldDescription:setFillColor(unpack(opt.labelColor));
        fieldDescription.anchorX = 0;
        fieldDescription.x = xStart + widgetsWidthLeft + opt.spacing ;
        fieldDescription.y = yCenter + opt.fakeLabelYOffset
        textLabelX = fieldDescription.x;
        textLabelWidth = fieldDescription.contentWidth
    end;   
    -- Create the textbox (that is contained within the editField)
    local textFieldWidth = opt.textFieldWidth;
    if textFieldWidth == 0 then
        textFieldWidth = (xEnd - xStart) - widgetsWidthLeft - widgetsWidthRight -opt.textFieldXOffset 
        - textLabelWidth - 2* opt.spacing;
    end
    --calculate textheight for selected font
    local tmpField = display.newText("W",0,0,opt.editFont,opt.editFontSize)
    local lineHeight = tmpField.contentHeight;
    tmpField:removeSelf();
    editField._xOriginal = textLabelX - opt.textFieldHeightAdjust/2 + textLabelWidth + opt.textFieldXOffset + widgetsWidthLeft 
    editField._yOriginal = yCenter + opt.textFieldHeightAdjust/2 + opt.textFieldYOffset
    if opt.native then
        viewTextField = native.newTextField(editField._xOriginal, editField._yOriginal, textFieldWidth,lineHeight + opt.textFieldHeightAdjust )
        viewTextField.placeholder = opt.placeholder;
    else
        viewTextField = native.newTextField( -1000, -1000, textFieldWidth,lineHeight + opt.textFieldHeightAdjust )
    end    
    
    viewTextField.anchorX = 0;
    editField:insert(viewTextField);
    
    viewTextField.isEditable = true
    viewTextField.hasBackground = false
    viewTextField.align = "left"
    viewTextField.inputType = opt.inputType;
    
    editField.inputType = opt.inputType;
    
    viewTextField.isSecure  = opt.isSecure;
    editField.isSecure = opt.isSecure;
    
    viewTextField:setReturnKey(opt.returnKey);
    editField.returnKey = opt.returnKey;
    
    editField.required = opt.required;
    
    editField.slideGroup = opt.slideGroup
    editField.keyboardSlideTime = opt.keyboardSlideTime
    editField.calibrating = opt.calibrating
    editField.native = opt.native;
    editField.fontScale = opt.fontScale;
    
    viewTextField.font = native.newFont( opt.editFont )
    viewTextField.size = opt.editFontSize * opt.fontScale --deviceScale
    
    viewTextField:setTextColor(opt.editFontColor[1]*255, opt.editFontColor[2]*255,
    opt.editFontColor[3]*255, opt.editFontColor[4]*255);
    local fakeTextField
    if not opt.native then
        fakeTextField = display.newText(editField, "", 0, 0, textFieldWidth, 
        lineHeight, opt.editFont, opt.editFontSize)
        fakeTextField.anchorX = 0;
        fakeTextField.x = textLabelX + textLabelWidth + widgetsWidthLeft + opt.fakeLabelXOffset ;
        fakeTextField.y = yCenter + opt.fakeLabelYOffset ;
        fakeTextField:setFillColor(unpack(opt.editFontColor));	
        fakeTextField._viewTextField = viewTextField;
        fakeTextField._placeholder = opt.placeholder;
        editField._fakeTextField = fakeTextField;
    end;    
    if ( opt.listener and type(opt.listener) == "function" ) then
        viewTextField._listener = opt.listener
    end
    if (  opt.onSubmit and type(opt.onSubmit) == "function" ) then
        editField._onSubmit = opt.onSubmit
    end
    
    editField._textField = viewTextField
    editField._textLabelX = textLabelX
    editField._textLabelWidth = textLabelWidth
    editField.submitOnClear = opt.submitOnClear;
    editField.maxChars = opt.maxChars;
    editField.allowedChars = opt.allowedChars;
    
    viewTextField._editField = editField;
    
    if "function" == type(opt.onClick) then
        editField._onClick = opt.onClick;
    end;    
    
    --add to storyboard list of editFields
    if _storyboard.getCurrentScene then
        local scene = _storyboard.getCurrentScene()
        if scene.addEditField then
            scene.addEditField(editField)
            editField._scene = scene;
        end
        
    end
    
    local function onClearTap(event)
        
        editField._textField.text = "";
        
        editField._clearButton.isVisible = false;
        editField:updateFakeContent("")
        editField._textField._originalText = ""
        event.target = editField;
        if editField.submitOnClear and editField._onSubmit then
            editField._onSubmit(event);
        end
        
        return true;
    end
    
    if editField._clearButton then
        editField._clearButton:addEventListener( "tap" , onClearTap )
    end      
    ----------------------------------------------------------
    --	PUBLIC METHODS	
    ----------------------------------------------------------
    function editField:updateFakeContent(value)
        if self._fakingIt then
            local fakeTextField =  self._fakeTextField; 
            local text = value;
            if text:len() > 0 then
                if not self.calibrating then
                    fakeTextField:setFillColor(unpack(opt.editFontColor));
                else
                    fakeTextField:setFillColor(1,0,0,1);
                    fakeTextField:toFront();
                end    
                if self.isSecure then
                    fakeTextField.text = string.rep("•", string.len(text));
                else    
                    fakeTextField.text = text;
                end    
            else    
                if not self.calibrating then
                    fakeTextField:setFillColor(unpack(opt.editHintColor));
                    fakeTextField.text = fakeTextField._placeholder;
                else
                    fakeTextField:setFillColor(1,0,0,1);
                    fakeTextField:toFront();
                end    
                
            end
        end;     
    end
    
    function editField:slideBackKeyboard()
        local slideGroup = self.slideGroup
        
        if slideGroup then
            --check if we are in a scrollview
            if self == slideGroup._slidingField then
                self:setSlideGroupPosition(slideGroup._originalSlideY)
                slideGroup._slidingField = nil
                slideGroup._originalSlideY = nil
            else
            end
        end      
    end
    
    function editField:getSlideGroupPosition()
        local slideGroup =  self.slideGroup;
        local xGroup, yGroup
        if slideGroup.getContentPosition and slideGroup.scrollToPosition then
            xGroup, yGroup = slideGroup:getContentPosition()  
        else
            yGroup = slideGroup.y;
        end    
        return yGroup
    end
    
    function editField:setSlideGroupPosition(yGroup)
        local slideGroup =  self.slideGroup;
        if slideGroup.getContentPosition and slideGroup.scrollToPosition then
            slideGroup:scrollToPosition({y=yGroup,time = self.keyboardSlideTime})
        else
            transition.to(slideGroup,{y = yGroup,time=self.keyboardSlideTime} )
        end    
    end
    
    function editField:slideForKeyboard(neededHeight)
        local slideGroup =  self.slideGroup;
        if slideGroup  then
            local y = self.y;
            local parent = self.parent;
            while parent and parent.y do
                y = y + parent.y;
                parent = parent.parent
            end
            local yGroup = self:getSlideGroupPosition()
            local groupOffset = 0
            --if the group is already slid up, check difference
            if slideGroup._originalSlideY then
                groupOffset = (slideGroup._originalSlideY - yGroup)
            end
            local top = y - self.contentHeight * self.anchorY + groupOffset; 
            
            
            local kbHeight = neededHeight or getKeyboardHeight();
            local desiredTop = display.contentHeight - kbHeight - self.contentHeight;
            if top > desiredTop   then
                local y = yGroup - (top - desiredTop) + groupOffset
                if not slideGroup._slidingField then
                    slideGroup._originalSlideY = yGroup
                end    
                self:setSlideGroupPosition(y)
                slideGroup._slidingField = self
            end  
        end
    end
    
    function editField:_swapFakeField( fakeIt )
        
        
        local fakeTextField =  self._fakeTextField; 
        local viewTextField = self._textField;
        
        local function showEditField(event)
            
            self:insert(viewTextField)
            viewTextField.x = self._xOriginal;
            viewTextField.y = self._yOriginal;
            native.setKeyboardFocus( viewTextField )
            fakeTextField.isVisible = self.calibrating;
            self._fakingIt = false;
            if self._clearButton then
                self._clearButton.isVisible = string.len(viewTextField.text) ~= 0
            end;
        end
        
        if fakeIt  then
            if not self._fakingIt then
                self._fakingIt = true;
                self:updateFakeContent(viewTextField.text)
                fakeTextField.isVisible = true;
                
                if not self.calibrating then
                    display.getCurrentStage():insert(viewTextField)
                    viewTextField.x = -1000;
                    viewTextField.y = -1000;
                else
                    viewTextField.x = self._xOriginal;
                    viewTextField.y = self._yOriginal;                    
                end;    
            end      
        else    
            showEditField()
        end
        
    end
    
    local function touchFakeLabel(event)
        local phase = event.phase;
        if "began" == phase then  
            --keep focus, since the field can be scrolling up
            display.getCurrentStage():setFocus(fakeTextField);
            if editField._onClick == nil then
                editField:_swapFakeField( false )
            else    
                editField._onClick(event)
            end
        elseif ( "ended" == phase or "off" == phase or "cancelled" == phase )  then
            --release focus
            display.getCurrentStage():setFocus(nil);
            
        end;  
        return true
    end
    
    local function touchLabelText(event)
        if editField._onClick then
            editField._onClick(event)
        end
    end
    local function onBackgroundTouch(event)
        local phase = event.phase;
        if "began" == phase then
            --keep focus, since the field can be scrolling up
            display.getCurrentStage():setFocus(editField);
        elseif ( "ended" == phase or "off" == phase or "cancelled" == phase )  then
            --release focus
            display.getCurrentStage():setFocus(nil);
        end
        return true
    end
    if fakeTextField then
        fakeTextField:addEventListener( "touch", touchFakeLabel )
    end;
    
    if fieldDescription then
        fieldDescription:addEventListener( "touch", touchLabelText )
    end
    
    editField._fakingIt = false;
    if not editField.native then
        editField:_swapFakeField( true )
    end    
    
    editField:addEventListener( "touch", onBackgroundTouch  )
    
    -- Function to listen for textbox events
    function viewTextField:_inputListener( event )
        local editField  = self._editField;
        local phase = event.phase
        
        --async called on Submit in case other edit field is taking focus
        local function onHideField(event)
           if _focusedField == nil or _focusedField == self then
                native.setKeyboardFocus( nil )
                _focusedField = nil;
            end;   
            editField:slideBackKeyboard()
            --phase submitted
            if editField._onSubmit and (phase == "submitted" or phase == "ended" and self.text ~= self._originalText) then
                event.target = editField
                self._originalText = self.text
                editField._onSubmit(event)
            end
            --phase ended - send onSubmit only if the text is different
        end
        
        if "began" == phase then
            _focusedField = self;
            self._originalText = self.text
            editField:slideForKeyboard()
        elseif "editing" == phase then
            -- If there is one or more characters in the textField show the cancel button, if not hide it
            local sText = self.text; 
            local textLen = string.len(sText);
            if editField.allowedChars and event.newCharacters  then
                if not string.match(editField.allowedChars, event.newCharacters) then
                    --remove the offending character
                    self.text = string.gsub(sText, event.newCharacters,"");
                end
            end
            if editField.maxChars > 0 then
                if textLen > editField.maxChars then
                    self.text = string.sub(sText, 1, editField.maxChars)
                end 
            end
            if editField.calibrating then
                editField._fakeTextField.text = self.text;
            end
            if editField._clearButton then
                editField._clearButton.isVisible = textLen > 0
            end        
            if editField._errorFrame and editField.validating then
                editField._errorFrame.isVisible = editField.required and textLen == 0;
            end
            
        elseif "submitted" == phase or 
            "ended" == phase then
            -- Hide keyboard
            timer.performWithDelay(100,onHideField ,1)

            if not editField.native then
                editField:_swapFakeField( true )
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
        self._textField.text = value 
        self:updateFakeContent(value)
        --android sets text asynchroneously
        
    end
    
    function editField:getText()
        return self._textField.text
    end
    
    function editField:setValue(value)
        self:setText(value)
    end
    
    function editField:getValue()
        return self:getText()
    end
    
    function editField:setReturnKey(value)
        self.returnKey = value;
        self._textField:setReturnKey(self.returnKey);
        
    end;   
    
    function editField:setInputType(value)
        self.inputType = value;
        self._textField.inputType = value;
    end;   
    
    function editField:setIsSecure(value)
        self.isSecure = value;
        self._textField.isSecure = value;
    end;   
    
    function editField:validate()
        if self._errorFrame then
            self.validating = true;
            self._errorFrame.isVisible = 
            self.required and
            string.len(self._textField.text) == 0 
            return self._errorFrame.isVisible
        end 
        return false
    end
    
    function editField:setEditMode(value)
        self:_swapFakeField( not value )  
    end
    
    function editField:getEditMode()
        return not self._fakingIt; 
    end
    -- Finalize function
    function editField:_finalize()
        --remove from storyboard
        local scene = self._scene;
        if scene then 
            if scene.removeEditField then
                scene.removeEditField(self)
            end
        end
        
        -- Remove the textField
        display.remove( self._textField )
        
        self._textField = nil
        self._fakeTextField = nil;
        self._cancelButton = nil
        
    end
    
    --create a hidden background to "eat" the touch events"
    local bg = display.newRect(editField, opt.width / 2, opt.height / 2, opt.width, opt.height)
    bg:setFillColor(0,0,0,0);
    bg.isHitTestable = true;
    bg:toBack()
    bg:addEventListener("touch", function (event) return true; end)
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
    end    
    opt.width = customOptions.width or 150
    
    opt.frame  = customOptions.frame
    if opt.frame then
        
        opt.frame.cornerRadius = opt.frame.cornerRadius or 0;
        opt.frame.strokeWidth = opt.frame.strokeWidth or 1;
        opt.frame.strokeColor = opt.frame.strokeColor or frameStrokeDefault;
        opt.frame.fillColor = opt.frame.fillColor or frameFillDefault;
    end;  
    
    opt.errorFrame  = customOptions.errorFrame
    if opt.errorFrame then
        opt.errorFrame.cornerRadius = opt.errorFrame.cornerRadius or (opt.frame and opt.frame.cornerRadius or 0);
        opt.errorFrame.strokeWidth = opt.errorFrame.strokeWidth or (opt.frame and opt.frame.strokeWidth or 1);
        opt.errorFrame.strokeColor = opt.errorFrame.strokeColor or frameErrorStrokeDefault;
        opt.errorFrame.offset = opt.errorFrame.offset  or 3;
        
    end;  
    
    opt.id = customOptions.id
    opt.placeholder = customOptions.placeholder or "";
    opt.inputType  = customOptions.inputType or "default"
    opt.isSecure    = customOptions.isSecure or false;
    opt.returnKey    = customOptions.returnKey or "done";
    opt.onClick      = customOptions.onClick;
    opt.required   = customOptions.required or false;
    opt.textFieldYOffset = customOptions.textFieldYOffset or efDefaults.textFieldYOffset
    opt.textFieldXOffset = customOptions.textFieldXOffset or efDefaults.textFieldXOffset
    opt.fakeLabelYOffset = customOptions.fakeLabelYOffset or efDefaults.fakeLabelYOffset
    opt.fakeLabelXOffset = customOptions.fakeLabelXOffset or efDefaults.fakeLabelXOffset
    opt.textFieldHeightAdjust = customOptions.textFieldHeightAdjust or efDefaults.textFieldHeightAdjust
    opt.fontScale = customOptions.fontScale or efDefaults.fontScale;
    opt.calibrating = customOptions.calibrating
    
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
    opt.spacing = customOptions.spacing or 2;    
    opt.widgets = customOptions.widgets or {};
    opt.listButton = customOptions.listButton or false;
    opt.maxChars = customOptions.maxChars or 0;
    opt.allowedChars = customOptions.allowedChars or nil;
    if opt.allowedChars and string.len(opt.allowedChars)== 0 then
        opt.allowedChars = nil;
    end
    opt.buttonXOffset = customOptions.buttonXOffset or 0
    opt.buttonYOffset = customOptions.buttonYOffset or 0
    
    opt.editFont = customOptions.editFont or opt.labelFont
    opt.editFontSize = customOptions.editFontSize or opt.labelFontSize
    opt.height = customOptions.height or (opt.editFontSize and opt.editFontSize + 12 or 29)
    opt.native = customOptions.native or false
    opt.slideGroup = customOptions.slideGroup
    opt.keyboardSlideTime = customOptions.keyboardSlideTime or 200
    
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
    opt.middleFrame = customOptions.middleFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleFrame )
    opt.bottomMiddleFrame = customOptions.bottomMiddleFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomMiddleFrame )
    
    --3 slice
    opt.leftFrame = customOptions.leftFrame or _widget._getFrameIndex( themeOptions, themeOptions.leftFrame )
    opt.rightFrame = customOptions.rightFrame or _widget._getFrameIndex( themeOptions, themeOptions.rightFrame )
    opt.middleFrame = opt.middleFrame or customOptions.middleFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleFrame )
    if opt.leftFrame and  opt.rightFrame and opt.middleFrame then
        opt.edgeWidth = customOptions.edgeWidth or themeOptions.edgeWidth or error( "ERROR: " .. M._widgetName .. ": edgeFrameWidth expected, got nil", 3 )
        opt.edgeHeight = customOptions.edgeHeight or themeOptions.edgeHeight or error( "ERROR: " .. M._widgetName .. ": edgeFrameHeight expected, got nil", 3 )
    end
    
    -------------------------------------------------------
    -- Create the editField
    -------------------------------------------------------
    
    -- Create the editField object
    local editField = _widget._new
    {
        left = opt.left,
        top = opt.top,
        id = opt.id or "widget_editField",
    }
    
    
    initEditField( editField, opt )
    
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
