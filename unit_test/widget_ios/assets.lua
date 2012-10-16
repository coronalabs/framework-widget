--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:a65b519b4237b253ad531ab7215e9510$
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
            -- searchField_remove
            x=2,
            y=2,
            width=19,
            height=19,

        },
        {
            -- switch_handle
            x=23,
            y=2,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=56,
            y=2,
            width=31,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=89,
            y=2,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=124,
            y=2,
            width=33,
            height=33,

        },
        {
            -- switch_radioButtonSelected
            x=159,
            y=2,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonDefault
            x=194,
            y=2,
            width=33,
            height=34,

        },
        {
            -- spinner_spinner
            x=2,
            y=38,
            width=40,
            height=40,

        },
        {
            -- switch_overlay
            x=44,
            y=38,
            width=83,
            height=31,

        },
        {
            -- stepper_minusActive
            x=129,
            y=38,
            width=94,
            height=27,

        },
        {
            -- stepper_plusActive
            x=2,
            y=80,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=98,
            y=80,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
            x=2,
            y=109,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=98,
            y=109,
            width=94,
            height=27,

        },
        {
            -- switch_background
            x=2,
            y=138,
            width=165,
            height=31,

        },
        {
            -- searchField_bar
            x=2,
            y=171,
            width=207,
            height=33,

        },
    },
    
    sheetContentWidth = 229,
    sheetContentHeight = 206
}

SheetInfo.frameIndex =
{

    ["searchField_remove"] = 1,
    ["switch_handle"] = 2,
    ["switch_handleOver"] = 3,
    ["switch_checkboxDefault"] = 4,
    ["switch_checkboxSelected"] = 5,
    ["switch_radioButtonSelected"] = 6,
    ["switch_radioButtonDefault"] = 7,
    ["spinner_spinner"] = 8,
    ["switch_overlay"] = 9,
    ["stepper_minusActive"] = 10,
    ["stepper_plusActive"] = 11,
    ["stepper_noMinus"] = 12,
    ["stepper_nonActive"] = 13,
    ["stepper_noPlus"] = 14,
    ["switch_background"] = 15,
    ["searchField_bar"] = 16,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
