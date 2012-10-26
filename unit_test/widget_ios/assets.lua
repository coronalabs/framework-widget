--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:2dd0550466632534f10d4adfa76e7486$
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
            -- progressView_leftFill
            x=214,
            y=17,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFill
            x=189,
            y=75,
            width=35,
            height=10,

        },
        {
            -- progressView_outerFrame
            x=3,
            y=75,
            width=182,
            height=10,

        },
        {
            -- progressView_rightFill
            x=214,
            y=3,
            width=12,
            height=10,

        },
        {
            -- searchField_bar
            x=3,
            y=3,
            width=207,
            height=33,

        },
        {
            -- searchField_remove
            x=73,
            y=244,
            width=19,
            height=19,

        },
        {
            -- segmentedControl_left
            x=171,
            y=168,
            width=66,
            height=29,

        },
        {
            -- segmentedControl_leftOn
            x=101,
            y=223,
            width=66,
            height=29,

        },
        {
            -- segmentedControl_middle
            x=101,
            y=190,
            width=66,
            height=29,

        },
        {
            -- segmentedControl_middleOn
            x=101,
            y=157,
            width=66,
            height=29,

        },
        {
            -- segmentedControl_right
            x=101,
            y=124,
            width=66,
            height=29,

        },
        {
            -- segmentedControl_rightOn
            x=3,
            y=244,
            width=66,
            height=29,

        },
        {
            -- spinner_spinner
            x=171,
            y=124,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=3,
            y=213,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=3,
            y=182,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=3,
            y=151,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=3,
            y=120,
            width=94,
            height=27,

        },
        {
            -- stepper_plusActive
            x=3,
            y=89,
            width=94,
            height=27,

        },
        {
            -- switch_background
            x=3,
            y=40,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=208,
            y=239,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=171,
            y=239,
            width=33,
            height=33,

        },
        {
            -- switch_handle
            x=188,
            y=89,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=172,
            y=40,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=101,
            y=89,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=208,
            y=201,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=171,
            y=201,
            width=33,
            height=34,

        },
    },
    
    sheetContentWidth = 244,
    sheetContentHeight = 276
}

SheetInfo.frameIndex =
{

    ["progressView_leftFill"] = 1,
    ["progressView_middleFill"] = 2,
    ["progressView_outerFrame"] = 3,
    ["progressView_rightFill"] = 4,
    ["searchField_bar"] = 5,
    ["searchField_remove"] = 6,
    ["segmentedControl_left"] = 7,
    ["segmentedControl_leftOn"] = 8,
    ["segmentedControl_middle"] = 9,
    ["segmentedControl_middleOn"] = 10,
    ["segmentedControl_right"] = 11,
    ["segmentedControl_rightOn"] = 12,
    ["spinner_spinner"] = 13,
    ["stepper_minusActive"] = 14,
    ["stepper_noMinus"] = 15,
    ["stepper_noPlus"] = 16,
    ["stepper_nonActive"] = 17,
    ["stepper_plusActive"] = 18,
    ["switch_background"] = 19,
    ["switch_checkboxDefault"] = 20,
    ["switch_checkboxSelected"] = 21,
    ["switch_handle"] = 22,
    ["switch_handleOver"] = 23,
    ["switch_overlay"] = 24,
    ["switch_radioButtonDefault"] = 25,
    ["switch_radioButtonSelected"] = 26,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
