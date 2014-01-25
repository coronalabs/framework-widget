local storyboard = require("storyboard")

function storyboard.getCurrentScene()
    local sceneName = storyboard.getCurrentSceneName()
    if sceneName and string.len(sceneName) > 0 then
        return storyboard.getScene(sceneName)
    else
        return nil
    end
end


local oldNewScene = nil;
local function newScene()
    local scene = oldNewScene()
    scene._editFields = {}
    
    function onExitScene( event )
        native.setKeyboardFocus(nil)
    end
    
    function onEnterScene( event )
        native.setKeyboardFocus(nil)
    end
    
    function onCreateScene( event )
        native.setKeyboardFocus(nil)
    end
    
    function scene.addEditField(field)
       scene._editFields [field] = field;
    end
    
    function scene.removeEditField(field)
       scene._editFields [field] = nil; 
    end
    
    function scene.validateEditFields()
        local retVal = {}
        for i,v in pairs(scene._editFields) do
            if i:validate() then
                table.insert(retVal, i)
            end
        end
        if #retVal > 0 then
            return retVal
        else
            return nil
        end    
    end
    
    function scene.isModified()
        local retVal = {}
        for i,v in pairs(scene._editFields) do
            if i:isModified() then
                table.insert(retVal, i)
            end
        end
        if #retVal > 0 then
           return retVal 
        else
            return nil
        end    
    end
    function scene.setIsModified(value)
        for i,v in pairs(scene._editFields) do
            i:setIsModified(value)
        end
    end

    
    scene:addEventListener( "exitScene", onExitScene )
    scene:addEventListener( "enterScene", onEnterScene )
    scene:addEventListener( "createScene", onCreateScene )
    return scene;
end
if oldNewScene ~= newScene then
    oldNewScene = storyboard.newScene
end

storyboard.newScene = newScene;

