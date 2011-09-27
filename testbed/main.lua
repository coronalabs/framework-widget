--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK "Widget" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 1.3
--
-- Copyright (C) 2011 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Published changes made to this software and associated documentation and module files (the
-- "Software") may be used and distributed by ANSCA, Inc. without notification. Modifications
-- made to this software and associated documentation and module files may or may not become
-- part of an official software release. All modifications made to the software will be
-- licensed under these same terms and conditions.
--
--*********************************************************************************************

display.setStatusBar( display.DarkStatusBar )

local widget = require "widgetnew"

-- Skin options: ios, red, mono
--widget.setSkin( "mono" )

-- provide access to widgets to external module
skinSetting = widget.skinSetting
newEmbossedText = widget.newEmbossedText
newButton = widget.newButton
newSegmentedControl = widget.newSegmentedControl
newSlider = widget.newSlider
newToolbar = widget.newToolbar
newScrollView = widget.newScrollView
newTableView = widget.newTableView
newPickerWheel = widget.newPickerWheel
newRoundedRectButton = widget.newRoundedRectButton

-- vars
listBoxStart = display.statusBarHeight + 44	--> 44 is the default height of toolbar
local platformName = system.getInfo( "platformName" )
local modelName = system.getInfo( "model" )
local isAndroid = platformName == "Android"
local isAndroidSim = platformName == "Mac OS X" and modelName ~= "iPhone" and modelName ~= "iPhone4" and modelName ~= "iPad" and modelName ~= "iPhone Simulator"
local isiOS = platformName == "iPhone" or platformName == "iOS" or modelName == "iPod touch" or modelName == "iPhone" or modelName == "iPhone4" or modelName == "iPad"
local isiOSsim = platformName == "Mac OS X" and modelName == "iPhone" or modelName == "iPhone4" or modelName == "iPad" or modelName == "iPhone Simulator"

-- forward references
local apiList, appToolbar

if isiOS or isiOSsim then
	
	-- For iOS, load a different module depending on if user's device is
	-- an iPhone/iPod touch or an iPad.
	
	widget.setSkin( "iOS" )
	skinSetting = widget.skinSetting
	
	if modelName == "iPad" then
		require( "ipad" ).loadMod()
	
	else
		require( "iphone" ).loadMod()
	end

elseif isAndroid or isAndroidSim then
	
	-- Widgets should now work fine on Android (beta). It's recommended you use the "red" or "mono" theme.
	
	widget.setSkin( "red" )
	skinSetting = widget.skinSetting
	
	require( "iphone" ).loadMod()
end
