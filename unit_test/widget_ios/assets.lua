--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:b934b3ecff41eb5ed454a78c8db68acc$
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
            x=429,
            y=108,
            width=15,
            height=15,

        },
        {
            -- button_bottomLeftOver
            x=414,
            y=89,
            width=15,
            height=15,

        },
        {
            -- button_bottomMiddle
            x=414,
            y=70,
            width=15,
            height=15,

        },
        {
            -- button_bottomMiddleOver
            x=410,
            y=108,
            width=15,
            height=15,

        },
        {
            -- button_bottomRight
            x=391,
            y=109,
            width=15,
            height=15,

        },
        {
            -- button_bottomRightOver
            x=395,
            y=89,
            width=15,
            height=15,

        },
        {
            -- button_middle
            x=395,
            y=70,
            width=15,
            height=15,

        },
        {
            -- button_middleLeft
            x=372,
            y=109,
            width=15,
            height=15,

        },
        {
            -- button_middleLeftOver
            x=376,
            y=90,
            width=15,
            height=15,

        },
        {
            -- button_middleOver
            x=376,
            y=71,
            width=15,
            height=15,

        },
        {
            -- button_middleRight
            x=353,
            y=109,
            width=15,
            height=15,

        },
        {
            -- button_middleRightOver
            x=334,
            y=109,
            width=15,
            height=15,

        },
        {
            -- button_topLeft
            x=315,
            y=104,
            width=15,
            height=15,

        },
        {
            -- button_topLeftOver
            x=296,
            y=105,
            width=15,
            height=15,

        },
        {
            -- button_topMiddle
            x=357,
            y=90,
            width=15,
            height=15,

        },
        {
            -- button_topMiddleOver
            x=338,
            y=90,
            width=15,
            height=15,

        },
        {
            -- button_topRight
            x=357,
            y=71,
            width=15,
            height=15,

        },
        {
            -- button_topRightOver
            x=338,
            y=71,
            width=15,
            height=15,

        },
        {
            -- progressView_leftFill
            x=195,
            y=112,
            width=12,
            height=10,

        },
        {
            -- progressView_leftFillBorder
            x=77,
            y=114,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFill
            x=179,
            y=112,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFillBorder
            x=61,
            y=100,
            width=35,
            height=10,

        },
        {
            -- progressView_rightFill
            x=61,
            y=114,
            width=12,
            height=10,

        },
        {
            -- progressView_rightFillBorder
            x=120,
            y=108,
            width=12,
            height=10,

        },
        {
            -- searchField_leftEdge
            x=223,
            y=78,
            width=18,
            height=30,

        },
        {
            -- searchField_magnifyingGlass
            x=100,
            y=108,
            width=16,
            height=17,

        },
        {
            -- searchField_middle
            x=201,
            y=78,
            width=18,
            height=30,

        },
        {
            -- searchField_remove
            x=273,
            y=105,
            width=19,
            height=19,

        },
        {
            -- searchField_rightEdge
            x=179,
            y=78,
            width=18,
            height=30,

        },
        {
            -- segmentedControl_divider
            x=303,
            y=72,
            width=1,
            height=29,

        },
        {
            -- segmentedControl_left
            x=323,
            y=71,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_leftOn
            x=308,
            y=71,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middle
            x=288,
            y=72,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middleOn
            x=273,
            y=72,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_right
            x=451,
            y=67,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_rightOn
            x=451,
            y=34,
            width=11,
            height=29,

        },
        {
            -- silder_middleFrame
            x=433,
            y=83,
            width=10,
            height=10,

        },
        {
            -- slider_fill
            x=433,
            y=69,
            width=10,
            height=10,

        },
        {
            -- slider_handle
            x=380,
            y=34,
            width=32,
            height=32,

        },
        {
            -- slider_leftFrame
            x=225,
            y=112,
            width=10,
            height=10,

        },
        {
            -- slider_rightFrame
            x=211,
            y=112,
            width=10,
            height=10,

        },
        {
            -- spinner_spinner
            x=188,
            y=34,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=368,
            y=3,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=270,
            y=3,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=3,
            y=69,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=172,
            y=3,
            width=94,
            height=27,

        },
        {
            -- stepper_plusActive
            x=3,
            y=38,
            width=94,
            height=27,

        },
        {
            -- switch_background
            x=3,
            y=3,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=343,
            y=34,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=306,
            y=34,
            width=33,
            height=33,

        },
        {
            -- switch_handle
            x=101,
            y=73,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=416,
            y=34,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=101,
            y=38,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=269,
            y=34,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=232,
            y=34,
            width=33,
            height=34,

        },
        {
            -- tabBar_background
            x=136,
            y=73,
            width=25,
            height=50,

        },
        {
            -- tabBar_iconActive
            x=32,
            y=100,
            width=25,
            height=25,

        },
        {
            -- tabBar_iconInactive
            x=3,
            y=100,
            width=25,
            height=25,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=259,
            y=72,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedMiddle
            x=245,
            y=72,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedRightEdge
            x=165,
            y=73,
            width=10,
            height=50,

        },
    },
    
    sheetContentWidth = 465,
    sheetContentHeight = 128
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
    ["slider_fill"] = 38,
    ["slider_handle"] = 39,
    ["slider_leftFrame"] = 40,
    ["slider_rightFrame"] = 41,
    ["spinner_spinner"] = 42,
    ["stepper_minusActive"] = 43,
    ["stepper_noMinus"] = 44,
    ["stepper_noPlus"] = 45,
    ["stepper_nonActive"] = 46,
    ["stepper_plusActive"] = 47,
    ["switch_background"] = 48,
    ["switch_checkboxDefault"] = 49,
    ["switch_checkboxSelected"] = 50,
    ["switch_handle"] = 51,
    ["switch_handleOver"] = 52,
    ["switch_overlay"] = 53,
    ["switch_radioButtonDefault"] = 54,
    ["switch_radioButtonSelected"] = 55,
    ["tabBar_background"] = 56,
    ["tabBar_iconActive"] = 57,
    ["tabBar_iconInactive"] = 58,
    ["tabBar_tabSelectedLeftEdge"] = 59,
    ["tabBar_tabSelectedMiddle"] = 60,
    ["tabBar_tabSelectedRightEdge"] = 61,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
