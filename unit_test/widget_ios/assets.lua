--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:eb869495304aebefc9dd1839461f3276$
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
            -- switch_handleOver
            x=23,
            y=2,
            width=31,
            height=31,

        },
        {
            -- switch_handle
            x=56,
            y=2,
            width=31,
            height=31,

        },
        {
            -- switch_checkboxSelected
            x=89,
            y=2,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxDefault
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
            -- stepper_plusActive
            x=129,
            y=38,
            width=94,
            height=27,

        },
        {
            -- stepper_minusActive
            x=2,
            y=80,
            width=94,
            height=27,

        },
        {
            -- stepper_noPlus
            x=98,
            y=80,
            width=94,
            height=27,

        },
        {
            -- stepper_noMinus
            x=2,
            y=109,
            width=94,
            height=27,

        },
        {
            -- stepper_nonActive
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
            -- progressView_outerFrame
            x=2,
            y=171,
            width=182,
            height=10,

        },
        {
            -- searchField_bar
            x=2,
            y=183,
            width=207,
            height=33,

        },
    },
    
    sheetContentWidth = 229,
    sheetContentHeight = 218
}

SheetInfo.frameIndex =
{

    ["searchField_remove"] = 1,
    ["switch_handleOver"] = 2,
    ["switch_handle"] = 3,
    ["switch_checkboxSelected"] = 4,
    ["switch_checkboxDefault"] = 5,
    ["switch_radioButtonSelected"] = 6,
    ["switch_radioButtonDefault"] = 7,
    ["spinner_spinner"] = 8,
    ["switch_overlay"] = 9,
    ["stepper_plusActive"] = 10,
    ["stepper_minusActive"] = 11,
    ["stepper_noPlus"] = 12,
    ["stepper_noMinus"] = 13,
    ["stepper_nonActive"] = 14,
    ["switch_background"] = 15,
    ["progressView_outerFrame"] = 16,
    ["searchField_bar"] = 17,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
