--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:ba0ba8b8e4a50867b437a4ceb6eafdbe$
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
            x=502,
            y=100,
            width=15,
            height=15,

        },
        {
            -- button_bottomLeftOver
            x=709,
            y=104,
            width=15,
            height=15,

        },
        {
            -- button_bottomMiddle
            x=690,
            y=104,
            width=15,
            height=15,

        },
        {
            -- button_bottomMiddleOver
            x=671,
            y=105,
            width=15,
            height=15,

        },
        {
            -- button_bottomRight
            x=652,
            y=105,
            width=15,
            height=15,

        },
        {
            -- button_bottomRightOver
            x=255,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_full
            x=3,
            y=52,
            width=278,
            height=45,

        },
        {
            -- button_fullOver
            x=3,
            y=3,
            width=278,
            height=45,

        },
        {
            -- button_middle
            x=236,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_middleLeft
            x=217,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_middleLeftOver
            x=198,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_middleOver
            x=179,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_middleRight
            x=160,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_middleRightOver
            x=141,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_topLeft
            x=122,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_topLeftOver
            x=103,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_topMiddle
            x=84,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_topMiddleOver
            x=65,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_topRight
            x=46,
            y=101,
            width=15,
            height=15,

        },
        {
            -- button_topRightOver
            x=483,
            y=100,
            width=15,
            height=15,

        },
        {
            -- progressView_leftFill
            x=608,
            y=106,
            width=12,
            height=10,

        },
        {
            -- progressView_leftFillBorder
            x=728,
            y=104,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFill
            x=521,
            y=99,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFillBorder
            x=366,
            y=73,
            width=35,
            height=10,

        },
        {
            -- progressView_rightFill
            x=435,
            y=108,
            width=12,
            height=10,

        },
        {
            -- progressView_rightFillBorder
            x=419,
            y=108,
            width=12,
            height=10,

        },
        {
            -- searchField_leftEdge
            x=630,
            y=72,
            width=18,
            height=30,

        },
        {
            -- searchField_magnifyingGlass
            x=26,
            y=101,
            width=16,
            height=17,

        },
        {
            -- searchField_middle
            x=608,
            y=72,
            width=18,
            height=30,

        },
        {
            -- searchField_remove
            x=3,
            y=101,
            width=19,
            height=19,

        },
        {
            -- searchField_rightEdge
            x=586,
            y=78,
            width=18,
            height=30,

        },
        {
            -- segmentedControl_divider
            x=744,
            y=34,
            width=1,
            height=29,

        },
        {
            -- segmentedControl_left
            x=727,
            y=71,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_leftOn
            x=712,
            y=71,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middle
            x=697,
            y=71,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middleOn
            x=682,
            y=71,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_right
            x=667,
            y=72,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_rightOn
            x=652,
            y=72,
            width=11,
            height=29,

        },
        {
            -- sliderFillLeft
            x=537,
            y=99,
            width=10,
            height=10,

        },
        {
            -- sliderFillMiddle
            x=274,
            y=101,
            width=2,
            height=10,

        },
        {
            -- sliderFillRight
            x=405,
            y=73,
            width=10,
            height=10,

        },
        {
            -- sliderHandle
            x=383,
            y=87,
            width=32,
            height=32,

        },
        {
            -- spinner_spinner
            x=552,
            y=34,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=454,
            y=34,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=650,
            y=3,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=552,
            y=3,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=454,
            y=3,
            width=94,
            height=27,

        },
        {
            -- stepper_plusActive
            x=285,
            y=93,
            width=94,
            height=27,

        },
        {
            -- switch_background
            x=285,
            y=3,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=707,
            y=34,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=670,
            y=34,
            width=33,
            height=33,

        },
        {
            -- switch_handle
            x=483,
            y=65,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=419,
            y=73,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=366,
            y=38,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=633,
            y=34,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=596,
            y=34,
            width=33,
            height=34,

        },
        {
            -- tabBar_background
            x=454,
            y=65,
            width=25,
            height=50,

        },
        {
            -- tabBar_iconActive
            x=552,
            y=78,
            width=30,
            height=30,

        },
        {
            -- tabBar_iconInactive
            x=518,
            y=65,
            width=30,
            height=30,

        },
        {
            -- tabBar_tabSelected
            x=285,
            y=38,
            width=77,
            height=51,

        },
    },
    
    sheetContentWidth = 748,
    sheetContentHeight = 123
}

SheetInfo.frameIndex =
{

    ["button_bottomLeft"] = 1,
    ["button_bottomLeftOver"] = 2,
    ["button_bottomMiddle"] = 3,
    ["button_bottomMiddleOver"] = 4,
    ["button_bottomRight"] = 5,
    ["button_bottomRightOver"] = 6,
    ["button_full"] = 7,
    ["button_fullOver"] = 8,
    ["button_middle"] = 9,
    ["button_middleLeft"] = 10,
    ["button_middleLeftOver"] = 11,
    ["button_middleOver"] = 12,
    ["button_middleRight"] = 13,
    ["button_middleRightOver"] = 14,
    ["button_topLeft"] = 15,
    ["button_topLeftOver"] = 16,
    ["button_topMiddle"] = 17,
    ["button_topMiddleOver"] = 18,
    ["button_topRight"] = 19,
    ["button_topRightOver"] = 20,
    ["progressView_leftFill"] = 21,
    ["progressView_leftFillBorder"] = 22,
    ["progressView_middleFill"] = 23,
    ["progressView_middleFillBorder"] = 24,
    ["progressView_rightFill"] = 25,
    ["progressView_rightFillBorder"] = 26,
    ["searchField_leftEdge"] = 27,
    ["searchField_magnifyingGlass"] = 28,
    ["searchField_middle"] = 29,
    ["searchField_remove"] = 30,
    ["searchField_rightEdge"] = 31,
    ["segmentedControl_divider"] = 32,
    ["segmentedControl_left"] = 33,
    ["segmentedControl_leftOn"] = 34,
    ["segmentedControl_middle"] = 35,
    ["segmentedControl_middleOn"] = 36,
    ["segmentedControl_right"] = 37,
    ["segmentedControl_rightOn"] = 38,
    ["sliderFillLeft"] = 39,
    ["sliderFillMiddle"] = 40,
    ["sliderFillRight"] = 41,
    ["sliderHandle"] = 42,
    ["spinner_spinner"] = 43,
    ["stepper_minusActive"] = 44,
    ["stepper_noMinus"] = 45,
    ["stepper_noPlus"] = 46,
    ["stepper_nonActive"] = 47,
    ["stepper_plusActive"] = 48,
    ["switch_background"] = 49,
    ["switch_checkboxDefault"] = 50,
    ["switch_checkboxSelected"] = 51,
    ["switch_handle"] = 52,
    ["switch_handleOver"] = 53,
    ["switch_overlay"] = 54,
    ["switch_radioButtonDefault"] = 55,
    ["switch_radioButtonSelected"] = 56,
    ["tabBar_background"] = 57,
    ["tabBar_iconActive"] = 58,
    ["tabBar_iconInactive"] = 59,
    ["tabBar_tabSelected"] = 60,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
