local composer = require ("composer")
local scene = composer.newScene()
local timer = require("timer")
local background = nil

function scene:create(event)
    local SceneGroup =self.view
    background = display.newImageRect(SceneGroup,"Sprites/Menu/loadImage.png",display.contentWidth+200,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    local text = display.newText(  SceneGroup,"Идет загрузка...", 100, 200, "azerot", 36)
    text.x = display.contentCenterX
    text.y = display.contentCenterY*1.7
end
local function goTo()
    composer.gotoScene( "Scenes.game")
end

function scene:show(event)
    timer.performWithDelay(1000, goTo)
end
scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

return scene
