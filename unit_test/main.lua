-- Copyright (C) 2012 Corona Inc. All Rights Reserved.
-- File: main.lua

-- For xcode console output
io.output():setvbuf( "no" )

display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )
storyboard.gotoScene( "newStepper" )
