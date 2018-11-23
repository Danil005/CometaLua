local composer = require("composer")

local scene = composer.newScene()

local background = nil
local image_comet = nil

function scene:create(event)
    local scene_group = self.view
    background = display.newImageRect( scene_group, "Sprites/menyu_fon_2.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    --image_comet = display.newImageRect( scene_group,"Sprites/kometa_staticheskaya_1.tif",90,400)
    --image_comet.x = display.contentCenterX
    --image_comet.y = display.contentCenterY
end

function scene:show(event)
end

function scene:hide(event)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
