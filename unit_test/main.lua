local widget = require "widgetnew"

local listOptions = {
        top = display.statusBarHeight,
        height = 410,
        maskFile = "mask-410.png"
}

local list = widget.newTableView( listOptions )

-- onEvent listener for the tableView
local function onRowTouch( event )
        local row = event.target
        local rowGroup = event.view

        if event.phase == "press" then

            local y = tableView:getContentPosition()
            print( "Position is:", y )      

            if not row.isCategory then rowGroup.alpha = 0.5; end

        elseif event.phase == "swipeLeft" then
                print( "Swiped left." )

        elseif event.phase == "swipeRight" then
                print( "Swiped right." )

        elseif event.phase == "release" then

                if not row.isCategory then
                        -- reRender property tells row to refresh if still onScreen when content moves
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

-- Create 100 rows, and two categories to the tableView:
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

        -- function below is responsible for creating the row
        list:insertRow{
                onEvent=onRowTouch,
                onRender=onRowRender,
                height=rowHeight,
                isCategory=isCategory,
                rowColor=rowColor,
                lineColor=lineColor
        }


end

list:scrollToY( -300, 800 )