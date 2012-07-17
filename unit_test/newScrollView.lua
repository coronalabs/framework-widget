local widget = require( "widgetnew" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

function scene:createScene( event )
	local group = self.view
	
	--Display an iOS style background
	local background = display.newImage( "assets/background.png" )
	group:insert( background )
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = 20,
	    label = "Return To Menu",
	    width = 200, height = 52,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST													  --
	----------------------------------------------------------------------------------------------------------------
	
	--[[
	
	RECENT CHANGES/THINGS TO REVIEW:
	
	1) Scrollbar can be hidden. 
	
	How: Pass < hideScrollBar = true > to widget.newScrollView.
	Expected behavior: The Scrollbar should be hiden if this flag is set to true, otherwise it should be visible if this flag is set to false or omitted.
	
	2) Scrollbar can be set a custom color.
	
	How: Pass < scrollBarColor = { r, g, b, a } > to widget.newScrollView. 
	Expected behavior: The Scrollbar's color should represent the passed color, if this flag is omitted or a table isn't passed to it the Scrollbar will fall back to it's default color.
	
	--]]
	
	
	--Forward reference to scrollView listener
	local function scrollListener( event )
		print( event.type )
		return true
	end
	
	--Create scrollView
	local scrollBox = widget.newScrollView{
		top = 100,										--Test setting top position.
		left = 10,										--Test setting left position.
		width = 300, height = 350,						--Test setting width/height.
		scrollWidth = 768, scrollHeight = 1024,			--Test setting scroll width/height.
		maskFile = "assets/scrollViewMask-350.png",		--Test setting a mask.
		--baseDir = system.DocumentsDirectory,			--Test base directory (Ensure maskFile specified above exists in the baseDir specified).
		bgColor = { 255, 255, 255, 255 }, 				--Test setting a background color.
		hideBackground = true, 			 			 	--Test hiding the background color.
		scrollBarColor = { 255, 0, 128 }, 				--Test setting the scrollbar color. If this is ommited or not a table, the scrollbar falls back to it's default color.
		hideScrollBar = true, 							--Test hiding the scrollbar. When set to true, scrollbar is shown when set to false or omitted.
		listener = scrollListener						--Test setting a listener for the scrollView.
	}
	scrollBox.isHitTestMasked = true
	
	-- insert image into scrollView widget
	local bg = display.newImageRect( "assets/scrollimage.jpg", 768, 1024 )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x, bg.y = 0, 0
	scrollBox:insert( bg )

	--timer.performWithDelay( 1000, function() scrollBox.content.velocity = 0; end, 0 )
	
	-- don't forget to insert objects into the scene group!
	group:insert( scrollBox )
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
