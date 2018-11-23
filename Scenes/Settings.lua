-- Scene Settings

local composer = require("composer")

local scene = composer.newScene()

local background = nil
local image_comet = nil

function scene:create(event)
    local scene_group = self.view
    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local myText = display.newText( "Hello", 0, 0, native.systemFont, 51 )
    myText.x = display.contentWidth  ; myText.y = display.contentHeight +5
    print(myText)
    myText:setFillColor( 1, 1, 1 )
    myText.anchorX = 0
end

function scene:show(event)
end

function scene:hide(event)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
