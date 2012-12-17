--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:339b4e771c393b5fb5937c5f3b6afef4$
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
            x=850,
            y=214,
            width=30,
            height=30,

        },
        {
            -- button_bottomLeftOver
            x=850,
            y=176,
            width=30,
            height=30,

        },
        {
            -- button_bottomMiddle
            x=850,
            y=138,
            width=30,
            height=30,

        },
        {
            -- button_bottomMiddleOver
            x=812,
            y=216,
            width=30,
            height=30,

        },
        {
            -- button_bottomRight
            x=812,
            y=178,
            width=30,
            height=30,

        },
        {
            -- button_bottomRightOver
            x=812,
            y=140,
            width=30,
            height=30,

        },
        {
            -- button_middle
            x=774,
            y=216,
            width=30,
            height=30,

        },
        {
            -- button_middleLeft
            x=736,
            y=218,
            width=30,
            height=30,

        },
        {
            -- button_middleLeftOver
            x=774,
            y=178,
            width=30,
            height=30,

        },
        {
            -- button_middleOver
            x=774,
            y=140,
            width=30,
            height=30,

        },
        {
            -- button_middleRight
            x=736,
            y=180,
            width=30,
            height=30,

        },
        {
            -- button_middleRightOver
            x=736,
            y=142,
            width=30,
            height=30,

        },
        {
            -- button_topLeft
            x=902,
            y=114,
            width=30,
            height=30,

        },
        {
            -- button_topLeftOver
            x=698,
            y=208,
            width=30,
            height=30,

        },
        {
            -- button_topMiddle
            x=660,
            y=208,
            width=30,
            height=30,

        },
        {
            -- button_topMiddleOver
            x=622,
            y=208,
            width=30,
            height=30,

        },
        {
            -- button_topRight
            x=584,
            y=210,
            width=30,
            height=30,

        },
        {
            -- button_topRightOver
            x=546,
            y=210,
            width=30,
            height=30,

        },
        {
            -- progressView_leftFill
            x=390,
            y=224,
            width=24,
            height=20,

        },
        {
            -- progressView_leftFillBorder
            x=154,
            y=228,
            width=24,
            height=20,

        },
        {
            -- progressView_middleFill
            x=358,
            y=224,
            width=24,
            height=20,

        },
        {
            -- progressView_middleFillBorder
            x=122,
            y=200,
            width=70,
            height=20,

        },
        {
            -- progressView_rightFill
            x=122,
            y=228,
            width=24,
            height=20,

        },
        {
            -- progressView_rightFillBorder
            x=240,
            y=216,
            width=24,
            height=20,

        },
        {
            -- searchField_leftEdge
            x=446,
            y=156,
            width=36,
            height=60,

        },
        {
            -- searchField_magnifyingGlass
            x=200,
            y=216,
            width=32,
            height=34,

        },
        {
            -- searchField_middle
            x=402,
            y=156,
            width=36,
            height=60,

        },
        {
            -- searchField_remove
            x=902,
            y=68,
            width=38,
            height=38,

        },
        {
            -- searchField_rightEdge
            x=358,
            y=156,
            width=36,
            height=60,

        },
        {
            -- segmentedControl_divider
            x=606,
            y=144,
            width=2,
            height=58,

        },
        {
            -- segmentedControl_left
            x=706,
            y=142,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_leftOn
            x=676,
            y=142,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_middle
            x=646,
            y=142,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_middleOn
            x=616,
            y=142,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_right
            x=576,
            y=144,
            width=22,
            height=58,

        },
        {
            -- segmentedControl_rightOn
            x=546,
            y=144,
            width=22,
            height=58,

        },
        {
            -- silder_middleFrame
            x=916,
            y=208,
            width=20,
            height=20,

        },
        {
            -- silder_middleFrameVertical
            x=916,
            y=180,
            width=20,
            height=20,

        },
        {
            -- slider_bottomFrameVertical
            x=916,
            y=152,
            width=20,
            height=20,

        },
        {
            -- slider_fill
            x=888,
            y=208,
            width=20,
            height=20,

        },
        {
            -- slider_fillVertical
            x=888,
            y=180,
            width=20,
            height=20,

        },
        {
            -- slider_handle
            x=760,
            y=68,
            width=64,
            height=64,

        },
        {
            -- slider_leftFrame
            x=888,
            y=152,
            width=20,
            height=20,

        },
        {
            -- slider_rightFrame
            x=450,
            y=224,
            width=20,
            height=20,

        },
        {
            -- slider_topFrameVertical
            x=422,
            y=224,
            width=20,
            height=20,

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
            x=64,
            y=200,
            width=50,
            height=50,

        },
        {
            -- tabBar_iconInactive
            x=6,
            y=200,
            width=50,
            height=50,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=518,
            y=144,
            width=20,
            height=100,

        },
        {
            -- tabBar_tabSelectedMiddle
            x=490,
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
    
    sheetContentWidth = 946,
    sheetContentHeight = 256
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
    ["silder_middleFrame"] = 37,
    ["silder_middleFrameVertical"] = 38,
    ["slider_bottomFrameVertical"] = 39,
    ["slider_fill"] = 40,
    ["slider_fillVertical"] = 41,
    ["slider_handle"] = 42,
    ["slider_leftFrame"] = 43,
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
