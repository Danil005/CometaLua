local composer = require("composer")
require("Classes.Comet")

local scene = composer.newScene()

--Переменные кнопок
local background = nil
local background2 = nil
local cmt = nil
local button_settings = nil
local button_arcade = nil
local button_score_mode = nil
--[[
local soundOfButton= audio.loadSound("audio/buttonsInMenu.wav")
bgMusicInMenu = audio.loadSound( "audio/bgMusicInMenu.wav")
audio.play(bgMusicInMenu, {channel, loops=1, fadein=15000})
audio.fade( { channel, time=198, volume=0.5 } )
]]

local function enterFrame(event)
    if (background.y < HEIGHT*1.5) then
        background.y = background.y +0.5
    else
        background.y = display.contentCenterY
    end
    if (background2.y < display.contentCenterY) then
        background2.y = background2.y + 0.5
    else
        background2.y = -display.contentCenterY+1
    end
end

function scoreModeTouch(event)
  if(event.phase == "began") then
    audio.stop()
    audio.play( soundOfButton)
    composer.gotoScene("Scenes.Game_arkada")
  end
end

function arcadeTouch(event)
  if(event.phase == "began") then
    audio.stop(bgMusicInMenu)
    audio.play(soundOfButton)
    print("touch")
  end
end

function settingsTouch(event)
  if(event.phase == "began") then
  --  audio.play( soundOfButton)
    composer.gotoScene("Scenes.Settings")
  end
end

function scene:create(event)
    local scene_group = self.view
    cmt = comet:new("noname", 4, display.contentCenterX+50, display.contentCenterY)

    cmt:new_list(120)
    for i = 1, 20 do
      cmt:move()
    end
    cmt:animate("forward")

    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background2 = display.newImageRect(scene_group,"Sprites/backgroundReverse.png",display.contentWidth,display.contentHeight)
    background2.x = display.contentCenterX
    background2.y = -display.contentCenterY+1

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
    button_arcade:addEventListener("touch", arcadeTouch)
    Runtime:addEventListener("enterFrame",enterFrame)
  end
end

function scene:hide(event)
  button_settings:removeEventListener("touch", settingsTouch)
  button_score_mode:removeEventListener("touch", scoreModeTouch)
  button_arcade:removeEventListener("touch", arcadeTouch)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
