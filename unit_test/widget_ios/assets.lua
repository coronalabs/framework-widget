--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:355cfddf105b8aea79fb45f943fe3d04$
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
            -- stepper_plusActive
            x=2,
            y=2,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=98,
            y=2,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=194,
            y=2,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=290,
            y=2,
            width=94,
            height=27,

        },
        {
            -- stepper_minusActive
            x=386,
            y=2,
            width=94,
            height=27,

        },
        {
            -- switch_handleOver
            x=2,
            y=31,
            width=31,
            height=31,

        },
        {
            -- switch_handle
            x=35,
            y=31,
            width=31,
            height=31,

        },
        {
            -- switch_background
            x=68,
            y=31,
            width=165,
            height=31,

        },
        {
            -- switch_overlay
            x=235,
            y=31,
            width=83,
            height=31,

        },
        {
            -- switch_checkboxSelected
            x=320,
            y=31,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxDefault
            x=355,
            y=31,
            width=33,
            height=33,

        },
        {
            -- switch_radioButtonDefault
            x=390,
            y=31,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=425,
            y=31,
            width=33,
            height=34,

        },
        {
            -- spinner_spinner
            x=460,
            y=31,
            width=40,
            height=40,

        },
    },
    
    sheetContentWidth = 502,
    sheetContentHeight = 73
}

SheetInfo.frameIndex =
{

    ["stepper_plusActive"] = 1,
    ["stepper_nonActive"] = 2,
    ["stepper_noMinus"] = 3,
    ["stepper_noPlus"] = 4,
    ["stepper_minusActive"] = 5,
    ["switch_handleOver"] = 6,
    ["switch_handle"] = 7,
    ["switch_background"] = 8,
    ["switch_overlay"] = 9,
    ["switch_checkboxSelected"] = 10,
    ["switch_checkboxDefault"] = 11,
    ["switch_radioButtonDefault"] = 12,
    ["switch_radioButtonSelected"] = 13,
    ["spinner_spinner"] = 14,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
