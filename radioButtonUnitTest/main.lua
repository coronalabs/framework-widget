display.setStatusBar(display.HiddenStatusBar)

local widget = require("widgetNew")

local background = display.newImage("background.png")

local platforms = display.newText("What platforms do you develop for?", 0, 0, "helvetica", 16)
platforms:setTextColor(0, 0, 0)
platforms.x, platforms.y = display.contentCenterX, 20

local text = display.newEmbossedText("iPhone", 80, 60, "helvetica", 30)
local text2 = display.newEmbossedText("iPad", 80, 120, "helvetica", 30)
local text3 = display.newEmbossedText("Android", 80, 180, "helvetica", 30)
local text4 = display.newEmbossedText("Mac", 80, 240, "helvetica", 30)
local text5 = display.newEmbossedText("Windows", 80, 300, "helvetica", 30)

local function onRadioButtonsTap( self )
	print("Radio Button Name:", self:getName()) -- Returns the buttons name if set
	print(self:getName(), " Button State:", self:getState()) -- returns the buttons current state
end

--3 Radio buttons with image parameters
local radioButton = widget.newRadioButton{
	left = 250,
	top = text.y - text.contentHeight * 0.5 - 10,
	default = "checkOff.png",
	selected = "checkOn.png",
	name = "DevelopForIphone",
	onTap = onRadioButtonsTap
}

local radioButton2 = widget.newRadioButton{
	left = 250,
	top = text2.y - text2.contentHeight * 0.5 - 10,
	default = "checkOff.png",
	selected = "checkOn.png",
	name = "DevelopForIpad",
	onTap = onRadioButtonsTap
}

local radioButton3 = widget.newRadioButton{
	left = 250,
	top = text3.y - text3.contentHeight * 0.5 - 10,
	default = "checkOff.png",
	selected = "checkOn.png",
	name = "DevelopForAndroid",
	onTap = onRadioButtonsTap
}

--2 without
local radioButton4 = widget.newRadioButton{
	left = 279,
	top = text4.y - text4.contentHeight * 0.5 + 18,
	radius = 25,
	name = "DevelopForMac",
	onTap = onRadioButtonsTap
}

--2 without
local radioButton5 = widget.newRadioButton{
	left = 279,
	top = text5.y - text5.contentHeight * 0.5 + 18,
	name = "DevelopForWindows",
	onTap = onRadioButtonsTap
}
