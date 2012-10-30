--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:3ea6d339f84ef076efbd542582d4906f$
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
            x=244,
            y=38,
            width=12,
            height=10,

        },
        {
            -- progressView_middleFill
            x=189,
            y=40,
            width=35,
            height=10,

        },
        {
            -- progressView_outerFrame
            x=3,
            y=47,
            width=182,
            height=10,

        },
        {
            -- progressView_rightFill
            x=228,
            y=38,
            width=12,
            height=10,

        },
        {
            -- spinner_spinner
            x=3,
            y=3,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=717,
            y=3,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=619,
            y=34,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=619,
            y=3,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=521,
            y=34,
            width=94,
            height=27,

        },
        {
            -- stepper_plusActive
            x=521,
            y=3,
            width=94,
            height=27,

        },
        {
            -- switch_background
            x=195,
            y=3,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=158,
            y=3,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=121,
            y=3,
            width=33,
            height=33,

        },
        {
            -- switch_handle
            x=486,
            y=3,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=451,
            y=3,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=364,
            y=3,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=84,
            y=3,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=47,
            y=3,
            width=33,
            height=34,

        },
    },
    
    sheetContentWidth = 814,
    sheetContentHeight = 64
}

SheetInfo.frameIndex =
{

    ["progressView_leftFill"] = 1,
    ["progressView_middleFill"] = 2,
    ["progressView_outerFrame"] = 3,
    ["progressView_rightFill"] = 4,
    ["spinner_spinner"] = 5,
    ["stepper_minusActive"] = 6,
    ["stepper_noMinus"] = 7,
    ["stepper_noPlus"] = 8,
    ["stepper_nonActive"] = 9,
    ["stepper_plusActive"] = 10,
    ["switch_background"] = 11,
    ["switch_checkboxDefault"] = 12,
    ["switch_checkboxSelected"] = 13,
    ["switch_handle"] = 14,
    ["switch_handleOver"] = 15,
    ["switch_overlay"] = 16,
    ["switch_radioButtonDefault"] = 17,
    ["switch_radioButtonSelected"] = 18,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
