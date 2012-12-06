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
            x=445,
            y=100,
            width=15,
            height=15,

        },
        {
            -- button_bottomLeftOver
            x=426,
            y=107,
            width=15,
            height=15,

        },
        {
            -- button_bottomMiddle
            x=415,
            y=88,
            width=15,
            height=15,

        },
        {
            -- button_bottomMiddleOver
            x=416,
            y=69,
            width=15,
            height=15,

        },
        {
            -- button_bottomRight
            x=407,
            y=108,
            width=15,
            height=15,

        },
        {
            -- button_bottomRightOver
            x=388,
            y=108,
            width=15,
            height=15,

        },
        {
            -- button_middle
            x=114,
            y=108,
            width=15,
            height=15,

        },
        {
            -- button_middleLeft
            x=95,
            y=108,
            width=15,
            height=15,

        },
        {
            -- button_middleLeftOver
            x=369,
            y=104,
            width=15,
            height=15,

        },
        {
            -- button_middleOver
            x=396,
            y=89,
            width=15,
            height=15,

        },
        {
            -- button_middleRight
            x=396,
            y=70,
            width=15,
            height=15,

        },
        {
            -- button_middleRightOver
            x=350,
            y=104,
            width=15,
            height=15,

        },
        {
            -- button_topLeft
            x=331,
            y=104,
            width=15,
            height=15,

        },
        {
            -- button_topLeftOver
            x=275,
            y=106,
            width=15,
            height=15,

        },
        {
            -- button_topMiddle
            x=256,
            y=106,
            width=15,
            height=15,

        },
        {
            -- button_topMiddleOver
            x=237,
            y=106,
            width=15,
            height=15,

        },
        {
            -- button_topRight
            x=218,
            y=107,
            width=15,
            height=15,

        },
        {
            -- button_topRightOver
            x=199,
            y=107,
            width=15,
            height=15,

        },
        {
            -- progressView_leftFill
            x=51,
            y=114,
            width=12,
            height=10,

        },
        {
            -- progressView_leftFillBorder
            x=42,
            y=100,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFill
            x=35,
            y=114,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFillBorder
            x=3,
            y=100,
            width=35,
            height=10,

        },
        {
            -- progressView_rightFill
            x=19,
            y=114,
            width=12,
            height=10,

        },
        {
            -- progressView_rightFillBorder
            x=3,
            y=114,
            width=12,
            height=10,

        },
        {
            -- searchField_leftEdge
            x=281,
            y=72,
            width=18,
            height=30,

        },
        {
            -- searchField_magnifyingGlass
            x=179,
            y=107,
            width=16,
            height=17,

        },
        {
            -- searchField_middle
            x=259,
            y=72,
            width=18,
            height=30,

        },
        {
            -- searchField_remove
            x=72,
            y=100,
            width=19,
            height=19,

        },
        {
            -- searchField_rightEdge
            x=237,
            y=72,
            width=18,
            height=30,

        },
        {
            -- segmentedControl_divider
            x=376,
            y=71,
            width=1,
            height=29,

        },
        {
            -- segmentedControl_left
            x=381,
            y=70,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_leftOn
            x=361,
            y=71,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middle
            x=346,
            y=71,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middleOn
            x=331,
            y=71,
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
            -- sliderFillLeft
            x=435,
            y=69,
            width=10,
            height=10,

        },
        {
            -- sliderFillMiddle
            x=294,
            y=106,
            width=2,
            height=10,

        },
        {
            -- sliderFillRight
            x=58,
            y=100,
            width=10,
            height=10,

        },
        {
            -- sliderHandle
            x=380,
            y=34,
            width=32,
            height=32,

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
            x=208,
            y=78,
            width=25,
            height=25,

        },
        {
            -- tabBar_iconInactive
            x=179,
            y=78,
            width=25,
            height=25,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=317,
            y=71,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedMiddle
            x=303,
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
    sheetContentHeight = 127
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
