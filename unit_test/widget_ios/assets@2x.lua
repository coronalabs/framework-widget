--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:4d2ba5bf8e7efad3101f04da2e0d600e$
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
            width=80,
            height=80,

        },
        {
            -- switch_background
            x=84,
            y=2,
            width=330,
            height=61,

        },
        {
            -- switch_checkboxDefault
            x=474,
            y=2,
            width=56,
            height=56,

            sourceX = 5,
            sourceY = 5,
            sourceWidth = 66,
            sourceHeight = 66
        },
        {
            -- switch_checkboxSelected
            x=416,
            y=2,
            width=56,
            height=56,

            sourceX = 5,
            sourceY = 5,
            sourceWidth = 66,
            sourceHeight = 66
        },
        {
            -- switch_handle
            x=143,
            y=65,
            width=57,
            height=57,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 61,
            sourceHeight = 61
        },
        {
            -- switch_handleOver
            x=84,
            y=65,
            width=57,
            height=57,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 61,
            sourceHeight = 61
        },
        {
            -- switch_overlay
            x=318,
            y=65,
            width=158,
            height=56,

            sourceX = 3,
            sourceY = 2,
            sourceWidth = 166,
            sourceHeight = 62
        },
        {
            -- switch_radioButtonDefault
            x=260,
            y=65,
            width=56,
            height=57,

            sourceX = 5,
            sourceY = 5,
            sourceWidth = 66,
            sourceHeight = 67
        },
        {
            -- switch_radioButtonSelected
            x=202,
            y=65,
            width=56,
            height=57,

            sourceX = 5,
            sourceY = 5,
            sourceWidth = 66,
            sourceHeight = 67
        },
    },
    
    sheetContentWidth = 532,
    sheetContentHeight = 124
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
