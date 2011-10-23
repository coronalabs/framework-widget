display.setStatusBar( display.DefaultStatusBar )

local widget = require( "widget" )
widget.setTheme( "theme_ios" )

local options = {}
options.left = 0
options.top = display.statusBarHeight
options.topPadding = 0
options.bottomPadding = 0
options.height = 410
options.maskFile = "assets/mask-410.png"

local list = widget.newScrollView( options )

local testImage = display.newImage( "assets/coronaIcon.png" )
testImage.y = 100
list:insert( testImage )

local testImage = display.newImage( "assets/coronaIcon.png" )
testImage.y = 800
list:insert( testImage )

-- onEvent listener for the tableView
local function onRowTouch( event )
	local row = event.target
	local rowGroup = event.view
	
	if event.phase == "press" then
		if not row.isCategory then rowGroup.alpha = 0.5; end

	elseif event.phase == "release" then
		
		if not row.isCategory then
			row.reRender = true
			print( "You touched row #" .. event.index )
		end
	end
	
	return true
end

-- onRender listener for the tableView
local function onRowRender( event )
	local row = event.target
	local rowGroup = event.view
	
	local text = display.newRetinaText( "Row #" .. event.index, 12, 0, "Helvetica-Bold", 18 )
	text:setReferencePoint( display.CenterLeftReferencePoint )
	text.y = row.height * 0.5
	if not row.isCategory then
		text.x = 15
		text:setTextColor( 0 )
	end
	
	-- must insert everything into event.view:
	rowGroup:insert( text )
end

-- Add 100 rows, and two categories to the tableView:
--[[
for i=1,100 do
	local rowHeight, rowColor, lineColor, isCategory

	-- make the 25th item a category
	if i == 25 then
		isCategory = true; rowHeight = 24; rowColor={ 70, 70, 130, 255 }; lineColor={0,0,0,255}
	end

	-- make the 45th item a category as well
	if i == 45 then
		isCategory = true; rowHeight = 24; rowColor={ 70, 70, 130, 255 }; lineColor={0,0,0,255}
	end

	list:insertRow{
		onEvent=onRowTouch,
		onRender=onRowRender,
		height=rowHeight,
		isCategory=isCategory,
		rowColor=rowColor,
		lineColor=lineColor
	}
end
--]]

local onTabPress = function( event )
	print( "You pressed a tab button: " .. event.target.id )
end

-- buttons
local buttonsTable = {
	{ label="First Tab", up="assets/coronaIcon.png", down="assets/coronaIcon-down.png", width=32, height=32, onPress=onTabPress, selected=true },
	{ label="Second", up="assets/coronaIcon.png", down="assets/coronaIcon-down.png", width=32, height=32, onPress=onTabPress },
	{ label="Third", up="assets/coronaIcon.png", down="assets/coronaIcon-down.png", width=32, height=32, onPress=onTabPress },
	--{ label="Fourth", up="assets/coronaIcon.png", down="assets/coronaIcon-down.png", width=32, height=32, onPress=onTabPress },
}

-- create tab bar
local tabBar = widget.newTabBar( { top=480-50, buttons=buttonsTable } )

--tabBar:removeSelf()
--list:removeSelf()

--list:scrollToIndex( 2 )

timer.performWithDelay( 2000, function()
	--list:deleteRow( 100 )
	--list:scrollToIndex( 50 )
end, 1 )
---[[
local columnData = {
	{ "One", "Two", "Three", "Four", "Five" },
	{ "One", "Two", "Three", "Four", "Five" },
	{ "AM", "PM" }
}

columnData[1].width = 128
columnData[1].alignment = "right"
columnData[3].startIndex = 2
--]]

--[[
local picker = widget.newPickerWheel( {
	id="pickerWheel",
	font="Helvetica-Bold",
	top=480+222,--258-50,
	columns=columnData,
} )

transition.to( picker.view, { time=500, y=258, transition=easing.outQuad } )
--]]

local function getColumnData()
	local columnData = picker:getValues()
	
	for i=1,#columnData do
		print( columnData[i].value, columnData[i].index )
	end
end

timer.performWithDelay( 4000, function()
	--picker:removeSelf()
end, 1 )

local function sliderCallback( event )
	print( event.value )
end

--local slider = widget.new( "slider", { x=100, y=200, width=100, callback=sliderCallback } )

--timer.performWithDelay( 2000, function() list:removeSelf(); list = nil; end, 1 )

--local text1 = display.newRetinaText( "Hello World! I'm hoping this will finally work!", 100, 200, 200, 200, "Helvetica-Bold", 18 )
--local text2 = display.newText( "Hello World! I'm hoping this will finally work!", 100, 200, 200, 200, "Helvetica-Bold", 18 )

--print( text1.width )

--timer.performWithDelay(3000, function() list:scrollToY( -882, 0 ); end, 1 )

--timer.performWithDelay( 5000, addTwentyFive, 5 )

--timer.performWithDelay( 3000, function() list:removeSelf(); list = nil; end, 1 )

--[[
local black1 = display.newRect( 50, 0, 150, 40 )
black1:setFillColor( 50, 0, 25, 255 )

local black2 = display.newRect( 50, 42, 150, 40 )
black2:setFillColor( 50, 0, 25, 255 )

local black3 = display.newRect( 50, 84, 150, 40 )
black3:setFillColor( 50, 0, 25, 255 )

list._view:insert( black1 )
list._view:insert( black2 )
list._view:insert( black3 )


black2:setReferencePoint( display.TopLeftReferencePoint )
black2.y = black2.y + 100


--]]


--Runtime:addEventListener( "enterFrame", function() print( list._view.content.rows[1].top ); end )