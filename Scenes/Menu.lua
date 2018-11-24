local composer = require("composer")

local scene = composer.newScene()

--Переменные кнопок
local background = nil
local image_comet = nil
local button_back = nil
local button_settings = nil
local button_arcade = nil
local button_score_mode = nil

function scoreModeTouch(event)
  if(event.phase == "began") then
    composer.gotoScene("Scenes.Game_arkada")
  end
end

function settingsTouch(event)
  if(event.phase == "began") then
    composer.gotoScene("Scenes.Settings")
  end
end

function scene:create(event)
    local scene_group = self.view

    --Установки кнопок на места
    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    button_back = display.newImageRect( scene_group, "Sprites/knopka_nazad.png", 24,35)
    button_back.x = 50
    button_back.y = 30
    button_settings = display.newImageRect( scene_group,"Sprites/knopka_nastroyki.png", 35,35)
    button_settings.x = 265
    button_settings.y = 30
    button_score_mode = display.newImageRect( scene_group,"Sprites/rezhim_na_ochki.png", 205,45)
    button_score_mode.x = display.contentCenterX
    button_score_mode.y = display.contentCenterY*1.5
    button_arcade = display.newImageRect( scene_group,"Sprites/rezhim_arkada.png", 205,45)
    button_arcade.x = display.contentCenterX
    button_arcade.y = display.contentCenterY*1.74
    --image_comet = display.newImageRect( scene_group,"Sprites/sprite_comet.tif",40,100)
    --image_comet.x = display.contentCenterX
    --image_comet.y = display.contentCenterY * 1.5

end



function scene:show(event)
  if(event.phase == "did") then
    button_settings:addEventListener("touch", settingsTouch)
    button_score_mode:addEventListener("touch", scoreModeTouch)
  end
end

function scene:hide(event)
  button_settings:removeEventListener("touch", settingsTouch)
  button_score_mode:removeEventListener("touch", scoreModeTouch)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
