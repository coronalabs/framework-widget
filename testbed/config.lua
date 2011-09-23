local platform = system.getInfo( "platformName" )
local isAndroid = false

if platform == "Mac OS X" then
	local model = system.getInfo( "model" )
	
	if model == "Nexus One" or model == "myTouch" or model == "Droid" or model == "Galaxy Tab" then
		isAndroid = true
	end
end

if not isAndroid then
	application = 
	{
		content = 
		{ 
			width = 320,
			height = 480,
			scale = "letterbox",
			fps = 30,
			
			imageSuffix = {
				["@2x"] = 2,
			}
		}
	}
else
	application = 
	{
		content = 
		{ 
			width = 320,
			height = 480,
			scale = "letterbox",
			fps = 30,
			
			imageSuffix = {
				["@2x"] = 2,
			}
		}
	}
end

local sysModel = system.getInfo("model")

if sysModel == "iPad" then

	application = 
	{
		content = 
		{ 
			width = 768,
			height = 1024,
			scale = "letterbox",
			fps = 30,
			
			imageSuffix = {
				["@2x"] = 2,
			}
		}
	}
end