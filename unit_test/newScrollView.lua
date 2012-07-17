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
	
	--Toggle these defines to execute tests
	local TEST_GET_CONTENT_POSITION = false
	local TEST_SCROLL_TO_POSITION = false
	local TEST_SCROLL_TO_TOP = false
	local TEST_SCROLL_TO_BOTTOM = true
	local TEST_SCROLL_TO_LEFT = false
	local TEST_SCROLL_TO_RIGHT = false
	
	--Forward reference to scrollView listener
	local function scrollListener( event )
		print( event.type )
		return true
	end
	
	--Create scrollView
	local scrollView = widget.newScrollView{
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
	scrollView.isHitTestMasked = true
	
	-- insert image into scrollView widget
	local bg = display.newImageRect( "assets/scrollimage.jpg", 768, 1024 )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x, bg.y = 0, 0
	scrollView:insert( bg )
	
	-- don't forget to insert objects into the scene group!
	group:insert( scrollView )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	--[[
	local TEST_GET_CONTENT_POSITION = false
	local TEST_SCROLL_TO_POSITION = false
	local TEST_SCROLL_TO_TOP = false
	local TEST_SCROLL_TO_BOTTOM = false
	local TEST_SCROLL_TO_LEFT = false
	local TEST_SCROLL_TO_RIGHT = false
	--]]
	
	--Test getContentPosition()
	if TEST_GET_CONTENT_POSITION then
		timer.performWithDelay( 2000, function()
			local x, y = scrollView:getContentPosition()
			print( "ScrollView content position. ( x = ", x, " y = ", y, ")" ) 
			x, y = nil
		end, 1 )
	end
	
	--Test takeFocus
	
	--Test scrollToPosition()
	if TEST_SCROLL_TO_POSITION then
		timer.performWithDelay( 2000, function()
			scrollView:scrollToPosition( -100, -600, 800, function() print( "scrollToPosition test completed" ) end )
		end, 1 )
	end	
	
	--Test scrollToTop()
	if TEST_SCROLL_TO_TOP then
		scrollView:scrollToBottom( 0 )
		
		timer.performWithDelay( 2000, function()
			scrollView:scrollToTop( 800, function() print( "scrollToTop test completed" ) end  )
		end, 1 )
	end
	
	--Test scrollToBottom()
	if TEST_SCROLL_TO_BOTTOM then
		timer.performWithDelay( 2000, function()
			scrollView:scrollToBottom( 800, function() print( "scrollToBottom test completed" ) end  )
		end, 1 )
	end
	
	--Test scrollToLeft()
	if TEST_SCROLL_TO_LEFT then
		scrollView:scrollToRight( 0 )
		
		timer.performWithDelay( 2000, function()
			scrollView:scrollToLeft( 800, function() print( "scrollToLeft test completed" ) end  )
		end, 1 )
	end
	
	--Test scrollToRight()
	if TEST_SCROLL_TO_RIGHT then
		timer.performWithDelay( 2000, function()
			scrollView:scrollToRight( 800, function() print( "scrollToRight test completed" ) end  )
		end, 1 )
	end
	
end

function scene:exitScene( event )
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
