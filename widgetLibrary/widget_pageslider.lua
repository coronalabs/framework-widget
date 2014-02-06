-- Copyright © 2014 Top Rank Software LLC. All Rights Reserved.
-- This library includes code developed by Corona Labs Inc. (http://www.coronalabs.com).
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of the company nor the names of its contributors
--      may be used to endorse or promote products derived from this software
--      without specific prior written permission.
--    * Redistributions in any form whatsoever must retain the following
--      acknowledgment visually in the program (e.g. the credits of the program): 
--      'This product includes software developed by Top Rank Software LLC'
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL CORONA LABS INC. BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- Require needed widget files
local _widget = require( "widget" )


local M = 
{
    _options = {},
    _widgetName = "widget.newPageSlider",
}

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )
local isByteColorRange = display.getDefault( "isByteColorRange" )

local fillColorDefault
if isByteColorRange then
    fillColorDefault = { 255, 255, 255 } 
else
    fillColorDefault = { 1, 1, 1 }
end

local dotFillColorDefault

if isByteColorRange then
    dotFillColorDefault = { 127, 127, 127 } 
else
    dotFillColorDefault = { 0.5, 0.5, 0.5 }
end

local function createPageSlider( pageSlider, options )
    local opt = options
    
    
    local view = display.newGroup();
    pageSlider:insert(view)
    
    local  rect = display.newRect( 0, 0,opt.width * opt.numPages, opt.height);
    rect:setFillColor(unpack(opt.fillColor));
    rect.x =   rect.contentWidth / 2;
    rect.y =   rect.contentHeight / 2;
    rect.isHitTestable = true;
    view:insert(rect)
    
    
    pageSlider._view = view
    pageSlider._transition = 0;
    view._numPages = opt.numPages;

    local dots = {};
    local dGroup = nil
    if opt.dotSegmentHeight > 0 then
        dGroup = display.newGroup()
        dGroup.x =  (opt.width - (opt.numPages+1)*opt.dotsMargin)/ 2;
        dGroup.y = opt.height - opt.dotSegmentHeight 
        pageSlider:insert(dGroup);
    end;      
    
    local pages = {};
    for i = 1, opt.numPages do
        if opt.dotSegmentHeight > 0 then
            local dot = display.newCircle(dGroup,  i*opt.dotsMargin, 
                                          opt.dotSegmentHeight / 2,
                                          opt.dotRadius) ; 
            dot:setFillColor(unpack(opt.dotFillColor))
            dot:setStrokeColor(unpack(opt.dotStrokeColor));
            dot.strokeWidth = 1;
            dots[#dots+1] = dot
        end;
        
        local page = display.newGroup();
        page.x = opt.width * (i - 1) --+ opt.width / 2;
        page.y = 0 --opt.height / 2
        page.contentWidth = opt.width
        page.contentHeight = opt.height
        view:insert(page);
        pages[i] = page;
    end
  
    view._dots = dots;
    
    view._width = opt.width;
    view._isEnabled = opt.isEnabled
    view._fastSwipeTime = opt.fastSwipeTime;
    view._fastSwipeDist = opt.fastSwipeDist;
    pageSlider.pages = pages;
    pageSlider._onChangePage = opt.onChangePage;
    
    function pageSlider:selectPage(iPage, isAnimated) 
        
        local function onTransitionComplete( event )
            transition.cancel( pageSlider._transition ) ; 
            pageSlider._transition = 0
            
            local targetX = -(self._view.selectedPage-1)* self._view._width 
            if ( self._view.x ~= targetX ) then 
                self._view.x = targetX 
            end
            self:updateDots( self._view.selectedPage)
        end
        
        local canChangePage = true;
        if self._onChangePage then
            canChangePage = self._onChangePage(iPage)
                
        end  
        
        if canChangePage then
            self._view.selectedPage = iPage;
        end;    
        if ( self._transition ~= 0 ) then 
            transition.cancel( self._transition ) 
            self._transition = 0
        end
        local targetX = -(self._view.selectedPage-1) * self._view._width 
        local _view = self._view;
        if targetX ~= _view.X then
            
            if isAnimated then
                self._transition = transition.to(
                    _view , 
                    { x  = targetX, 
                        time = 1000*math.abs(targetX - _view.x)/self._view._width, 
                        transition = easing.outQuad, 
                    onComplete = onTransitionComplete } )
                    
            else
                _view.x = targetX;
            end;
            self:updateDots( self._view.selectedPage );
        end 
        
    end  
    
    function pageSlider:updateDots( iPage )
        local dots = self._view._dots;
        
        for i = 1, #dots do
            if i == iPage then 
                dots[i].alpha = 1.0 
            else 
                dots[i].alpha = 0.3 
            end
        end
    end
    

    
    function pageSlider:getPage( iPage )
        return self.pages[iPage];
    end
    
    function pageSlider:getSelected()
        return self._view.selectedPage;
    end
    -- Function to set a pageSlider as active
    function pageSlider:setEnabled( isEnabled )
        self._view._isEnabled = isEnabled
    end
    
    function pageSlider:takeFocus(event)
        self._view:touch(event) 
    end    
    
    function view:touch( event )
        
        local phase = event.phase
        local currentPage = self.selectedPage;
        
        -- If the pageSlider isn't active, just return
        if not self._isEnabled then
            return
        end
        if "began" == phase then
            display.getCurrentStage():setFocus(self);
            self.isFocus = true;
            native.setKeyboardFocus(nil)
            if (self._transition ~= 0 ) then 
                transition.cancel( self._transition ) ; 
                self._transition = 0 
            end
            self._startX = event.x ; 
            self._lastX = event.x ; 
            self._startTime = event.time;
        elseif ( "moved" == phase and self.isFocus == true ) then
            local movedDistance = event.x - self._lastX;
            local totalDistance = event.x - self._startX ; 
            local resist = 1;
            if (( currentPage == 1 and totalDistance > 0 ) or 
                ( currentPage == self._numPages and totalDistance < 0 ) ) then 
                resist = 0.3;
            end
            self.x = self.x + (movedDistance * resist) ; 
            self._lastX = event.x ;
            
        elseif ( "ended" == phase or "off" == phase or "cancelled" == phase ) and self._startTime then
            display.getCurrentStage():setFocus(nil);
            self.isFocus = false;
            local totalSwipeTime = system.getTimer() - self._startTime
            self._startTime = nil
            local totalDistance = event.x - self._startX ; 
            local swipeDist = math.abs( totalDistance )
            local fastSwipeTime = self._fastSwipeTime;
            local pageWidth = self._width;
            if (totalSwipeTime <= fastSwipeTime and swipeDist >= self._fastSwipeDist) or
               ( totalSwipeTime > fastSwipeTime and swipeDist >= pageWidth*0.5 ) then 
                if  totalDistance < 0  then 
                    currentPage = math.min(self._numPages, currentPage + 1);
                else 
                    currentPage = math.max(1, currentPage - 1) 
                end
            end;    
            self.parent:selectPage(currentPage, true)
            
        end
        return true
    end
    
    view:addEventListener( "touch")
    pageSlider:selectPage(opt.selectedPage, false)
    
    
    
end

-- Function to create a new button object ( widget.newButton )
function M.new( options, theme )	
    local customOptions = options or {}
    local themeOptions = theme or {}
    
    -- Create a local reference to our options table
    local opt = M._options
    
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
    opt.isEnabled = customOptions.isEnabled or true;
    opt.numPages = customOptions.numPages or 1;
    opt.fillColor = customOptions.fillColor or fillColorDefault;
    opt.selectedPage = customOptions.selectedPage or 1;
    opt.dotFillColor = customOptions.dotFillColor or dotFillColorDefault;
    opt.dotStrokeColor = customOptions.dotStrokeColor or opt.dotFillColor
    opt.dotsMargin = customOptions.dotsMargin or 35;
    opt.fastSwipeTime = customOptions.fastSwipeTime or 300;
    opt.fastSwipeDist = customOptions.fastSwipeDist or display.contentWidth/10
    opt.dotSegmentHeight = customOptions.dotSegmentHeight or 20;
    opt.dotRadius = customOptions.dotRadius or 6;
    

    opt.onChangePage = ( type(customOptions.onChangePage) == "function" )  and customOptions.onChangePage or nil;
    -- Create the pageslider object
    local pageSlider = _widget._new
    {
        left = opt.left,
        top = opt.top,
        id = opt.id or "widget_pageslider",
        baseDir = opt.baseDir,
        widgetType = "pageslider",
    }
    createPageSlider(pageSlider, opt)
    
    if ( isGraphicsV1 ) then
        pageSlider:setReferencePoint( display.CenterReferencePoint )
    end
	
    local x, y = _widget._calculatePosition( pageSlider, opt )
    pageSlider.x, pageSlider.y = x, y
   
    return pageSlider
end;

return M