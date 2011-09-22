--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK Widget Module
-- ====================================================================
--
-- File: widget.lua
--
-- Version 0.1.8 (BETA)
--
-- Copyright (C) 2011 ANSCA Inc. All Rights Reserved.
--
--*********************************************************************************************

module(..., package.seeall)

-- localize some math functions
local mFloor = math.floor
local mCeil = math.ceil
local mAbs = math.abs

-- localize some corona items
local currentStage = display.getCurrentStage()

--
--

version = "0.1.8 (Beta)"

-- use as a substitute for nil params tables
local dummyEmpty = {}


--
--

----------------------------------------------------------------------------------------------------
--
-- ++(START) Skin Settings and tables for storing widget-specific settings/resource locations
--
----------------------------------------------------------------------------------------------------

-- In the future, the table below will be populated through a function which will read
-- in a special Corona package (.cpk?). For now, the table is pre-populated:

local defaultBase = system.ResourceDirectory

--************************************************************
--
-- ANDROID
--
--************************************************************

androidSkin = {

	defaultFont = "DroidSans",
	
	--************************************************************
	--
	-- Rounded Rect Button (basic ui button, non-toolbar)
	--
	--************************************************************
	
	roundedRectButton = {
		cornerRadius = 5,
		upText = { 0, 0, 0 },
		downText = { 255, 255, 255 },
		upFill = { 215, 215, 215 },
		downFill = { 232, 156, 0 },
		borderColor = { 0, 0, 0 },
		fontFamily = "DroidSans",
		fontSize = 14
	},
	
	--************************************************************
	--
	-- UI Button (toolbar-style button)
	--
	--************************************************************
	
	uiButton = {
		upText = { 0, 0, 0 },
		fontEmboss = true,
		fontFamily = "DroidSans",
		fontSize = 14,
		leftImages = { up="uiButton/uibutton_left.png", down="uiButton/uibutton_left-over.png", w=6, h=44 },
		midImages = { up="uiButton/uibutton_mid.png", down="uiButton/uibutton_mid-over.png", w=4, h=44 },
		rightImages = { up="uiButton/uibutton_right.png", down="uiButton/uibutton_right-over.png", w=6, h=44 },
		labelPadding = 20
	},
	
	--************************************************************
	--
	-- UI Slider (variable width)
	--
	--************************************************************
	
	uiSlider = {
		width = 220,
		leftImage = { "uiSlider/slider_left.png", 32, 28 },
		rightImage = { "uiSlider/slider_right.png", 32, 28 },
		maskImage = { "uiSlider/slider_mask.png", 920, 64 },
		fillImage = { "uiSlider/slider_fill.png", 800, 32 },
		handleImage = { "uiSlider/slider_handle.png", 16, 32 }
	}
}

--****************************************************************
--
-- iOS
--
--****************************************************************

iosSkin = {

	defaultFont = "Helvetica",
	
	--************************************************************
	--
	-- Rounded Rect Button (basic ui button, non-toolbar)
	--
	--************************************************************
	
	roundedRectButton = {
		cornerRadius = 11,
		upText = { 0, 0, 0 },
		downText = { 255, 255, 255 },
		upFill = { 255, 255, 255 },
		downFill = { 80, 140, 235 },
		borderColor = { 187, 187, 187 },
		fontFamily = "Helvetica-Bold",
		fontSize = 15
	},
	
	--************************************************************
	--
	-- UI Button (toolbar-style button)
	--
	--************************************************************
	
	uiButton = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = "HelveticaNeue-Bold",
		fontSize = 14,
		leftImages = { up="uiButton/barbutton_left.png", down="uiButton/barbutton_left-over.png", w=6, h=30 },
		midImages = { up="uiButton/barbutton_mid.png", down="uiButton/barbutton_mid-over.png", w=4, h=30 },
		rightImages = { up="uiButton/barbutton_right.png", down="uiButton/barbutton_right-over.png", w=6, h=30 },
		labelPadding = 20
	},
	
	uiButtonRed = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = "HelveticaNeue-Bold",
		fontSize = 14,
		leftImages = { up="uiButton/barbuttonred_left.png", down="uiButton/barbuttonred_left-over.png", w=6, h=30 },
		midImages = { up="uiButton/barbuttonred_mid.png", down="uiButton/barbuttonred_mid-over.png", w=4, h=30 },
		rightImages = { up="uiButton/barbuttonred_right.png", down="uiButton/barbuttonred_right-over.png", w=6, h=30 },
		labelPadding = 20
	},
	
	--************************************************************
	--
	-- Segmented Control (toolbar-style)
	--
	--************************************************************
	
	segmentedControl = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = "HelveticaNeue-Bold",
		fontSize = 12,
		leftImages = {
			left =	{ up="segControl/segbuttonleft_left.png", down="segControl/segbuttonleft_left-over.png", w=6, h=30 },
			right = { up="segControl/segbuttonleft_right.png", down="segControl/segbuttonleft_right-over.png", w=6, h=30 }
		},
		rightImages = {
			left =	{ up="segControl/segbuttonright_left.png", down="segControl/segbuttonright_left-over.png", w=6, h=30 },
			right = { up="segControl/segbuttonright_right.png", down="segControl/segbuttonright_right-over.png", w=6, h=30 }
		},
		midImages = { up="segControl/segbuttonmid.png", down="segControl/segbuttonmid-over.png", w=4, h=30 },
		labelPadding = 20
	},
	
	--************************************************************
	--
	-- UI Slider (variable width)
	--
	--************************************************************
	
	uiSlider = {
		width = 220,
		leftImage = { "uiSlider/slider_left.png", 32, 28 },
		rightImage = { "uiSlider/slider_right.png", 32, 28 },
		maskImage = { "uiSlider/slider_mask.png", 920, 56 },
		fillImage = { "uiSlider/slider_fill.png", 800, 28 },
		handleImage = { "uiSlider/slider_handle.png", 24, 28 }
	},
	
	--************************************************************
	--
	-- Nav/Toolbar (variable width)
	--
	--************************************************************
	
	navToolbar = {
		font = "HelveticaNeue-Bold",
		size = 20,
		gradientImage = { "navToolbar/toolbargradient-bg.png", 1, 44 }
	},
	
	--************************************************************
	--
	-- scrollView
	--
	--************************************************************
	
	scrollView = {
		mask100 = { "scrollView/mask-100.png" },
		mask128 = { "scrollView/mask-128.png" },
		mask176 = { "scrollView/mask-176.png" },
		mask200 = { "scrollView/mask-200.png" },
		mask208 = { "scrollView/mask-208.png" },
		mask240 = { "scrollView/mask-240.png" },
		mask256 = { "scrollView/mask-256.png" },
		mask300 = { "scrollView/mask-300.png" },
		mask320 = { "scrollView/mask-320.png" },
		mask384 = { "scrollView/mask-384.png" },
		mask400 = { "scrollView/mask-400.png" },
		mask480 = { "scrollView/mask-480.png" },
		mask500 = { "scrollView/mask-500.png" },
		mask512 = { "scrollView/mask-512.png" },
		mask600 = { "scrollView/mask-600.png" },
		mask624 = { "scrollView/mask-624.png" },
		mask700 = { "scrollView/mask-700.png" },
		mask752 = { "scrollView/mask-752.png" },
		mask768 = { "scrollView/mask-768.png" },
		mask800 = { "scrollView/mask-800.png" },
		mask1024 = { "scrollView/mask-1024.png" }
	},
	
	--************************************************************
	--
	-- tableView
	--
	--************************************************************
	
	tableView = {
		mask100 = { "tableView/mask-100.png" },
		mask128 = { "tableView/mask-128.png" },
		mask176 = { "tableView/mask-176.png" },
		mask200 = { "tableView/mask-200.png" },
		mask208 = { "tableView/mask-208.png" },
		mask240 = { "tableView/mask-240.png" },
		mask256 = { "tableView/mask-256.png" },
		mask300 = { "tableView/mask-300.png" },
		mask320 = { "tableView/mask-320.png" },
		mask384 = { "tableView/mask-384.png" },
		mask400 = { "tableView/mask-400.png" },
		mask480 = { "tableView/mask-480.png" },
		mask500 = { "tableView/mask-500.png" },
		mask512 = { "tableView/mask-512.png" },
		mask600 = { "tableView/mask-600.png" },
		mask624 = { "tableView/mask-624.png" },
		mask700 = { "tableView/mask-700.png" },
		mask752 = { "tableView/mask-752.png" },
		mask768 = { "tableView/mask-768.png" },
		mask800 = { "tableView/mask-800.png" },
		mask1024 = { "tableView/mask-1024.png" },
		
		categoryBg = { img = "tableView/categoryBg.png", w=1, h=24 },
		rightArrow = { img = "tableView/rightArrow.png", w=10, h=14 },
		
		titleFont = "HelveticaNeue-Bold",
		titleSize = 18,
		descFont = "HelveticaNeue",
		descSize = 14,
		categoryFont = "HelveticaNeue-Bold",
		categorySize = 18
	},
	
	--************************************************************
	--
	-- pickerWheel
	--
	--************************************************************
	
	pickerWheel = {
		pickerBg = { "pickerWheel/pickerBg.png", 1, 222 },
		pickerGloss = { "pickerWheel/pickerGloss.png", 320, 222 },
		columnSeparator = { "pickerWheel/columnSeparator.png", 8, 1 },
		pickerMask = "pickerWheel/pickerMask.png",
		font = "HelveticaNeue-Bold",
		size = 24
	}
}

--****************************************************************
--
-- RED theme
--
--****************************************************************

redSkin = {
	
	defaultFont = native.systemFont,
	
	--************************************************************
	--
	-- Rounded Rect Button (basic ui button, non-toolbar)
	--
	--************************************************************
	
	roundedRectButton = {
		cornerRadius = 8,
		upText = { 255, 255, 255 },
		downText = { 255, 255, 255 },
		upFill = { 154, 0, 0 },
		downFill = { 0, 0, 0 },
		borderColor = { 154, 0, 0 },
		fontFamily = native.systemFont,
		fontSize = 14
	},
	
	--************************************************************
	--
	-- UI Button (toolbar-style button)
	--
	--************************************************************
	
	uiButton = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = "HelveticaNeue-Bold",
		fontSize = 14,
		leftImages = { up="uiButton/barbutton_left.png", down="uiButton/barbutton_left-over.png", w=6, h=30 },
		midImages = { up="uiButton/barbutton_mid.png", down="uiButton/barbutton_mid-over.png", w=4, h=30 },
		rightImages = { up="uiButton/barbutton_right.png", down="uiButton/barbutton_right-over.png", w=6, h=30 },
		labelPadding = 20
	},
	
	uiButtonRed = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = "HelveticaNeue-Bold",
		fontSize = 14,
		leftImages = { up="uiButton/barbuttonred_left.png", down="uiButton/barbuttonred_left-over.png", w=6, h=30 },
		midImages = { up="uiButton/barbuttonred_mid.png", down="uiButton/barbuttonred_mid-over.png", w=4, h=30 },
		rightImages = { up="uiButton/barbuttonred_right.png", down="uiButton/barbuttonred_right-over.png", w=6, h=30 },
		labelPadding = 20
	},
	
	--************************************************************
	--
	-- Segmented Control (toolbar-style)
	--
	--************************************************************
	
	segmentedControl = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = native.systemFont,
		fontSize = 12,
		leftImages = {
			left =	{ up="segControl/segbuttonleft_left.png", down="segControl/segbuttonleft_left-over.png", w=6, h=30 },
			right = { up="segControl/segbuttonleft_right.png", down="segControl/segbuttonleft_right-over.png", w=6, h=30 }
		},
		rightImages = {
			left =	{ up="segControl/segbuttonright_left.png", down="segControl/segbuttonright_left-over.png", w=6, h=30 },
			right = { up="segControl/segbuttonright_right.png", down="segControl/segbuttonright_right-over.png", w=6, h=30 }
		},
		midImages = { up="segControl/segbuttonmid.png", down="segControl/segbuttonmid-over.png", w=4, h=30 },
		labelPadding = 20
	},
	
	--************************************************************
	--
	-- UI Slider (variable width)
	--
	--************************************************************
	
	uiSlider = {
		width = 220,
		leftImage = { "uiSlider/slider_left.png", 32, 28 },
		rightImage = { "uiSlider/slider_right.png", 32, 28 },
		maskImage = { "uiSlider/slider_mask.png", 920, 56 },
		fillImage = { "uiSlider/slider_fill.png", 800, 28 },
		handleImage = { "uiSlider/slider_handle.png", 24, 28 }
	},
	
	--************************************************************
	--
	-- Nav/Toolbar (variable width)
	--
	--************************************************************
	
	navToolbar = {
		font = native.systemFont,
		size = 18,
		gradientImage = { "navToolbar/toolbargradient-bg.png", 1, 44 }
	},
	
	--************************************************************
	--
	-- scrollView
	--
	--************************************************************
	
	scrollView = {
		mask100 = { "scrollView/mask-100.png" },
		mask128 = { "scrollView/mask-128.png" },
		mask176 = { "scrollView/mask-176.png" },
		mask200 = { "scrollView/mask-200.png" },
		mask208 = { "scrollView/mask-208.png" },
		mask240 = { "scrollView/mask-240.png" },
		mask256 = { "scrollView/mask-256.png" },
		mask300 = { "scrollView/mask-300.png" },
		mask320 = { "scrollView/mask-320.png" },
		mask384 = { "scrollView/mask-384.png" },
		mask400 = { "scrollView/mask-400.png" },
		mask480 = { "scrollView/mask-480.png" },
		mask500 = { "scrollView/mask-500.png" },
		mask512 = { "scrollView/mask-512.png" },
		mask600 = { "scrollView/mask-600.png" },
		mask624 = { "scrollView/mask-624.png" },
		mask700 = { "scrollView/mask-700.png" },
		mask752 = { "scrollView/mask-752.png" },
		mask768 = { "scrollView/mask-768.png" },
		mask800 = { "scrollView/mask-800.png" },
		mask1024 = { "scrollView/mask-1024.png" }
	},
	
	--************************************************************
	--
	-- tableView
	--
	--************************************************************
	
	tableView = {
		mask100 = { "tableView/mask-100.png" },
		mask128 = { "tableView/mask-128.png" },
		mask176 = { "tableView/mask-176.png" },
		mask200 = { "tableView/mask-200.png" },
		mask208 = { "tableView/mask-208.png" },
		mask240 = { "tableView/mask-240.png" },
		mask256 = { "tableView/mask-256.png" },
		mask300 = { "tableView/mask-300.png" },
		mask320 = { "tableView/mask-320.png" },
		mask384 = { "tableView/mask-384.png" },
		mask400 = { "tableView/mask-400.png" },
		mask480 = { "tableView/mask-480.png" },
		mask500 = { "tableView/mask-500.png" },
		mask512 = { "tableView/mask-512.png" },
		mask600 = { "tableView/mask-600.png" },
		mask624 = { "tableView/mask-624.png" },
		mask700 = { "tableView/mask-700.png" },
		mask752 = { "tableView/mask-752.png" },
		mask768 = { "tableView/mask-768.png" },
		mask800 = { "tableView/mask-800.png" },
		mask1024 = { "tableView/mask-1024.png" },
		
		categoryBg = { img = "tableView/categoryBg.png", w=1, h=24 },
		rightArrow = { img = "tableView/rightArrow.png", w=10, h=14 },
		
		titleFont = native.systemFont,
		titleSize = 18,
		descFont = native.systemFont,
		descSize = 12,
		categoryFont = native.systemFont,
		categorySize = 16
	},
	
	--************************************************************
	--
	-- pickerWheel
	--
	--************************************************************
	
	pickerWheel = {
		pickerBg = { "pickerWheel/pickerBg.png", 1, 222 },
		pickerGloss = { "pickerWheel/pickerGloss.png", 320, 222 },
		columnSeparator = { "pickerWheel/columnSeparator.png", 8, 1 },
		pickerMask = "pickerWheel/pickerMask.png",
		font = native.systemFont,
		size = 20
	}
}

--****************************************************************
--
-- MONO theme
--
--****************************************************************

monoSkin = {
	
	defaultFont = native.systemFont,
	
	--************************************************************
	--
	-- Rounded Rect Button (basic ui button, non-toolbar)
	--
	--************************************************************
	
	roundedRectButton = {
		cornerRadius = 8,
		upText = { 255, 255, 255 },
		downText = { 255, 255, 255 },
		upFill = { 74, 74, 74 },
		downFill = { 0, 0, 0 },
		borderColor = { 74, 74, 74 },
		fontFamily = native.systemFont,
		fontSize = 14
	},
	
	--************************************************************
	--
	-- UI Button (toolbar-style button)
	--
	--************************************************************
	
	uiButton = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = "HelveticaNeue-Bold",
		fontSize = 14,
		leftImages = { up="uiButton/barbutton_left.png", down="uiButton/barbutton_left-over.png", w=6, h=30 },
		midImages = { up="uiButton/barbutton_mid.png", down="uiButton/barbutton_mid-over.png", w=4, h=30 },
		rightImages = { up="uiButton/barbutton_right.png", down="uiButton/barbutton_right-over.png", w=6, h=30 },
		labelPadding = 20
	},
	
	uiButtonRed = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = "HelveticaNeue-Bold",
		fontSize = 14,
		leftImages = { up="uiButton/barbuttonred_left.png", down="uiButton/barbuttonred_left-over.png", w=6, h=30 },
		midImages = { up="uiButton/barbuttonred_mid.png", down="uiButton/barbuttonred_mid-over.png", w=4, h=30 },
		rightImages = { up="uiButton/barbuttonred_right.png", down="uiButton/barbuttonred_right-over.png", w=6, h=30 },
		labelPadding = 20
	},
	
	--************************************************************
	--
	-- Segmented Control (toolbar-style)
	--
	--************************************************************
	
	segmentedControl = {
		upText = { 255, 255, 255 },
		fontEmboss = true,
		fontFamily = native.systemFont,
		fontSize = 12,
		leftImages = {
			left =	{ up="segControl/segbuttonleft_left.png", down="segControl/segbuttonleft_left-over.png", w=6, h=30 },
			right = { up="segControl/segbuttonleft_right.png", down="segControl/segbuttonleft_right-over.png", w=6, h=30 }
		},
		rightImages = {
			left =	{ up="segControl/segbuttonright_left.png", down="segControl/segbuttonright_left-over.png", w=6, h=30 },
			right = { up="segControl/segbuttonright_right.png", down="segControl/segbuttonright_right-over.png", w=6, h=30 }
		},
		midImages = { up="segControl/segbuttonmid.png", down="segControl/segbuttonmid-over.png", w=4, h=30 },
		labelPadding = 20
	},
	
	--************************************************************
	--
	-- UI Slider (variable width)
	--
	--************************************************************
	
	uiSlider = {
		width = 220,
		leftImage = { "uiSlider/slider_left.png", 32, 28 },
		rightImage = { "uiSlider/slider_right.png", 32, 28 },
		maskImage = { "uiSlider/slider_mask.png", 920, 56 },
		fillImage = { "uiSlider/slider_fill.png", 800, 28 },
		handleImage = { "uiSlider/slider_handle.png", 24, 28 }
	},
	
	--************************************************************
	--
	-- Nav/Toolbar (variable width)
	--
	--************************************************************
	
	navToolbar = {
		font = native.systemFont,
		size = 18,
		gradientImage = { "navToolbar/toolbargradient-bg.png", 1, 44 }
	},
	
	--************************************************************
	--
	-- scrollView
	--
	--************************************************************
	
	scrollView = {
		mask100 = { "scrollView/mask-100.png" },
		mask128 = { "scrollView/mask-128.png" },
		mask176 = { "scrollView/mask-176.png" },
		mask200 = { "scrollView/mask-200.png" },
		mask208 = { "scrollView/mask-208.png" },
		mask240 = { "scrollView/mask-240.png" },
		mask256 = { "scrollView/mask-256.png" },
		mask300 = { "scrollView/mask-300.png" },
		mask320 = { "scrollView/mask-320.png" },
		mask384 = { "scrollView/mask-384.png" },
		mask400 = { "scrollView/mask-400.png" },
		mask480 = { "scrollView/mask-480.png" },
		mask500 = { "scrollView/mask-500.png" },
		mask512 = { "scrollView/mask-512.png" },
		mask600 = { "scrollView/mask-600.png" },
		mask624 = { "scrollView/mask-624.png" },
		mask700 = { "scrollView/mask-700.png" },
		mask752 = { "scrollView/mask-752.png" },
		mask768 = { "scrollView/mask-768.png" },
		mask800 = { "scrollView/mask-800.png" },
		mask1024 = { "scrollView/mask-1024.png" }
	},
	
	--************************************************************
	--
	-- tableView
	--
	--************************************************************
	
	tableView = {
		mask100 = { "tableView/mask-100.png" },
		mask128 = { "tableView/mask-128.png" },
		mask176 = { "tableView/mask-176.png" },
		mask200 = { "tableView/mask-200.png" },
		mask208 = { "tableView/mask-208.png" },
		mask240 = { "tableView/mask-240.png" },
		mask256 = { "tableView/mask-256.png" },
		mask300 = { "tableView/mask-300.png" },
		mask320 = { "tableView/mask-320.png" },
		mask384 = { "tableView/mask-384.png" },
		mask400 = { "tableView/mask-400.png" },
		mask480 = { "tableView/mask-480.png" },
		mask500 = { "tableView/mask-500.png" },
		mask512 = { "tableView/mask-512.png" },
		mask600 = { "tableView/mask-600.png" },
		mask624 = { "tableView/mask-624.png" },
		mask700 = { "tableView/mask-700.png" },
		mask752 = { "tableView/mask-752.png" },
		mask768 = { "tableView/mask-768.png" },
		mask800 = { "tableView/mask-800.png" },
		mask1024 = { "tableView/mask-1024.png" },
		
		categoryBg = { img = "tableView/categoryBg.png", w=1, h=24 },
		rightArrow = { img = "tableView/rightArrow.png", w=10, h=14 },
		
		titleFont = native.systemFont,
		titleSize = 18,
		descFont = native.systemFont,
		descSize = 12,
		categoryFont = native.systemFont,
		categorySize = 16
	},
	
	--************************************************************
	--
	-- pickerWheel
	--
	--************************************************************
	
	pickerWheel = {
		pickerBg = { "pickerWheel/pickerBg.png", 1, 222 },
		pickerGloss = { "pickerWheel/pickerGloss.png", 320, 222 },
		columnSeparator = { "pickerWheel/columnSeparator.png", 8, 1 },
		pickerMask = "pickerWheel/pickerMask.png",
		font = native.systemFont,
		size = 20
	}
}

skinBase = defaultBase				--> default base directory for interface-related resource look-up
skinPackage = "widget_ios"	--> until .cpk is ready, will be read as such: skinBase .. skinPackage .. "/" .. "resourceFile.png" (example)
skinSetting = iosSkin				--> defaults to iOS-style widgets

----------------------------------------------------------------------------------------------------
--
-- ++(START) setSkin() public function to set "style" of interface widgets
--
----------------------------------------------------------------------------------------------------

setSkin = function( interfaceLib )
	
	if not interfaceLib then
		interfaceLib = "ios"	--> default to iOS style widgets
	end
	
	interfaceLib = string.lower(interfaceLib)
	
	if interfaceLib == "ios" then
		skinSetting = iosSkin
		skinPackage = "widget_ios"
	
	elseif interfaceLib == "android" then
		skinSetting = androidSkin
		skinPackage = "widget_android"
	
	elseif interfaceLib == "red" then
		skinSetting = redSkin
		skinPackage = "widget_red"
	
	elseif interfaceLib == "mono" then
		skinSetting = monoSkin
		skinPackage = "widget_mono"
	
	else
		skinSetting = iosSkin
		skinPackage = "widget_ios"
	end
end

local getSkinTable = function( interfaceLib )
	
	local result = iosSkin
	
	if interfaceLib then
		
		if interfaceLib == "ios" then
			result = iosSkin
		
		elseif interfaceLib == "red" then
			result = redSkin
		
		elseif interfaceLib == "mono" then
			result = monoSkin
		end
	end
	
	return result
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) display.newGroup() patch to include sliding effects
--
----------------------------------------------------------------------------------------------------

local addSlideEffects = function( displayObject )
	
	local o = displayObject
	
	--=============================================================
	--
	-- Add sliding effects to display groups
	--
	--=============================================================
	
	--
	--
	
	-- LEFT slide effect
	o.slideLeft = function( self, params )
		
		local params = params or {}
		
		local slideTime = params.time or 450
		local slideDistance = params.distance or self.width
		local slideAlpha = params.alpha or self.alpha
		local onComplete = params.onComplete or nil
		
		transition.to( self, { time=slideTime, x=self.x-slideDistance, alpha=slideAlpha, transition=easing.outQuad, onComplete=onComplete } )
	end
	
	
	-- RIGHT slide effect
	o.slideRight = function( self, params )
		
		local params = params or {}
		
		local slideTime = params.time or 450
		local slideDistance = params.distance or self.width
		local slideAlpha = params.alpha or self.alpha
		local onComplete = params.onComplete or nil
		
		transition.to( self, { time=slideTime, x=self.x+slideDistance, alpha=slideAlpha, transition=easing.outQuad, onComplete=onComplete } )
	end
	
	
	-- UP slide effect
	o.slideUp = function( self, params )
		
		local params = params or {}
		
		local slideTime = params.time or 450
		local slideDistance = params.distance or self.height
		local slideAlpha = params.alpha or self.alpha
		local onComplete = params.onComplete or nil
		
		transition.to( self, { time=slideTime, y=self.y-slideDistance, alpha=slideAlpha, transition=easing.outQuad, onComplete=onComplete } )
	end
	
	
	-- DOWN slide effect
	o.slideDown = function( self, params )
		
		local params = params or {}
		
		local slideTime = params.time or 450
		local slideDistance = params.distance or self.height
		local slideAlpha = params.alpha or self.alpha
		local onComplete = params.onComplete or nil
		
		transition.to( self, { time=slideTime, y=self.y+slideDistance, alpha=slideAlpha, transition=easing.outQuad, onComplete=onComplete } )
	end
	
	--
	--
	
end

local oldNewGroup = display.newGroup
display.newGroup = function(...)
    local group = oldNewGroup(...)
    addSlideEffects( group )
    return group
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newText() patch :: to be compatible with content scaling (e.g. retina display text)
--
----------------------------------------------------------------------------------------------------

local priorNewText = display.newText

display.newText = function( ... )
	
	-- SYNTAX: display.newText( parentGroup, text, x, y, font, size )
	
	local	parentG
	local 	hasParent = false
	local 	argOffset = 0
	
	if arg and type(arg[1]) == "table" then
		parentG = arg[1]
		argOffset = 1
		hasParent = true
	end
	
	local actualText	=	arg[1+argOffset] or ""
	local xPosition		=	arg[2+argOffset] or 0
	local yPosition		=	arg[3+argOffset] or 0
	local actualFont	=	arg[4+argOffset] or native.systemFont
	local actualSize	=	arg[5+argOffset] or 12
	
	
	----------
	
	local xScale, yScale = display.contentScaleX, display.contentScaleY
	local sizeMultiply = 1
	
	-- if the content scale is less than 1.0 (anything higher resolution than original iPhone), multiply text size by 2 (and then size down based on contentScaleX/Y)
	if xScale < 1 or yScale < 1 then
		sizeMultiply = 2
	end
	
	local t = priorNewText( actualText, 0, 0, actualFont, actualSize * sizeMultiply )
	
	-- reset the reference point on the text object
	t:setReferencePoint( display.TopLeftReferencePoint )	-- fix for casenum: 6911
	
	t.xScale, t.yScale = xScale, yScale
	t.x, t.y = xPosition, yPosition or 0, 0
	
	-- insert into group (if group exists)
	if hasParent then parentG:insert( t ); end
	
	return t
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newEmbossedText() - returns a display group, not a normal text object as with newText
--
----------------------------------------------------------------------------------------------------

newEmbossedText = function( text, xPos, yPos, font, size, fontColor, isCategory, offset )
	
	local actualText = text or ""
	local actualFont = font or native.systemFont
	local actualSize = size or 16
	local actualColor = fontColor or { 255, 255, 255 }
	local x = xPos or 0
	local y = yPos or 0
	local offset = offset or 0
	
	local textGroup = display.newGroup()
	
	local labelHighlight
	local labelShadow
	local labelText
	
	local r, g, b = actualColor[1], actualColor[2], actualColor[3]
	local textBrightness = ( r + g + b ) / 3
	
	-- SET UP LABEL HIGHLIGHT TEXT LAYER:
	labelHighlight = display.newText( actualText, 0, 0, actualFont, actualSize )
	if ( textBrightness > 127) then
		labelHighlight:setTextColor( 255, 255, 255, 20 )
	else
		labelHighlight:setTextColor( 255, 255, 255, 140 )
	end
	
	
	if isCategory then
		labelHighlight.y = labelHighlight.y - 0.5
	else
		labelHighlight.y = labelHighlight.y + 0.5 + offset
		labelHighlight.x = labelHighlight.x + 1.5
	end
	
	-- SET UP LABEL SHADOW TEXT LAYER:
	labelShadow = display.newText( actualText, 0, 0, actualFont, actualSize )
	if ( textBrightness > 127) then
		if isCategory then
			labelShadow:setTextColor( 0, 0, 0, 200 )
		else
			labelShadow:setTextColor( 0, 0, 0, 128 )
		end
	else
		labelShadow:setTextColor( 0, 0, 0, 20 )
	end
		
	if isCategory then
		labelShadow.y = labelShadow.y + 0.5
		labelShadow.x = labelShadow.x + 0.5
	else
		labelShadow.y = labelShadow.y - 0.5
		labelShadow.x = labelShadow.x - 0.5 + offset
	end
	
	-- SET UP ACTUAL TEXT LAYER (that will be displayed)
	local labelText = display.newText( actualText, 0, 0, actualFont, actualSize )
	labelText:setTextColor( r, g, b, 255 )
	labelText.y = labelText.y + offset
	
	-- INSERT ALL TEXT LAYERS INTO THE DISPLAY GROUP
	textGroup:insert( labelHighlight )
	textGroup:insert( labelShadow )
	textGroup:insert( labelText )
	
	textGroup.x = x
	textGroup.y = y
	
	-- PUBLIC METHODS
	function textGroup:setText( newText, newColor )
		if newColor then
			r, g, b = newColor[1], newColor[2], newColor[3]
		end
		
		if not newText then newText = actualText end
		local textBrightness = ( r + g + b ) / 3
		
		self:setReferencePoint( display.TopLeftReferencePoint )
		labelHighlight:setReferencePoint( display.TopLeftReferencePoint )
		labelShadow:setReferencePoint( display.TopLeftReferencePoint )
		labelText:setReferencePoint( display.TopLeftReferencePoint )
		
		local oldX, oldY = self.x, self.y
		
		self.x, self.y = 0, 0
		labelHighlight.x, labelHighlight.y = 0, 0
		labelShadow.x, labelShadow.y = 0, 0
		labelText.x, labelText.y = 0, 0+offset
		
		-- reset labelHighlight
		labelHighlight.text = newText
		if ( textBrightness > 127) then
			labelHighlight:setTextColor( 255, 255, 255, 20 )
		else
			labelHighlight:setTextColor( 255, 255, 255, 140 )
		end
		
		if isCategory then
			labelHighlight.y = labelHighlight.y - 0.5
		else
			labelHighlight.y = labelHighlight.y + 1 + offset
			labelHighlight.x = labelHighlight.x + 1.5
		end
		
		-- reset labelShadow
		labelShadow.text = newText
		if ( textBrightness > 127) then
			labelShadow:setTextColor( 0, 0, 0, 128 )
		else
			labelShadow:setTextColor( 0, 0, 0, 20 )
		end
		
		if isCategory then
			labelShadow.y = labelShadow.y + 0.5
			labelShadow.x = labelShadow.x + 0.5;
		else
			labelShadow.y = labelShadow.y - 1
			labelShadow.x = labelShadow.x - 0.5 + offset
		end
		
		-- reset labelText
		labelText.text = newText
		labelText:setTextColor( r, g, b, 255 )
		
		-- reposition self
		self:setReferencePoint( display.TopLeftReferencePoint )
		self.x, self.y = x, y
		
		self.text = newText
		
		self.x, self.y = oldX, oldY
	end
	
	textGroup.text = actualText
	
	-- RETURN THE DISPLAY GROUP
	return textGroup
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) textWrapper()
--
----------------------------------------------------------------------------------------------------


local function textWrapper( text, font, size, color, width )

	if not text or text == "" then return nil; end

	font = font or native.systemFont
	size = tonumber(size) or 12
	color = color or { 0, 0, 0 }
	width = width or display.contentWidth

	local allText = display.newGroup()
	
	local lineCount = 0
	local tempDisplayLine, newDisplayLine
	
	-- process each line
	for line in string.gmatch(text, "[^\n]+") do
	
		local currentLine = ""
	
		local currentLineLength = 0		-- length of string
		local currentLineWidth = 0		-- width of string
		
		local testLineLength = 0 -- the target length of the string (starts at 0)
		
		-- iterate by each word
		for word, spacer in string.gmatch(line, "([^%s%-]+)([%s%-]*)") do
  			local tempLine = currentLine..word..spacer
  			local tempLineLength = string.len(tempLine)
  			
  			-- test to see if we are at a point to try to render the string
  			if testLineLength > tempLineLength then
				currentLine = tempLine
				currentLineLength = tempLineLength
			else
			
				-- line could be long enough, try to render and compare against the max width
				tempDisplayLine = display.newText(tempLine, 0, 0, font, size)
				local tempDisplayWidth = tempDisplayLine.width * display.contentScaleX
				tempDisplayLine:removeSelf()
				tempDisplayLine=nil
				
				if tempDisplayWidth <= width then
					-- line not long enough yet, save line and recalculate for the next render test
					currentLine = tempLine
					currentLineLength = tempLineLength
					testLineLength = math.floor((width*0.9) / (tempDisplayWidth/currentLineLength))
					
				else
					-- line long enough, show the old line then start the new one
					newDisplayLine = display.newText(currentLine, 0, (size * 1.3) * (lineCount - 1), font, size)
					newDisplayLine:setTextColor(color[1], color[2], color[3])
					allText:insert(newDisplayLine)
					lineCount = lineCount + 1
					currentLine = word..spacer
					currentLineLength = string.len(word)
				end
			end
		end
	
		-- finally display any remaining text for the current line
		newDisplayLine = display.newText(currentLine, 0, (size * 1.3) * (lineCount - 1), font, size)
		newDisplayLine:setTextColor(color[1], color[2], color[3])
		allText:insert(newDisplayLine)
		lineCount = lineCount + 1
		currentLine = ""
		currentLineLength = 0
	end
	
	allText:setReferencePoint(display.TopLeftReferencePoint)
	
	--
	--
	
	function allText:setTextColor( r, g, b, a )
		--[[
		if tempDisplayLine then
			tempDisplayLine:setTextColor( r, g, b, a )
		end
		
		if newDisplayLine then
			newDisplayLine:setTextColor( r, g, b, a )
		end
		]]--
		
		for i=allText.numChildren,1,-1 do
			if allText[i].setTextColor then
				allText[i]:setTextColor( r, g, b, a )
			end
		end
	end
	
	-----
	return allText
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newRoundedRectButton()
--
----------------------------------------------------------------------------------------------------

newRoundedRectButton = function( params )
	
	-- override skinSetting if one is specified for this widget
	local skinSetting = skinSetting
	if params and params.skin then
		skinSetting = getSkinTable( params.skin )
	end
	
	local id, x, y, width, height, upColor, downColor, label, labelUpColor, labelDownColor, borderColor, cornerRadius, fontSize, fontFamily, onPress, onRelease =
		"roundedRectButton", 0, 0, 148, 32, skinSetting.roundedRectButton.upFill,
			skinSetting.roundedRectButton.downFill, "Button", skinSetting.roundedRectButton.upText,
					skinSetting.roundedRectButton.downText, skinSetting.roundedRectButton.borderColor,
						skinSetting.roundedRectButton.cornerRadius, skinSetting.roundedRectButton.fontSize,
							skinSetting.roundedRectButton.fontFamily, nil, nil
	
	if params then
		id = params.id or id
		x = params.x or x
		y = params.y or y
		width = params.width or width
		height = params.height or height
		upColor = params.upColor or upColor
		downColor = params.downColor or downColor
		label = params.label or label
		labelUpColor = params.labelUpColor or labelUpColor
		labelDownColor = params.labelDownColor or labelDownColor
		borderColor = params.borderColor or borderColor
		cornerRadius = params.cornerRadius or cornerRadius
		fontSize = params.fontSize or fontSize
		fontFamily = params.fontFamily or fontFamily
		onPress = params.onPress or nil
		onRelease = params.onRelease or nil
	end
	
	-- Create empty table to hold button, label, etc.
	local t = display.newGroup()
	
	t.rect = display.newRoundedRect( x, y, width, height, cornerRadius )
	t.rect.strokeWidth = 1
	t.rect:setFillColor( upColor[1], upColor[2], upColor[3] )
	local color = borderColor
	t.rect:setStrokeColor( color[1], color[2], color[3] )
	t.rect.parentT = t
	
	-- CREATE A CENTERED LABEL FOR THE BUTTON
	local buttonCenterX = x + (width * 0.5)
	local buttonCenterY = y + (height * 0.5)
	
	t.label = display.newText( label, buttonCenterX, buttonCenterY, fontFamily, fontSize )
	local color = labelUpColor
	t.label:setTextColor( color[1], color[2], color[3] )
	t.label:setReferencePoint( display.CenterReferencePoint )
	t.label.x = buttonCenterX
	t.label.y = buttonCenterY
	
	------------------------------------------------------------------------------------------------
	--
	-- Button Touch Event
	--
	------------------------------------------------------------------------------------------------
	
	function t.rect:touch( event )
		
		local result = true
		
		if event.phase == "began" then
			
			currentStage:setFocus( self, event.id )
			self.isFocus = true
			
			-- Set color to downColor
			local color = downColor
			self:setFillColor( color[1], color[2], color[3] )
			
			-- Set label's down color
			local color = labelDownColor
			t.label:setTextColor( color[1], color[2], color[3] )
			
			-- Call onPress event if it exists
			if onPress then
				local newEvent = event
				newEvent.phase = "press"
				newEvent.target = self.parentT
				result = onPress( newEvent )
				if result == nil then result = false; end
			end
		
		elseif self.isFocus then
			
			local bounds = self.contentBounds
			local x, y = event.x, event.y
			local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
			
			if event.phase == "moved" then
				
				if not isWithinBounds then
					
					-- Reset fill color if finger is not within content bounds of button
					local color = upColor
					self:setFillColor( color[1], color[2], color[3] )
					
					-- Reset label's color
					local color = labelUpColor
					t.label:setTextColor( color[1], color[2], color[3] )
				
				else
					
					-- Set color back to original
					local color = downColor
					self:setFillColor( color[1], color[2], color[3] )
					
					-- Reset label's color
					local color = labelDownColor
					t.label:setTextColor( color[1], color[2], color[3] )
				end
			
			elseif event.phase == "cancelled" or event.phase == "ended" then
				
				
				-- Reset fill color
				local color = upColor
				self:setFillColor( color[1], color[2], color[3] )
				
				-- Reset label's color
				local color = labelUpColor
				t.label:setTextColor( color[1], color[2], color[3] )
				
				currentStage:setFocus( nil )
				self.isFocus = false
				
				if event.phase == "ended" and isWithinBounds then
					
					-- User lifts finger from button, while within stagebounds					
					if onRelease then
						
						local newEvent = event
						newEvent.phase = "release"
						newEvent.target = self.parentT
						
						-- call onRelease listener
						result = onRelease( newEvent )
					end
				end
			end
			
		end
		
		if result == nil then result = true; end
		
		return result
	end
	
	-- Assign touch listener to the button
	t.rect:addEventListener( "touch", t.rect )
	
	------------------------------------------------------------------------------------------------
	--
	-- Button Methods
	--
	------------------------------------------------------------------------------------------------
	
	-- setLabel() will set the buttons label to a new text string
	function t:setLabel( labelText )
		if labelText and type(labelText) == "string" then
			t.label.text = labelText
			
			t.label.x = buttonCenterX
			t.label.y = buttonCenterY
		end
	end
	
	-- getLabel will return the current label's text string (same as querying label.text)
	function t:getLabel()
		local labelText = t.label.text
		return labelText
	end
	
	
	-- Insert both the rectangle and label into button's display group:
	t:insert( t.rect )
	t:insert( t.label )
	
	-- Set the "id" of this button
	t.id = id
	
	-- Set the .view property to remain consistent with other widgets
	t.view = t
	
	return t
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) buttonEventHandler - newButton event handler
--
----------------------------------------------------------------------------------------------------

local buttonEventHandler = function( self, event )
	
	local result = true
	local up = self.up
	local down = self.down
	local label = self.label
	
	if event.phase == "began" then
		
		currentStage:setFocus( self, event.id )
		self.isFocus = true
		
		-- For segmented buttons
		
		if self.segmentedButton then
			
			-- Loop through each button in parent "control" group
			-- and depress all of the buttons
			
			for i=1,self.controlGroup.numChildren do
				self.controlGroup[i].up.isVisible = true
				self.controlGroup[i].down.isVisible = false
			end
		end
		
		-- End segmented button specific block
		
		up.isVisible = false
		down.isVisible = true
		
		-- Call onEvent or onPress event if it exists
		if self._onEvent then
			local newEvent = event
			newEvent.phase = "press"
			newEvent.target = self
			
			result = self._onEvent( newEvent )
			if result == nil then result = false; end
		else
			
			if self._onPress then
				local newEvent = event
				newEvent.target = self
				
				result = self._onPress( newEvent )
				if result == nil then result = false; end
			end
		end
	
	elseif self.isFocus then
		
		local bounds = self.contentBounds
		local x, y = event.x, event.y
		local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
		
		if event.phase == "moved" then
			
			if not self.segmentedButton then
				if not isWithinBounds then
					
					-- Show "up" button position
					up.isVisible = true
					down.isVisible = false
				
				else
					
					-- Show "down" button position
					up.isVisible = false
					down.isVisible = true
				end
			end
		
		elseif event.phase == "cancelled" or event.phase == "ended" then
			
			
			-- Show "up" button position
			if not self.segmentedButton then
				up.isVisible = true
				down.isVisible = false
			else
				
				-- segmented buttons (also tab bar buttons),
				-- remain depressed even after lifting finger.
				
				up.isVisible = false
				down.isVisible = true
			end
			
			currentStage:setFocus( nil )
			self.isFocus = false
			
			if event.phase == "ended" and isWithinBounds then
				
				-- User lifts finger from button, while within stagebounds					
				if self._onEvent then
					local newEvent = event
					newEvent.phase = "release"
					newEvent.target = self
					
					result = self._onEvent( newEvent )
					if result == nil then result = false; end
				else
				
					if self._onRelease then
						
						local newEvent = event
						newEvent.target = self
						
						-- call the onRelease listener
						result = self._onRelease( newEvent )
					end
				end
				
			end
		end
		
	end
	
	if result == nil then result = true; end
	
	return result
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newButton()
--
----------------------------------------------------------------------------------------------------

newButton = function( params )
	
	-- override skinSetting if one is specified for this widget
	local skinSetting = skinSetting
	if params and params.skin then
		skinSetting = getSkinTable( params.skin )
	end
	
	local skinTable = skinSetting.uiButton
	
	if not skinTable then return; end
	
	local leftTable = skinTable.leftImages
	local midTable = skinTable.midImages
	local rightTable = skinTable.rightImages
	
	-- setup dummy table for params (in case no parameters were set)
	if not params then params = dummyEmpty; end
	
	-- extract parameters or set to defaults
	local	id = params.id or "uiButton"
	local	x = params.x or 0
	local	y = params.y or 0
	local	offset = params.offset or 0
	local	label = params.label or "Button"
	local	labelUpColor = params.labelUpColor or params.textColor or skinSetting.uiButton.upText
	local	fontSize = params.fontSize or params.size or skinSetting.uiButton.fontSize
	local	fontFamily = params.fontFamily or params.font or skinSetting.uiButton.fontFamily
	local	leftImages = params.leftImages or { up = skinPackage .. "/" .. leftTable.up, down = skinPackage .. "/" .. leftTable.down, w = leftTable.w, h = leftTable.h, base = skinBase }
	local	midImages = params.midImages or { up = skinPackage .. "/" .. midTable.up, down = skinPackage .. "/" .. midTable.down, w = midTable.w, h = midTable.h, base = skinBase }
	local	rightImages = params.rightImages or { up = skinPackage .. "/" .. rightTable.up, down = skinPackage .. "/" .. rightTable.down, w = rightTable.w, h = rightTable.h, base = skinBase }
	local	isEmbossed = not params.emboss or skinSetting.uiButton.fontEmboss
	local	labelPadding = params.padding or skinSetting.uiButton.labelPadding
	local	onPress = params.onPress
	local	onRelease = params.onRelease
	local	onEvent = params.onEvent
	local	customImg = params.customImg
	local	default = params.default
	local	over = params.over
	local	width = params.width or 0
	local	height = params.height or midImages.h
	local	buttonTheme = params.buttonTheme or "blue"
	local	baseDir = params.baseDir or defaultBase
	
	-- check for customImg, if so, adjust height
	if customImg and customImg.height then height = customImg.height; end
	
	-- set default font to 20 to maintain some old ui.lua backwards compatibility
	if default and over and not params.fontSize and not params.size then fontSize = 20; end
	
	-- Change resources if this is going to be a "red" button (normally used for deletion/archiving)
	if buttonTheme == "red" then
		leftTable = skinSetting.uiButtonRed.leftImages
		midTable = skinSetting.uiButtonRed.midImages
		rightTable = skinSetting.uiButtonRed.rightImages
		
		leftImages = { up = skinPackage .. "/" .. leftTable.up, down = skinPackage .. "/" .. leftTable.down, w = leftTable.w, h = leftTable.h, base = skinBase }
		midImages = { up = skinPackage .. "/" .. midTable.up, down = skinPackage .. "/" .. midTable.down, w = midTable.w, h = midTable.h, base = skinBase }
		rightImages = { up = skinPackage .. "/" .. rightTable.up, down = skinPackage .. "/" .. rightTable.down, w = rightTable.w, h = rightTable.h, base = skinBase }
	end
	
	-- Create display groups for entire button, up images, down images, and label text
	local buttonGroup = display.newGroup()
	buttonGroup.label = display.newGroup()
	buttonGroup.up = display.newGroup()
	buttonGroup.down = display.newGroup()
	
	buttonGroup:insert( buttonGroup.down )
	buttonGroup:insert( buttonGroup.up )
	buttonGroup:insert( buttonGroup.label )
	
	-- Create tables (for metamethods, etc.)
	local t = { _view = buttonGroup }
	local mt = {}
	
	-- Calculate width of the button (to get an accurate button width)
	local midWidth = width - (leftImages.w + rightImages.w)
	local xS = midWidth / midImages.w
	
	
	local leftUp, midUp, rightUp, leftDown, midDown, rightDown
	local upImg
	
	-- Create the "up" (non-pressed, non-over) button face
	if not customImg or not customImg.up or not customImg.down then
		
		if not default and not over then
			leftUp = display.newImageRect( leftImages.up, leftImages.base, leftImages.w, leftImages.h )
			leftUp:setReferencePoint( display.TopLeftReferencePoint )
			leftUp.x, leftUp.y = 0, 0
			
			midUp = display.newImageRect( midImages.up, midImages.base, midImages.w, midImages.h )
			midUp:setReferencePoint( display.TopLeftReferencePoint )
			midUp.x, midUp.y = leftImages.w, 0
			midUp.xScale = xS
			
			rightUp = display.newImageRect( rightImages.up, rightImages.base, rightImages.w, rightImages.h )
			rightUp:setReferencePoint( display.TopLeftReferencePoint )
			rightUp.x, rightUp.y = leftImages.w + midWidth, 0
			
			-- Insert "up" images into the correct group
			buttonGroup.up:insert( leftUp )
			buttonGroup.up:insert( midUp )
			buttonGroup.up:insert( rightUp )
		end
	end
	
	if customImg or default and over then
	
		local upImgFile = default or customImg.up
		local height = height or customImg.height
		local theBase
		if customImg and customImg.baseDir then
			theBase = customImg.baseDir
		else
			theBase = defaultBase
		end
		if customImg and customImg.width then width = customImg.width; end
		if not height then height = 30; end
		
		if width and width ~= 0 then
			upImg = display.newImageRect( upImgFile, theBase, width, height )
		else
			upImg = display.newImage( upImgFile, theBase )
		end
		
		upImg:setReferencePoint( display.TopLeftReferencePoint )
		upImg.x, upImg.y = 0, 0
		
		buttonGroup.up:insert( upImg )
	end
	
	
	-- Create the "down" (over) button face
	if not customImg or not customImg.up or not customImg.down then
		
		if not default and not over then
			leftDown = display.newImageRect( leftImages.down, leftImages.base, leftImages.w, leftImages.h )
			leftDown:setReferencePoint( display.TopLeftReferencePoint )
			leftDown.x, leftDown.y = 0, 0
			
			midDown = display.newImageRect( midImages.down, midImages.base, midImages.w, midImages.h )
			midDown:setReferencePoint( display.TopLeftReferencePoint )
			midDown.x, midDown.y = leftImages.w, 0
			midDown.xScale = xS
			
			rightDown = display.newImageRect( rightImages.down, rightImages.base, rightImages.w, rightImages.h )
			rightDown:setReferencePoint( display.TopLeftReferencePoint )
			rightDown.x, rightDown.y = leftImages.w + midWidth, 0
			
			-- Insert "down" images into the correct group
			buttonGroup.down:insert( leftDown )
			buttonGroup.down:insert( midDown )
			buttonGroup.down:insert( rightDown )
		end
	end
	
	if customImg or default and over then
		local downImgFile = over or customImg.down
		local height = height or customImg.height
		if customImg and customImg.baseDir then
			theBase = customImg.baseDir
		else
			theBase = defaultBase
		end
		if not height then height = 30; end
		local downImg
		
		if width and width ~= 0 then
			downImg = display.newImageRect( downImgFile, theBase, width, height )
		else
			downImg = display.newImage( downImgFile, theBase )
		end
		downImg:setReferencePoint( display.TopLeftReferencePoint )
		downImg.x, downImg.y = 0, 0
		
		buttonGroup.down:insert( downImg )
	end
	
	-- Make the "down" group invisible (starting off)
	buttonGroup.down.isVisible = false
	
	-- Create button's label text
	local labelText
	local xPos, yPos = width * 0.5, height * 0.5
	
	if width == 0 and default and over then
		width = upImg.width
		height = upImg.height
		
		xPos = width * 0.5
		yPos = height * 0.5
		
	end
	
	if isEmbossed then
		labelText = newEmbossedText( label, 0, 0, fontFamily, fontSize, labelUpColor, false, offset )
	else
		labelText = display.newText( label, 0, 0+offset, fontFamily, fontSize )
		labelText:setTextColor( labelUpColor[1], labelUpColor[2], labelUpColor[3] )
	end
	
	labelText:setReferencePoint( display.CenterReferencePoint )
	labelText.x, labelText.y = xPos, yPos+2
	
	local envInfo = system.getInfo( "environment" )
	local devName = system.getInfo( "model" )
	
	if envInfo == "simulator" then
		if devName ~= "iPhone4" then
			labelText.y = labelText.y - 4
		else
			labelText.y = labelText.y - 2
		end
	end
	
	-- Insert label text into buttonGroup
	buttonGroup.label:insert( labelText )
	
	-- Auto-size width if it's not specifically set in params
	if width == 0 and not default and not over then
		width = labelText.width + labelPadding	-- Npx buffer on each side of label text
		
		-- reposition all button elements based on new width
		midWidth = width - (leftImages.w + rightImages.w)
		midUp.x = leftImages.w
		midDown.x = leftImages.w
		rightUp.x = leftImages.w + midWidth
		rightDown.x = leftImages.w + midWidth
		labelText.x = width * 0.5
		local xS = midWidth / midImages.w
		midUp.xScale = xS
		midDown.xScale = xS
	end
	
	-- Position the buttonGroup to where it should be
	buttonGroup:setReferencePoint( display.TopLeftReferencePoint )
	buttonGroup.x, buttonGroup.y = x, y
	
	-- Add "touch" listener to buttonGroup
	buttonGroup.touch = buttonEventHandler
	buttonGroup:addEventListener( "touch", buttonGroup )
	
	-- Set the "id" of this button
	buttonGroup.id = id
	
	-- Assign onEvent event to buttonGroup (if exists )
	if not onRelease and not onPress and onEvent then
		buttonGroup._onEvent = onEvent
	else
	
		-- Assign onPress event to buttonGroup (if exists)
		if onPress then
			buttonGroup._onPress = onPress
		end
		
		-- Assign onRelease event to buttonGroup (if exists)
		if onRelease then
			buttonGroup._onRelease = onRelease
		end
	end
	
	
	-- ***
	------------ PUBLIC METHODS
	-- ***
	
	function buttonGroup:setLabel( newText, newColor, newWidth )
		local r, g, b = labelUpColor[1], labelUpColor[2], labelUpColor[3]
		
		if newColor and type(newColor) == "table" then
			r, g, b = newColor[1], newColor[2], newColor[3]
		end
		
		if not newText then newText = labelText.text; end
		
		if isEmbossed then
			labelText:setText( newText, { r, g, b } )
		else
			labelText.text = newText
			labelText:setTextColor( r, g, b, 255 )
		end
		
		labelText:setReferencePoint( display.CenterReferencePoint )
		
		if not customImg and not default and not over then
			
			-- Reposition label text and resize button
			if newColor and type(newColor) == "number" then
				width = newColor
			
			elseif not newColor and not newWidth then
				width = labelText.width + 20
				
			elseif not newColor and newWidth then
				width = newWidth
				
			elseif newColor and newWidth then
				width = newWidth
	
			else
				width = labelText.width + 20
			end
		
			-- reposition all button elements based on new width
			
			midWidth = width - (leftImages.w + rightImages.w)
			midUp.x = leftImages.w
			midDown.x = leftImages.w
			rightUp.x = leftImages.w + midWidth
			rightDown.x = leftImages.w + midWidth
			labelText.x = width * 0.5
			labelText.y = midImages.h * 0.5
			local xS = midWidth / midImages.w
			midUp.xScale = xS
			midDown.xScale = xS
			
		else
			labelText.x = width * 0.5
			labelText.y = height * 0.5
		end
	end
	
	--
	
	function t:setReferencePoint( refPoint )
		if refPoint then
			buttonGroup:setReferencePoint( refPoint )
		end
	end
	
	--
	
	function t:removeSelf()
		
		-- In case user tries to remove the button when it has already been removed
		-- (e.g. it's parent was removed and the button was removed as a result), perform
		-- the check below so it doesn't produce an error when no removeEventListener method
		-- is found.
		
		if buttonGroup.removeEventListener then
			buttonGroup:removeEventListener( "touch", buttonGroup )
			buttonGroup.touch = nil
		end
		
		display.remove( buttonGroup )
		buttonGroup = nil
		self = nil
		
		return nil
	end
	
	--====================================================
	
	-- Metamethods
	
	--====================================================
	
	mt.__index = function( tb, key )
		if key == "view" then
			return t._view
		
		else
			return buttonGroup[ key ]
		end
	end
	
	mt.__newindex = function( tb, key, value )
		
		if key == "x" then
			
			buttonGroup.x = value
		
		elseif key == "y" then
			
			buttonGroup.y = value
		
		elseif key == "label" then
			
			buttonGroup:setLabel( value )
		
		elseif key == "labelColor" then
			
			buttonGroup:setLabel( nil, value )
		
		elseif key == "id" then
			
			buttonGroup.id = value
			
		end
	end
	
	setmetatable( t, mt )
	
	-- Return the entire buttonGroup as a new UI Button
	return t
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newSegmentedControl()
--
----------------------------------------------------------------------------------------------------

newSegmentedControl = function( buttonTable, params )
	
	-- override skinSetting if one is specified for this widget
	local skinSetting = skinSetting
	if params and params.skin then
		skinSetting = getSkinTable( params.skin )
	end
	
	-- Set up skin resource variables (if using skin's default setting)
	local skinTable = skinSetting.segmentedControl
	
	-- If this skin doesn't support the segmented control, exit the function:
	if not skinTable then
		print( "--" )
		print( "WARNING: Interace Library" )
		print( "Chosen interface skin does not support the \"segmentedControl\" widget." )
		print( "=======================================" )
		return nil
	end
	
	local leftTable = skinTable.leftImages
		local leftLeftUp, leftLeftDown, leftLeftWidth, leftLeftHeight =
				skinPackage .. "/" .. leftTable.left.up, skinPackage .. "/" .. leftTable.left.down, leftTable.left.w, leftTable.left.h	
		local leftRightUp, leftRightDown, leftRightWidth, leftRightHeight =
				skinPackage .. "/" .. leftTable.right.up, skinPackage .. "/" .. leftTable.right.down, leftTable.right.w, leftTable.right.h
		
	local midTable = skinTable.midImages
		local midUp, midDown, midWidth, midHeight = skinPackage .. "/" .. midTable.up, skinPackage .. "/" .. midTable.down, midTable.w, midTable.h
		
	local rightTable = skinTable.rightImages
		local rightLeftUp, rightLeftDown, rightLeftWidth, rightLeftHeight =
				skinPackage .. "/" .. rightTable.left.up, skinPackage .. "/" .. rightTable.left.down, rightTable.left.w, rightTable.left.h	
		local rightRightUp, rightRightDown, rightRightWidth, rightRightHeight =
				skinPackage .. "/" .. rightTable.right.up, skinPackage .. "/" .. rightTable.right.down, rightTable.right.w, rightTable.right.h
	
	
	
	-- set up other default variables
	
	local id, x, y, labelUpColor, fontSize, fontFamily, isEmbossed, labelPadding, baseDir =
		"segmentedControl",
		0, 0,
		skinTable.upText,
		skinTable.fontSize,
		skinTable.fontFamily,
		skinTable.fontEmboss,
		skinTable.labelPadding,
		skinBase
	
	
	-- set up default buttonTable in case one wasn't specified
	
	if not buttonTable then
		
		-- buttonTable syntax:
		--
		-- { id=(string), label=(string), onPress=(function), onRelease=(function), width=(number), isDown=(boolean) }	--> all optional, but must be in order
		
		buttonTable = { { id="button1" }, { id="button2" }, { id="button3" } }
	end
	
	
	-- gather up params and do something with them (if any were entered)
	
	if params then
		id = params.id or id
		x = params.x or x
		y = params.y or y
		labelUpColor = params.labelColor or params.textColor or labelUpColor
		fontSize = params.fontSize or params.size or fontSize
		fontFamily = params.fontFamily or params.font or fontFamily
		labelPadding = params.padding or labelPadding
		
		leftTable = params.leftImages or leftTable
		midTable = params.midImages or midTable
		rightTable = params.rightImages or rightTable
		baseDir = params.baseDir or baseDir
		
		if params.emboss ~= nil then
			isEmbossed = params.emboss
		end
	end
	
	-- Create a group for the entire segmented control:
	local segmentedGroup = display.newGroup()
	
	-- set the "id" of this group
	segmentedGroup.id = id
	
	-- iterate through each entry in buttonTable and create a new segmented button
	
	local numRows = #buttonTable
	local nextX = 0	--> for segmented button positioning
	
	for i=1,numRows,1 do
		
		-- The code below is (almost) a replica of newButton, with some changes
		
		local buttonRow = buttonTable[i]
		
		-- Define some button-specific variables
		local id, label, onPress, onRelease, onEvent, width, isDown =
			tostring(i), "Label", nil, nil, nil, 0, false
		
		id = buttonRow.id or id
		label = buttonRow.label or label
		onPress = buttonRow.onPress or onPress
		onRelease = buttonRow.onRelease or onRelease
		onEvent = buttonRow.onEvent or onEvent
		width = buttonRow.width or width
		isDown = buttonRow.isDown or isDown
		
		-- Create display groups for entire button, up images, down images, and label text
		
		local buttonGroup = display.newGroup()
		buttonGroup.label = display.newGroup()
		buttonGroup.up = display.newGroup()
		buttonGroup.down = display.newGroup()
		
		buttonGroup:insert( buttonGroup.down )
		buttonGroup:insert( buttonGroup.up )
		buttonGroup:insert( buttonGroup.label )
		
		-- set the button group's control property to the segmentedControl group it belongs to
		buttonGroup.controlGroup = segmentedGroup
		
		-- Set a property to differientiate between regular ui buttons
		buttonGroup.segmentedButton = true
		
		-- First, determine if this is a left-edge button, mid button, or right-edge button
		
		local leftButton, midButton, rightButton
		
		if i == 1 and i ~= numRows then		
			leftButton = true
		end
	
		if i > 1 and i ~= numRows then	
			midButton = true
		end
		
		if i > 1 and i == numRows then
			rightButton = true
		end
		
		-- NOTE: There should always be at least 2 rows or the result would be a regular ui button.
		
		--
		
		
		-- Calculate width and gather correct resource, depending on which button this is in the segment
		local middleWidth, leftUp, leftWidth, leftHeight,
				rightUp, rightWidth, rightHeight,
					leftDown, rightDown
		
		if leftButton then
			middleWidth = width - (leftLeftWidth + leftRightWidth)
			leftUp = leftLeftUp
			leftDown = leftLeftDown
			leftWidth = leftLeftWidth
			leftHeight = leftLeftHeight
			
			rightUp = leftRightUp
			rightDown = leftRightDown
			rightWidth = leftRightWidth
			rightHeight = leftRightHeight
		end
		
		if midButton then
			middleWidth = width - (rightLeftWidth + leftLeftWidth)
			
			leftUp = rightLeftUp
			leftDown = rightLeftDown
			leftWidth = rightLeftWidth
			leftHeight = rightLeftHeight
			
			rightUp = leftRightUp
			rightDown = leftRightDown
			rightWidth = leftRightWidth
			rightHeight = leftRightHeight
		end
		
		if rightButton then
			middleWidth = width - (rightLeftWidth + rightRightWidth)
			
			leftUp = rightLeftUp
			leftDown = rightLeftDown
			leftWidth = rightLeftWidth
			leftHeight = rightLeftHeight
			
			rightUp = rightRightUp
			rightDown = rightRightDown
			rightWidth = rightRightWidth
			rightHeight = rightRightHeight
		end
		
		-- For horizontal scaling (stretching):
		local xS = middleWidth / midWidth	--> midWidth is defined at top of function, pulled from skinSettings table
		
		
		-- Create the "up" (non-pressed, non-over) button face
		local btnLeftUp = display.newImageRect( leftUp, baseDir, leftWidth, leftHeight )
		btnLeftUp:setReferencePoint( display.TopLeftReferencePoint )
		btnLeftUp.x, btnLeftUp.y = 0, 0
		
		local btnMidUp = display.newImageRect( midUp, baseDir, midWidth, midHeight )
		btnMidUp:setReferencePoint( display.TopLeftReferencePoint )
		btnMidUp.x, btnMidUp.y = leftWidth, 0
		btnMidUp.xScale = xS
		
		local btnRightUp = display.newImageRect( rightUp, baseDir, rightWidth, rightHeight )
		btnRightUp:setReferencePoint( display.TopLeftReferencePoint )
		btnRightUp.x, btnRightUp.y = leftWidth + midWidth, 0
		
		
		-- Insert the "up face" images into the correct group:
		buttonGroup.up:insert( btnLeftUp )
		buttonGroup.up:insert( btnMidUp )
		buttonGroup.up:insert( btnRightUp )
		
		
		-- Create the "down" (over) button face
		local btnLeftDown = display.newImageRect( leftDown, baseDir, leftWidth, leftHeight )
		btnLeftDown:setReferencePoint( display.TopLeftReferencePoint )
		btnLeftDown.x, btnLeftDown.y = 0, 0
		
		local btnMidDown = display.newImageRect( midDown, baseDir, midWidth, midHeight )
		btnMidDown:setReferencePoint( display.TopLeftReferencePoint )
		btnMidDown.x, btnMidDown.y = leftWidth, 0
		btnMidDown.xScale = xS
		
		local btnRightDown = display.newImageRect( rightDown, baseDir, rightWidth, rightHeight )
		btnRightDown:setReferencePoint( display.TopLeftReferencePoint )
		btnRightDown.x, btnRightDown.y = leftWidth + midWidth, 0
		
		-- Insert the "down face" images into the correct group:
		buttonGroup.down:insert( btnLeftDown )
		buttonGroup.down:insert( btnMidDown )
		buttonGroup.down:insert( btnRightDown )
		
		-- Make the proper group invisible (to start off)
		if isDown then
			buttonGroup.up.isVisible = false
		else
			buttonGroup.down.isVisible = false
		end
		
		-- Create the button's label text
		local labelText
		local xPos, yPos = width * 0.5, midHeight * 0.5
		
		if isEmbossed then
			labelText = newEmbossedText( label, 0, 0, fontFamily, fontSize, labelUpColor )
		else
			labelText = display.newText( label, 0, 0, fontFamily, fontSize )
			labelText:setTextColor( labelUpColor[1], labelUpColor[2], labelUpColor[3] )
		end
		
		labelText:setReferencePoint( display.CenterReferencePoint )
		labelText.x, labelText.y = xPos, yPos
		
		-- Insert label text into buttonGroup
		buttonGroup.label:insert( labelText )
		
		-- Auto-size width if it's not specifically set in params
		if width == 0 then
			width = labelText.width + labelPadding	-- Npx buffer on each side of label text
			buttonGroup.totalWidth = width
			
			-- reposition all button elements based on new width
			middleWidth = width - (leftWidth + rightWidth)
			btnMidUp.x = leftWidth
			btnMidDown.x = leftWidth
			btnRightUp.x = leftWidth + middleWidth
			btnRightDown.x = leftWidth + middleWidth
			labelText.x = width * 0.5
			local xS = middleWidth / midWidth
			btnMidUp.xScale = xS
			btnMidDown.xScale = xS
		end
		
		-- position the buttonGroup to where it should be in conjunction with other buttons
		buttonGroup:setReferencePoint( display.TopLeftReferencePoint )
		buttonGroup.x = nextX
		buttonGroup.y = 0
		
		-- determine the next X coordinate for the next button
		nextX = nextX + width
		
		-- Add "touch" listener to buttonGroup
		buttonGroup.touch = buttonEventHandler
		buttonGroup:addEventListener( "touch", buttonGroup )
		
		-- Set the "id" of this button
		buttonGroup.id = id
		
		-- assign an onEvent listener to the button
		if onEvent then
			buttonGroup._onEvent = onEvent
		else
			-- Assign onPress event to buttonGroup (if exists)
			if onPress then
				buttonGroup._onPress = onPress
			end
			
			-- Assign onRelease event to buttonGroup (if exists)
			if onRelease then
				buttonGroup._onRelease = onRelease
			end
		end
		
		
		--=======================================================================================
		-- 
		-- PUBLIC METHODS
		-- 
		--=======================================================================================
		
		function buttonGroup:setLabel( newText, newColor, newWidth )
			local r, g, b = labelUpColor[1], labelUpColor[2], labelUpColor[3]
			
			if newColor and type(newColor) == "table" then
				r, g, b = newColor[1], newColor[2], newColor[3]
			end
			
			if isEmbossed then
				labelText:setText( newText, { r, g, b } )
			else
				labelText.text = newText
			end
			
			labelText:setReferencePoint( display.CenterReferencePoint )
			
			-- Reposition label text and resize button
			if newColor and type(newColor) == "number" then
				width = newColor
			
			elseif not newColor and not newWidth then
				width = labelText.width + labelPadding
				
			elseif not newColor and newWidth then
				width = newWidth
				
			elseif newColor and newWidth then
				width = newWidth
	
			else
				width = labelText.width + labelPadding
			end
			
			-- reposition all button elements based on new width
			middleWidth = width - (leftWidth + rightWidth)
			btnMidUp.x = leftWidth
			btnMidDown.x = leftWidth
			btnRightUp.x = leftWidth + middleWidth
			btnRightDown.x = leftWidth + middleWidth
			labelText.x = width * 0.5
			labelText.y = midHeight * 0.5
			local xS = middleWidth / midWidth
			btnMidUp.xScale = xS
			btnMidDown.xScale = xS
			
			self.totalWidth = width
			
			-- reposition buttons in the entire segmentedGroup
			local nextX = self.x
			
			for i=1,segmentedGroup.numChildren do
				segmentedGroup[i].x = nextX
				
				nextX = nextX + segmentedGroup[i].totalWidth
			end
		end
		
		-- insert the button into the segmentedGroup
		segmentedGroup:insert( buttonGroup )
	end
	
	--=========================================================================
	--
	-- PUBLIC METHODS (for entire segmented control)
	--
	--=========================================================================
	
	function segmentedGroup:centerOnToolbar( theToolbar )
			
		local coronaMetaTable = getmetatable(currentStage)

		-- Returns whether aDisplayObject is a Corona display object.
		local isDisplayObject = function(aDisplayObject)
			return (type(aDisplayObject) == "table" and getmetatable(aDisplayObject) == coronaMetaTable)
		end
		
		-- If no toolbar object set, and the toolbar is not a display object, and if it's name property isn't "toolbar" do nothing (exit function)
		if not theToolbar and not isDisplayObject( theToolbar ) and theToolbar.name ~= "toolbar" then return nil; end
	
		local toolbarCenterX = theToolbar.view.realWidth * 0.5
		local toolbarCenterY = theToolbar.view.height * 0.5
		
		self:setReferencePoint( display.CenterReferencePoint )
		self.x = toolbarCenterX
		self.y = toolbarCenterY
		self:setReferencePoint( display.TopLeftReferencePoint )
		
	end
	
	
	-- Add a .view property (for consistency)
	segmentedGroup.view = segmentedGroup
	
	-- PATCH removeSelf() to ensure all children "buttons" are removed
	
	segmentedGroup.oldRemoveSelf = segmentedGroup.removeSelf
	
	function segmentedGroup:removeSelf()
		
		-- Go through and remove all buttons from the segmented control
		for i=segmentedGroup.numChildren,1,-1 do
			segmentedGroup[i]:removeSelf()
			segmentedGroup[i] = nil
		end
		
		-- remove the segmentedGroup finally
		segmentedGroup:oldRemoveSelf()
		segmentedGroup = nil
	end
	
	
	--
	
	-- position the segmented group depending on the x/y values set (or go with default)
	segmentedGroup:setReferencePoint( display.TopLeftReferencePoint )
	segmentedGroup.x = x
	segmentedGroup.y = y
	
	
	-- return the segmented control group as one:
	return segmentedGroup
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newSlider()
--
----------------------------------------------------------------------------------------------------

newSlider = function( params )
	
	-- override skinSetting if one is specified for this widget
	local skinSetting = skinSetting
	if params and params.skin then
		skinSetting = getSkinTable( params.skin )
	end
	
	local sliderSkin = skinSetting.uiSlider
	
	-- dummy table in case no params were set
	if not params then params = dummyEmpty; end
	
	-- extract parameters or set defaults
	local	id = params.id or "uiSlider"
	local	initialValue = params.initialValue or params.value or 50
	local	x = params.x or 0
	local	y = params.y or 0
	local	width = params.width or sliderSkin.width
	local	leftImage = params.leftImage or { skinPackage .. "/" .. sliderSkin.leftImage[1], sliderSkin.leftImage[2], sliderSkin.leftImage[3], skinBase }
	local	rightImage = params.rightImage or { skinPackage .. "/" .. sliderSkin.rightImage[1], sliderSkin.rightImage[2], sliderSkin.rightImage[3], skinBase }
	local	maskImage = params.maskImage or { skinPackage .. "/" .. sliderSkin.maskImage[1], sliderSkin.maskImage[2], sliderSkin.maskImage[3], skinBase }
	local	fillImage = params.fillImage or { skinPackage .. "/" .. sliderSkin.fillImage[1], sliderSkin.fillImage[2], sliderSkin.fillImage[3], skinBase }
	local	handleImage = params.handleImage or { skinPackage .. "/" .. sliderSkin.handleImage[1], sliderSkin.handleImage[2], sliderSkin.handleImage[3], skinBase }
	local	callBack = params.callback or params.callBack or params.onEvent
	
	-- don't let width go higher than 400 px
	if width > 400 then width = 400 end
	
	-- calculate xMin and xMax (contentBounds) based on width and x position of slider
	local halfW = (width * 0.5) + 2
	local xMin = x - halfW
	local xMax = x + halfW
	
	-- create groups
	local sliderControl = display.newGroup()	--> holds entire switch
	local maskGroup = display.newGroup()		--> will mask everything within this group
	local edgeGroup = display.newGroup()		--> will contain rounded edge images (underneath mask)
	
	-- set up table and metatable for intercepting property changes
	---local t = { _view = sliderControl, _value = initialValue }
	local t = { _view = sliderControl, _value = initialValue }
	local mt = {}
	
	-- set the id of the slider
	sliderControl.id = id
	
	-- assign a callback function to t if it exists
	if callBack then
		t._callBack = callBack
	end
	
	-- assign default properties to the table t
	t.sliderWidth = width
	
	-- insert mask group into the slider control group:
	sliderControl:insert( edgeGroup )
	sliderControl:insert( maskGroup )
	
	-- create the slider "fill" graphic
	local sliderFill = display.newImageRect( fillImage[1], fillImage[4], fillImage[2], fillImage[3] )
	
	-- determine position of fill depending on slider width
	local pixelPosition = ((initialValue * width) / 100) - (width * 0.5)
	sliderFill:setReferencePoint( display.CenterReferencePoint )
	sliderFill.x = pixelPosition
	
	maskGroup:insert( sliderFill )
	
	-- create the left and right rounded ends of the slider control
	local leftEdge = display.newImageRect( leftImage[1], leftImage[4], leftImage[2], leftImage[3] )
	leftEdge:setReferencePoint( display.CenterRightReferencePoint )
	
	local rightEdge = display.newImageRect( rightImage[1], rightImage[4], rightImage[2], rightImage[3] )
	rightEdge:setReferencePoint( display.CenterLeftReferencePoint )
	
	edgeGroup:insert( leftEdge )
	edgeGroup:insert( rightEdge )
	
	-- create the slider handle
	sliderControl.handle = display.newImageRect( handleImage[1], handleImage[4], handleImage[2], handleImage[3] )
	
	-- determine position and adjust accordingly
	sliderControl.handle:setReferencePoint( display.CenterReferencePoint )
	sliderControl.handle.x = pixelPosition
	
	sliderControl:insert( sliderControl.handle )
	
	-- create a bitmap mask and set it on the whole group
	local sliderMask = graphics.newMask( maskImage[1] )
	maskGroup:setMask( sliderMask )
	
	-- calculate the xScale of graphics mask depending on width of widget
	local widgetScale = width / 220
	maskGroup.maskScaleX = widgetScale * 0.5
	maskGroup.maskScaleY = 0.5
	
	-- localize math.floor
	local mFloor = mFloor
	
	-- TOUCH EVENT HANDLER
	
	function sliderFill:touch( event )
		local isWithinBounds = xMin <= event.x and xMax >= event.x
		
		if event.phase == "began" then
			
			if isWithinBounds then
			
				currentStage:setFocus( self, event.id )
				self.isFocus = true
				
				-- calculate the position things are supposed to be
				local positionCalc = event.x - x
				
				-- set the value of the control
				local mFloor = mFloor
				local newValue = mFloor(((( (width*0.5) + positionCalc) * 100) / width))
				
				if newValue < 0 then newValue = 0 end
				if newValue > 100 then newValue = 100 end
				
				t.value = newValue
				
				-- execute the callback listener if it exists (and if it's a function)
				if t._callBack and type( t._callBack ) == "function" then
					local newEvent = event
					sliderControl.value = t.value
					newEvent.target = sliderControl
					newEvent.value = newValue
					
					t._callBack( newEvent )
				end
			end
			
		elseif self.isFocus then
			
			if event.phase == "moved" then
				
				-- calculate the position things are supposed to be
				local positionCalc = event.x - x
				
				-- set the value of the control
				local mFloor = mFloor
				local newValue = mFloor(((( (width*0.5) + positionCalc) * 100) / width))
				
				if newValue < 0 then newValue = 0 end
				if newValue > 100 then newValue = 100 end
				
				t.value = newValue
				
				-- execute the callback listener if it exists (and if it's a function)
				if t._callBack and type( t._callBack ) == "function" then
					local newEvent = event
					sliderControl.value = t.value
					newEvent.target = sliderControl
					newEvent.value = newValue
					
					t._callBack( newEvent )
				end
			
			elseif event.phase == "ended" or event.phase == "cancelled" then
				
				currentStage:setFocus( nil )
				self.isFocus = false
				
			end
		end
		
		return true
	end
	
	-- assign touch listener to sliderFill object
	sliderFill:addEventListener( "touch", sliderFill )
	
	--==========================================================================
	
	-- PUBLIC METHODS
	
	--==========================================================================
	
	--
	
	function sliderControl:setValue( valueNum )
		sliderFill.x = ((valueNum * width) / 100) - (width * 0.5)
		self.handle.x = sliderFill.x
	end
	
	--
	
	function sliderControl:adjustWidth( newWidth )
		if not newWidth then return nil; end
		if newWidth > 400 then newWidth = 400; end
		
		width = newWidth
		
		halfW = (width * 0.5) + 2
		xMin = x - halfW
		xMax = x + halfW
		
		widgetScale = width / 220
		maskGroup.maskScaleX = widgetScale * 0.5
		
		leftEdge.x = -(x - xMin) + 20
		rightEdge.x = (x - xMin) - 20
		
		-- recalculate where the slider should be at
		positionCalc = ((t._value * width) / 100) - (width * 0.5)
		
		local newValue = mFloor(((( (width*0.5) + positionCalc) * 100) / width))
		
		
		-- reposition the handle and the slider fill
		sliderFill.x = ((newValue * width) / 100) - (width * 0.5)
		self.handle.x = sliderFill.x
		
		
		-- reposition the entire sliderControl
		self.x, self.y = x, y
	end
	
	--
	
	function t:removeSelf()
		
		display.remove( sliderControl )
		sliderControl = nil
		self = nil
		
		return nil
	end
	
	
	-- position the sliderControl group
	sliderControl.x, sliderControl.y = x, y
	
	--  - (x - (x - (width * 0.5)))
	-- position the left and right edges
	leftEdge.x = leftEdge.x - (x - xMin) + 9
	rightEdge.x = rightEdge.x + (x - xMin) - 9
	
	-- METAMETHODS to intercept property calls/assignments
	
	mt.__index = function( tb, key )
		if key == "value" then
			return rawget( tb, "_value" )
		
		elseif key == "view" then
			return rawget( tb, "_view" )
		
		elseif key == "width" then
			return width
		
		elseif key == "x" then
			return sliderControl.x
		
		elseif key == "y" then
			return sliderControl.y
			
		elseif key == "id" then
			return sliderControl.id
		
		end
	end
	
	mt.__newindex = function( tb, key, value )
		
		if key == "value" then
			
			if value < 0 then value = 0 end
			if value > 100 then value = 100 end
			
			t._value = value
			sliderControl:setValue( value )
		
		elseif key == "x" then
			x = value
			xMin = x - halfW
			xMax = x + halfW
			
			sliderControl.x = x
		
		elseif key == "y" then
			y = value
			sliderControl.y = y
		
		elseif key == "width" then
			
			sliderControl:adjustWidth( value )
		
		elseif key == "id" then
			
			sliderControl.id = value
			
		end
	end
	
	setmetatable( t, mt )
	
	-- assign properties to the table t
	t.value = initialValue
	
	-- return the sliderControl group
	return t
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newToolbar()
--
----------------------------------------------------------------------------------------------------

function newToolbar( ... )
	
	-- Function structure: newToolbar( [titleString, params] )
	
	-- override skinSetting if one is specified for this widget
	local skinSetting = skinSetting
	if arg[1] and type(arg[1]) == "table" and arg[1].skin then
		skinSetting = getSkinTable( arg[1].skin )
	end
	
	-- Set up skin resource variables (if using skin's default setting)
	local skinTable = skinSetting.navToolbar
	
	-- If this skin doesn't support the segmented control, exit the function:
	if not skinTable then
		print( "--" )
		print( "WARNING: Interace Library" )
		print( "Chosen interface skin does not support the \"Nav/Toolbar\" widget." )
		print( "=======================================" )
		return nil
	end
	
	local gradientImage = skinTable.gradientImage[1]
	local gradientWidth = skinTable.gradientImage[2]
	local gradientHeight = skinTable.gradientImage[3]
	
	-- defaults for arguments
	local params = dummyEmpty
	local titleString = ""
	local isNavBar = false	--> navbars have a label, toolbars do not (just a platform for ui buttons)
	
	-- extract arguments
	if arg and type(arg[1]) == "table" then
		params = arg[1]
	
	elseif arg and type(arg[1]) == "string" then
		titleString = arg[1]
		if arg[2] then
			params = arg[2]
		end
		
		isNavBar = true
	end
	
	-- extract parameters or set defaults
	local	width = params.width or display.contentWidth
	local	height = params.height or gradientHeight
	local	bgImage = params.bgImage
	local	customGradient = params.gradientImage or params.gradient
	local	baseDir = params.baseDir or defaultBase
	local	titleFont = params.font or skinTable.font
	local	fontSize = params.size or skinTable.size
	local	textColor = params.labelColor or params.titleColor or params.textColor or { 255, 255, 255 }
	local	x = params.x or 0
	local	y = params.y or 0
	
	-- If custom gradient was specified
	if customGradient then
		gradientImage = customGradient[1] or gradientImage
		gradientWidth = customGradient[2] or gradientWidth
		gradientHeight = customGradient[3] or gradientHeight
	end
	
	-- set default y position, depending on if there's a statusbar present
	local sbHeight = display.statusBarHeight
	if sbHeight then y = sbHeight; end
	
	-- Create a group to hold the background image and (potentially) the title text
	local theToolbar = display.newGroup()
	
	-- Set the widget's name
	theToolbar.name = "toolbar"
	
	-- Set the width property
	theToolbar.realWidth = width
	
	-- Create a table that will hold everything
	local t = { _view = theToolbar }
	
	-- Create another table to serve as a metatable (for metamethods)
	local mt = {}
	
	
	-- Create the background
	local background
	
	if not bgImage then
		local imagePath
		if customGradient then
			imagePath = gradientImage
		else
			imagePath = skinPackage .. "/" .. gradientImage
		end
		
		background = display.newImageRect( imagePath, baseDir, gradientWidth, gradientHeight )
		background.xScale = gradientWidth * width
		background:setReferencePoint( display.TopLeftReferencePoint )
		background.x, background.y = 0, 0
	else
		background = display.newImageRect( bgImage, baseDir, width, height )
		background:setReferencePoint( display.TopLeftReferencePoint )
		background.x, background.y = 0, 0
	end
	
	-- set the _id property of this object
	background._id = "background"
	
	-- Insert toolbar background into group
	theToolbar:insert( background )
	
	
	-- Create the title text (if this is a nav bar)
	
	if isNavBar then
		
		local textObject = newEmbossedText( titleString, 0, 0, titleFont, fontSize, textColor )
		textObject:setReferencePoint( display.CenterReferencePoint )
		textObject.x = width * 0.5
		textObject.y = height * 0.5
		
		-- set the _id property of this object
		textObject._id = "titleText"
		
		-- Insert into the toolbar group
		theToolbar:insert( textObject )
	end
	
	
	--====================================================
	
	-- ***
	------------------ PUBLIC METHODS
	-- ***
	
	function theToolbar:resetWidth( newWidth )
		
		-- This function is to change the width of the toolbar when using a gradient background,
		-- not a fixed background. Most common use: when device orientation changes.
		
		-- exit function if this toolbar uses a background image
		if bgImage then return nil; end
		
		-- if width isn't set, use the entire screen width
		if not newWidth then newWidth = display.contentWidth; end
		
		local currentX, currentY = self.x, self.y
		
		-- find the background object
		local background, titleObj
		
		for i=1,self.numChildren do
			if self[i]._id and self[i]._id == "background" then
				background = self[i]
			end
			
			if self[i]._id and self[i]._id == "titleText" then
				titleObj = self[i]
			end
		end
		
		-- reset background gradient width (by modifying the xScale property)
		if background then
			background.xScale = gradientWidth * newWidth
			background:setReferencePoint( display.TopLeftReferencePoint )
			background.x, background.y = 0, 0
		end
		
		-- next, reset the position of the title text, if present
		if titleObj then
			titleObj:setReferencePoint( display.CenterReferencePoint )
			titleObj.x = newWidth * 0.5
		end
		
		width = newWidth
		self.realWidth = width
		
		-- reposition entire nav/toolbar to prevent any corruption (preserves top/left reference point)
		self.x, self.y = currentX, currentY
	end
	
	
	--
	
	function theToolbar:resetTitle( newTitle )
		
		-- This function is used to change the title text, if this is a navigation bar.
		
		-- if no newTitle value is set, make no changes (exit the function)
		if not newTitle then return nil; end
		if newTitle and type(newTitle) ~= "string" then return nil; end
		
		
		-- create embossed text object if one doesn't exist
		if not isNavBar then
			local textObject = newEmbossedText( newTitle, 0, 0, titleFont, fontSize, textColor )
			textObject:setReferencePoint( display.CenterReferencePoint )
			textObject.x = width * 0.5
			textObject.y = height * 0.5
			
			-- set the _id property of this object
			textObject._id = "titleText"
			
			-- Insert into the toolbar group
			self:insert( textObject )
		end
		
		--
		
		
		local titleObj
		
		-- find the titleObject
		for i=1,self.numChildren do
			if self[i]._id and self[i]._id == "titleText" then
				titleObj = self[i]
			end
		end
		
		-- change the embossed text of title, and reposition
		if titleObj then
			titleObj:setText( newTitle )
			titleObj:setReferencePoint( display.CenterReferencePoint )
			titleObj.x = width * 0.5
			titleObj.y = self.height * 0.5
		else
			return nil
		end
	end
	
	--
	
	-- Private touch listener method to disallow touches from going behind toolbar
	local onToolbarTouch = function( event )
		if event.phase == "began" then
			currentStage:setFocus( nil )
		end
		
		return true
	end
	theToolbar:addEventListener( "touch", onToolbarTouch )
	
	--
	
	theToolbar.oldRemoveSelf = theToolbar.removeSelf
	
	function theToolbar:removeSelf()
		
		-- remove touch event listener
		theToolbar:removeEventListener( "touch", onToolbarTouch )
		
		local titleObj
		
		-- find the label text
		for i=1,self.numChildren do
			if self[i]._id and self[i]._id == "titleText" then
				titleObj = self[i]
			end
		end
		
		display.remove( titleObj )
		titleObj = nil
		
		theToolbar:oldRemoveSelf()
		theToolbar = nil
	end
	
	--
	
	function t:removeSelf()
		
		display.remove( theToolbar )
		theToolbar = nil
		self = nil
		
		return nil
	end
	
	-- Position the toolbar
	theToolbar.x, theToolbar.y = x, y
	
	
	--====================================================
	
	-- Metamethods
	
	--====================================================
	
	mt.__index = function( tb, key )
		if key == "view" then
			return t._view
		
		elseif key == "x" then
			return x
			
		elseif key == "y" then
			return y
			
		end
	end
	
	mt.__newindex = function( tb, key, value )
		
		if key == "x" then
			
			x = value
			theToolbar.x = value
		
		elseif key == "y" then
			
			y = value
			theToolbar.y = value
		
		elseif key == "width" then
			
			theToolbar:resetWidth( value )
		
		elseif key == "title" then
			
			theToolbar:resetTitle( value )
		
		elseif key == "label" then
			theToolbar:resetTitle( value )
			
		end
	end
	
	setmetatable( t, mt )
	
	return t
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newScrollView()
--
----------------------------------------------------------------------------------------------------

function newScrollView( ... )
	
	-- override skinSetting if one is specified for this widget
	local skinSetting = skinSetting
	if arg[1] and type(arg[1]) == "table" and arg[1].skin then
		skinSetting = getSkinTable( arg[1].skin )
	end
	
	-- Set up skin resource variables (if using skin's default setting)
	
	local skinTable, whichView
	
	if isTableView then
		skinTable = skinSetting.tableView
		whichView = "Table View"
	else
		skinTable = skinSetting.scrollView
		whichView = "Scroll View"
	end
	
	-- If this skin doesn't support the segmented control, exit the function:
	if not skinTable then
		
		print( "--" )
		print( "WARNING: Interace Library" )
		print( "Chosen interface skin does not support the \"" .. whichView .. "\" widget." )
		print( "=======================================" )
		
		return nil
	end
	
	
	-- Localize some math functions (for faster look-up during enterFrame listener)
	local mAbs = mAbs
	local mFloor = mFloor
	
	-- set up default values for arguments
	local params = dummyEmpty
	local isTableView = false
	
	-- determine how many arguments were passed (distinguish between them)
	if arg and type(arg[1]) == "table" then
		params = arg[1]
		
		if arg[2] then
			isTableView = true
		end
	end
	
	-- extract params or set defaults
	local	width = params.width or 320
	local	height = params.height
	local	rowHeight = params.rowHeight or 56
	local	x = params.x or 0
	local	y = params.y or 0
	local	hideScrollbar = params.hideScrollbar
	local	maskFile = params.maskFile or params.mask
	local	bgImage = params.background
	local	bgColor = params.backgroundColor or { 67, 67, 67, 255 }
	local	isForPickerWheel = params.isForPickerWheel
	
	-- reset friction if this is for a picker wheel (increase drag, so lower friction)
	if isForPickerWheel then
		friction = 0.9
	end
	
	-- Set a specific mask if height setting matches any preset coordinates
	if not maskFile then
		--> if custom mask hasn't already been specified...
		
		if height then	--> if a custom height was set
			
			local customHeightFound =
				height == 100 or height == 128 or height == 176 or
				height == 200 or height == 208 or height == 240 or height == 256 or
				height == 300 or height == 320 or height == 384 or
				height == 400 or height == 480 or
				height == 500 or height == 512 or
				height == 600 or height == 624 or
				height == 700 or height == 752 or height == 768 or
				height == 800 or height == 1024
			
			if customHeightFound then
				
				local maskTable = "mask" .. height
				maskFile = skinPackage .. "/" .. skinTable[maskTable][1]
			end
		end
	end
	
	
	--
	
	-- Create a group for scrolling content
	
	local catGroup = display.newGroup()		--> for category headings
	local maskGroup = display.newGroup()	--> for height masking
	local scrollGroup = display.newGroup()	--> for actual scrollable content
	local bgGroup = display.newGroup()		--> for bgColor or background image
	
	maskGroup:insert( bgGroup )
	maskGroup:insert( scrollGroup )
	catGroup:insert( maskGroup )
	
	scrollGroup.background = bgGroup
	scrollGroup.maskGroup = maskGroup
	scrollGroup.catGroup = catGroup
	scrollGroup.scrollbarHidden = hideScrollbar
	
	if maskFile then
		
		if type(maskFile) == "string" then
			local scrollMask = graphics.newMask( maskFile )
			maskGroup:setMask( scrollMask )
		else
			maskGroup:setMask( maskFile )
		end
		
		maskGroup.maskX = x + (width * 0.5)
		maskGroup.maskY = y + (height * 0.5)
	end
	
	-- Create a table that will hold everything
	local t = { _view = scrollGroup, maskView = catGroup }
	
	-- Create another table to serve as a metatable (for metamethods)
	local mt = {}
	
	
	
	-- Declare variables for scrollGroup.velocity (nil), prevY (nil), startTime (0), lastTime (0), prevTime (0)
	local startTime, prevTime, friction = 0, 0, 0.8888 --0.8888 --0.9532
	
	scrollGroup.currentY = 0
	scrollGroup.prevY = 0
	scrollGroup.lastTime = 0
	scrollGroup.isTableView = isTableView
	
	-- Quick function to limit scrollGroup.velocity amount
	local limitVelocity = function()
		
		local velocity = scrollGroup.velocity
		
		if velocity then
			local limit = 3.25 --5.25
			
			if velocity > limit then
				scrollGroup.velocity = limit
			elseif velocity < -limit then
				scrollGroup.velocity = -limit
			end
		end
	end	
	
	
	-- Calculate the top/bottom points of the scrolling list, based on height and y coordinate
	local screenH = display.contentHeight
	
	if not height then
		height = screenH - y
	end
	
	local leftover = screenH - height
	scrollGroup.top = y
	scrollGroup.bottom = leftover - scrollGroup.top
	scrollGroup.wSize = width
	scrollGroup.hSize = height	--> for outside access
	scrollGroup.isMoving = false
	
	--
	
	-- Create the background image, or the background color
	if bgImage ~= "none" or bgColor ~= "none" then
		
		if not bgImage and bgColor ~= nil and bgColor ~= "none" then
			
			local backgroundColor = display.newRect( bgGroup, x, 0, width, height )
			local bgAlpha = bgColor[4] or 255
			backgroundColor:setFillColor( bgColor[1], bgColor[2], bgColor[3], bgAlpha  )
			backgroundColor.y = backgroundColor.y + scrollGroup.top
			
			bgGroup:insert( backgroundColor )
		
		elseif bgImage then
			
			local image = bgImage[1] or nil
			local w = bgImage[2] or width
			local h = bgImage[3] or height
			local baseDir = bgImage[4] or defaultBase
			
			if image then
				
				local bg = display.newImageRect( image, baseDir, w, h )
				bg:setReferencePoint( display.TopLeftReferencePoint )
				bg.x, bg.y = x, 0
				
				bgGroup:insert( bg )
				
				bg.y = bg.y + scrollGroup.top
			end
		end
	end
	
	--
	
	-- Function responsible for showing the highlight
	
	local function highlightItem( event )
		
		local startTime = scrollGroup.startTime or 0
		local timePassed = system.getTimer() - startTime
 		
		if timePassed > 50 then 
			
			local theItem = scrollGroup.lastItemTouched
			
			if theItem.bgObj and not theItem.isCategory then
				if theItem.bgObj.setFillColor then
					local c = theItem.downColor							--> fix for highlight item bug (no casenum)
					theItem.bgObj:setFillColor( c[1], c[2], c[3], 255 )	--> fix for highlight item bug (no casenum)
				end
				
				if theItem.titleText then
					theItem.titleText:setTextColor( 255, 255, 255, 255 )
				end
				
				if theItem.subTitleText then
					theItem.subTitleText:setTextColor( 255, 255, 255, 255 )
				end
				
				theItem.isHighlighted = true
			end
			
			Runtime:removeEventListener( "enterFrame", highlightItem )
		end
		
	end
	
	--
	--
	--
	
	local resetHighlight = function( listItem, invokeListener )
		
		-- reset list item highlight
		if listItem and not listItem.isCategory then
			if listItem.bgObj then
				if listItem.bgObj.setFillColor then
					if listItem.bgColor then
						local bgColor = listItem.bgColor
						listItem.bgObj:setFillColor( bgColor[1], bgColor[2], bgColor[3], 255 )
					else
						listItem.bgObj:setFillColor( 255, 255, 255, 255 )
					end
				end
			end
			
			-- reset title text color
			if listItem.titleText then
				if listItem.titleColor then
					local r, g, b =
						listItem.titleColor[1],
						listItem.titleColor[2],
						listItem.titleColor[3]
					
					listItem.titleText:setTextColor( r, g, b, 255 )
				end
			end
			
			-- reset subtitle text color
			if listItem.subTitleText then
				if listItem.subColor then
					local r, g, b =
						listItem.subColor[1],
						listItem.subColor[2],
						listItem.subColor[3]
					
					listItem.subTitleText:setTextColor( r, g, b, 255 )
				end
			end
		
			-- Call the item's onRelease function:
			if listItem.isHighlighted then
				if listItem.onRelease and invokeListener then
					local event = {
						target = listItem
					}
					listItem.onRelease( event )
				end
			end
			
			listItem.isHighlighted = false
		end
	end
	
	--
	--
	--
	
	-- Function for moving the scrollbar
	
	function scrollGroup:moveScrollBar()
		if self.scrollBar and self.height > (height + 100) then

			local top = self.top
			local bottom = self.bottom
			local height = self.hSize + top
			local scrollBar = self.scrollBar
			local mFloor = mFloor
			
			local difference = self.height - height
			
			if self.isTableView then
				difference = self.totalHeight - height
			end
			
			local yRatio = mFloor((-self.y * 100) / difference)
			
			if yRatio < 0 then
				yRatio = 0
			elseif yRatio > 100 then
				yRatio = 100
			end
			
			local realPosition = mFloor((yRatio * height) / 100)
			local maxReal = mFloor((100 * height) / 100 )
			
			local gotoPosition = realPosition + 35
			if gotoPosition > maxReal then gotoPosition = maxReal; end
			
			scrollBar.y = gotoPosition
			
			
			
			-- If scrollbar tries to move past highest point...
			
			if scrollBar.y < 5 + top + mFloor(scrollBar.height * 0.5) then
				
				local intendedPosition = 5 + top + mFloor(scrollBar.height * 0.5)
				
				scrollBar.y = intendedPosition
				
			end
			
			
			-- If scrollbar tries to move past lowest point...
			
			if scrollBar.y > height - 5 - scrollBar.height * 0.5 then
				
				local intendedPosition = height - 5 - scrollBar.height * 0.5
				
				-- Don't let scrollbar move past certain point
				scrollBar.y = intendedPosition
			end
		end
	end
	
	
	--
	--
	-- Create a function to track scrollGroup.velocity (enterFrame listener)
	
	local function trackVelocity( event )	--> an "enterFrame" event listener
		
		local eTime = event.time
		
		-- Track how much time user has finger on the screen
		local timePassed = eTime - prevTime
		
		-- Compound the prevTime for every frame of the event
		prevTime = prevTime + timePassed
		
		-- calculate scrollGroup.velocity (determine how far the user moved their finger, in how much time)
		local currentTarget = scrollGroup
		
		local prevY = currentTarget.prevY
		local currentY = currentTarget.currentY
		
		if prevY then
			scrollGroup.velocity = (currentY - prevY)/timePassed
		end
		
		currentTarget.prevY = currentY
	end
	
	--===========================================
	--
	-- Create a function to scroll the content
	--
	--===========================================
	
	function scrollGroup:enterFrame( event )		--> an "enterFrame" listener function
		
		-- The "if" block below is a back-up measure, to ensure the trackVelocity listener
		-- is removed. When user touches, trackVelocity is turned on. During the ended/cancelled
		-- phase of their touch, trackVelocity is turned off and this listener (scrollGroup:enterFrame)
		-- is turned on. The block below is in case trackVelocity didn't get removed for whatever
		-- reason.
		
		if self.isTrackingVelocity then
			Runtime:removeEventListener( "enterFrame", self )
		else
			Runtime:removeEventListener( "enterFrame", trackVelocity )
		end
		
		-- localize needed variables/functions
		local mAbs = mAbs
		local mFloor = mFloor
		local eTime = event.time
		local screenH = display.contentHeight
		
		local velocity = self.velocity
		if not velocity then velocity = 0; end
		
		local myVelocity = mAbs(velocity)
		
		-- for picker wheels
		if self.isPickerColumn then
			if mAbs(myVelocity) < .02 then
				self.snapDisabled = false
			else
				if not self.snapDisabled then self.snapDisabled = true; end
			end
		end
		
		--local velocityMeetsMinimum = (myVelocity > 0 and myVelocity < .01) or (myVelocity < 0 and myVelocity > -0.01)
		local velocityMeetsMinimum = myVelocity < .01
		
		if velocityMeetsMinimum then
			
			-- remove this event listener:
			Runtime:removeEventListener( "enterFrame", self )
			
			-- Stop scrolling content when self.velocity reaches (close to) zero
			self.velocity = 0
			
			self.isMoving = false
			
			-- fade scrollbar out
			if self.scrollBar then
				self.scrollTween = transition.to( self.scrollBar, { time=300, alpha=0 } )
			end
		end
	  
		-- Localize friction setting
		local friction = friction
		local lastTime = self.lastTime
		
		-- Calculate the amount of time passed since the last frame
		local timePassed = eTime - lastTime
		self.lastTime = lastTime + timePassed
		
		
		local currentTarget = self
		
		-- Slow the list down as it moves using friction
		local velocity = self.velocity
		self.velocity = velocity*friction
		
		
		-- Update the y value of the list, i.e. move it up or down, based on self.velocity and time passed
		currentTarget.y = mFloor(self.y + velocity*timePassed)
		
		-- Make sure content doesn't scroll past boundaries
		local top = self.top
		local bottom = screenH - self.height - self.bottom --+ self.top
		local additionalScroll = 0
		
		if self.isTableView then
			
			local selfTotalHeight = self.totalHeight
			local selfBottom = self.bottom
			local isPickerColumn = self.isPickerColumn
			
			if self.hSize < selfTotalHeight + top then
				additionalScroll = self.hSize - selfTotalHeight
			end
			
			bottom = screenH - selfTotalHeight - selfBottom
			
			if isPickerColumn then
				bottom = bottom - 160
			end
		end
		
		--
		--
		--
		-- For time pickers:
		
		if self.timeID == "amPM" then
			top = 88 --80
			bottom = 42
		end
		
		if not self.isInfinite or self.timeID == "amPM" then
			
			local currentY = currentTarget.y
			
			if currentY > top then
				
				--====================================================
				--
				-- Swipe too far past beginning of scrollable content
				--
				--====================================================
				
				-- For tableviews, if list shifts up too far due to item deletion,
				-- adjust all list items to the correct position
				
				if self.isTableView and currentTarget.listItems[1].y+top ~= top then
					
					local difference = top - (currentTarget.listItems[1].y+top)
					
					for i=1,currentTarget.listItems.numChildren do
						currentTarget.listItems[i].y = currentTarget.listItems[i].y + difference
					end
				end
				
				--
				--
				
				Runtime:removeEventListener( "enterFrame", self )
				--self.velocity = 0
				
				self.tween = transition.to( currentTarget, { time=400, y=top, transition=easing.outQuad } )
				
				-- fade scrollbar out
				if self.scrollBar then
					self.scrollTween = transition.to( self.scrollBar, { time=400, alpha=0 } )
				end
				
			elseif currentY < bottom and bottom < 0 then
				
				--====================================================
				--
				--- Swipe too far past end of scrollable content
				--
				--====================================================
				
				-- For tableviews, if list shifts up too far due to item deletion,
				-- adjust all list items to the correct position
				
				if self.isTableView then
					
					local lastItem = currentTarget.listItems[currentTarget.listItems.numChildren]
					local lastY = currentTarget.hSize - (lastItem.y + lastItem.rowHeight) + top
					
					if lastY ~= bottom then
						
						local difference = bottom - lastY
						local addAmount = lastY + difference
						
						for i=1,currentTarget.listItems.numChildren do
							currentTarget.listItems[i].y = currentTarget.listItems[i].y - difference
						end
					end
				end
				
				--
				--
				
				Runtime:removeEventListener( "enterFrame", self )
				self.velocity = 0
				
				self.tween = transition.to( currentTarget, { time=400, y=bottom, transition=easing.outQuad } )
				
				-- fade scrollbar out
				if self.scrollBar then
					self.scrollTween = transition.to( self.scrollBar, { time=400, alpha=0 } )
				end
			
			elseif currentY < bottom then
				
				local newTop = top - additionalScroll
				
				if self.timeID == "amPM" then
					newTop = bottom
				end
				
				Runtime:removeEventListener( "enterFrame", self )
				self.velocity = 0
				
				self.tween = transition.to( currentTarget, { time=400, y=newTop, transition=easing.outQuad } )
				
				-- fade scrollbar out
				if self.scrollBar then
					self.scrollTween = transition.to( self.scrollBar, { time=400, alpha=0 } )
				end
			end
		
		end
		
		--
		--
		
		--======================================
		--======================================
		
		self:moveScrollBar()
		
		return true
	end
	
	--
	
	-- Add touch listener to entire group to turn on/off listeners at appropriate times
	
	function scrollGroup:touch( event )
		
		local ePhase = event.phase
		
		if ePhase == "began" then
			
			-- Place focus on the self's content
			currentStage:setFocus( self )
            self.isFocus = true
			
			-- Reset some variables
			startPos = event.y
            self.prevPos = event.y
            self.currentY = event.y
			self.velocity = 0
            
            -- Cancel any current transitions on the self (if any)
            if self.tween then transition.cancel(self.tween); self.tween = nil; end
			
			-- Stop scrolling the list if it is currently scrolling
            Runtime:removeEventListener( "enterFrame", self )
            self.isMoving = false

			-- Start tracking self.velocity
			prevTime = 0
			self.isTrackingVelocity = true
			Runtime:removeEventListener( "enterFrame", trackVelocity )
			Runtime:addEventListener( "enterFrame", trackVelocity )
			
			-- Show scrollbar
			if self.height > (height + 100) then
				if self.scrollTween then transition.cancel( self.scrollTween ); end
            	if self.scrollBar then self.scrollBar.alpha = 1.0; end
            end
            
            
            -- Reset highlight timer
            if self.isTableView and self.lastItemTouched then
            	if self.lastItemTouched.onRelease then
            		self.startTime = system.getTimer()
            		Runtime:removeEventListener( "enterFrame", highlightItem )
               		Runtime:addEventListener( "enterFrame", highlightItem )
               	end
            end
            
            -- for picker wheels
            if self.isPickerColumn then
            	self.snapDisabled = true
            end
            
            self.markY = self.y
		
		elseif self.isFocus then
			
			if ePhase == "moved" then
				
				-- Stop the highlight timer
				if self.isTableView and self.lastItemTouched.onRelease then
					self.startTime = nil
					Runtime:removeEventListener( "enterFrame", highlightItem )
					
					-- reset list item highlight
					resetHighlight( self.lastItemTouched )
				end
				
				-- Set some variables depending on position of finger
				local delta = event.y - self.prevPos
                self.prevPos = event.y
                
                local currentTarget = self
                
                --self.x = event.x - event.xStart + markX
				self.y = event.y - event.yStart + self.markY
                
                if currentTarget.y < self.top or currentTarget.y > self.bottom then
                	-- Make sure content doesn't get pulled too far beyond edges
                	currentTarget.y = currentTarget.y + delta * 0.25
                end
                
                -- indicates when scrollView object is moving
                self.isMoving = true
                
                self:moveScrollBar()
                
                self.currentY = event.y
                
                -- detect left/right swipes, but not if they have moved the list up/down a certain amount
                local verticalThresh = 25
                local verticalSwipeAmount = event.yStart - event.y
                
                if self.isTableView and verticalSwipeAmount < verticalThresh and verticalSwipeAmount > -verticalThresh then
					
					local swipeThresh = 75 -- horizontal swipe threshhold (in pixels)
					
					if event.xStart - event.x > swipeThresh then
						
						--============================
						-- LEFT SWIPE
						--============================
						
						-- call event listener (if it exists)
						local target = self.lastItemTouched
						
						if target.onLeftSwipe then
							local event = { target = self.lastItemTouched, direction = "left" }
							target.onLeftSwipe( event )
						end
						
						-- escape this touch event instance
						currentStage:setFocus( nil )
						self.isFocus = nil
						
						return true
					
					elseif event.x - event.xStart > swipeThresh then
						
						--============================
						-- RIGHT SWIPE
						--============================
						
						local target = self.lastItemTouched
						
						if target.onRightSwipe then
							local event = { target = self.lastItemTouched, direction = "right" }
							target.onRightSwipe( event )
						end
						
						-- escape this touch event instance
						currentStage:setFocus( nil )
						self.isFocus = nil
						
						return true
					end
				end
			
			elseif ePhase == "ended" or ePhase == "cancelled" then
				
				local eTime = event.time
				local eY = event.y
				local startPos = startPos
				
				-- reset the last time variable
				self.lastTime = eTime
				
				local dragDistance = eY - startPos
                
                
                -- Stop tracking self.velocity
                self.isTrackingVelocity = false
                self.currentY = event.y
	 			Runtime:removeEventListener( "enterFrame", trackVelocity )
	 			limitVelocity()
	 			
	 			-- Start moving the list based on self.velocity (how fast the user "flicked")
                Runtime:removeEventListener( "enterFrame", self )
                Runtime:addEventListener( "enterFrame", self )
				
				
				-- Defocus the self so other objects can be touched again:
                currentStage:setFocus( nil )
                self.isFocus = false
                
                
                if self.isTableView and self.lastItemTouched.onRelease then
                	self.startTime = nil	
                	Runtime:removeEventListener( "enterFrame", highlightItem )
                
               		-- reset list item highlight
               		resetHighlight( self.lastItemTouched, true )
               	end
			
			end	--> if ePhase == "moved" ... elseif ePhase ==
			
		end	--> if ePhase == "began"... elseif self.isFocus...
		
		return true
	end
	
	scrollGroup:addEventListener( "touch", scrollGroup )
	
	
	--
	--
	-- Add a scrollbar to the scrollView
	--
	
	function scrollGroup:addScrollBar()
		
		if self.scrollBar then display.remove( self.scrollBar ); self.scrollBar = nil; end
		if hideScrollbar then return false; end
		
		if self.isInfinite then return false; end
		
		if self.isPickerColumn then return false; end
		
		local width = width
		local height = self.hSize + self.top
		
		local r, g, b, a = 0, 0, 0, 120
		
		local scrollH = 52 --height * self.height/( self.height*2 - height )		
		self.scrollBar = display.newRoundedRect( x+width-7, 0, 5, scrollH, 2 )
		self.scrollBar:setFillColor( r, g, b, a )

		local difference = self.height - height
		
		if self.isTableView and self.totalHeight then
			difference = self.totalHeight - height
		end
		
		local yRatio = mFloor((-self.y * 100) / difference)
		
		if yRatio < 0 then
			yRatio = 0
		elseif yRatio > 100 then
			yRatio = 100
		end
		
		local realPosition = (yRatio * height) / 100
		
		self.scrollBar.y = realPosition

		self.scrollTween = transition.to( self.scrollBar,  { time=300, alpha=0 } )
		
		self.catGroup:insert( self.scrollBar )
	end
	
	
	--
	
	-- Resize the height of the scrollView
	
	--
	
	function scrollGroup:resetHeight( newHeight )
		
		height = newHeight
		self.hSize = height
		
		if maskFile then	
			-- remove old mask
			maskGroup:setMask( nil )
			scrollMask = nil			
		end
		
		-- if new height matches either of the preset mask dimensions, add a mask
		local customHeightFound =
				height == 100 or height == 128 or height == 176 or
				height == 200 or height == 208 or height == 240 or height == 256 or
				height == 300 or height == 320 or height == 384 or
				height == 400 or height == 480 or
				height == 500 or height == 512 or
				height == 600 or height == 624 or
				height == 700 or height == 752 or height == 768 or
				height == 800 or height == 1024
		
		--if height == 128 or height == 176 or height == 208 or height == 240 or height == 256 or height == 320 or height == 384 or height == 480 or height == 512 or height == 624 or height == 752 or height == 768 or height == 1024 then
		
		if customHeightFound then
			
			local maskTable = "mask" .. height
			maskFile = skinPackage .. "/" .. skinTable[maskTable][1]
			
			scrollMask = graphics.newMask( maskFile )
			maskGroup:setMask( scrollMask )
			
			maskGroup.maskX = x + (width * 0.5)
			maskGroup.maskY = y + (height * 0.5)
		end
		
		
		-- reset some of the screenGroup's variables
		local screenH = display.contentHeight
		local leftover = screenH - height
		self.top = y
		self.bottom = leftover - self.top
		
		self:moveScrollBar()
	end
	
	
	--
	
	-- Resize the width of the scrollView
	
	--
	
	function scrollGroup:resetWidth( newWidth )
		
		width = newWidth
		
		if maskFile and maskGroup and maskGroup.maskX then
			maskGroup.maskX = x + (width * 0.5)
		end
		
		if not hideScrollbar then
			scrollGroup:addScrollBar()
		end
	end
	
	--
	
	-- Override the removeSelf() event with one that also cancels the movement tween,
	-- as well as any potential Runtime listeners that may still be active.
	
	--
	
	scrollGroup.oldRemoveSelf = scrollGroup.removeSelf
	
	function scrollGroup:removeSelf()
	
		if self.lastItemTouched then
			self.lastItemTouched = nil
		end
		
		Runtime:removeEventListener( "enterFrame", trackVelocity )
		limitVelocity()
		Runtime:removeEventListener( "enterFrame", self )
		
		
		if self.tween then
			transition.cancel( self.tween )
			self.tween = nil
		end
		
		if self.scrollTween then
			transition.cancel( self.scrollTween )
			self.scrollTween = nil
		end
		
		if self.itemTween then
			transition.cancel( self.itemTween )
			self.itemTween = nil
		end
		
		if self.scrollBar then
			display.remove( self.scrollBar )
			self.scrollBar = nil
		end
		
		self:oldRemoveSelf()
		self = nil
	end
	
	--
	--
	
	function t:stopScrolling()
		Runtime:removeEventListener( "enterFrame", trackVelocity )
		limitVelocity()
		Runtime:removeEventListener( "enterFrame", t.view )
	end
	
	--
	-- Override the insert() function to add add a new scrollBar (deleting the old one first)
	-- whenever a new item is inserted into the group (because height changes)
	--
	
	scrollGroup.oldInsert = scrollGroup.insert
	
	function scrollGroup:insert( obj, position )
		self:oldInsert( obj, position )
		
		if not hideScrollbar then
			self:addScrollBar()
		end
	end
	
	--
	
	function t:removeSelf()
		
		display.remove( scrollGroup )
		scrollGroup = nil
		
		if maskGroup then
			maskGroup:setMask( nil )
			
			display.remove( maskGroup )
			maskGroup = nil
			
			if scrollMask then
				scrollMask = nil
			end
		end
		
		if catGroup then
			display.remove( catGroup )
			catGroup = nil
		end
		
		if bgGroup then
			bgGroup = nil
		end
		
		self = nil
		
		return nil
	end
	
	--
	--
	
	function t:insert( obj )
		scrollGroup:insert( obj )
	end
	
	--
	--
	
	-- Position the scrollGroup based on given x/y coordinates
	scrollGroup.x, scrollGroup.y = x, y
	
	--====================================================
	
	-- Metamethods
	
	--====================================================
	
	mt.__index = function( tb, key )
		if key == "view" then
			return t.maskView
		
		elseif key == "display" then
			return t._view
		
		elseif key == "x" then
			return x
			
		elseif key == "y" then
			return y
		
		elseif key == "height" then
			return height
		
		elseif key == "width" then
			return width
		
		elseif key == "listItems" then
			return scrollGroup.listItems
			
		end
	end
	
	mt.__newindex = function( tb, key, value )
		
		if key == "x" then
			
			if maskFile then
				x = value
				scrollGroup.x = x
				maskGroup.maskX = x + (width * 0.5)
			else
				x = value	--> position 
				scrollGroup.x = x
			end

			if not hideScrollbar then
				scrollGroup:addScrollBar()
			end
		
		elseif key == "y" then
			
			if maskFile then
				y = value
				scrollGroup.y = y
				maskGroup.maskY = y + (height * 0.5)
			else
				y = value	--> position 
				scrollGroup.y = y
			end

			-- reset some of the screenGroup's variables
			local screenH = display.contentHeight
			local leftover = screenH - height
			scrollGroup.top = y
			scrollGroup.bottom = leftover - scrollGroup.top
				
			scrollGroup:moveScrollBar()

		elseif key == "height" then
			scrollGroup:resetHeight( value )
		
		elseif key == "width" then
			scrollGroup:resetWidth( value )
		
		end
	end
	
	setmetatable( t, mt )
	
	
	-- Return the table as the final object
	return t
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newTableView()
--
----------------------------------------------------------------------------------------------------

function newTableView( params )
	
	-- localize math function
	local mFloor = mFloor
	
	-- override skinSetting if one is specified for this widget
	local skinSetting = skinSetting
	if params and params.skin then
		skinSetting = getSkinTable( params.skin )
	end
	
	local skinTable = skinSetting.tableView
	
	-- setup scrollView-specific variables w/ defaults
	local width, height, x, y, hideScrollbar, maskFile =
		320, nil, 0, 0, false, nil
	
	-- create dummy params table if no params were set
	if not params then params = dummyEmpty; end
	
	-- extract parameters or set defaults
	local	width = params.width or 320
	local	height = params.height
	local	x = params.x or 0
	local	y = params.y or 0
	local	hideScrollbar = params.hideScrollbar
	local	maskFile = params.mask or params.maskFile
	local	rowHeight = params.rowHeight or 56
	local	rowColor = params.rowColor or { 255, 255, 255 }
	local	downColor = params.downColor or { 67, 141, 241 }
	local	rowBg = params.rowBg or params.rowBackground
	local	titleFont = params.titleFont or { skinTable.titleFont, { 0, 0, 0 }, skinTable.titleSize }
	local	descFont = params.subtitleFont or params.subFont or { skinTable.descFont, { 106, 115, 125 }, skinTable.descSize }
	local	categoryBg = params.categoryBg or params.categoryBackground or { skinPackage .. "/" .. skinTable.categoryBg.img, skinTable.categoryBg.w, skinTable.categoryBg.h }
	local	categoryFont = params.categoryFont or { skinTable.categoryFont, { 255, 255, 255 }, skinTable.categorySize }
	local	rowMask = params.rowMask
	local	baseDir = params.baseDir or defaultBase
	local	bgImage = params.background
	local	bgColor = params.backgroundColor or { 67, 67, 67 }
	local	isInfinite = params.isInfinite
	local	bottomLineColor = params.bottomLineColor or params.lineColor or { 224, 224, 224 }
	local	isForPickerWheel = params.isForPickerWheel
	local	labelStartX = params.labelStartX
	local	rightArrow = params.rightArrow or { skinPackage .. "/" .. skinTable.rightArrow.img, skinTable.rightArrow.w, skinTable.rightArrow.h }
	
	-- set min. row height to 40 px
	if rowHeight < 40 then rowHeight = 40; end
	
	-- Create our scrollView container (for the list)
	local scrollView = newScrollView( {
		width = width,
		height = height,
		x = x, y = y,
		maskFile = maskFile,
		backgroundImage = bgImage,
		backgroundColor = bgColor,
		isInfinite = isInfinite,
		isForPickerWheel = isForPickerWheel,
		hideScrollbar = hideScrollbar }, true )	--> second argument (true) lets it know this is a tableView, not just a normal scrollView
	
	
	-- create tables (for metamethods)
	local t = { _view = scrollView.display, maskView = scrollView.view }
	local mt = {}	--> our metatable
	
	
	local listItems = display.newGroup()
	local scrollV = scrollView.display
	
	scrollV:insert( listItems )
	scrollV.listItems = listItems
	
	scrollV.data = {}
	
	scrollV.rowHeight = rowHeight
	
	scrollV.totalHeight = 0
	
	scrollV.jumpDistance = rowHeight+100     -- 200 --scrollV.hSize / 1.5	--> amount of pixels above and below list items to "jump" to bottom or top position
	scrollV.maxY = 0
	scrollV.minY = 0
	
	-- default category in view
	scrollV.category = nil
	scrollV.categories = {}
	
	
	scrollV.isInfinite = isInfinite
	
	--==================================================================================
	--
	--	SYNC FUNCTION: t:sync()
	--
	--	Removes old entries, calculates how many entries to add based on list
	--  height, and renders visible items.
	--
	--==================================================================================
	
	function t:sync( dataTable, gotoTop )
		
		if not dataTable or type(dataTable) ~= "table" then return nil; end
		
		-- This function will create the actual rows, assign enterFrame listeners to
		-- them, and render the first set of data
		
		local scrollV = scrollV	--> for easier access
		
		-- calculate how many rows need to be shown (minimum) depending on
		-- the scrollView's height.
		
		local mCeil = mCeil
		
		local height = scrollV.hSize
		--local minRowHeight = 56
		local defaultRowHeight = scrollV.rowHeight
		local howManyWillFit = mCeil( height / defaultRowHeight )
		local totalRows = howManyWillFit + 3	--> add an extra 3 rows for buffer
		
		if totalRows > #dataTable then
			totalRows = #dataTable
		end
		
		-- First, go through and delete any items that may already be there,
		-- if so, this is treated as a re-render session
		
		for i=scrollV.listItems.numChildren,1,-1 do
			
			-- remove any "stuck" categories
			Runtime:removeEventListener( "enterFrame", scrollV.listItems[i] )
			display.remove( scrollV.listItems[i] )
			display.remove( scrollV.category )
			scrollV.listItems[i] = nil
			scrollV.category = nil
			
			-- nil out the "categories" table as well
			scrollV.categories = nil
			scrollV.categories = {}
			
			-- reset total list height
			scrollV.totalHeight = 0
		end
		
		-- make sure the scrollview's location is reset back to top
		-- position since all items were just removed
		
		scrollV.y = scrollV.top
		
		-- for setting category for individual list item
		local currentCategory = ""
		
		-- get the total height of the list (including categories)
		for i=1,#dataTable do
			
			local defaultHeight = scrollV.rowHeight
			local rowHeight
			
			-- set the id for each item in dataTable
			dataTable[i].id = i
			
			if dataTable[i].rowHeight then
				rowHeight = dataTable[i].rowHeight
			
			elseif dataTable[i].categoryName then
				rowHeight = categoryBg[3]
				
				currentCategory = dataTable[i].categoryName
				
				-- add this entry to the categories table
				scrollV.categories[#scrollV.categories+1] = { categoryName=dataTable[i].categoryName, dataIndex=dataTable[i].id }
			else
				rowHeight = defaultHeight
			end
			
			dataTable[i].catName = currentCategory
			
			scrollV.totalHeight = scrollV.totalHeight + rowHeight
		end
		
		--
		--
		
		-- assign the data table to the scrollView object, which holds info
		-- for ALL row items, not just the amount that will be rendered at first.
		scrollV.data = dataTable
		
		local yPosition = 0
		
		
		scrollV.totalRowHeight = 0	--> will hold total row height for currently shown entries (not all in dataTable)
		
		-- go through and create the number of rows calculated
		for i=1,totalRows do
			
			local listIndex = i
			local dataIndex = i
			local parseItem = dataTable[i]
			
			-- create the list entry group
			local listEntry = display.newGroup()
			
			listEntry.listIndex = listIndex
			
			-- determine the row height
			local rowHeight = parseItem.rowHeight or scrollV.rowHeight
			
			if parseItem.categoryName then
				rowHeight = parseItem.rowHeight or categoryBg[3]
			end
			
			listEntry.rowHeight = rowHeight
			
			scrollV.totalRowHeight = scrollV.totalRowHeight + rowHeight
			
			t:renderItem( listEntry, dataIndex, listIndex )
			
			-- position the item (relative to other items)
			listEntry.y = yPosition or 0
			
			yPosition = yPosition + rowHeight
			
			
			-- insert list item into scrollview
			scrollV.listItems:insert( listEntry )
			
			
			-- add enterFrame listener
			function listEntry:enterFrame( event )
				
				local scrollV = scrollV
				local isMoving = scrollV.isMoving
				
				if isMoving then
					
					local totalRowHeight = scrollV.totalRowHeight
					local hSize = scrollV.hSize
					local halfRow = self.rowHeight + (self.rowHeight * 0.5)
					
					-- calculate new jump distance
					scrollV.jumpDistance = totalRowHeight - (hSize + halfRow) --(totalRowHeight - hSize) - halfRow
					
					local jumpDistance = scrollV.jumpDistance
					
					local myY = self.contentBounds.yMin
					local myId = self.id
					local myIndex = self.listIndex
					local top = scrollV.top
					local topMax = top - jumpDistance
					local bottomMax = top + hSize + jumpDistance
					local isPickerColumn = scrollV.isPickerColumn
					
					--
					--
					--
					
					--===============================================
					--===============================================
					--
					-- For Picker Wheels
					--
					--===============================================
					--===============================================
					
					if isPickerColumn then
						
						local top = scrollV.pickerParent.y
						local topPoint, bottomPoint = top+45, top+100
						local midPoint = top + 88 --80
						
						if myY <= bottomPoint and myY > topPoint then
						
							if self.titleText.text ~= scrollV.value then
								scrollV.value = self.titleText.text
								
								if scrollV.columnType and scrollV.columnType == "day" then
									scrollV.pickerParentT.dayValue = scrollV.value
								end
								
								--print( "Selected item: " .. scrollV.value )
								
							end
							
							-- SNAP ITEM INTO PLACE (if in-between items or not centered on glass):
							
							if not scrollV.snapDisabled then
								
								if myY > midPoint then
									local snapAmount = myY - midPoint
									
									local newY = scrollV.listItems.y - snapAmount
									
									
									transition.to( scrollV.listItems, { time=300, y=newY, transition=easing.outQuad } )
									
								elseif myY < midPoint then
									scrollView._view.velocity = 0
									
									local snapAmount = midPoint - myY
									
									local newY = scrollV.listItems.y + snapAmount
									
									transition.to( scrollV.listItems, { time=300, y=newY, transition=easing.outQuad } )
								end
							end
						end
						
					end
					
					
					--===============================================
					--===============================================
					
					--
					--
					--
					
					local timeID = scrollV.timeID
					
					if timeID ~= "amPM" then
						
						
						if myY == top then
								
							-- CHECK IF CATEGORY NAME IS THE CORRECT ONE
							
							local theCat = scrollV.category
							local isCategory = self.isCategory
							
							if theCat and not isCategory then
								
								local catName = self.catName
								
								if catName ~= "" then
								
									local labelText = scrollV.category.titleText.text
									
									if catName ~= labelText then
										scrollV.category.titleText:setText( catName )
									end
								
								else
									display.remove( scrollV.category )
									scrollV.category = nil
								end
							end
						end
						
						
						-- CONTINUE RENDERING DEPENDING ON UPWARD/DOWNWARD MOVEMENT
						if myY <= topMax then
							
							--===============================================
							--===============================================
							--
							-- LIST ITEMS MOVING UP (negative-Y direction)
							-- 
							-- Take item from very top to very end
							--
							--==============================================
							--==============================================
	
							-- score this item's id and list index
							local myId = myId
							local myIndex = myIndex
							
							
							-- find out which is the last item in the index
							local lastItem = scrollV.listItems[scrollV.listItems.numChildren]
							local lastIndex = lastItem.listIndex
							local lastY = lastItem.y
							
							-- move this item to underneath last item, and rerender
							-- but ONLY if the last item hasn't been reached
							
							local moveToBottom = function( isInfinite )
								local theLast = lastIndex
								local nextIndex = theLast+1
								
								if isInfinite then
									if theLast == #scrollV.data then
										nextIndex = 1
										lastIndex = #scrollV.data
									end
								end
								
								local nextRowHeight = scrollV.data[lastIndex].rowHeight or scrollV.rowHeight
								
								if scrollV.data[lastIndex].categoryName then
									nextRowHeight = scrollV.data[lastIndex].rowHeight or categoryBg[3]
								end
								
								local yPos = lastY + nextRowHeight
								
								
								scrollV.listItems:insert( self )
								self.y = yPos
								
								t:renderItem( self, nextIndex, nextIndex )
							end
							
							if not scrollV.isInfinite then
								if tonumber(lastIndex) < #scrollV.data then
									moveToBottom()
								end
							else
								moveToBottom( true )
							end
							
						elseif myY >= bottomMax then
							
							--===============================================
							--===============================================
							--
							-- LIST ITEMS MOVING DOWN (positive-Y direction)
							-- 
							-- Take item from end to the very top
							--
							--==============================================
							--==============================================
							
							local myId = myId
							local myIndex = myIndex
							
							-- get and store the first item in the index
							local firstItem = scrollV.listItems[1]
							local firstIndex = firstItem.listIndex
							local firstY = firstItem.y
							
							
							-- move this item to above the first item, and rerender
							-- but ONLY if the first item hasn't been reached
							
							local moveToTop = function( isInfinite )
								
								local nextI = firstIndex-1
								
								if isInfinite then
									if firstIndex == 1 then
										nextI = #scrollV.data
									end
								end
								
								t:renderItem( self, nextI, nextI )
								
								local nextRowHeight = scrollV.data[nextI].rowHeight or scrollV.rowHeight
								
								if scrollV.data[nextI].categoryName then
									nextRowHeight = scrollV.data[nextI].rowHeight or categoryBg[3]
								end
								
								local yPos = firstY - nextRowHeight
								
								scrollV.listItems:insert( 1, self )
								self.y = yPos
							end
							
							--
							
							if not scrollV.isInfinite then
								if tonumber(firstIndex) > 1 then
									moveToTop()
								end
							else
								moveToTop( true )
							end
							
						else
							--==============================================
							--==============================================
							--
							-- FOR CATEGORIES
							--
							--==============================================
							--==============================================
							
							if self.isCategory then
								
								local top = top
								local myY = myY
								
								-- PUSH THE PREVIOUS CATEGORY UP OR DOWN (IF IT EXISTS):
								
								if scrollV.category then
									
									local top = top
									local selfHeight = self.height
									local myY = myY
									
									local catHeight = categoryBg[3]
									
									if myY <= top + catHeight then
										
										scrollV.category.y = myY - catHeight
									
									elseif myY >= top + catHeight + selfHeight then
										scrollV.category.y = top
									end
								end
								
								--
								
								-- DISPLAY THE PROPER CATEGORY:
								
								if myY <= top then
									
									-- Check to see if item crosses the top position (upward)
									
									-- Create new category item (identical to self)
									-- to make the category appear to "stick"
									local categoryLabel
									
									if not self.titleText.text then
										categoryLabel = "Category"
									else
										categoryLabel = self.titleText.text
									end
									
									local newCategory = t:renderCategory( categoryLabel, self.id )
									
									newCategory.x = scrollV.x
									newCategory.y = top
									
									scrollV.maskGroup:insert( newCategory )
									
									if scrollV.category then
										display.remove( scrollV.category )
										scrollV.category = nil
									end
									
									scrollV.category = newCategory
									scrollV.category.labelText = categoryLabel
								
								elseif myY > top and myY < bottomMax then
									
									-- Check to see if item goes back down PAST the top position
									
									if scrollV.category then	--> a category label was present
										
										-- check to see if current category's dataIndex is the same
										-- as this item's id
										
										if scrollV.category.dataIndex == self.id then
											
											display.remove( scrollV.category )
											scrollV.category = nil
											
											-- check to see if there's another category that needs to
											-- be rendered
											
											if self.id >= 1 then
												local previousCategory
												
												for i=1,#scrollV.categories do
													if scrollV.categories[i].dataIndex == self.id then
														
														if i==1 and scrollV.isInfinite then
															previousCategory = scrollV.categories[#scrollV.categories]
														else
															previousCategory = scrollV.categories[i-1]
														end
													end
												end
												
												if previousCategory then
													
													local nextId = self.id-1
													
													if nextId == 0 then nextId = scrollV.categories[#scrollV.categories].dataIndex; end
													
													local newCategory = t:renderCategory( previousCategory.categoryName, self.id-1 )
													
													newCategory.x = scrollV.x
													newCategory.y = top
													
													scrollV.maskGroup:insert( newCategory )
													
													scrollV.category = newCategory
												end
											end
										end
									else
										
										if scrollV.isInfinite then
											
											local previousCategory = scrollV.categories[#scrollV.categories]
											
											if previousCategory then
													
												local nextId = self.id-1
												
												if nextId == 0 then nextId = scrollV.categories[#scrollV.categories].dataIndex; end
												
												local newCategory = t:renderCategory( previousCategory.categoryName, self.id-1 )
												
												newCategory.x = scrollV.x
												newCategory.y = top
												
												scrollV.maskGroup:insert( newCategory )
												
												scrollV.category = newCategory
											end
										end
										
										
									end
								end
							end
						end	--> if myY > topMax ...
					
					end --> if timeID...
				end
			end
			
			Runtime:removeEventListener( "enterFrame", listEntry )
			Runtime:addEventListener( "enterFrame", listEntry )
			
			--===================================================================================
			
			function listEntry:touch( event )
				
				local scrollV = scrollView.display
				
				if event.phase == "began" then
					scrollV.lastItemTouched = self
				end
				
				return false
			end
			
			listEntry:addEventListener( "touch", listEntry )
			
		end	--> end for loop
		
		-- set the maxY and minY values for the scrollView object.
		-- these are the points at which entries will go to the other end and re-render
		scrollV.maxY = scrollV.top - scrollV.jumpDistance
		scrollV.minY = scrollV.totalHeight + scrollV.jumpDistance
		
		
		-- reset the scrollBar
		if not scrollV.scrollbarHidden then
			scrollV:addScrollBar()
		end
		
		--
		-- scroll to the top
		--
		-- should be set to true is updated/re-synced list is significantly smaller
		-- than previously synced list
		
		if gotoTop then
			t:scrollToTop()
		end
	end
	
	--
	--
	
	function t:getIndexOfItemsInView()
		
		--
		-- This function is used to determine the data indexes of the list items
		-- that are currently rendered.
		
		local listItems = self.display.listItems
		local totalItems = listItems.numChildren
		
		local itemsInView = {}
		
		for i=1,totalItems do
			itemsInView[i] = listItems[i].dataIndex
		end
		
		return itemsInView
	end
	
	--
	--
	
	function t:deleteRow( listObject )
		
		--*************************************************************************
		--
		--    This function will delete a row item that is currently
		--	  rendered, shifting the items below it upwards.
		--
		--*************************************************************************
		
		local scrollV = self.display
		local dataTable = scrollV.data
		local listItems = scrollV.listItems
		
		-- mark the height and y position of the listObject (the row marked for deletion)
		local rowHeight = listObject.rowHeight
		local rowY = listObject.y
		local dataIndex = listObject.dataIndex
		
		-- Get index of items in view, store as a table
		local itemsInView = self:getIndexOfItemsInView()
		
		-- Remove the item marked from deletion from the table
		for i=1,#itemsInView do
			if itemsInView[i] == dataIndex then
				table.remove( itemsInView, i )
			end
		end
		
		-- make list object invisible
		Runtime:removeEventListener( "enterFrame", listObject )
		listObject.isVisible = false
		
		-- remove item from data table
		table.remove( scrollV.data, dataIndex )
		
		-- forward references for shifting list items upward
		local finalY, finalRowHeight, finalData
		
		--
		--
		
		-- function to render next data item below last list object (row)
		local renderToBottom = function()
			
			listObject.y = finalY + finalRowHeight
		
			self:renderItem( listObject, finalData+1, finalData+1 )
			
			listObject.isVisible = true
			Runtime:addEventListener( "enterFrame", listObject )
			
			listItems:insert( listObject )
		end
		
		--
		--
		
		-- function to render next data item above first list object (row)
		local renderToTop = function()
			
			listObject.y = listItems[1].y - listItems[1].rowHeight
			
			self:renderItem( listObject, listItems[1].dataIndex-1, listItems[1].dataIndex-1 )
			
			listObject.isVisible = true
			Runtime:addEventListener( "enterFrame", listObject )
			
			listItems:insert( 1, listObject )
		end
		
		--
		--
		
		-- shift the list objects below upward
		local firstDataIndex = listItems[1].dataIndex
		
		local syncOrRender = function( finalWasDeleted )
			if listObject == listItems[1] or listItems.numChildren > #dataTable then
				self:sync( dataTable )
			else
				
				-- make sure last item doesn't already have final data index				
				if listItems[listItems.numChildren].dataIndex == #dataTable or finalWasDeleted then
					
					-- if so, render the next item at the very top
					renderToTop()
				else
					-- otherwise, render item at very bottom
					renderToBottom()
				end
				
				-- reset current totalHeight for list
				scrollV.totalHeight = 0
				
				-- recalculate total height of all list items
				for i=1,#dataTable do
					
					local defaultHeight = scrollV.rowHeight
					local rowHeight
					
					-- set the id for each item in dataTable
					dataTable[i].id = i
					
					if dataTable[i].rowHeight then
						rowHeight = dataTable[i].rowHeight
					
					elseif dataTable[i].categoryName then
						rowHeight = categoryBg[3]
					else
						rowHeight = defaultHeight
					end
					
					scrollV.totalHeight = scrollV.totalHeight + rowHeight
				end
			end
		end
		
		--
		
		for i=1,listItems.numChildren do
			
			local itemY = listItems[i].y
			local newY
			
			if itemY > rowY + 16 and listItems[i] ~= listObject then
				newY = itemY - rowHeight
				
				local lastItem = i == listItems.numChildren
				
				local finishSlideUp = function()
					if lastItem then
						syncOrRender()
					end
				end
				
				transition.to( listItems[i], { time=200, y=newY, transition=easing.inOutQuad, onComplete=finishSlideUp } )
				-- No animation: listItems[i].y = newY
				
				-- Update dataIndex and listIndex
				listItems[i].dataIndex = listItems[i].dataIndex - 1
				listItems[i].listIndex = listItems[i].listIndex - 1
				
				-- Record the y position and data Index of last rendered list item
				if i == listItems.numChildren then
					finalY = newY
					finalRowHeight = listItems[i].rowHeight
					finalData = listItems[i].dataIndex
				end
			
			elseif i == listItems.numChildren and listItems[i] == listObject then
				
				-- If this is the last list item, but also the item marked for deletion...
				
				syncOrRender( true )
				
			end
		end
		
		return true
	end
	
	--
	--
	
	function t:changeTitleText( listItem, newTextString )
		
		if not listItem then return nil; end
		
		local titleX, titleY
		if listItem.titleText then
			titleX = listItem.titleText.x
			titleY = listItem.titleText.y
			
			display.remove( listItem.titleText )
		end
		
		local title = self.display.data[listItem.dataIndex].title
		local titleLabel, titleFont, titleSize, titleColor =
				"", titleFont, 18, { 0, 0, 0 }
				
		local titleColor = title.color or titleColor
		
		local fontLabel = newTextString or titleLabel
		local fontName = title.font or titleFont
		local fontSize = title.size or titleSize
		local r = titleColor[1]
		local g = titleColor[2]
		local b = titleColor[3]
		
		titleTextObj = display.newText( fontLabel, 0, 0, fontName, fontSize )
		titleTextObj:setTextColor( r, g, b, 255 )
		titleTextObj:setReferencePoint( display.TopLeftReferencePoint )
		titleTextObj.x = titleX
		titleTextObj.y = titleY
		
		listItem.titleColor = titleColor
		listItem.textGroup:insert( titleTextObj )
		listItem.titleText = titleTextObj
	end
	
	--
	--
	
	function t:changeSubText( listItem, newTextString )
		
		if not listItem then return nil; end
		
		-- get textWidth from old subtitle
		local textWidth = 0
		if listItem.subTitleText then
			textWidth = listItem.subTitleText.textWidth
		end
		
		local subtitle = self.view.data[listItem.dataIndex].subtitle
		local subLabel, subFont, subSize, subColor, subX, subY =
				"", descFont, 14, { 150, 150, 150 }, 0, 0
		
		if subtitle then
			subLabel = newTextString or subLabel
			subFont = subtitle.font or subFont
			subSize = subtitle.size or subSize
			subColor = subtitle.color or subColor
			subX = listItem.subTitleText.x
			subY = listItem.subTitleText.y
		end
		
		if listItem.subTitleText then
			display.remove( listItem.subTitleText )
		end
		
		local newSubTitle = textWrapper( subLabel, subFont, subSize, subColor, textWidth )
		newSubTitle:setReferencePoint( display.TopLeftReferencePoint )
		newSubTitle.x = subX
		newSubTitle.y = subY
		
		listItem.textGroup:insert( newSubTitle )
		listItem.subTitleText = newSubTitle
	end
	
	--
	--
	
	function t:renderItem( listEntryObject, dataIndex, listIndex )
		
		local scrollV = scrollView.display
		local dataI = dataIndex or 1
		local listI = listIndex or 1
		
		local oldRowHeight = listEntryObject.rowHeight
		
		local dataItem = scrollV.data[dataIndex]
		local listItem = listEntryObject
		
		-- if faulty data item requested, exit the function
		if not dataItem then return false end;
		
		-- remove old item contents
		if listItem.itemContent then
			for i=listItem.itemContent.numChildren,1,-1 do
				display.remove( listItem.itemContent[i] )
			end
			
			display.remove( listItem.itemContent )
		end
		
		
		--====================================
		--
		-- PARSE DATA FROM dataTable
		--
		--====================================
		
		local id = dataIndex
		local customId = dataItem.customId or ""			--> fix to allow users to set a custom id for each list item
		local titleText = dataItem.titleText or ""
		local onRelease = dataItem.onRelease or nil
		local onLeftSwipe = dataItem.onLeftSwipe or nil
		local onRightSwipe = dataItem.onRightSwipe or nil
		local rowHeight = dataItem.rowHeight or scrollV.rowHeight
		
		-- individual content elements (for list item):
		local icon = dataItem.icon or nil
		local title = dataItem.title or nil
		local subtitle = dataItem.subtitle or nil
		local hideArrow = dataItem.hideArrow or false
		local bgAlpha = dataItem.bgAlpha or 1.0
		local rowColor = dataItem.bgColor or rowColor		--> fix for bug where individual row color could not be set (no casenum)
		local downColor = dataItem.downColor or downColor	--> for for bug where individual row color (down position) could not be set (no casenum)
		
		
		--
		
		if dataItem.categoryName then
			titleText = dataItem.categoryName
			rowHeight = dataItem.rowHeight or categoryBg[3]
		end
		
		-- calculate difference between this row height and the previous
		-- and then update the jump distance of entry item. this must
		-- be recalculated on every jump due to the possible variances
		-- in row heights between items/categories
		
		if oldRowHeight and oldRowHeight ~= rowHeight then
			local difference = rowHeight - oldRowHeight
			scrollV.totalRowHeight = scrollV.totalRowHeight + difference
		end
		
		--
		--
		--
		
		local titleTextObj, subTitleObj, rightArrowObj, xPos, yPos
		
		
		-- Below function creates background rectangle and bottom line
		--
		
		local createBackgroundAndLine = function()
			
			local listBg
			
			-- remove previous background IF the rowheight is different,
			-- otherwise, we can optimize by re-using the rectangle
			
			if listItem.bgObj then
				if listItem.bgObj.height ~= rowHeight then
					display.remove( listItem.bgObj )
					listItem.bgObj = nil
				else
					listBg = listItem.bgObj
				end
			end
			
			-- remove previous border line
			display.remove( listItem.bottomLine )
			listItem.bottomLine = nil
			
			local width = scrollV.wSize
			
			-- create a standard rectangular background
			if not listBg then listBg = display.newRect( 0, 0, width, rowHeight ); end
			listBg:setFillColor( rowColor[1], rowColor[2], rowColor[3], 255 )
			listBg:setReferencePoint( display.TopLeftReferencePoint )
			listBg.alpha = bgAlpha
			
			listItem:insert( listBg )
			
			listItem.bgObj = listBg
			listItem.bgColor = rowColor
			listItem.downColor = downColor	--> fix for highlight item bug (no casenum)
			
			-- create the line that goes below the list item
			local bottomY = listBg.height
			local bottomLine = display.newLine( listItem, 0, 0, width, 0 )
			local r, g, b = 
				bottomLineColor[1],
				bottomLineColor[2],
				bottomLineColor[3]
			bottomLine:setColor( r, g, b, 255 )
			bottomLine.width = 2
			bottomLine.x = 0
			bottomLine.y = bottomY
			
			listItem.bottomLine = bottomLine
		end
		
		-- if item is a category and NEXT item is not
		if listItem.isCategory then
			
			--check the next item
			if not dataItem.categoryName then
				createBackgroundAndLine()
			end
		end
		
			
		-- this item was NOT a category, lets see if the next
		-- one is (if so, create a category bg object)
		
		if dataItem.categoryName then
			
			display.remove( listItem.bgObj )
			listItem.bgObj = nil
			
			display.remove( listItem.bottomLine )
			listItem.bottomLine = nil
			
			-- create a category background
			local categoryBg = categoryBg
			rowHeight = categoryBg[3]
			
			local catBg = display.newImageRect( categoryBg[1], baseDir, categoryBg[2], rowHeight )
			catBg.xScale = scrollV.wSize * categoryBg[2]
			catBg:setReferencePoint( display.TopLeftReferencePoint )
			catBg.x = 0
			catBg.y = 0
			
			listItem:insert( catBg )
			listItem.bgObj = catBg
			
			-- create embossed text
			titleTextObj = newEmbossedText( titleText, 0, 0, categoryFont[1], categoryFont[3], categoryFont[2], true )
			titleTextObj:setReferencePoint( display.CenterLeftReferencePoint )
			titleTextObj.x = 0
			titleTextObj.y = 0 --rowHeight * 0.5
			
			xPos = 10
			yPos = rowHeight * 0.5
		
		else
			if not listItem.bgObj or listItem.rowHeight ~= rowHeight then
				createBackgroundAndLine()
			end
		end
		
		-- set the onRelease, onLeftSwip, and onRightSwipe event listeners
		listItem.onRelease = onRelease
		listItem.onLeftSwipe = onLeftSwipe
		listItem.onRightSwipe = onRightSwipe
		
		
		--======================================================
		--======================================================
		--
		--  Render Item Content
		--
		--======================================================
		--======================================================
		
		local itemContent = display.newGroup()
		local textGroup = display.newGroup()
		itemContent:insert( textGroup )
		
		--
		
		local renderItemContent = function()
			
			-- Make some calculations based on icon, width, etc.
			local leftPosition = 0
			local iconPadding, iconPaddingTop, iconPaddingLeft, iconPaddingRight, iconImg, iconWidth, iconHeight =
					10, nil, 0, 0
			
			if icon then
				iconPadding = icon.padding or 10
				iconPaddingTop = icon.paddingTop or iconPadding
				iconPaddingLeft = icon.paddingLeft or iconPadding
				iconPaddingRight = icon.paddingRight or iconPadding
				iconImg = icon.image or nil
				iconWidth = icon.width or 0
				iconHeight = icon.height or 0
				local baseDir = icon.base or icon.baseDir or defaultBase	--> localize baseDir so default is not changed (fix for casenum: 6917)
				
				-- create the icon image
				local theIcon = display.newImageRect( iconImg, baseDir, iconWidth, iconHeight )
				theIcon:setReferencePoint( display.TopLeftReferencePoint )
				theIcon.x = leftPosition + iconPadding
				theIcon.y = iconPaddingTop
				
				itemContent:insert( theIcon )
			end
			
			local titleLabel, titleFontname, titleSize, titleColor, titleLeft, titleTop =
					titleText, titleFont[1], titleFont[3], titleFont[2], 0, 10
			
			if title then
				titleLabel = title.label or titleLabel
				titleFontname = title.font or titleFontname
				titleSize = title.size or titleSize
				titleColor = title.color or titleColor
				titleLeft = title.left or titleLeft
				titleTop = title.top or titleTop
			end
			
			local subLabel, subFont, subSize, subColor, subLeft, subTop, subWidth =
					"", descFont[1], descFont[3], descFont[2], 0, 0, 0
			
			if subtitle then
				subLabel = subtitle.label or subLabel
				subFont = subtitle.font or subFont
				subSize = subtitle.size or subSize
				subColor = subtitle.color or subColor
				subLeft = subtitle.left or subLeft
				subTop = subtitle.top or subTop
				subWidth = subtitle.width or subWidth	-- fix bug where width was not allowed to be set for subtitle (no casenum)
			end
			
			-- update left position
			if iconWidth and iconWidth > 1 then
				leftPosition = leftPosition + iconPaddingLeft + iconWidth + iconPaddingRight + leftPosition
			else
				leftPosition = iconPadding
			end
			
			-- fix bug where width was not allowed to be set for subtitle (no casenum)
			if subWidth == 0 then subWidth = (scrollV.wSize - leftPosition - 20); end
			
			-- calculate available width for title and subtitle
			local textWidth = subWidth	-- fix bug where width was not allowed to be set for subtitle (no casenum)
			
		
			-- Create the titleText (if it's not already present, because it might've already been made)
			
			if titleTextObj then display.remove( titleTextObj ); end
							
			local fontName = titleFontname or titleFont[1]
			local fontSize = titleSize or 18
			local r = titleColor[1] or 0
			local g = titleColor[2] or 0
			local b = titleColor[3] or 0
			
			
			titleTextObj = display.newText( titleLabel, 0, 0, fontName, fontSize )
			titleTextObj:setTextColor( r, g, b, 255 )
			titleTextObj:setReferencePoint( display.TopLeftReferencePoint )
			titleTextObj.x = labelStartX or leftPosition + titleLeft
			titleTextObj.y = titleTop
			
			listItem.titleColor = titleColor
			textGroup:insert( titleTextObj )
			
			-- Create sub-title text
			--local subTitleObj = display.newText( subLabel, 0, 0, subFont, subSize )	--> single line text
			--subTitleObj:setTextColor( subColor[1], subColor[2], subColor[3], 255 )	--> for single line text
			
			if subtitle then
				subTitleObj = textWrapper( subLabel, subFont, subSize, { subColor[1], subColor[2], subColor[3] }, textWidth )
				subTitleObj:setReferencePoint( display.TopLeftReferencePoint )
				subTitleObj.x = leftPosition + subLeft
				local realHeight = titleTextObj.height * display.contentScaleY
				subTitleObj.y = titleTextObj.y + realHeight + subTop
				
				subTitleObj.textWidth = textWidth
				
				listItem.subColor = subColor
				textGroup:insert( subTitleObj )
			end
			
			if listItem.onRelease and not dataItem.hideArrow then
				
				-- Create the right arrow
				rightArrowObj = display.newImageRect( rightArrow[1], baseDir, rightArrow[2], rightArrow[3] )
				rightArrowObj:setReferencePoint( display.CenterRightReferencePoint )
				rightArrowObj.x = scrollV.wSize - 8
				rightArrowObj.y = listItem.rowHeight * 0.5
				
				itemContent:insert( rightArrowObj )
			end
			
			
			--
			listItem:insert( itemContent )
		end
		
		--======================================================
		
		--
		--
		
		if not dataItem.categoryName then
			-- if this isn't a category, render item content
			renderItemContent()
		else
			if titleTextObj then
				textGroup:insert( titleTextObj )
			end
			
			textGroup.x = xPos or labelStartX
			textGroup.y = yPos or rowHeight * 0.5 - 10
			
			listItem:insert( itemContent )
		end
		
		-- Position item contents
		--itemContent.y = yPos or rowHeight * 0.5 -10
		
		
		-- set the category type (true/false)
		if dataItem.categoryName then
			listItem.isCategory = true
		else
			listItem.isCategory = false
		end
		
		--=======================================
		--
		-- Assign variables to this list item:
		--
		--=======================================
		
		-- set up the variables for this list item
		listItem.id = id
		listItem.customId = customId		--> fix to allow users to set a custom id for each list item
		listItem.titleText = titleTextObj
		listItem.subTitleText = subTitleObj
		listItem.textGroup = textGroup
		listItem.itemContent = itemContent
		listItem.rowHeight = rowHeight
		listItem.dataIndex = dataI
		listItem.listIndex = listI
		listItem.catName = dataItem.catName
		listItem.bgColor = rowColor			--> fix for bug where individual row color could not be set (no casenum)
		listItem.downColor = downColor		--> fix for but where individual row color (down position) could not be set (no casenum)
		-- Defined above: listItem.bgObj = [the item background]
	end
	
	--
	--
	
	function t:renderCategory( labelText, dataIndex )
		
		local scrollV = scrollView.display
		
		if not labelText then labelText = "Category"; end
		if not dataIndex then dataIndex = 1; end
		
		local listItem = display.newGroup()
		
		-- create a category background
		local categoryBg = categoryBg
		rowHeight = categoryBg[3]
		
		local catBg = display.newImageRect( categoryBg[1], baseDir, categoryBg[2], rowHeight )
		catBg.xScale = scrollV.wSize * categoryBg[2]
		catBg:setReferencePoint( display.TopLeftReferencePoint )
		catBg.x = 0
		catBg.y = 0
		
		listItem:insert( catBg )
		listItem.bgObj = catBg
		
		-- create embossed text
		titleTextObj = newEmbossedText( labelText, 0, 0, categoryFont[1], categoryFont[3], categoryFont[2], true )
		titleTextObj:setReferencePoint( display.CenterLeftReferencePoint )
		titleTextObj.x = 10
		titleTextObj.y = rowHeight * 0.5
		
		listItem:insert( titleTextObj )
		
		-- set the dataIndex of this object
		listItem.dataIndex = dataIndex
		listItem.titleText = titleTextObj
		
		-- return the object
		return listItem
	end
	
	--
	--
	
	function t:stopScrolling()
		
		local scrollV = scrollView.display
		
		scrollView:stopScrolling()
		scrollV.isMoving = false
	end
	
	--
	--
	-- Touch listener for status bar (calls scrollToTop())
	
	local statusBarHeight = display.statusBarHeight
	
	local touchTopOfScreen = function( event )
		if event.phase == "began" and event.y <= statusBarHeight then
			t:scrollToTop()
		end
		
		return false
	end
	
	-- If status bar is showing, add a touch listener
	
	--[[ Commented out until we can figure out how to get touches to register on status bar (on device)
	if statusBarHeight > 0 then
		Runtime:addEventListener( "touch", touchTopOfScreen )
	end
	--]]
	
	--
	--
	
	function t:removeSelf()
		
		-- iterate through all of the items and remove the runtime listeners
		-- and the items
		
		local scrollV = scrollView.display
		
		-- remove the touch listener on status bar
		t:removeStatusBarTouch()
		
		-- Remove the category heading attached to top of list (if it exists)
		display.remove( scrollV.category )
		scrollV.category = nil
		
		-- Remove any runtime listeners associated with list items
		for i=scrollV.listItems.numChildren,1,-1 do
			
			Runtime:removeEventListener( "enterFrame", scrollV.listItems[i] )
			scrollV.listItems[i].enterFrame = nil
			
			display.remove( scrollV.listItems[i] )
			scrollV.listItems[i] = nil
		end
		
		-- remove the scrollview object
		
		display.remove( scrollView )
		scrollView = nil
		
		self = nil
		
		-- force garbage collection
		local doCollection = function() collectgarbage( "collect" ); end
		timer.performWithDelay(1, doCollection, 1 )
		
		return nil
	end
	
	
	--
	--
	
	function t:scrollToTop()
		
		local scrollV = scrollView.display
		local dataTable = scrollV.data
		
		-- reset velocity (in case list in currently moving)
		scrollV.velocity = 0
		
		-- re-sync the data to the table (will bring list to first item)
		t:sync( dataTable )
	end
	
	
	--
	--
	
	function t:addStatusBarTouch()
		Runtime:addEventListener( "touch", touchTopOfScreen )
	end
	
	--
	--
	
	function t:removeStatusBarTouch()
		Runtime:removeEventListener( "touch", touchTopOfScreen )
	end
	
	
	--
	--
	
	function t:scrollToBottom()
		
		local scrollV = scrollView.display
		local bottomPosition = display.contentHeight - scrollV.totalHeight - scrollV.bottom
		local mFloor = mFloor
		
		if scrollV.totalHeight > scrollV.height then
			
			local timeToScroll = mFloor(-((-scrollV.y - scrollV.totalHeight) / 4))
			
			scrollV.isMoving = true
			
			local completeScroll = function()
				scrollV.isMoving = false
				
				-- reset the scrollBar
				scrollV:addScrollBar()
			end
			
			scrollV.velocity = 0
			scrollV.scrollTween = transition.to( scrollV, { time=timeToScroll, y=bottomPosition, transition=easing.outQuad, onComplete=completeScroll } )
		end
	end
	
	--
	--
	
	--====================================================
	
	-- Metamethods
	
	--====================================================
	
	mt.__index = function( tb, key )
		if key == "view" then
			return t.maskView
		
		elseif key == "display" then
			return t._view
		
		elseif key == "x" then
			return scrollView.display.x
			
		elseif key == "y" then
			return scrollView.display.y
		
		elseif key == "height" then
			return scrollView.display.height
		
		elseif key == "width" then
			return scrollView.display.width
		
		elseif key == "isInfinite" then
			return scrollView.display.isInfinite
		
		elseif key == "data" then			-- added in to fix casenum: 6944
			return scrollView.display.data
			
		elseif key == "value" and scrollView.display.isPickerColumn then
			
			-- First, check to see if this is a date picker
			local preset = scrollView.display.preset
			
			if preset then
				
				if preset == "usDate" or preset == "euDate" then
					-- Make sure this is the second column (day)
					
					local colID = "second"
					if preset == "euDate" then colID = "first"; end
					
					if scrollView.display.columnID == colID then
						
						local month
						
						if preset == "usDate" then
							month = scrollView.display.pickerParentT.col1.value
						
						elseif preset == "euDate" then
						
							month = scrollView.display.pickerParentT.col2.value
						end
						
						local year = tonumber(scrollView.display.pickerParentT.col3.value)
						local day = tonumber(scrollView.display.pickerParentT.dayValue)
						
						
						if month == "February" and day >= 30 then
							-- check for leap year
							if (year % 400) == 0 or (year % 100) ~= 0 and (year % 4) == 0 then
								
								-- leap year:
								return "29"
							else
								-- normal year
								return "28"
							end
						
						else
							if day and day > 30 then
								if month == "April" or month == "June" or month == "September" or month == "November" then
									return "30"
								else
									return "31"
								end
							else
								return tostring(day)
							end
						end
					else
						return scrollView.display.value
					end
				else
					return scrollView.display.value
				end
			else
				return scrollView.display.value
			end
			
			
		end
	end
	
	mt.__newindex = function( tb, key, value )
		
		if key == "x" then
			
			scrollView.x = value
		
		elseif key == "y" then
			
			scrollView.y = value
		
		elseif key == "height" then
			
			scrollView.height = value
		
		elseif key == "width" then
			
			scrollView.width = value
		
		elseif key == "isInfinite" then
			
			scrollView.display.isInfinite = value
		
		end
	end
	
	setmetatable( t, mt )
	
	-- return the tableView object
	return t
end

----------------------------------------------------------------------------------------------------
--
-- ++(START) newPickerWheel()
--
----------------------------------------------------------------------------------------------------

function newPickerWheel( params )
	
	local mCeil = mCeil
	
	-- override skinSetting if one is specified for this widget
	local skinSetting = skinSetting
	if params and params.skin then
		skinSetting = getSkinTable( params.skin )
	end
	
	-- Specify the skin resource
	local skinTable = skinSetting.pickerWheel
	
	-- If this skin doesn't support the segmented control, exit the function:
	if not skinTable then
		print( "--" )
		print( "WARNING: Interace Library" )
		print( "Chosen interface skin does not support the \"Picker Wheel\" widget." )
		print( "=======================================" )
		return nil
	end
	
	--
	--
	--
	
	-- create dummy params table if no params were set
	if not params then params = dummyEmpty; end
	
	-- extract params or set defaults
	local	id = params.id or "pickerWheel"
	local	x = params.x or 0
	local	y = params.y or 0
	local	width = params.width or 320
	local	column1 = params.column1 or { 	data={ "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten" }, width = 290, loopDisabled = false }
	local	column2 = params.column2
	local	column3 = params.column3
	local	columnFontSize = params.fontSize or skinTable.size	-- allow users to change font size of picker wheel (fixes JA-Whye's issue)
	local	preset = params.preset
	
	local	startMonth = params.startMonth
	local	startDay = params.startDay
	local	startYear = params.startYear
	local	startHour = params.startHour
	local	startMinute = params.startMinute
	local	startAmPm = params.startAmPm or params.startAmpm or params.startampm
	
	local	columnSeparatorT = params.columnSeparator or skinTable.columnSeparator
	local	pickerBgT = params.pickerBg or skinTable.pickerBg
	local	pickerGlossT = params.pickerGloss or skinTable.pickerGloss
	local	pickerMask = params.pickerMask or skinPackage .. "/" .. skinTable.pickerMask
	local	baseDir = params.baseDir or defaultBase
	
	-- Set some local variables for graphics resources
	local columnSeparatorImg = skinPackage .. "/" .. columnSeparatorT[1]
	local pickerBgImg = skinPackage .. "/" .. pickerBgT[1]
	local pickerGlossImg = skinPackage .. "/" .. pickerGlossT[1]
	
	-- Setup groups
	local pickerGroup = display.newGroup()		-- main group for everything
	local backgroundGroup = display.newGroup()	-- for the streched background
	local columnGroup = display.newGroup()		-- to hold the tableViews and column separators
	local maskGroup = display.newGroup()		-- for the picker's mask (to hide tableview top/bottom)
	local glossGroup = display.newGroup()		-- main picker aesthetic
	
	-- setup tables for metatables
	local t = { _view = pickerGroup }
	local mt = {}
	
	
	-- Setup date preset data (pre-populate columns,
	-- ignoring custom column data that was passed)
	
	-- To initialize tableview (??)
	local fauxTV = newTableView{ backgroundColor="none" }
	columnGroup:insert( fauxTV.display )
	
	--
	
	if preset == "usDate" or preset == "euDate" then
		
		--====================================================================================
		--====================================================================================
		--
		--  DATE PICKER PRESET
		--
		--====================================================================================
		--====================================================================================
		
		local monthCol = { data = { "December", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November" } }
		
		-- reorganize data based on start month:
		
		if startMonth then
			
			local mo = string.lower(tostring(startMonth))
			
			-- January selection is default
			
			if mo == "february" or mo == "feb" or mo == "2" or mo == "02" then
				monthCol = { data = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" } }
			
			elseif mo == "march" or mo == "mar" or mo == "3" or mo == "03" then
				monthCol = { data = { "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", "January" } }
			
			elseif mo == "april" or mo == "apr" or mo == "4" or mo == "04" then
				monthCol = { data = { "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", "January", "February" } }
			
			elseif mo == "may" or mo == "5" or mo == "05" then
				monthCol = { data = { "April", "May", "June", "July", "August", "September", "October", "November", "December", "January", "February", "March" } }
			
			elseif mo == "june" or mo == "jun" or mo == "6" or mo == "06" then
				monthCol = { data = { "May", "June", "July", "August", "September", "October", "November", "December", "January", "February", "March", "April" } }
			
			elseif mo == "july" or mo == "jul" or mo == "7" or mo == "07" then
				monthCol = { data = { "June", "July", "August", "September", "October", "November", "December", "January", "February", "March", "April", "May" } }
			
			elseif mo == "august" or mo == "aug" or mo == "8" or mo == "08" then
				monthCol = { data = { "July", "August", "September", "October", "November", "December", "January", "February", "March", "April", "May", "June" } }
			
			elseif mo == "september" or mo == "sep" or mo == "9" or mo == "09" then
				monthCol = { data = { "August", "September", "October", "November", "December", "January", "February", "March", "April", "May", "June", "July" } }
			
			elseif mo == "october" or mo == "oct" or mo == "10" or mo == "10" then
				monthCol = { data = { "September", "October", "November", "December", "January", "February", "March", "April", "May", "June", "July", "August" } }
			
			elseif mo == "november" or mo == "nov" or mo == "11" then
				monthCol = { data = { "October", "November", "December", "January", "February", "March", "April", "May", "June", "July", "August", "September" } }
			
			elseif mo == "december" or mo == "dec" or mo == "12" then
				monthCol = { data = { "November", "December", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October" } }
			end
		end
		
		-- end reorganize based on start month
		
		monthCol.width = 150
		
		local dayCol31, yearCol = { data={} }, { data={} }
		
		-- setup day column based on startDay
		if not startDay then startDay = 1; end
		if startDay > 31 then startDay = 31; end
		local addAmount = startDay - 2
		
		if addAmount == -1 then
			addAmount = 30
		end

		for i=1,31 do
			local finalAmount = i+addAmount
			
			if finalAmount > 31 then
				finalAmount = i+addAmount - 31
			end
			
			if finalAmount < 10 then
				dayCol31.data[i] = "0" .. finalAmount
			else
				dayCol31.data[i] = tostring(finalAmount)
			end
		end
		
		dayCol31.width = 60
		
		--
		--
		
		local currentYear = startYear or tonumber(os.date( "%Y" ))
		local yearPast, yearFuture = currentYear-50, currentYear+50
		local addAmount = currentYear - 2
		
		for i=1,50 do
			
			local theYear = i+currentYear-2
			yearCol.data[i] = theYear
		end
		
		for i=1,50 do
			local theYear = i+yearPast-2
			yearCol.data[i+50] = theYear
		end
		
		yearCol.width = 88	-- changed from 50 to 88 for casenum: 7281
		
		-- assign data columns to the correct ones:
		
		if preset == "usDate" then
			column1 = monthCol
			column2 = dayCol31
		else
			column1 = dayCol31
			column2 = monthCol
		end
		
		column3 = yearCol
	
	
	elseif preset == "time" then
		
		--====================================================================================
		--====================================================================================
		--
		--  TIME PICKER PRESET
		--
		--====================================================================================
		--====================================================================================
		
		
		local hourCol, minCol, amPmCol = { data={} }, { data={} }, { data={  "AM", "PM"  } }
		
		-- setup ampm
		if startAmPm then
			local ap = string.lower( tostring(startAmPm) )
			
			if ap == "a" or ap == "am" or ap == "1" or ap == "01" then
				amPmCol = { data={ "PM", "AM" } }
			end
		end
		
		
		-- setup hour column
		if startHour and startHour > 12 then startHour = 12; end
		if not startHour then startHour = 1; end
		
		local addAmount = startHour - 2
		
		if addAmount == -1 then
			addAmount = 11
		end

		for i=1,12 do
			local finalAmount = i+addAmount
			
			if finalAmount > 12 then
				finalAmount = i+addAmount - 12
			end
			
			if finalAmount < 10 then
				hourCol.data[i] = "0" .. finalAmount
			else
				hourCol.data[i] = tostring(finalAmount)
			end
		end
		
		
		-- setup minute column
		if startMinute and startMinute > 59 then startMinute = 59; end
		if not startMinute then startMinute = 1; end
		
		local addAmount = startMinute - 2
		
		if addAmount == -1 then
			addAmount = 58
		end

		for i=1,59 do
			local finalAmount = i+addAmount
			
			if finalAmount > 59 then
				finalAmount = i+addAmount - 59
			end
			
			if finalAmount < 10 then
				minCol.data[i] = "0" .. finalAmount
			else
				minCol.data[i] = tostring(finalAmount)
			end
		end
		
		-- makd first column a little larger
		hourCol.width = 150
		
		-- assign data to columns
		column1 = hourCol
		column2 = minCol
		column3 = amPmCol
	end
	
	-- Make sure each column has at least 5 items or exclude
	-- the column from even showing
	
	if preset ~= "time" then
	
		if #column1.data < 6 then
			column1 = nil
			
			print( "--" )
			print( "WARNING: Interace Library" )
			print( "All columns must have at least six items. First column is blank." )
			print( "=======================================" )
			
			return nil
		end
		
		if column2 and #column2.data < 6 then
			column2 = nil;
			
			print( "--" )
			print( "WARNING: Interace Library" )
			print( "Second Picker Wheel column has less than six items." )
			print( "=======================================" )
		end
		
		if column3 and #column3.data < 6 then
			column3 = nil
			
			print( "--" )
			print( "WARNING: Interace Library" )
			print( "Second Picker Wheel column has less than six items." )
			print( "=======================================" )
		end
		
		-- if there are no columns to display, exit the function
		if not column1 and not column2 and not column3 then
			print( "--" )
			print( "WARNING: Interace Library" )
			print( "No selections to show for Picker Wheel; Aborting." )
			print( "=======================================" )
			
			return nil
		end
	
	end
	
	
	-- Determine the amount of columns that will be shown,
	-- and also set/adjust widths if necessary.
	
	local columnCount
	local maxColumnWidth = 298
	
	if column1 and not column2 then
		
		--==============================
		--
		-- single-column picker
		--
		--==============================
		
		columnCount = 1
		
		-- make sure column fills max space
		column1.width = maxColumnWidth
	
	elseif column1 and column2 and not column3 then
		
		--==============================
		--
		-- 2-column picker
		--
		--==============================
		
		columnCount = 2
		
		local separatorWidth = columnSeparatorT[3] or 8
		local halfColumn = mCeil(maxColumnWidth * 0.5) - (separatorWidth * 0.5)	-- split column in half (minus column separator)
		
		local col1width = column1.width or halfColumn
		local col2width = column2.width or halfColumn
		
		
		-- make sure column widths don't exceed maximum space
		-- for all columns
		local totalWidth = col1width + col2width
		
		if totalWidth > maxColumnWidth then
			local difference = totalWidth - maxColumnWidth
			
			-- take away from column2
			col2width = col2width - difference
		end
		
		column1.width, column2.width = col1width, col2width
	
	elseif column1 and column2 and column3 then
		
		--==============================
		--
		-- 3-column picker
		--
		--==============================
		
		columnCount = 3
		
		local separatorWidth = columnSeparatorT[3] or 8
		local thirdColumn = mCeil(maxColumnWidth * 0.33) - ((separatorWidth * 0.5)*2)	-- split column into thirds (minus column separators)
		
		local col1width = column1.width or thirdColumn
		local col2width = column2.width or thirdColumn
		local col3width = column3.width or thirdColumn
		
		-- make sure all column widths don't exceed max space
		-- for all columns
		local totalWidth = col1width + col2width + col3width
		
		if totalWidth > maxColumnWidth then
			local difference = totalWidth - maxColumnWidth
			local splitDifference = difference * 0.5
			
			-- take away equally from column 2 and 3 if columns are too long
			col2width = col2width - splitDifference
			col3width = col3width - splitDifference
		end
		
		column1.width, column2.width, column3.width =
			col1width, col2width, col3width
	end
	
	
	--========================================
	--
	-- END: Resource and Local Defaults Setup
	--
	--========================================
	
	
	-- Insert the groups into the pickerGroup, in order
	pickerGroup:insert( backgroundGroup )
	maskGroup:insert( columnGroup )
	pickerGroup:insert( maskGroup )
	pickerGroup:insert( glossGroup )
	
	
	-- Create and setup the background group
	local pickerBgW = pickerBgT[2] or 1
	local pickerBgH = pickerBgT[3] or 222
	local pickerBg = display.newImageRect( pickerBgImg, baseDir, pickerBgW, pickerBgH )
	pickerBg.xScale = pickerBgW * width
	pickerBg:setReferencePoint( display.TopLeftReferencePoint )
	pickerBg.x, pickerBg.y = 0, 0
	
	function pickerBg:touch( event )
		return true;
	end
	
	pickerBg:addEventListener( "touch", pickerBg )
	
	-- Create a white rectangle to go behind list
	local whiteRect = display.newRect( 0, 0, maxColumnWidth, 222 )
	whiteRect:setFillColor( 255, 255, 255, 255 )
	whiteRect:setReferencePoint( display.TopLeftReferencePoint )
	
	function whiteRect:touch( event )
		return true;
	end
	
	whiteRect:addEventListener( "touch", whiteRect )
	
	-- Insert into background group
	backgroundGroup:insert( pickerBg )
	backgroundGroup:insert( whiteRect )
	  
	
	-- Create and setup the column group (tableviews)
	
	-- currentX will determine where the next column's X value should be
	local currentX = (width * 0.5) - (maxColumnWidth * 0.5)
	
	local colSep1x, colSep2x
	
	local realColumn1, realColumn2, realColumn3, dayValue
	
	whiteRect.x = currentX
	
	for i=1,columnCount do
		
		local columnTable
		
		if 		i == 1 then columnTable = column1
		elseif 	i == 2 then columnTable = column2
		elseif	i == 3 then columnTable = column3
		end
		
		if columnTable then
			
			local isColumnLoopingDisabled = columnTable.loopDisabled or false
			local isInfinite = true
			
			if isColumnLoopingDisabled then isInfinite = false end
			
			local labelX = 16
			
			-- if this is a time picker, adjust label position for first and
			-- second columns (hour and minute):
			
			if preset == "time" then
				if i == 1 then
					labelX = 100
				
				elseif i == 2 then
					labelX = 24
				end
			end
			
			-- Create the tableView object and insert it into the column group
			local newColumn = newTableView{
				width = columnTable.width,
				height = 222,
				x = currentX, y = 0,
				isInfinite = isInfinite,
				backgroundColor = "none", --{ 255, 255, 255 },
				bottomLineColor = { 255, 255, 255 },
				titleFont = { skinTable.font, { 0, 0, 0 }, columnFontSize },
				hideScrollbar = true,
				isForPickerWheel = true,
				labelStartX = labelX,
				rowHeight=46
			}
			
			-- set the X position of the column separator (if applicable)
			if columnCount > 1 then
				if i == 1 then colSep1x = currentX + columnTable.width; end
				if i == 2 then colSep2x = currentX + columnTable.width; end
			end
			
			-- set the next X position (for another column)
			currentX = currentX + columnTable.width
			
			
			-- set some column data
			newColumn.display.isPickerColumn = true
			newColumn.display.snapDisabled = true
			newColumn.display.pickerParent = pickerGroup
			newColumn.display.pickerParentT = t
			dayValue = "01"
			
			-- setup preset info
			if preset then
				newColumn.display.preset = preset
				
				if preset == "time" then
					if i == 3 then
						newColumn.display.timeID = "amPM"
					end
				end
			end
			
			
			-- provide a way to access column data
			if i == 1 then
				realColumn1 = newColumn
				newColumn.display.columnID = "first"
				
				if preset then
					if preset == "usDate" then
						newColumn.display.columnType = "month"
					elseif preset == "euDate" then
						newColumn.display.columnType = "day"
					end
				end
				
			elseif 	i == 2 then
				realColumn2 = newColumn
				newColumn.display.columnID = "second"
				
				if preset then
					if preset == "usDate" then
						newColumn.display.columnType = "day"
					elseif preset == "euDate" then
						newColumn.display.columnType = "month"
					end
				end
				
			elseif	i == 3 then
				realColumn3 = newColumn
				newColumn.display.columnID = "third"
				newColumn.display.columnType = "year"
			end
			
			local tableData = {}
			
			-- Create the tableData from column data
			if columnTable.data then
				
				for i=1,#columnTable.data do
					tableData[i] = { titleText=columnTable.data[i] }
				end
			end
			
			-- Set the currently selected item to the first item in tableData
			newColumn.display.value = tableData[1].titleText
			
			-- sync the table data with our new tableview:
			newColumn:sync( tableData )
			
			-- insert the new column into the column group
			columnGroup:insert( newColumn.display )
			
			
			if isInfinite then
				newColumn.display.isMoving = true
				newColumn.display.isFocus = true
			
				local resetY = function()
					newColumn.display.isMoving = false
					newColumn.display.isFocus = false
					
					-- Set value to be the 2nd item (instead of first, for looping items)
					newColumn.display.value = tableData[2].titleText
					--print( "Currently selected item: " .. newColumn.display.value )
				end
				
				-- the y value below will set starting position of picker wheel
				transition.to( newColumn.display, { time=500, y=newColumn.display.y+42, onComplete=resetY } )
				
				--newColumn.display.y = newColumn.display.y+42
			else
				--print( "Currently selected item: " .. newColumn.display.value )
			end
		end
	end
	
	
	-- Create the column separators (if necessary)
	if columnCount > 1 then
		
		local sepW = columnSeparatorT[2] or 8
		local sepH = columnSeparatorT[3] or 1
		
		local firstSeparator = display.newImageRect( columnSeparatorImg, baseDir, sepW, sepH )
		firstSeparator.yScale = sepH * 222
		firstSeparator:setReferencePoint( display.TopLeftReferencePoint )
		firstSeparator.x, firstSeparator.y = 0, 0
		firstSeparator.x = colSep1x - (sepW * 0.5)
		
		glossGroup:insert( firstSeparator )
		
		if columnCount > 2 then
			
			local secondSeparator = display.newImageRect( columnSeparatorImg, baseDir, sepW, sepH )
			secondSeparator.yScale = sepH * 222
			secondSeparator:setReferencePoint( display.TopLeftReferencePoint )
			secondSeparator.x, secondSeparator.y = 0, 0
			
			secondSeparator.x = colSep2x - (sepW * 0.5)
		
			glossGroup:insert( secondSeparator )
			
		end
	end
	
	
	-- Create a mask that will go on the columns (to hide list items above and below picker)
	local maskObj = graphics.newMask( pickerMask )
	maskGroup:setMask( maskObj )
	maskGroup.maskScaleX = 0.5
	maskGroup.maskScaleY = 0.5
	maskGroup.maskX = width * 0.5
	maskGroup.maskY = 111
	
	-- Set up the "gloss" layer
	local glossW = pickerGlossT[2] or 320
	local glossH = pickerGlossT[3] or 222
	local pickerGloss = display.newImage( pickerGlossImg, baseDir, glossW, glossH )
	pickerGloss:setReferencePoint( display.TopLeftReferencePoint )
	pickerGloss.x, pickerGloss.y = width*0.5-glossW*0.5, 0
	
	glossGroup:insert( pickerGloss )
	
	--pickerGroup.y = 100
	pickerGroup.x = x
	pickerGroup.y = y
	
	
	--====================================================
	
	-- Patched removeSelf()
	
	--====================================================
	
	
	function t:removeSelf()
		
		if maskGroup then
			maskGroup:setMask( nil )
			
			if maskObj then
				maskObj = nil
			end
		end
		
		pickerBg:removeEventListener( "touch", pickerBg )
		whiteRect:removeEventListener( "touch", whiteRect )
		
		display.remove( realColumn1 )
		realColumn1 = nil
		
		display.remove( realColumn2 )
		realColumn2 = nil
		
		display.remove( realColumn3 )
		realColumn3 = nil
		
		display.remove( pickerGroup )
		pickerGroup = nil
		
		self = nil
		
		return nil
	end
	
	
	--
	--
	
	--====================================================
	
	-- Metamethods
	
	--====================================================
	
	mt.__index = function( tb, key )
		if key == "view" then
			return t._view
		
		elseif key == "x" then
			return pickerGroup.x
			
		elseif key == "y" then
			return pickerGroup.y
		
		elseif key == "height" then
			return 222
		
		elseif key == "width" then
			return width
			
		elseif key == "col1" then
			
			if realColumn1 then
				return realColumn1
			end
		
		elseif key == "col2" then
			
			if realColumn2 then
				return realColumn2
			end
		
		elseif key == "col3" then
			
			if realColumn3 then
				return realColumn3
			end
		
		elseif key == "dayValue" then
			return dayValue
			
		end
	end
	
	mt.__newindex = function( tb, key, value )
		
		if key == "x" then
			
			x = value
			
			pickerGroup.x = x
		
		elseif key == "y" then
			
			y = value
			pickerGroup.y = y
			
			if realColumn1 then
				realColumn1.y = y
			end
			
			if realColumn2 then
				realColumn2.y = y
			end
			
			if realColumn3 then
				realColumn3.y = y
			end
		
		elseif key == "dayValue" then
			dayValue = value			
		
		end
	end
	
	setmetatable( t, mt )
	
	return t
end
  
