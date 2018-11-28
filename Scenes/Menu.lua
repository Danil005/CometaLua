local composer = require("composer")
local json = require("json")
require("Classes.Comet")
require("Classes.Animations")
local scene = composer.newScene()
local background = nil
local cmt = nil
local backMusic = nil

local options_for_asteroids =
{
    width = 100,
    height = 110,
    numFrames = 12,
    sheetContentWidth = 1200,
    sheetContentHeight = 110
}

local image_sheet_asteroids = graphics.newImageSheet("Sprites/asteroidcr.png",options_for_asteroids)

--Переменные кнопок
function scene:create(event)
    local scene_group = self.view
    if(composer.getScene("Scenes.Settings") ~= nil) then
        composer.removeScene( "Scenes.Settings")
    end

    if (composer.getScene("Scenes.Death_comet") ~= nil) then
        composer.removeScene("Scenes.Death_comet")
    end

    if (composer.getScene("Scenes.Shop") ~= nil) then
        composer.removeScene("Scenes.Shop")
    end

    background = Background:new(scene_group)

    --Установки кнопок на места
    button_settings = display.newImageRect( scene_group,"Sprites/knopka_nastroyki.png", 35,35)
    button_settings.x = 265
    button_settings.y = 30

    button_shop = display.newImageRect(scene_group,"Sprites/shop/shop_icon.png",35,35)
    button_shop.x = 265
    button_shop.y = 85

    button_start = display.newImageRect(scene_group, "Sprites/tap_to_start.png",WIDTH/1.5,HEIGHT/10)
    button_start.x = display.contentCenterX
    button_start.y = display.contentCenterY * 1.8
    -- button_score_mode = display.newImageRect( scene_group,"Sprites/rezhim_vyzhivanie.png", 205,45)
end

local function enterFrame(event)
    local speed_background = 2
    background:move(speed_background)

    if (start_comet and cmt.y < -160) then
        start_comet = false
        composer.gotoScene("Scenes.Game_arkada", "fade")
    elseif (start_comet) then
      cmt:new_y(-3)
    end
end


function scoreModeTouch(event)
  if(event.phase == "began") then
    audio.pause(bgMusicInMenu)
    audio.play( soundOfButton)
    start_comet = true
  end
end

function shopTouch(event)
  if(event.phase == "began") then
    audio.play( soundOfButton)
    composer.gotoScene("Scenes.Shop", "crossFade")
  end
end


function settingsTouch(event)
  if(event.phase == "began") then
    audio.play( soundOfButton)
    composer.gotoScene("Scenes.Settings", "crossFade")
  end
end

function scene:show(event)
  -- is_mute_musics = not result
  -- if(is_mute_musics) then
  --     audio.pause(backMusic)
  -- else
  --     audio.resume(backMusic)
  -- end
  if(event.phase == "did") then
    cmt = comet:new(current_comet_skin, 4, display.contentCenterX+42, display.contentCenterY, 0.1)
    cmt:new_list(120)
    for i = 1, 20 do
      cmt:move()
    end
    cmt:animate("forward")
    cmt.sprite:scale(cmt.scale, cmt.scale)
    button_settings:addEventListener("touch", settingsTouch)
    button_shop:addEventListener("touch", shopTouch)
    background.bg_1:addEventListener("touch", scoreModeTouch)
    background.bg_2:addEventListener("touch", scoreModeTouch)
    Runtime:addEventListener("enterFrame",enterFrame)
    backMusic = audio.loadStream("audio/bgMusicInMenu.mp3")
    audio.play( backMusic)
    audio.fade( { channel=1, time=6680, volume=0.5 } )
  end
end

function scene:hide(event)
  Runtime:removeEventListener("enterFrame",enterFrame)
  button_settings:removeEventListener("touch", settingsTouch)
  button_shop:removeEventListener("touch",shopTouch)
  background.bg_1:removeEventListener("touch", scoreModeTouch)
  background.bg_2:removeEventListener("touch", scoreModeTouch)
  audio.stop(backgroundMusic)

  display.remove(cmt.sprite)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
