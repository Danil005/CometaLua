local composer = require("composer")
local json = require("json")
require("Classes.Comet")
require("Classes.Save")

local scene = composer.newScene()


--Переменные кнопок
function scene:create(event)
    local scene_group = self.view



local function enterFrame(event)
    local speed_background = 2
    if (background3.y <= display.contentCenterY*3-10) then
        background3.y = background3.y + speed_background
    else
        background3.y = -display.contentCenterY
    end
    if (background4.y <= display.contentCenterY*3-10) then
        background4.y = background4.y + speed_background
    else
        background4.y = -display.contentCenterY
    end

    if (start_comet and cmt.sprite.y < -70) then
        start_comet = false
        composer.gotoScene("Scenes.Game_arkada", "fade")
    elseif (start_comet) then
        cmt.sprite.y = cmt.sprite.y - 3
    end
end

function scoreModeTouch(event)
  if(event.phase == "began") then
    audio.pause(bgMusicInMenu)
    audio.play( soundOfButton)
    start_comet = true
  end
end


function settingsTouch(event)
  if(event.phase == "began") then
    audio.play( soundOfButton)
    composer.gotoScene("Scenes.Settings", "crossFade")
  end
end


function scene:create(event)
    local scene_group = self.view

    background3 = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background3.x = display.contentCenterX
    background3.y = display.contentCenterY
    background4 = display.newImageRect(scene_group,"Sprites/backgroundReverse.png",display.contentWidth,display.contentHeight)
    background4.x = display.contentCenterX
    background4.y = -display.contentCenterY+1

    --Установки кнопок на места
    button_settings = display.newImageRect( scene_group,"Sprites/knopka_nastroyki.png", 35,35)
    button_settings.x = 265
    button_settings.y = 30
    button_score_mode = display.newImageRect( scene_group,"Sprites/rezhim_vyzhivanie.png", 205,45)
    button_score_mode.x = display.contentCenterX
    button_score_mode.y = display.contentCenterY*1.7


    print(Save:getFile("database/test.json").admin)
end

function scene:show(event)
  if(event.phase == "did") then
    cmt = comet:new(current_comet_skin, 4, display.contentCenterX+42, display.contentCenterY)
    cmt:new_list(120)
    for i = 1, 20 do
      cmt:move()
    end

    cmt:animate("forward")
    cmt.sprite:scale(cmt.scale, cmt.scale)
    button_settings:addEventListener("touch", settingsTouch)
    background3:addEventListener("touch", scoreModeTouch)
    background4:addEventListener("touch", scoreModeTouch)
    Runtime:addEventListener("enterFrame",enterFrame)
  end
end

function scene:hide(event)

  button_settings:removeEventListener("touch", settingsTouch)
  background3:removeEventListener("touch", scoreModeTouch)
  background4:addEventListener("touch", scoreModeTouch)
  display.remove(cmt.sprite)
end

function scene:createScene( event )

end

function scene:enterScene( event )

end

function scene:exitScene( event )

end

function scene:destroyScene( event )

end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
