--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:2486ed3c589d3dc0ea9ac80bf853bc8e$
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
            -- background
            x=130,
            y=2,
            width=165,
            height=31,

        },
        {
            -- checkboxDefault
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
            -- checkboxSelected
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
            -- handle
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
            -- handleOver
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
            -- onOffMask
            x=44,
            y=2,
            width=84,
            height=32,

        },
        {
            -- overlay
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
            -- radioButtonDefault
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
            -- radioButtonSelected
            x=297,
            y=2,
            width=29,
            height=30,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 33,
            sourceHeight = 34
        },
        {
            -- spinner
            x=2,
            y=2,
            width=40,
            height=40,

        },
    },
    
    sheetContentWidth = 473,
    sheetContentHeight = 64
}

SheetInfo.frameIndex =
{

    ["background"] = 1,
    ["checkboxDefault"] = 2,
    ["checkboxSelected"] = 3,
    ["handle"] = 4,
    ["handleOver"] = 5,
    ["onOffMask"] = 6,
    ["overlay"] = 7,
    ["radioButtonDefault"] = 8,
    ["radioButtonSelected"] = 9,
    ["spinner"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
