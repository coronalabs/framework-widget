--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:7a8e9e1cbaa5bb9ab35f49ff7435c4cd$
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
            x=130,
            y=2,
            width=165,
            height=31,

        },
        {
            -- switch_checkboxDefault
            x=442,
            y=2,
            width=29,
            height=29,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 33,
            sourceHeight = 33
        },
        {
            -- switch_checkboxSelected
            x=421,
            y=33,
            width=29,
            height=29,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 33,
            sourceHeight = 33
        },
        {
            -- switch_handle
            x=390,
            y=33,
            width=29,
            height=29,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 31,
            sourceHeight = 31
        },
        {
            -- switch_handleOver
            x=359,
            y=33,
            width=29,
            height=29,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 31,
            sourceHeight = 31
        },
        {
            -- switch_onOffMask
            x=44,
            y=2,
            width=84,
            height=32,

        },
        {
            -- switch_overlay
            x=359,
            y=2,
            width=81,
            height=29,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 83,
            sourceHeight = 31
        },
        {
            -- switch_radioButtonDefault
            x=328,
            y=2,
            width=29,
            height=30,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 33,
            sourceHeight = 34
        },
        {
            -- switch_radioButtonSelected
            x=297,
            y=2,
            width=29,
            height=30,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 33,
            sourceHeight = 34
        },
    },
    
    sheetContentWidth = 473,
    sheetContentHeight = 64
}

SheetInfo.frameIndex =
{

    ["spinner_spinner"] = 1,
    ["switch_background"] = 2,
    ["switch_checkboxDefault"] = 3,
    ["switch_checkboxSelected"] = 4,
    ["switch_handle"] = 5,
    ["switch_handleOver"] = 6,
    ["switch_onOffMask"] = 7,
    ["switch_overlay"] = 8,
    ["switch_radioButtonDefault"] = 9,
    ["switch_radioButtonSelected"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
