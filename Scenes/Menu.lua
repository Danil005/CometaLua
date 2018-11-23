local composer = require("composer")

local scene = composer.newScene()

local background = nil
local image_comet = nil

function scene:create(event)
    local scene_group = self.view
    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
<<<<<<< HEAD
    image_comet = display.newImageRect( scene_group,"Sprites/sprite_comet.tif",40,100)

    image_comet.x = display.contentCenterX
    image_comet.y = display.contentCenterY * 1.5
=======
    --image_comet = display.newImageRect( scene_group,"Sprites/kometa_staticheskaya_1.tif",90,400)
    --image_comet.x = display.contentCenterX
    --image_comet.y = display.contentCenterY
>>>>>>> master
end

function scene:show(event)
end

function scene:hide(event)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
