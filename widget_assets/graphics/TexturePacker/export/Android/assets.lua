--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:f3480600b41bf710fec29165571e29c7$
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
            x=259,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_bottomLeftOver
            x=250,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_bottomMiddle
            x=241,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_bottomMiddleOver
            x=232,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_bottomRight
            x=223,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_bottomRightOver
            x=214,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_middle
            x=205,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_middleLeft
            x=196,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_middleLeftOver
            x=187,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_middleOver
            x=178,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_middleRight
            x=169,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_middleRightOver
            x=160,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_topLeft
            x=151,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_topLeftOver
            x=142,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_topMiddle
            x=133,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_topMiddleOver
            x=124,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_topRight
            x=115,
            y=229,
            width=5,
            height=5,

        },
        {
            -- button_topRightOver
            x=460,
            y=185,
            width=5,
            height=5,

        },
        {
            -- picker_bg
            x=327,
            y=3,
            width=1,
            height=222,

        },
        {
            -- picker_overlay
            x=3,
            y=3,
            width=320,
            height=222,

        },
        {
            -- picker_separator
            x=3,
            y=245,
            width=8,
            height=1,

        },
        {
            -- progressView_leftFill
            x=107,
            y=229,
            width=4,
            height=12,

        },
        {
            -- progressView_leftFillBorder
            x=83,
            y=229,
            width=4,
            height=12,

        },
        {
            -- progressView_middleFill
            x=75,
            y=229,
            width=4,
            height=12,

        },
        {
            -- progressView_middleFillBorder
            x=67,
            y=229,
            width=4,
            height=12,

        },
        {
            -- progressView_rightFill
            x=43,
            y=229,
            width=4,
            height=12,

        },
        {
            -- progressView_rightFillBorder
            x=35,
            y=229,
            width=4,
            height=12,

        },
        {
            -- searchField_leftEdge
            x=475,
            y=196,
            width=4,
            height=30,

        },
        {
            -- searchField_magnifyingGlass
            x=390,
            y=218,
            width=24,
            height=24,

        },
        {
            -- searchField_middle
            x=467,
            y=196,
            width=4,
            height=30,

        },
        {
            -- searchField_remove
            x=482,
            y=61,
            width=24,
            height=24,

        },
        {
            -- searchField_rightEdge
            x=459,
            y=203,
            width=4,
            height=30,

        },
        {
            -- segmentedControl_divider
            x=419,
            y=183,
            width=1,
            height=27,

        },
        {
            -- segmentedControl_left
            x=499,
            y=196,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_leftOn
            x=491,
            y=196,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_middle
            x=483,
            y=196,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_middleOn
            x=502,
            y=3,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_right
            x=494,
            y=3,
            width=4,
            height=26,

        },
        {
            -- segmentedControl_rightOn
            x=486,
            y=3,
            width=4,
            height=26,

        },
        {
            -- slider_bottomFrameVertical
            x=91,
            y=237,
            width=12,
            height=4,

        },
        {
            -- slider_fill
            x=27,
            y=229,
            width=4,
            height=12,

        },
        {
            -- slider_fillVertical
            x=91,
            y=229,
            width=12,
            height=4,

        },
        {
            -- slider_handle
            x=482,
            y=33,
            width=24,
            height=24,

        },
        {
            -- slider_leftFrame
            x=19,
            y=229,
            width=4,
            height=12,

        },
        {
            -- slider_middleFrame
            x=11,
            y=229,
            width=4,
            height=12,

        },
        {
            -- slider_middleFrameVertical
            x=51,
            y=237,
            width=12,
            height=4,

        },
        {
            -- slider_rightFrame
            x=3,
            y=229,
            width=4,
            height=12,

        },
        {
            -- slider_topFrameVertical
            x=51,
            y=229,
            width=12,
            height=4,

        },
        {
            -- spinner_spinner
            x=424,
            y=33,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=332,
            y=153,
            width=88,
            height=26,

        },
        {
            -- stepper_noMinus
            x=332,
            y=123,
            width=88,
            height=26,

        },
        {
            -- stepper_noPlus
            x=332,
            y=93,
            width=88,
            height=26,

        },
        {
            -- stepper_nonActive
            x=332,
            y=63,
            width=88,
            height=26,

        },
        {
            -- stepper_plusActive
            x=332,
            y=33,
            width=88,
            height=26,

        },
        {
            -- switch_background
            x=332,
            y=3,
            width=150,
            height=26,

        },
        {
            -- switch_checkboxDefault
            x=474,
            y=125,
            width=32,
            height=32,

        },
        {
            -- switch_checkboxSelected
            x=424,
            y=167,
            width=32,
            height=32,

        },
        {
            -- switch_handle
            x=424,
            y=203,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=474,
            y=161,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=332,
            y=183,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=467,
            y=89,
            width=32,
            height=32,

        },
        {
            -- switch_radioButtonSelected
            x=424,
            y=131,
            width=32,
            height=32,

        },
        {
            -- tabBar_background
            x=424,
            y=77,
            width=25,
            height=50,

        },
        {
            -- tabBar_iconActive
            x=361,
            y=218,
            width=25,
            height=25,

        },
        {
            -- tabBar_iconInactive
            x=332,
            y=218,
            width=25,
            height=25,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=460,
            y=131,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedMiddle
            x=468,
            y=33,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedRightEdge
            x=453,
            y=77,
            width=10,
            height=50,

        },
    },
    
    sheetContentWidth = 509,
    sheetContentHeight = 249
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
    ["picker_bg"] = 19,
    ["picker_overlay"] = 20,
    ["picker_separator"] = 21,
    ["progressView_leftFill"] = 22,
    ["progressView_leftFillBorder"] = 23,
    ["progressView_middleFill"] = 24,
    ["progressView_middleFillBorder"] = 25,
    ["progressView_rightFill"] = 26,
    ["progressView_rightFillBorder"] = 27,
    ["searchField_leftEdge"] = 28,
    ["searchField_magnifyingGlass"] = 29,
    ["searchField_middle"] = 30,
    ["searchField_remove"] = 31,
    ["searchField_rightEdge"] = 32,
    ["segmentedControl_divider"] = 33,
    ["segmentedControl_left"] = 34,
    ["segmentedControl_leftOn"] = 35,
    ["segmentedControl_middle"] = 36,
    ["segmentedControl_middleOn"] = 37,
    ["segmentedControl_right"] = 38,
    ["segmentedControl_rightOn"] = 39,
    ["slider_bottomFrameVertical"] = 40,
    ["slider_fill"] = 41,
    ["slider_fillVertical"] = 42,
    ["slider_handle"] = 43,
    ["slider_leftFrame"] = 44,
    ["slider_middleFrame"] = 45,
    ["slider_middleFrameVertical"] = 46,
    ["slider_rightFrame"] = 47,
    ["slider_topFrameVertical"] = 48,
    ["spinner_spinner"] = 49,
    ["stepper_minusActive"] = 50,
    ["stepper_noMinus"] = 51,
    ["stepper_noPlus"] = 52,
    ["stepper_nonActive"] = 53,
    ["stepper_plusActive"] = 54,
    ["switch_background"] = 55,
    ["switch_checkboxDefault"] = 56,
    ["switch_checkboxSelected"] = 57,
    ["switch_handle"] = 58,
    ["switch_handleOver"] = 59,
    ["switch_overlay"] = 60,
    ["switch_radioButtonDefault"] = 61,
    ["switch_radioButtonSelected"] = 62,
    ["tabBar_background"] = 63,
    ["tabBar_iconActive"] = 64,
    ["tabBar_iconInactive"] = 65,
    ["tabBar_tabSelectedLeftEdge"] = 66,
    ["tabBar_tabSelectedMiddle"] = 67,
    ["tabBar_tabSelectedRightEdge"] = 68,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
