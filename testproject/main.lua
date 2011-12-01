local widget = require "widget"


-- Create the First List.
local myList = widget.newTableView{
	width = 310,
	height = 270,
	top = 200,
	left = 100,
}

-- Event Listener for the TableView.
local function onRowTouch(event)
	local row = event.target
	local rowGroup = event.view
	if event.phase == "press" then
		if not row.isCategory then rowGroup.alpha = 0.5; end
	elseif event.phase == "release" then
		if not row.isCategory then
			row.reRender = true
			print("You touched row#"..event.index)
		end
	end
	return true
end
			
-- Render Event for the TableView
local function onRowRender(event)
	local row = event.target
	local rowGroup = event.view
	
	local text = display.newRetinaText("Row #"..event.index, 12, 0, nil, 18)
	text:setReferencePoint(display.CenterLeftReferencePoint)
	text.y = row.height * 0.5
	if not row.isCategory then
		text.x = 15
		text:setTextColor(0)
	end
	rowGroup:insert(text)
end
				
-- Create the List rows.
for i = 1,100 do
	local rowHeight, rowColor, lineColor, isCategory
	if i == 25 then
		isCategory = true
		rowHeight = 24
		rowColor = { 70, 70, 130, 255 }
		lineColor = { 0, 0, 0, 255 }
	end
	if i == 45 then
		isCategory = true
		rowHeight = 24
		rowColor = { 70, 70, 130, 255 }
		lineColor = { 0, 0, 0, 255 }
	end
					
	myList:insertRow{
		onEvent=onRowTouch,
		onRender=onRowRender,
		height=rowHeight,
		isCategory=isCategory,
		rowColor=rowColor,
		lineColor=lineColor
	}
end


-- Create the Second List.
local myList2 = widget.newTableView{
	width = 310,
	height = 270,
	top = 500,
	left = 100
}

-- Event Listener for the TableView.
local function onRowTouch2(event)
	local row = event.target
	local rowGroup = event.view
	if event.phase == "press" then
		if not row.isCategory2 then rowGroup.alpha = 0.5; end
	elseif event.phase == "release" then
		if not row.isCategory2 then
			row.reRender = true
			print("You touched row#"..event.index)
		end
	end
	return true
end
			
-- Render Event for the TableView
local function onRowRender2(event)
	local row = event.target
	local rowGroup = event.view
	
	local text = display.newRetinaText("Row #"..event.index, 12, 0, nil, 18)
	text:setReferencePoint(display.CenterLeftReferencePoint)
	text.y = row.height * 0.5
	if not row.isCategory2 then
		text.x = 15
		text:setTextColor(0)
	end
	rowGroup:insert(text)
end
				
-- Create the List rows.
for i = 1,100 do
	local rowHeight2, rowColor2, lineColor2, isCategory2
	if i == 25 then
		isCategory2 = true
		rowHeight2 = 24
		rowColor2 = { 70, 70, 130, 255 }
		lineColor2 = { 0, 0, 0, 255 }
	end
	if i == 45 then
		isCategory2 = true
		rowHeight2 = 24
		rowColor2 = { 70, 70, 130, 255 }
		lineColor2 = { 0, 0, 0, 255 }
	end
					
	myList2:insertRow{
		onEvent=onRowTouch2,
		onRender=onRowRender2,
		height=rowHeight2,
		isCategory=isCategory2,
		rowColor=rowColor2,
		lineColor=lineColor2
	}
end