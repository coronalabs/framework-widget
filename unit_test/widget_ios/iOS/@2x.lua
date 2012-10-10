--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:5c0fd216301e2dafee9da05e22db02c4$
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
            -- background@2x
            x=84,
            y=2,
            width=330,
            height=61,

        },
        {
            -- checkboxDefault@2x
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
            -- checkboxSelected@2x
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
            -- handle@2x
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
            -- handleOver@2x
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
            -- overlay@2x
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
            -- radioButtonDefault@2x
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
            -- radioButtonSelected@2x
            x=202,
            y=65,
            width=56,
            height=57,

            sourceX = 5,
            sourceY = 5,
            sourceWidth = 66,
            sourceHeight = 67
        },
        {
            -- spinner@2x
            x=2,
            y=2,
            width=80,
            height=80,

        },
    },
    
    sheetContentWidth = 532,
    sheetContentHeight = 124
}

SheetInfo.frameIndex =
{

    ["background@2x"] = 1,
    ["checkboxDefault@2x"] = 2,
    ["checkboxSelected@2x"] = 3,
    ["handle@2x"] = 4,
    ["handleOver@2x"] = 5,
    ["overlay@2x"] = 6,
    ["radioButtonDefault@2x"] = 7,
    ["radioButtonSelected@2x"] = 8,
    ["spinner@2x"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
