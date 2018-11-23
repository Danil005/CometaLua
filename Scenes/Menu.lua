local composer = require("composer")

local scene = composer.newScene()

local background = nil
local image_comet = nil
local button_back = nil
local button_settings = nil
function scene:create(event)
    local scene_group = self.view
    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    button_back = display.newImageRect( scene_group, "Sprites/knopka_nazad.png", 25,35)
    button_back.x = 50
    button_back.y = 30
    button_settings = display.newImageRect( scene_group,"Sprites/knopka_nastroyki.png", 35,35)
    button_settings.x = 265
    button_settings.y = 30
    --image_comet = display.newImageRect( scene_group,"Sprites/sprite_comet.tif",40,100)
    --image_comet.x = display.contentCenterX
    --image_comet.y = display.contentCenterY * 1.5

end

function scene:show(event)
end

function scene:hide(event)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
