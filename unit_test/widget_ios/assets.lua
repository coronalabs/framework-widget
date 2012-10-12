--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:1db18a4df512aa2609f1be993d86b668$
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
            -- spinner_spinner
            x=2,
            y=2,
            width=40,
            height=40,

        },
        {
            -- switch_background
            x=184,
            y=2,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=149,
            y=2,
            width=33,
            height=33,

        },
        {
            -- switch_checkboxSelected
            x=114,
            y=2,
            width=33,
            height=33,

        },
        {
            -- switch_handle
            x=469,
            y=2,
            width=31,
            height=31,

        },
        {
            -- switch_handleOver
            x=436,
            y=2,
            width=31,
            height=31,

        },
        {
            -- switch_overlay
            x=351,
            y=2,
            width=83,
            height=31,

        },
        {
            -- switch_radioButtonDefault
            x=79,
            y=2,
            width=33,
            height=34,

        },
        {
            -- switch_radioButtonSelected
            x=44,
            y=2,
            width=33,
            height=34,

        },
    },
    
    sheetContentWidth = 502,
    sheetContentHeight = 44
}

SheetInfo.frameIndex =
{

    ["spinner_spinner"] = 1,
    ["switch_background"] = 2,
    ["switch_checkboxDefault"] = 3,
    ["switch_checkboxSelected"] = 4,
    ["switch_handle"] = 5,
    ["switch_handleOver"] = 6,
    ["switch_overlay"] = 7,
    ["switch_radioButtonDefault"] = 8,
    ["switch_radioButtonSelected"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
