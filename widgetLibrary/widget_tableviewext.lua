local _widget = require("widget")

local fastSwipeTime = 400;
local fastSwipeDistance = 50;

local M = {}

function M.new(old_newTableView, options)
    local tableview
    
    local function onTransitionComplete(event)
        tableview._transition = nil;
    end
    
    
local function tableViewListener(event)
        local row = event.target;
        if event.phase == "began" then
            if tableview._beganPhase then
                event.phase = "moved"
                
            else
                tableview._beganPhase = true; 
                tableview._slideStarted = false;
                if tableview._slideDistance > 0 then
                    if tableview._targetRow and (tableview._targetRow ~= row) and (tableview._targetRow.x ~= 0) then
                        tableview:cancelSlide(tableview._targetRow)
                    elseif tableview._slideDistance > 0 and row.hiddenGroup then
                        if  tableview._transition then
                            transition.cancel(tableview._transition);
                            tableview._targetRow.x = tableview._targetX;
                            tableview._transition = nil
                        end
                        display.getCurrentStage():setFocus(tableview.view);
                        tableview._sliding = true;
                        tableview._startX = event.x; 
                        tableview._startGroupX = row.x;
                        tableview._startTime = event.time;
                        if row.hiddenGroup.isVisible == false then
                            row.hiddenGroup.x = row.x;
                            row.hiddenGroup.y = row.y;
                            row.hiddenGroup.isVisible = true;
                        end;    
                    end;    
                end;   
                
                
            end
        end
        if event.phase == "moved" and tableview._sliding then
            
            local totalDistance = event.x - tableview._startX;
            if math.abs(totalDistance ) > 10 then
                tableview._slideStarted = true;
            end 
            if tableview._slideStarted then
                if tableview._startGroupX == 0 then
                    if (totalDistance < 0 ) and math.abs(totalDistance) <= tableview._slideDistance then
                        row.x = tableview._startGroupX + totalDistance; 
                    end    
                else
                    if (totalDistance > 0 ) and totalDistance <= tableview._slideDistance then
                        row.x = tableview._startGroupX + totalDistance; 
                    end    
                end    
            end;    
        end
        if  (event.phase == "ended" or event.phase == "cancelled")  then
            tableview._beganPhase = false;
            if tableview._sliding then
                display.getCurrentStage():setFocus(nil);
                
                tableview._sliding = false;
                --display.getCurrentStage():setFocus(nil);
                local totalSwipeTime = system.getTimer() - tableview._startTime
                local totalDistance = event.x - tableview._startX ; 
                local absDistance = math.abs(totalDistance);
                local targetX;
                if  (event.phase == "ended") then
                    if  ((totalSwipeTime <= fastSwipeTime and absDistance >= fastSwipeDistance) or
                        (absDistance > tableview._slideDistance /2 )) then 
                        if totalDistance < 0 then
                            if tableview._startGroupX == 0 then
                                targetX = tableview._startGroupX - tableview._slideDistance;
                            else
                                targetX = tableview._startGroupX;
                            end    
                        else
                            targetX = 0;
                        end    
                    else  
                        targetX = tableview._startGroupX;
                    end
                    
                else
                    targetX = tableview._startGroupX;
                end
                tableview:slideTo(row, targetX, 300)
            end    
        end
        
        if  tableview._listener then
            tableview._listener (event)
        end
    end
    
    
    local function tableViewRowRender(event)
        local row = event.row;
        local hiddenGroup = tableview.hiddenRows[row.index];
        if hiddenGroup then
            display.remove(hiddenGroup);
        end
        row.hiddenGroup = display.newGroup()
        tableview.hiddenRows[row.index] = row.hiddenGroup;
        
        --row:insert(row.hiddenGroup);
        tableview._view:insert(row.hiddenGroup)
        row.hiddenGroup.x = row.x;
        row.hiddenGroup.y = row.y;
        row.hiddenGroup:toBack()
        
        if  tableview._onRowRender then
            tableview._onRowRender (event)
        end
    end
    --install hooks only if the table needs to be sliding
   local _listener, _onRowRender = nil, nil;
   if options.slideDistance then
        
        if options.listener and "function" == type(options.listener) then
            _listener = options.listener;
        end;   
        options.listener = tableViewListener;
        
        
        if options.onRowRender and "function" == type(options.onRowRender) then
            _onRowRender = options.onRowRender;
        end;   
        
        options.onRowRender = tableViewRowRender;
    end
    tableview = old_newTableView(options)
    --tableview = require("widgets.widget_tableview").new(options)
    if options.slideDistance then
        tableview._listener = _listener;
        tableview.hiddenRows = {};
        tableview._onRowRender = _onRowRender;
    end;       
    tableview._slideDistance = options.slideDistance;
    
    
    
    
    function tableview:slideTo(row, targetX, transitionTime)
        if row then
            if self._transition then
                transition.cancel(self._transition)
                if self._targetRow then
                    self._targetRow.x = self._targetX;
                end
                self._transition = nil;
            end
            if transitionTime and transitionTime > 0 then
                self._targetRow = row
                self._targetX = targetX;
                local currentX = row.x;
                local speed = math.abs(targetX - currentX) / self._slideDistance;
                self._transition = transition.to(row, 
                { x  = targetX, 
                    time = transitionTime * speed, 
                    transition = easing.outQuad, 
                onComplete = onTransitionComplete})
            else
                row.x = targetX;
            end    
        end    
        
    end
    
    function tableview:deleteRow( rowIndex )
        local row = self._view:_getRowAtIndex( rowIndex )
        if row.hiddenGroup then
            if self._targetRow == row then
                self._targetRow = nil;
            end
            display.remove(row.hiddenGroup)
            tableview.hiddenRows[rowIndex] = nil;
            row.hiddenGroup = nil;
        end
	local retVal =  self._view:_deleteRow( rowIndex )
        for i = rowIndex , table.maxn(self._view._rows) do
            row = self._view._rows[i];
            -- If the row is within the visible view
            if row and "table" == type(row._view ) then
                if row and row._view.hiddenGroup then
                    row._view.hiddenGroup.isVisible = false;
                    --row._view.hiddenGroup.x = row._view.x;
                    --row._view.hiddenGroup.y = row._view.y;
                end
            end;     
        end
        return retVal;
    end
    
    function tableview:deleteAllRows()
        for i = 1 , table.maxn(self._view._rows) do
            row = self._view._rows[i];
            -- If the row is within the visible view
            if row and "table" == type(row._view ) then
                if row and row._view.hiddenGroup then
                    display.remove(row._view.hiddenGroup)
                    row._view.hiddenGroup = nil;
                end
            end;     
        end
        self.hiddenRows = {};
        return self._view:_deleteAllRows()
    end
    
    function tableview:cancelSlide(row)
        if row then
            self:slideTo(row, 0, 0)
        elseif self._targetRow then
            self:cancelSlide(tableview._targetRow)
        end    
        
    end    
    
    function tableview:takeFocus(event)
        self._view:touch(event) 
    end    
    
    return tableview;
end


return M;
