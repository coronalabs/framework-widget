display.setStatusBar( display.DefaultStatusBar )

local widget = require( "widgetlib" )
--widget.setTheme( "theme_ios" )

local button = widget.newButton{
	label = "My Button",
	default = "widget_ios/button/sheetBlack/default.png",
	over = "widget_ios/button/sheetBlack/over.png",
	width = 278, height = 46,
	font = "Helvetica-Bold",
	fontSize = 20,
	labelColor = { default={255}, over={0} },
	emboss = false,
}

button.view:setReferencePoint( display.CenterReferencePoint )
button.x, button.y = display.contentWidth * 0.5, display.contentHeight * 0.5
