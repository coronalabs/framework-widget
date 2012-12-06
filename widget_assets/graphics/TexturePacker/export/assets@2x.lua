--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:23191127b9436f8b5a49f63598f8b2b2$
--
-- local sheetInfo = require("myExportedImageSheet") -- lua file that Texture packer published
--
-- local myImageSheet = graphics.newImageSheet( "ImageSheet.png", sheetInfo:getSheet() ) -- ImageSheet.png is the image Texture packer published
--
-- local myImage1 = display.newImage( myImageSheet , sheetInfo:getFrameIndex("image_name1"))
-- local myImage2 = display.newImage( myImageSheet , sheetInfo:getFrameIndex("image_name2"))
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- button_bottomLeft
            x=890,
            y=200,
            width=30,
            height=30,

        },
        {
            -- button_bottomLeftOver
            x=852,
            y=214,
            width=30,
            height=30,

        },
        {
            -- button_bottomMiddle
            x=830,
            y=176,
            width=30,
            height=30,

        },
        {
            -- button_bottomMiddleOver
            x=832,
            y=138,
            width=30,
            height=30,

        },
        {
            -- button_bottomRight
            x=814,
            y=216,
            width=30,
            height=30,

        },
        {
            -- button_bottomRightOver
            x=776,
            y=216,
            width=30,
            height=30,

        },
        {
            -- button_middle
            x=228,
            y=216,
            width=30,
            height=30,

        },
        {
            -- button_middleLeft
            x=190,
            y=216,
            width=30,
            height=30,

        },
        {
            -- button_middleLeftOver
            x=738,
            y=208,
            width=30,
            height=30,

        },
        {
            -- button_middleOver
            x=792,
            y=178,
            width=30,
            height=30,

        },
        {
            -- button_middleRight
            x=792,
            y=140,
            width=30,
            height=30,

        },
        {
            -- button_middleRightOver
            x=700,
            y=208,
            width=30,
            height=30,

        },
        {
            -- button_topLeft
            x=662,
            y=208,
            width=30,
            height=30,

        },
        {
            -- button_topLeftOver
            x=550,
            y=212,
            width=30,
            height=30,

        },
        {
            -- button_topMiddle
            x=512,
            y=212,
            width=30,
            height=30,

        },
        {
            -- button_topMiddleOver
            x=474,
            y=212,
            width=30,
            height=30,

        },
        {
            -- button_topRight
            x=436,
            y=214,
            width=30,
            height=30,

        },
        {
            -- button_topRightOver
            x=398,
            y=214,
            width=30,
            height=30,

        },
        {
            -- progressView_leftFill
            x=102,
            y=228,
            width=24,
            height=20,

        },
        {
            -- progressView_leftFillBorder
            x=84,
            y=200,
            width=24,
            height=20,

        },
        {
            -- progressView_middleFill
            x=70,
            y=228,
            width=24,
            height=20,

        },
        {
            -- progressView_middleFillBorder
            x=6,
            y=200,
            width=70,
            height=20,

        },
        {
            -- progressView_rightFill
            x=38,
            y=228,
            width=24,
            height=20,

        },
        {
            -- progressView_rightFillBorder
            x=6,
            y=228,
            width=24,
            height=20,

        },
        {
            -- searchField_leftEdge
            x=562,
            y=144,
            width=36,
            height=60,

        },
        {
            -- searchField_magnifyingGlass
            x=358,
            y=214,
            width=32,
            height=34,

        },
        {
            -- searchField_middle
            x=518,
            y=144,
            width=36,
            height=60,

        },
        {
            -- searchField_remove
            x=144,
            y=200,
            width=38,
            height=38,

        },
        {
            -- searchField_rightEdge
            x=474,
            y=144,
            width=36,
            height=60,

        },
        {
            -- segmentedControl_divider
            x=752,
            y=142,
            width=2,
            height=58,

        },
        {
            -- segmentedControl_left
            x=762,
            y=140,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_leftOn
            x=722,
            y=142,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_middle
            x=692,
            y=142,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_middleOn
            x=662,
            y=142,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_right
            x=902,
            y=134,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_rightOn
            x=902,
            y=68,
            width=22,
            height=58,

        },
        {
            -- sliderFillLeft
            x=870,
            y=138,
            width=20,
            height=20,

        },
        {
            -- sliderFillMiddle
            x=588,
            y=212,
            width=4,
            height=20,

        },
        {
            -- sliderFillRight
            x=116,
            y=200,
            width=20,
            height=20,

        },
        {
            -- sliderHandle
            x=760,
            y=68,
            width=64,
            height=64,

        },
        {
            -- spinner_spinner
            x=376,
            y=68,
            width=80,
            height=80,

        },
        {
            -- stepper_minusActive
            x=736,
            y=6,
            width=188,
            height=54,

        },
        {
            -- stepper_noMinus
            x=540,
            y=6,
            width=188,
            height=54,

        },
        {
            -- stepper_noPlus
            x=6,
            y=138,
            width=188,
            height=54,

        },
        {
            -- stepper_nonActive
            x=344,
            y=6,
            width=188,
            height=54,

        },
        {
            -- stepper_plusActive
            x=6,
            y=76,
            width=188,
            height=54,

        },
        {
            -- switch_background
            x=6,
            y=6,
            width=330,
            height=62,

        },
        {
            -- switch_checkboxDefault
            x=686,
            y=68,
            width=66,
            height=66,

        },
        {
            -- switch_checkboxSelected
            x=612,
            y=68,
            width=66,
            height=66,

        },
        {
            -- switch_handle
            x=202,
            y=146,
            width=62,
            height=62,

        },
        {
            -- switch_handleOver
            x=832,
            y=68,
            width=62,
            height=62,

        },
        {
            -- switch_overlay
            x=202,
            y=76,
            width=166,
            height=62,

        },
        {
            -- switch_radioButtonDefault
            x=538,
            y=68,
            width=66,
            height=68,

        },
        {
            -- switch_radioButtonSelected
            x=464,
            y=68,
            width=66,
            height=68,

        },
        {
            -- tabBar_background
            x=272,
            y=146,
            width=50,
            height=100,

        },
        {
            -- tabBar_iconActive
            x=416,
            y=156,
            width=50,
            height=50,

        },
        {
            -- tabBar_iconInactive
            x=358,
            y=156,
            width=50,
            height=50,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=634,
            y=142,
            width=20,
            height=100,

        },
        {
            -- tabBar_tabSelectedMiddle
            x=606,
            y=144,
            width=20,
            height=100,

        },
        {
            -- tabBar_tabSelectedRightEdge
            x=330,
            y=146,
            width=20,
            height=100,

        },
    },
    
    sheetContentWidth = 930,
    sheetContentHeight = 254
}

SheetInfo.frameIndex =
{

    ["button_bottomLeft"] = 1,
    ["button_bottomLeftOver"] = 2,
    ["button_bottomMiddle"] = 3,
    ["button_bottomMiddleOver"] = 4,
    ["button_bottomRight"] = 5,
    ["button_bottomRightOver"] = 6,
    ["button_middle"] = 7,
    ["button_middleLeft"] = 8,
    ["button_middleLeftOver"] = 9,
    ["button_middleOver"] = 10,
    ["button_middleRight"] = 11,
    ["button_middleRightOver"] = 12,
    ["button_topLeft"] = 13,
    ["button_topLeftOver"] = 14,
    ["button_topMiddle"] = 15,
    ["button_topMiddleOver"] = 16,
    ["button_topRight"] = 17,
    ["button_topRightOver"] = 18,
    ["progressView_leftFill"] = 19,
    ["progressView_leftFillBorder"] = 20,
    ["progressView_middleFill"] = 21,
    ["progressView_middleFillBorder"] = 22,
    ["progressView_rightFill"] = 23,
    ["progressView_rightFillBorder"] = 24,
    ["searchField_leftEdge"] = 25,
    ["searchField_magnifyingGlass"] = 26,
    ["searchField_middle"] = 27,
    ["searchField_remove"] = 28,
    ["searchField_rightEdge"] = 29,
    ["segmentedControl_divider"] = 30,
    ["segmentedControl_left"] = 31,
    ["segmentedControl_leftOn"] = 32,
    ["segmentedControl_middle"] = 33,
    ["segmentedControl_middleOn"] = 34,
    ["segmentedControl_right"] = 35,
    ["segmentedControl_rightOn"] = 36,
    ["sliderFillLeft"] = 37,
    ["sliderFillMiddle"] = 38,
    ["sliderFillRight"] = 39,
    ["sliderHandle"] = 40,
    ["spinner_spinner"] = 41,
    ["stepper_minusActive"] = 42,
    ["stepper_noMinus"] = 43,
    ["stepper_noPlus"] = 44,
    ["stepper_nonActive"] = 45,
    ["stepper_plusActive"] = 46,
    ["switch_background"] = 47,
    ["switch_checkboxDefault"] = 48,
    ["switch_checkboxSelected"] = 49,
    ["switch_handle"] = 50,
    ["switch_handleOver"] = 51,
    ["switch_overlay"] = 52,
    ["switch_radioButtonDefault"] = 53,
    ["switch_radioButtonSelected"] = 54,
    ["tabBar_background"] = 55,
    ["tabBar_iconActive"] = 56,
    ["tabBar_iconInactive"] = 57,
    ["tabBar_tabSelectedLeftEdge"] = 58,
    ["tabBar_tabSelectedMiddle"] = 59,
    ["tabBar_tabSelectedRightEdge"] = 60,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
