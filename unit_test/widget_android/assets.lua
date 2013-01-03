--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:e40ee2f2492af37c9d5a5223c5849ff8$
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
            x=244,
            y=48,
            width=5,
            height=5,

        },
        {
            -- button_bottomLeftOver
            x=244,
            y=39,
            width=5,
            height=5,

        },
        {
            -- button_bottomMiddle
            x=235,
            y=48,
            width=5,
            height=5,

        },
        {
            -- button_bottomMiddleOver
            x=235,
            y=39,
            width=5,
            height=5,

        },
        {
            -- button_bottomRight
            x=226,
            y=48,
            width=5,
            height=5,

        },
        {
            -- button_bottomRightOver
            x=226,
            y=39,
            width=5,
            height=5,

        },
        {
            -- button_middle
            x=217,
            y=48,
            width=5,
            height=5,

        },
        {
            -- button_middleLeft
            x=217,
            y=39,
            width=5,
            height=5,

        },
        {
            -- button_middleLeftOver
            x=208,
            y=48,
            width=5,
            height=5,

        },
        {
            -- button_middleOver
            x=208,
            y=39,
            width=5,
            height=5,

        },
        {
            -- button_middleRight
            x=199,
            y=48,
            width=5,
            height=5,

        },
        {
            -- button_middleRightOver
            x=199,
            y=39,
            width=5,
            height=5,

        },
        {
            -- button_topLeft
            x=190,
            y=48,
            width=5,
            height=5,

        },
        {
            -- button_topLeftOver
            x=190,
            y=39,
            width=5,
            height=5,

        },
        {
            -- button_topMiddle
            x=181,
            y=47,
            width=5,
            height=5,

        },
        {
            -- button_topMiddleOver
            x=172,
            y=47,
            width=5,
            height=5,

        },
        {
            -- button_topRight
            x=163,
            y=47,
            width=5,
            height=5,

        },
        {
            -- button_topRightOver
            x=154,
            y=47,
            width=5,
            height=5,

        },
        {
            -- progressView_leftFill
            x=146,
            y=47,
            width=4,
            height=12,

        },
        {
            -- progressView_leftFillBorder
            x=138,
            y=47,
            width=4,
            height=12,

        },
        {
            -- progressView_middleFill
            x=130,
            y=47,
            width=4,
            height=12,

        },
        {
            -- progressView_middleFillBorder
            x=122,
            y=47,
            width=4,
            height=12,

        },
        {
            -- progressView_rightFill
            x=114,
            y=47,
            width=4,
            height=12,

        },
        {
            -- progressView_rightFillBorder
            x=106,
            y=47,
            width=4,
            height=12,

        },
        {
            -- searchField_leftEdge
            x=435,
            y=3,
            width=4,
            height=30,

        },
        {
            -- searchField_magnifyingGlass
            x=817,
            y=31,
            width=24,
            height=24,

        },
        {
            -- searchField_middle
            x=427,
            y=3,
            width=4,
            height=30,

        },
        {
            -- searchField_remove
            x=822,
            y=3,
            width=24,
            height=24,

        },
        {
            -- searchField_rightEdge
            x=419,
            y=3,
            width=4,
            height=30,

        },
        {
            -- segmentedControl_divider
            x=443,
            y=3,
            width=1,
            height=27,

        },
        {
            -- segmentedControl_left
            x=786,
            y=3,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_leftOn
            x=780,
            y=33,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_middle
            x=772,
            y=33,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_middleOn
            x=764,
            y=33,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_right
            x=756,
            y=33,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_rightOn
            x=748,
            y=33,
            width=4,
            height=26,

        },
        {
            -- slider_bottomFrameVertical
            x=166,
            y=39,
            width=12,
            height=4,

        },
        {
            -- slider_fill
            x=98,
            y=47,
            width=4,
            height=12,

        },
        {
            -- slider_fillVertical
            x=150,
            y=39,
            width=12,
            height=4,

        },
        {
            -- slider_handle
            x=794,
            y=3,
            width=24,
            height=24,

        },
        {
            -- slider_leftFrame
            x=90,
            y=47,
            width=4,
            height=12,

        },
        {
            -- slider_middleFrame
            x=82,
            y=47,
            width=4,
            height=12,

        },
        {
            -- slider_middleFrameVertical
            x=134,
            y=39,
            width=12,
            height=4,

        },
        {
            -- slider_rightFrame
            x=74,
            y=47,
            width=4,
            height=12,

        },
        {
            -- slider_topFrameVertical
            x=118,
            y=39,
            width=12,
            height=4,

        },
        {
            -- spinner_spinner
            x=74,
            y=3,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=694,
            y=3,
            width=88,
            height=26,

        },
        {
            -- stepper_noMinus
            x=656,
            y=33,
            width=88,
            height=26,

        },
        {
            -- stepper_noPlus
            x=602,
            y=3,
            width=88,
            height=26,

        },
        {
            -- stepper_nonActive
            x=564,
            y=33,
            width=88,
            height=26,

        },
        {
            -- stepper_plusActive
            x=472,
            y=33,
            width=88,
            height=26,

        },
        {
            -- switch_background
            x=448,
            y=3,
            width=150,
            height=26,

        },
        {
            -- switch_checkboxDefault
            x=226,
            y=3,
            width=32,
            height=32,

        },
        {
            -- switch_checkboxSelected
            x=190,
            y=3,
            width=32,
            height=32,

        },
        {
            -- switch_handle
            x=384,
            y=3,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=349,
            y=3,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=262,
            y=3,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=154,
            y=3,
            width=32,
            height=32,

        },
        {
            -- switch_radioButtonSelected
            x=118,
            y=3,
            width=32,
            height=32,

        },
        {
            -- tabBar_background
            x=3,
            y=3,
            width=25,
            height=50,

        },
        {
            -- tabBar_iconActive
            x=788,
            y=33,
            width=25,
            height=25,

        },
        {
            -- tabBar_iconInactive
            x=443,
            y=34,
            width=25,
            height=25,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=60,
            y=3,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedMiddle
            x=46,
            y=3,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedRightEdge
            x=32,
            y=3,
            width=10,
            height=50,

        },
    },
    
    sheetContentWidth = 849,
    sheetContentHeight = 62
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
    ["slider_bottomFrameVertical"] = 37,
    ["slider_fill"] = 38,
    ["slider_fillVertical"] = 39,
    ["slider_handle"] = 40,
    ["slider_leftFrame"] = 41,
    ["slider_middleFrame"] = 42,
    ["slider_middleFrameVertical"] = 43,
    ["slider_rightFrame"] = 44,
    ["slider_topFrameVertical"] = 45,
    ["spinner_spinner"] = 46,
    ["stepper_minusActive"] = 47,
    ["stepper_noMinus"] = 48,
    ["stepper_noPlus"] = 49,
    ["stepper_nonActive"] = 50,
    ["stepper_plusActive"] = 51,
    ["switch_background"] = 52,
    ["switch_checkboxDefault"] = 53,
    ["switch_checkboxSelected"] = 54,
    ["switch_handle"] = 55,
    ["switch_handleOver"] = 56,
    ["switch_overlay"] = 57,
    ["switch_radioButtonDefault"] = 58,
    ["switch_radioButtonSelected"] = 59,
    ["tabBar_background"] = 60,
    ["tabBar_iconActive"] = 61,
    ["tabBar_iconInactive"] = 62,
    ["tabBar_tabSelectedLeftEdge"] = 63,
    ["tabBar_tabSelectedMiddle"] = 64,
    ["tabBar_tabSelectedRightEdge"] = 65,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
