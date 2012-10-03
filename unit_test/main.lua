--*********************************************************************************************
--
-- ====================================================================
-- Corona SDK "Widget" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 1.6
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
display.setStatusBar(display.HiddenStatusBar)

local storyboard = require( "storyboard" )
storyboard.gotoScene( "test_spinner" )