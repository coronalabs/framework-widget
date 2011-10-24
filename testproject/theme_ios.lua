-----------------------------------------------------------------------------------------
--
-- theme_ios.lua
--
-----------------------------------------------------------------------------------------
local modname = ...
local themeTable = {}
package.loaded[modname] = themeTable
local assetDir = "widget_ios/"

-----------------------------------------------------------------------------------------
--
-- button
--
-----------------------------------------------------------------------------------------
--
-- specify a "style" option to use different button styles on a per-button basis
--
-- example:
-- local button = widget.newButton{ style="blue1Small" }
--
-- NOTE: using a "style" is not required.
--
-----------------------------------------------------------------------------------------

themeTable.button = {
	-- if no style is specified, will use button default:
	default = assetDir .. "button/default.png",
	over = assetDir .. "button/over.png",
	width = 278, height = 46,
	font = "Helvetica-Bold",
	fontSize = 20,
	labelColor = { default={0}, over={255} },
	emboss = true,
	
	blue1Small = {
		default = assetDir .. "button/blue1Small/default.png",
		over = assetDir .. "button/blue1Small/over.png",
		width = 60, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	blue1Large = {
		default = assetDir .. "button/blue1Large/default.png",
		over = assetDir .. "button/blue1Large/over.png",
		width = 90, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	blue2Small = {
		default = assetDir .. "button/blue2Small/default.png",
		over = assetDir .. "button/blue2Small/over.png",
		width = 60, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	blue2Large = {
		default = assetDir .. "button/blue2Large/default.png",
		over = assetDir .. "button/blue2Large/over.png",
		width = 90, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	blackSmall = {
		default = assetDir .. "button/blackSmall/default.png",
		over = assetDir .. "button/blackSmall/over.png",
		width = 60, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	blackLarge = {
		default = assetDir .. "button/blackLarge/default.png",
		over = assetDir .. "button/blackLarge/over.png",
		width = 90, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	redSmall = {
		default = assetDir .. "button/redSmall/default.png",
		over = assetDir .. "button/redSmall/over.png",
		width = 60, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	redLarge = {
		default = assetDir .. "button/redLarge/default.png",
		over = assetDir .. "button/redLarge/over.png",
		width = 90, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	backSmall = {
		default = assetDir .. "button/backSmall/default.png",
		over = assetDir .. "button/backSmall/over.png",
		width = 60, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	backLarge = {
		default = assetDir .. "button/backLarge/default.png",
		over = assetDir .. "button/backLarge/over.png",
		width = 90, height = 30,
		font = "Helvetica-Bold",
		fontSize = 12,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	sheetGreen = {
		default = assetDir .. "button/sheetGreen/default.png",
		over = assetDir .. "button/sheetGreen/over.png",
		width = 278, height = 46,
		font = "Helvetica-Bold",
		fontSize = 20,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	sheetRed = {
		default = assetDir .. "button/sheetRed/default.png",
		over = assetDir .. "button/sheetRed/over.png",
		width = 278, height = 46,
		font = "Helvetica-Bold",
		fontSize = 20,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	sheetBlack = {
		default = assetDir .. "button/sheetBlack/default.png",
		over = assetDir .. "button/sheetBlack/over.png",
		width = 278, height = 46,
		font = "Helvetica-Bold",
		fontSize = 20,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	
	sheetYellow = {
		default = assetDir .. "button/sheetYellow/default.png",
		over = assetDir .. "button/sheetYellow/over.png",
		width = 278, height = 46,
		font = "Helvetica-Bold",
		fontSize = 20,
		labelColor = { default={255}, over={255} },
		emboss = true,
	}
}


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
	width = 296,
	maskFile=assetDir .. "pickerWheel/pickermask.png",
	glassFile=assetDir .. "pickerWheel/pickerglass.png",
	glassWidth=320, glassHeight=222,
	background=assetDir .. "pickerWheel/bg.png",
	backgroundWidth=1, backgroundHeight=222,
	separator=assetDir .. "pickerWheel/separator.png",
	separatorWidth=8, separatorHeight=1
}

-----------------------------------------------------------------------------------------

return themeTable