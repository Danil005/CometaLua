-- Scene Settings

local composer = require("composer")

local scene = composer.newScene()

local background = nil
local image_comet = nil

local button_back = nil

function backTouch(event)
  if(event.phase == "began") then
    composer.gotoScene("Scenes.menu")
  end
end

function scene:create(event)
    local scene_group = self.view
    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    button_back = display.newImageRect( scene_group, "Sprites/knopka_nazad.png", 25,35)
    button_back.x = display.contentWidth - 270
    button_back.y = display.contentHeight - 450

end

function scene:show(event)
  if(event.phase == "did") then
    button_back:addEventListener("touch", backTouch)
  end
end

function scene:hide(event)
  button_back:removeEventListener("touch", backTouch)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
