--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:02936ef0982f89d0e7f71bc360e9f443$
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
            x=554,
            y=181,
            width=15,
            height=15,

        },
        {
            -- button_bottomLeftOver
            x=555,
            y=129,
            width=15,
            height=15,

        },
        {
            -- button_bottomMiddle
            x=551,
            y=148,
            width=15,
            height=15,

        },
        {
            -- button_bottomMiddleOver
            x=536,
            y=129,
            width=15,
            height=15,

        },
        {
            -- button_bottomRight
            x=532,
            y=148,
            width=15,
            height=15,

        },
        {
            -- button_bottomRightOver
            x=517,
            y=129,
            width=15,
            height=15,

        },
        {
            -- button_middle
            x=513,
            y=148,
            width=15,
            height=15,

        },
        {
            -- button_middleLeft
            x=498,
            y=129,
            width=15,
            height=15,

        },
        {
            -- button_middleLeftOver
            x=508,
            y=202,
            width=15,
            height=15,

        },
        {
            -- button_middleOver
            x=489,
            y=202,
            width=15,
            height=15,

        },
        {
            -- button_middleRight
            x=494,
            y=149,
            width=15,
            height=15,

        },
        {
            -- button_middleRightOver
            x=475,
            y=149,
            width=15,
            height=15,

        },
        {
            -- button_topLeft
            x=456,
            y=149,
            width=15,
            height=15,

        },
        {
            -- button_topLeftOver
            x=470,
            y=207,
            width=15,
            height=15,

        },
        {
            -- button_topMiddle
            x=451,
            y=207,
            width=15,
            height=15,

        },
        {
            -- button_topMiddleOver
            x=432,
            y=207,
            width=15,
            height=15,

        },
        {
            -- button_topRight
            x=413,
            y=207,
            width=15,
            height=15,

        },
        {
            -- button_topRightOver
            x=394,
            y=208,
            width=15,
            height=15,

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
            x=456,
            y=134,
            width=8,
            height=1,

        },
        {
            -- progressView_leftFill
            x=574,
            y=110,
            width=12,
            height=10,

        },
        {
            -- progressView_leftFillBorder
            x=558,
            y=110,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFill
            x=558,
            y=96,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFillBorder
            x=430,
            y=82,
            width=35,
            height=10,

        },
        {
            -- progressView_rightFill
            x=574,
            y=96,
            width=12,
            height=10,

        },
        {
            -- progressView_rightFillBorder
            x=554,
            y=167,
            width=12,
            height=10,

        },
        {
            -- searchField_leftEdge
            x=502,
            y=168,
            width=18,
            height=30,

        },
        {
            -- searchField_magnifyingGlass
            x=374,
            y=208,
            width=16,
            height=17,

        },
        {
            -- searchField_middle
            x=480,
            y=168,
            width=18,
            height=30,

        },
        {
            -- searchField_remove
            x=474,
            y=38,
            width=19,
            height=19,

        },
        {
            -- searchField_rightEdge
            x=474,
            y=61,
            width=18,
            height=30,

        },
        {
            -- segmentedControl_divider
            x=496,
            y=61,
            width=1,
            height=29,

        },
        {
            -- segmentedControl_left
            x=539,
            y=167,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_leftOn
            x=543,
            y=96,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middle
            x=524,
            y=167,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_middleOn
            x=528,
            y=96,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_right
            x=513,
            y=96,
            width=11,
            height=29,

        },
        {
            -- segmentedControl_rightOn
            x=498,
            y=96,
            width=11,
            height=29,

        },
        {
            -- silder_middleFrame
            x=570,
            y=205,
            width=10,
            height=10,

        },
        {
            -- silder_middleFrameVertical
            x=556,
            y=214,
            width=10,
            height=10,

        },
        {
            -- slider_bottomFrameVertical
            x=556,
            y=200,
            width=10,
            height=10,

        },
        {
            -- slider_fill
            x=587,
            y=191,
            width=10,
            height=10,

        },
        {
            -- slider_fillVertical
            x=573,
            y=191,
            width=10,
            height=10,

        },
        {
            -- slider_handle
            x=374,
            y=172,
            width=32,
            height=32,

        },
        {
            -- slider_leftFrame
            x=587,
            y=177,
            width=10,
            height=10,

        },
        {
            -- slider_rightFrame
            x=573,
            y=177,
            width=10,
            height=10,

        },
        {
            -- slider_topFrameVertical
            x=574,
            y=124,
            width=10,
            height=10,

        },
        {
            -- spinner_spinner
            x=430,
            y=38,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=501,
            y=65,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=332,
            y=69,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=332,
            y=38,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=501,
            y=34,
            width=94,
            height=27,

        },
        {
            -- stepper_plusActive
            x=501,
            y=3,
            width=94,
            height=27,

        },
        {
            -- switch_background
            x=332,
            y=3,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=369,
            y=135,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=332,
            y=135,
            width=33,
            height=33,

        },
        {
            -- switch_handle
            x=445,
            y=172,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=410,
            y=172,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=332,
            y=100,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=419,
            y=134,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=430,
            y=96,
            width=33,
            height=34,

        },
        {
            -- tabBar_background
            x=469,
            y=95,
            width=25,
            height=50,

        },
        {
            -- tabBar_iconActive
            x=570,
            y=148,
            width=25,
            height=25,

        },
        {
            -- tabBar_iconInactive
            x=527,
            y=200,
            width=25,
            height=25,

        },
        {
            -- tabBar_tabSelectedLeftEdge
            x=360,
            y=172,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedMiddle
            x=346,
            y=172,
            width=10,
            height=50,

        },
        {
            -- tabBar_tabSelectedRightEdge
            x=332,
            y=172,
            width=10,
            height=50,

        },
    },
    
    sheetContentWidth = 600,
    sheetContentHeight = 228
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
    ["silder_middleFrame"] = 40,
    ["silder_middleFrameVertical"] = 41,
    ["slider_bottomFrameVertical"] = 42,
    ["slider_fill"] = 43,
    ["slider_fillVertical"] = 44,
    ["slider_handle"] = 45,
    ["slider_leftFrame"] = 46,
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
