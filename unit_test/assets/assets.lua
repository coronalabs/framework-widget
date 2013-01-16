--
-- created with TexturePacker (http://www.texturepacker.com)
--
-- $TexturePacker:SmartUpdate:68ecf9f4e7df5f025e7ec82fefac3f0c$
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
            -- button
            x=107,
            y=3,
            width=100,
            height=25,

        },
        {
            -- buttonOver
            x=3,
            y=3,
            width=100,
            height=25,

        },
    },
    
    sheetContentWidth = 210,
    sheetContentHeight = 31
}

SheetInfo.frameIndex =
{

    ["button"] = 1,
    ["buttonOver"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
