
-- Abstract: widget.newSpinner()
-- Code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

local M = 
{
	_options = {},
	_widgetName = "widget.newSpinner",
}

-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

-- Creates a new spinner from an image
local function initWithImage( spinner, options )
	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local imageSheet, view
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	view = display.newImageRect( spinner, imageSheet, opt.startFrame, opt.width, opt.height )
	view.x = spinner.x + ( view.contentWidth * 0.5 )
	view.y = spinner.y + ( view.contentHeight * 0.5 )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	view._deltaAngle = opt.deltaAngle
	view._increments = opt.increments
	
	-------------------------------------------------------
	-- Assign properties/objects to the spinner
	-------------------------------------------------------
	
	-- Assign objects to the spinner
	spinner._imageSheet = imageSheet
	spinner._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
			
	-- Function to start the spinner's rotation
	function spinner:start()
		-- The spinner isn't a sprite > Start or resume it's timer
		local function rotateSpinner()
			if not ( self._view.rotation ) then return end
			--self._view:rotate( self._view._deltaAngle )
			self._view.rotation = self._view.rotation + self._view._deltaAngle
		end

		-- If the timer doesn't exist > Create it
		if not self._view._timer then
			self._view._timer = timer.performWithDelay( self._view._increments, rotateSpinner, 0 )
		else
			-- The timer exists > Resume it
			timer.resume( self._view._timer )
		end
	end
	
	-- Function to pause the spinner's rotation
	function spinner:stop()
		-- Pause the spinner's timer
		if self._view._timer then
			timer.pause( self._view._timer )
		end
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function for the spinner
	function spinner:_finalize()
		if self._view._timer then
			timer.cancel( self._view._timer )
			self._view._timer = nil
		end
		
		-- Set spinners ImageSheet to nil
		self._imageSheet = nil
	end
			
	return spinner
end


-- Creates a new spinner from a sprite
local function initWithSprite( spinner, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Animation options
	local sheetOptions = 
	{ 
		name = "default", 
		start = opt.startFrame, 
		count = opt.frameCount,
		time = opt.animTime,
	}
	
	-- Forward references
	local imageSheet, view
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	view = display.newSprite( spinner, imageSheet, sheetOptions )
	view:setSequence( "default" )
	
	-- Positioning
	view.x = spinner.x + ( view.contentWidth * 0.5 )
	view.y = spinner.y + ( view.contentHeight * 0.5 )
	
	-------------------------------------------------------
	-- Assign properties/objects to the spinner
	-------------------------------------------------------
	
	-- Assign objects to the spinner
	spinner._imageSheet = imageSheet
	spinner._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to start the spinner's animation
	function spinner:start()
		self._view:play()
	end
	
	-- Function to pause the spinner's animation
	function spinner:stop()
		self._view:pause()
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function
	function spinner:_finalize()
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
		
	return spinner
end


-- Function to create a new Spinner object ( widget.newSpinner )
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
	opt.width = customOptions.width or themeOptions.width or error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
	opt.height = customOptions.height or themeOptions.height or error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.animTime = customOptions.time or themeOptions.time or 1000
	opt.deltaAngle = customOptions.deltaAngle or themeOptions.deltaAngle or 1
	opt.increments = customOptions.incrementEvery or themeOptions.incrementEvery or 1
		
	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	opt.startFrame = customOptions.startFrame or _widget._getFrameIndex( themeOptions, themeOptions.startFrame )
	opt.frameCount = customOptions.count or themeOptions.count or 0

	-------------------------------------------------------
	-- Create the spinner
	-------------------------------------------------------
		
	-- Create the spinner object
	local spinner = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_spinner",
		baseDir = opt.baseDir,
	}
		
	-- Is the spinner animated?
	local spinnerIsAnimated = opt.frameCount > 1

	-- Create the spinner
	if spinnerIsAnimated then
		initWithSprite( spinner, opt )
	else
		initWithImage( spinner, opt )
	end
	
	-- Set the spinner's position ( set the reference point to center, just to be sure )
	
	if ( isGraphicsV1 ) then
		spinner:setReferencePoint( display.CenterReferencePoint )
	end
	
	local x, y = _widget._calculatePosition( spinner, opt )
	spinner.x, spinner.y = x, y
	
	return spinner
end

return M
