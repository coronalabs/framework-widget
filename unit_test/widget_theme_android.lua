-----------------------------------------------------------------------------------------
-- theme_ios.lua
-----------------------------------------------------------------------------------------
local modname = ...
local theme = {}
package.loaded[modname] = themeTable
local assetDir = "widget_android"
local imageSuffix = display.imageSuffix or ""

-----------------------------------------------------------------------------------------
-- button
-----------------------------------------------------------------------------------------

theme.button = 
{
	sheet = assetDir .. "/widget_theme_android.png",
	data = assetDir .. ".widget_theme_android",
	
	topLeftFrame = "button_topLeft",
	topLeftOverFrame =  "button_topLeftOver",
	middleLeftFrame = "button_middleLeft",
	middleLeftOverFrame = "button_middleLeftOver",
	bottomLeftFrame = "button_bottomLeft",
	bottomLeftOverFrame = "button_bottomLeftOver",
	
	topMiddleFrame = "button_topMiddle",
	topMiddleOverFrame = "button_topMiddleOver",
	middleFrame = "button_middle",
	middleOverFrame = "button_middleOver",
	bottomMiddleFrame = "button_bottomMiddle",
	bottomMiddleOverFrame = "button_bottomMiddleOver",
	
	topRightFrame = "button_topRight",
	topRightOverFrame = "button_topRightOver",
	middleRightFrame = "button_middleRight",
	middleRightOverFrame = "button_middleRightOver",
	bottomRightFrame = "button_bottomRight",
	bottomRightOverFrame = "button_bottomRightOver",
	
	width = 180, 
	height = 50,
	font = "Helvetica-Bold",
	fontSize = 20,
	labelColor = 
	{ 
		default = { 0, 0, 0 },
		over = { 0, 0, 0 },
	},
	emboss = true,
}


-----------------------------------------------------------------------------------------
-- slider
-----------------------------------------------------------------------------------------

theme.slider = 
{
	sheet = assetDir .. "/widget_theme_android.png",
    data = assetDir .. ".widget_theme_android",

	leftFrame = "slider_leftFrame",
	rightFrame = "slider_rightFrame",
	middleFrame = "silder_middleFrame",
	fillFrame = "slider_fill",
	
	topFrame ="slider_topFrameVertical",
	bottomFrame = "slider_bottomFrameVertical",
	middleVerticalFrame = "silder_middleFrameVertical",
	fillVerticalFrame = "slider_fillVertical",
	
	frameWidth = 10,
	frameHeight = 10,
	handleFrame = "slider_handle",
	handleWidth = 32, 
	handleHeight = 32,
}

-----------------------------------------------------------------------------------------
-- pickerWheel
-----------------------------------------------------------------------------------------

theme.pickerWheel = 
{
	sheet = assetDir .. "/widget_theme_android.png",
    data = assetDir .. ".widget_theme_android",
	backgroundFrame = "picker_bg",
	backgroundFrameWidth = 1,
	backgroundFrameHeight = 222,
	overlayFrame = "picker_overlay",
	overlayFrameWidth = 320,
	overlayFrameHeight = 222,
	seperatorFrame = "picker_separator",
	seperatorFrameWidth = 2,
	seperatorFrameHeight = 8,
	maskFile = assetDir .. "/masks/pickerWheel/pickerWheelMask.png",
}

-----------------------------------------------------------------------------------------
-- tabBar
-----------------------------------------------------------------------------------------

theme.tabBar =
{
	sheet = assetDir .. "/widget_theme_android.png",
    data = assetDir .. ".widget_theme_android",
	backgroundFrame = "tabBar_background",
	backgroundFrameWidth = 25,
	backgroundFrameHeight = 50,
	tabSelectedLeftFrame = "tabBar_tabSelectedLeftEdge",
	tabSelectedRightFrame = "tabBar_tabSelectedRightEdge",
	tabSelectedMiddleFrame = "tabBar_tabSelectedMiddle",
	tabSelectedFrameWidth = 10,
	tabSelectedFrameHeight = 50,
	tabSelectedFrame = "tabBar_tabSelected",
	iconInActiveFrame = "tabBar_iconInactive",
	iconActiveFrame = "tabBar_iconActive",
}

-----------------------------------------------------------------------------------------
-- spinner
-----------------------------------------------------------------------------------------

theme.spinner = 
{
	sheet = assetDir .. "/widget_theme_android.png",
	data = assetDir .. ".widget_theme_android",
	startFrame = "spinner_spinner",
	width = 40,
	height = 40,
	incrementEvery = 50,
	deltaAngle = 30,
}

-----------------------------------------------------------------------------------------
-- switch
-----------------------------------------------------------------------------------------

theme.switch = 
{
	-- Default (on/off switch)
	sheet = assetDir .. "/widget_theme_android.png",
	data = assetDir .. ".widget_theme_android",
	backgroundFrame = "switch_background",
	backgroundWidth = 165,
	backgroundHeight = 31,
	overlayFrame = "switch_overlay",
	overlayWidth = 83,
	overlayHeight = 31,
	handleDefaultFrame = "switch_handle",
	handleOverFrame = "switch_handleOver",
	mask = assetDir .. "/masks/switch/onOffMask.png",
	
	radio =
	{
		sheet = assetDir .. "/widget_theme_android.png",
		data = assetDir .. ".widget_theme_android",
		width = 33,
		height = 34,
		frameOff = "switch_radioButtonDefault",
		frameOn = "switch_radioButtonSelected",
	},
	checkbox = 
	{
		sheet = assetDir .. "/widget_theme_android.png",
		data = assetDir .. ".widget_theme_android",
		width = 33,
		height = 33,
		frameOff = "switch_checkboxDefault",
		frameOn = "switch_checkboxSelected",
	},
}

-----------------------------------------------------------------------------------------
-- stepper
-----------------------------------------------------------------------------------------

theme.stepper = 
{
	sheet = assetDir .. "/widget_theme_android.png",
	data = assetDir .. ".widget_theme_android",
	defaultFrame = "stepper_nonActive",
	noMinusFrame = "stepper_noMinus",
	noPlusFrame = "stepper_noPlus",
	minusActiveFrame = "stepper_minusActive",
	plusActiveFrame = "stepper_plusActive",
	width = 102,
	height = 38,
}

-----------------------------------------------------------------------------------------
-- progressView
-----------------------------------------------------------------------------------------

theme.progressView = 
{
	sheet = assetDir .. "/widget_theme_android.png",
	data = assetDir .. ".widget_theme_android",
	fillXOffset = 4,
	fillYOffset = 4,
	fillOuterWidth = 12,
	fillOuterHeight = 18,
	fillWidth = 8, 
	fillHeight = 10,
	
	fillOuterLeftFrame = "progressView_leftFillBorder",
	fillOuterMiddleFrame = "progressView_middleFillBorder",
	fillOuterRightFrame = "progressView_rightFillBorder",
	
	fillInnerLeftFrame = "progressView_leftFill",
	fillInnerMiddleFrame = "progressView_middleFill",
	fillInnerRightFrame = "progressView_rightFill",
}

-----------------------------------------------------------------------------------------
-- segmentedControl
-----------------------------------------------------------------------------------------

theme.segmentedControl = 
{
	sheet = assetDir .. "/widget_theme_android.png",
	data = assetDir .. ".widget_theme_android",
	width = 12,
	height = 29,
	leftSegmentFrame = "segmentedControl_left",
	leftSegmentSelectedFrame = "segmentedControl_leftOn",
	rightSegmentFrame = "segmentedControl_right",
	rightSegmentSelectedFrame = "segmentedControl_rightOn",
	middleSegmentFrame = "segmentedControl_middle",
	middleSegmentSelectedFrame = "segmentedControl_middleOn",
	dividerFrame = "segmentedControl_divider",
}

-----------------------------------------------------------------------------------------
-- searchField
-----------------------------------------------------------------------------------------

theme.searchField = 
{
    sheet = assetDir .. "/widget_theme_android.png",
    data = assetDir .. ".widget_theme_android",
    leftFrame = "searchField_leftEdge",
	rightFrame = "searchField_rightEdge",
	middleFrame = "searchField_middle",
	magnifyingGlassFrame = "searchField_magnifyingGlass",
    cancelFrame = "searchField_remove",
    edgeWidth = 17.5,
    edgeHeight = 30,
	magnifyingGlassFrameWidth = 16,
	magnifyingGlassFrameHeight = 17,
    cancelFrameWidth = 19,
    cancelFrameHeight = 19,
	textFieldWidth = 145,
	textFieldHeight = 20,
}

return theme
