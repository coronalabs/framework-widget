-----------------------------------------------------------------------------------------
--
-- theme_ios.lua
--
-----------------------------------------------------------------------------------------

local themeTable = {}
local assetDir = "widget_ios/"

-----------------------------------------------------------------------------------------
--
-- slider
--
-----------------------------------------------------------------------------------------

themeTable.slider = {
	width = 220,
	leftImage = { assetDir .. "slider/slider_left.png", 32, 28 },
	rightImage = { assetDir .. "slider/slider_right.png", 32, 28 },
	maskImage = { assetDir .. "slider/slider_mask.png", 920, 64 },
	fillImage = { assetDir .. "slider/slider_fill.png", 800, 32 },
	handleImage = { assetDir .. "slider/slider_handle.png", 24, 28 }
}

-----------------------------------------------------------------------------------------
--
-- pickerWheel
--
-----------------------------------------------------------------------------------------

themeTable.pickerWheel = {
	maskFile=assetDir .. "pickerWheel/pickermask.png",
	glassFile=assetDir .. "pickerWheel/pickerglass.png",
	glassWidth=290, glassHeight=222,
	background=assetDir .. "pickerWheel/bg.png",
	backgroundWidth=2, backgroundHeight=222,
	separator=assetDir .. "pickerWheel/separator.png",
	separatorWidth=8, separatorHeight=1
}

-----------------------------------------------------------------------------------------

return themeTable