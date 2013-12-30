local M = {}

if "Android" == system.getInfo("platformName") then
    M.textFieldYOffset  = 6
    M.textFieldXOffset  = -5
    M.fakeLabelYOffset  = 1
    M.fakeLabelXOffset  = 4
    M.textFieldHeightAdjust = 12
elseif  system.getInfo("environment") == "simulator" then   
    M.textFieldYOffset = -3
    M.textFieldXOffset = 0
    M.fakeLabelYOffset = 0
    M.fakeLabelXOffset = 2
    M.textFieldHeightAdjust = 0;
else
    M.textFieldYOffset = 0
    M.textFieldXOffset = 0
    M.fakeLabelYOffset = 0
    M.fakeLabelXOffset = 0
    M.textFieldHeightAdjust = 0;
    
end
local function calcFontSize(targetFontSize)
    local sysType = system.getInfo("architectureInfo")
    local environment = system.getInfo("environment")
    local fontScale = (display.pixelWidth / display.contentWidth) * display.contentScaleX;
    if display.pixelWidth == display.contentWidth then
        fontScale = 1;
    end
    if system.getInfo("platformName") == "Android" then                
       fontScale = (display.pixelWidth / display.contentWidth) * 0.5; 
    elseif  environment ~= "simulator" then    
        if string.match(system.getInfo("model"),"iPa") then
            --iPads 
            if display.pixelHeight == 2048 then
                --iPad retina
                fontScale = (display.pixelHeight / display.contentHeight) * 0.5;
            else
                fontScale = 1 / display.contentScaleY
            end    
        end
    end
    
    return fontScale
    
end

function M:robMiracleCalcFontSize()
  return ( display.pixelWidth / display.contentWidth ) * 0.5
end

function M:mpappasCalcFontSize()
    local sysType = system.getInfo("architectureInfo")
    
    local fontScale = 1 / display.contentScaleY    -- old method is fallback (ends up being sim setting)
    
    if system.getInfo("platformName") == "Android" or not string.match(system.getInfo("model"),"iP") then      -- try and get the real width / height and deal with it            
        --print(" -- -- Android font size calc...")
        
        local missingInches = display.screenOriginY * -2     -- account for both top and bottom area (x2), and change the sign sign since originY is always negative, if it exists...
        
        missingInches = missingInches / 320             -- 320 is 1 inch, in my 640x960 virual content space (960 == 3 inches for my app, designed for a standard iphone 4 display)        
        -- different contentScale sizes will use a different virtual pixel / inch value (eg, 320x480 virtual content = missingInches / 160)
        --print(" -- missing inches == ", missingInches)
        
        local heightIn = system.getInfo( "androidDisplayHeightInInches" )
        local widthIn = system.getInfo( "androidDisplayWidthInInches" )
        --print(" -- original height == ", heightIn)
        if heightIn ~= nil then
            heightIn = heightIn - missingInches               
        
        --Make sure its not nil... e.g. the simulator will return nil, perhaps some bad devices will too...
        
            -- heightIn is height of actual droid app is running on
            fontScale =  heightIn / 3.0 -- 3.0 is actual iPhone 3gs /4 /4s height
            --print(" -- fontsize set on actual droid screen inch height")
            --print(" -- widthIn = ", widthIn)
            --print(" -- heightIn = ", heightIn)
        else
            fontScale = 4/3  --Default to a 4 inch diagonal (iphone is 3.0)
            --print(" -- fontsize set to 4 inch phone size")
        end
        
        
    else     
        local fontScale = 1
        local heightIn = 3                                  -- default to stnadard iPhone size        
        local missingInches = display.screenOriginY * -2    -- account for both top and bottom area (x2), and change the sign sign originY is negative, if it exists...
        
        missingInches = missingInches / 320             -- 320 is 1 inch, in my 640x960 virual content space (960 == 3 inches for my app, designed for a standard iphone 4 display)
        -- different contentScale sizes will use a different virtual pixel / inch value (eg, 320x480 virtual content = missingInches / 160)        
        --
        -- Since there is no corona facility to get the screen height of the device on iOS, we'll determine it ourselves.
        --
        if( sysType == "iPhone2,1" ) then       -- 3GS        
            heightIn = 3.0 - missingInches      -- original iPhone size
        elseif( string.match(sysType, "iPhone3") or string.match(sysType, "iPhone4") ) then       -- iPhone 4, 4S        
            heightIn = 3.0 - missingInches      -- Same size as the old 3gs- better resolution, but same size
        elseif( string.match(sysType, "iPhone5")  ) then       -- iPhone 5
            heightIn = 4.0 - missingInches      -- Should go back to 3, after missing inches chopped off by corona are deducted.
        elseif sysType == "iPad2,5" or sysType == "iPad2,6" or sysType == "iPad2,7" or sysType == "iPad2,8" then    -- 2,8 is unknown, just a guess at next mini #
            heightIn = 6.25 - missingInches     -- mini
        elseif( string.match(sysType, "iPad") ) then       -- standard iPad
            heightIn = 7.75 - missingInches     -- iPad
        else
            if( missingInches == 0 ) then
                -- iPod falls through to here (and it is 3 inches tall, and any missing inches accounted for in a tall version, so that works for now)
                heightIn = 3.0 - missingInches  -- I would hope this is typical, zero extra on an unknown ios device
            else
                heightIn = 4.0 - missingInches  -- otherwise, we'll take a flying guess that the unknown device is bigger than a tiny breadbox, and smaller than a car. (4 inches tall, iphone 5 format)
            end
        end        
        fontScale =  heightIn / 3.0                 -- 3.0 inches is actual iPhone 4 height (that my content is based on)
    end
    return fontScale
    
end

M.fontScale = calcFontSize()

return M

