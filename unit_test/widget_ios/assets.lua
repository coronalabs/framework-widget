--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:5277db5f70a0622bea2ef7ef1efd1ebe$
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
            -- progressView_innerFrame
            x=2,
            y=2,
            width=48,
            height=14,

        },
        {
            -- progressView_outerFrame
            x=52,
            y=2,
            width=185,
            height=14,

        },
        {
            -- searchField_bar
            x=2,
            y=18,
            width=207,
            height=33,

        },
        {
            -- searchField_remove
            x=211,
            y=18,
            width=19,
            height=19,

        },
        {
            -- spinner_spinner
            x=2,
            y=53,
            width=40,
            height=40,

        },
        {
            -- stepper_minusActive
            x=44,
            y=53,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=140,
            y=53,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=2,
            y=95,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=98,
            y=95,
            width=94,
            height=27,

        },
        {
            -- stepper_plusActive
            x=2,
            y=124,
            width=94,
            height=27,

        },
        {
            -- switch_background
            x=2,
            y=153,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=169,
            y=153,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=204,
            y=153,
            width=33,
            height=33,

        },
        {
            -- switch_handle
            x=2,
            y=188,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=35,
            y=188,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=68,
            y=188,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=153,
            y=188,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=188,
            y=188,
            width=33,
            height=34,

        },
    },
    
    sheetContentWidth = 239,
    sheetContentHeight = 224
}

SheetInfo.frameIndex =
{

    ["progressView_innerFrame"] = 1,
    ["progressView_outerFrame"] = 2,
    ["searchField_bar"] = 3,
    ["searchField_remove"] = 4,
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
