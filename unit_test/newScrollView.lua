local widget = require( "widgetnew" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Forward reference for test function timer
local testTimer = nil

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
	
	1) Scrollview events sent incorrectly
	
	Fixes case number(s): 15550, 15871
	
	How: Scrollview events were being sent incorrectly, simply tapping the scrollview and releasing would result in: contentTouch, beganScroll and endedScroll to be fired.
	Expected behavior: Now just tapping the scrollview and releasing should result in only "contentTouch" being fired, "beganScroll" should fired when the content begins to scroll
	and "endedScroll" should fire when the content has completed stopped scrolling.
	
	
	
	2) ContentTouch being fired on every move event.
	
	How: Prior to this revison content touch was being fired on every "moved" phase internally. I don't know why it was or if it was just a bug but I have removed this behavior
	please review widgetnew.lua 1441 > 1448. 
	Expected behavior: Content touch should only fire on a press or release event.
	
	
	NOTES: Please review all other samples (tableView, scrollView, pickerWheel) to ensure my changes didn't break anything. I found my changes broke the call to my pickerWheel softlanding function
	so i changed the way it was called and it is working again fine. I just want to be sure these changes didn't break anything. 
	
	--]]
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_GET_CONTENT_POSITION = false
	local TEST_SCROLL_TO_POSITION = false
	local TEST_SCROLL_TO_TOP = false
	local TEST_SCROLL_TO_BOTTOM = false
	local TEST_SCROLL_TO_LEFT = false
	local TEST_SCROLL_TO_RIGHT = false
	
	--Forward reference to scrollView listener
	local function scrollListener( event )
		print( "Event type:", event.type )
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
		testTimer = timer.performWithDelay( 2000, function()
			local x, y = scrollView:getContentPosition()
			print( "ScrollView content position. ( x = ", x, " y = ", y, ")" ) 
			x, y = nil
		end, 1 )
	end
	
	--Test takeFocus
	
	--Test scrollToPosition()
	if TEST_SCROLL_TO_POSITION then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollToPosition( -100, -600, 800, function() print( "scrollToPosition test completed" ) end )
		end, 1 )
	end	
	
	--Test scrollToTop()
	if TEST_SCROLL_TO_TOP then
		scrollView:scrollToBottom( 0 )
		
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollToTop( 800, function() print( "scrollToTop test completed" ) end  )
		end, 1 )
	end
	
	--Test scrollToBottom()
	if TEST_SCROLL_TO_BOTTOM then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollToBottom( 800, function() print( "scrollToBottom test completed" ) end  )
		end, 1 )
	end
	
	--Test scrollToLeft()
	if TEST_SCROLL_TO_LEFT then
		scrollView:scrollToRight( 0 )
		
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollToLeft( 800, function() print( "scrollToLeft test completed" ) end  )
		end, 1 )
	end
	
	--Test scrollToRight()
	if TEST_SCROLL_TO_RIGHT then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollToRight( 800, function() print( "scrollToRight test completed" ) end  )
		end, 1 )
	end
	
end

function scene:exitScene( event )
	--Cancel test timer if active
	if testTimer ~= nil then
		timer.cancel( testTimer )
		testTimer = nil
	end
	
	storyboard.purgeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
