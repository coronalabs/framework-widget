--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:dbcce53eb3d2b1fc948fd60570692de9$
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
            -- AI_01
            x=2,
            y=2,
            width=50,
            height=50,

        },
        {
            -- AI_02
            x=54,
            y=2,
            width=50,
            height=50,

        },
        {
            -- AI_03
            x=2,
            y=54,
            width=50,
            height=50,

        },
        {
            -- AI_04
            x=54,
            y=54,
            width=50,
            height=50,

        },
        {
            -- AI_05
            x=2,
            y=106,
            width=50,
            height=50,

        },
        {
            -- AI_06
            x=54,
            y=106,
            width=50,
            height=50,

        },
    },
    
    sheetContentWidth = 106,
    sheetContentHeight = 158
}

SheetInfo.frameIndex =
{

    ["AI_01"] = 1,
    ["AI_02"] = 2,
    ["AI_03"] = 3,
    ["AI_04"] = 4,
    ["AI_05"] = 5,
    ["AI_06"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
