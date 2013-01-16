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
            x=518,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_bottomLeftOver
            x=500,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_bottomMiddle
            x=482,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_bottomMiddleOver
            x=464,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_bottomRight
            x=446,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_bottomRightOver
            x=428,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_middle
            x=410,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_middleLeft
            x=392,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_middleLeftOver
            x=374,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_middleOver
            x=356,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_middleRight
            x=338,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_middleRightOver
            x=320,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_topLeft
            x=302,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_topLeftOver
            x=284,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_topMiddle
            x=266,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_topMiddleOver
            x=248,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_topRight
            x=230,
            y=458,
            width=10,
            height=10,

        },
        {
            -- button_topRightOver
            x=920,
            y=370,
            width=10,
            height=10,

        },
        {
            -- picker_bg
            x=654,
            y=6,
            width=2,
            height=444,

        },
        {
            -- picker_overlay
            x=6,
            y=6,
            width=640,
            height=444,

        },
        {
            -- picker_separator
            x=6,
            y=490,
            width=16,
            height=2,

        },
        {
            -- progressView_leftFill
            x=214,
            y=458,
            width=8,
            height=24,

        },
        {
            -- progressView_leftFillBorder
            x=166,
            y=458,
            width=8,
            height=24,

        },
        {
            -- progressView_middleFill
            x=150,
            y=458,
            width=8,
            height=24,

        },
        {
            -- progressView_middleFillBorder
            x=134,
            y=458,
            width=8,
            height=24,

        },
        {
            -- progressView_rightFill
            x=86,
            y=458,
            width=8,
            height=24,

        },
        {
            -- progressView_rightFillBorder
            x=70,
            y=458,
            width=8,
            height=24,

        },
        {
            -- searchField_leftEdge
            x=950,
            y=392,
            width=8,
            height=60,

        },
        {
            -- searchField_magnifyingGlass
            x=780,
            y=436,
            width=48,
            height=48,

        },
        {
            -- searchField_middle
            x=934,
            y=392,
            width=8,
            height=60,

        },
        {
            -- searchField_remove
            x=964,
            y=122,
            width=48,
            height=48,

        },
        {
            -- searchField_rightEdge
            x=918,
            y=406,
            width=8,
            height=60,

        },
        {
            -- segmentedControl_divider
            x=838,
            y=366,
            width=2,
            height=54,

        },
        {
            -- segmentedControl_left
            x=998,
            y=392,
            width=8,
            height=52,

        },
        {
            -- segmentedControl_leftOn
            x=982,
            y=392,
            width=8,
            height=52,

        },
        {
            -- segmentedControl_middle
            x=966,
            y=392,
            width=8,
            height=52,

        },
        {
            -- segmentedControl_middleOn
            x=1004,
            y=6,
            width=8,
            height=52,

        },
        {
            -- segmentedControl_right
            x=988,
            y=6,
            width=8,
            height=52,

        },
        {
            -- segmentedControl_rightOn
            x=972,
            y=6,
            width=8,
            height=52,

        },
        {
            -- slider_bottomFrameVertical
            x=182,
            y=474,
            width=24,
            height=8,

        },
        {
            -- slider_fill
            x=54,
            y=458,
            width=8,
            height=24,

        },
        {
            -- slider_fillVertical
            x=182,
            y=458,
            width=24,
            height=8,

        },
        {
            -- slider_handle
            x=964,
            y=66,
            width=48,
            height=48,

        },
        {
            -- slider_leftFrame
            x=38,
            y=458,
            width=8,
            height=24,

        },
        {
            -- slider_middleFrame
            x=22,
            y=458,
            width=8,
            height=24,

        },
        {
            -- slider_middleFrameVertical
            x=102,
            y=474,
            width=24,
            height=8,

        },
        {
            -- slider_rightFrame
            x=6,
            y=458,
            width=8,
            height=24,

        },
        {
            -- slider_topFrameVertical
            x=102,
            y=458,
            width=24,
            height=8,

        },
        {
            -- spinner_spinner
            x=848,
            y=66,
            width=80,
            height=80,

        },
        {
            -- stepper_minusActive
            x=664,
            y=306,
            width=176,
            height=52,

        },
        {
            -- stepper_noMinus
            x=664,
            y=246,
            width=176,
            height=52,

        },
        {
            -- stepper_noPlus
            x=664,
            y=186,
            width=176,
            height=52,

        },
        {
            -- stepper_nonActive
            x=664,
            y=126,
            width=176,
            height=52,

        },
        {
            -- stepper_plusActive
            x=664,
            y=66,
            width=176,
            height=52,

        },
        {
            -- switch_background
            x=664,
            y=6,
            width=300,
            height=52,

        },
        {
            -- switch_checkboxDefault
            x=948,
            y=250,
            width=64,
            height=64,

        },
        {
            -- switch_checkboxSelected
            x=848,
            y=334,
            width=64,
            height=64,

        },
        {
            -- switch_handle
            x=848,
            y=406,
            width=62,
            height=62,

        },
        {
            -- switch_handleOver
            x=948,
            y=322,
            width=62,
            height=62,

        },
        {
            -- switch_overlay
            x=664,
            y=366,
            width=166,
            height=62,

        },
        {
            -- switch_radioButtonDefault
            x=934,
            y=178,
            width=64,
            height=64,

        },
        {
            -- switch_radioButtonSelected
            x=848,
            y=262,
            width=64,
            height=64,

        },
        {
            -- tabBar_background
            x=848,
            y=154,
            width=50,
            height=100,

        },
        {
            -- tabBar_iconActive
            x=722,
            y=436,
            width=50,
            height=50,

        },
        {
            -- tabBar_iconInactive
            x=664,
            y=436,
            width=50,
            height=50,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=920,
            y=262,
            width=20,
            height=100,

        },
        {
            -- tabBar_tabSelectedMiddle
            x=936,
            y=66,
            width=20,
            height=100,

        },
        {
            -- tabBar_tabSelectedRightEdge
            x=906,
            y=154,
            width=20,
            height=100,

        },
    },
    
    sheetContentWidth = 1018,
    sheetContentHeight = 498
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
