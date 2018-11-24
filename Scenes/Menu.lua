local composer = require("composer")
local json = require("json")
require("Classes.Comet")

local scene = composer.newScene()

--Переменные кнопок
local background3 = nil
local background4 = nil
local cmt = nil
local button_settings = nil
local button_arcade = nil
local button_score_mode = nil
local soundOfButton= audio.loadSound("audio/buttonsInMenu.mp3")
bgMusicInMenu = audio.loadSound( "audio/bgMusicInMenu.mp3")
local start_comet = false
local speed_background = 2
audio.play(bgMusicInMenu, {channel, loops=1, fadein=15000})
audio.fade( { channel, time=198, volume=0.5 } )

local function enterFrame(event)
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
        composer.gotoScene("Scenes.loadmainmenu")
    elseif (start_comet) then
        cmt.sprite.y = cmt.sprite.y - 3
    end
end

function scoreModeTouch(event)
  if(event.phase == "began") then
    audio.stop(bgMusicInMenu)
    audio.play( soundOfButton)
    start_comet = true
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
    audio.play( soundOfButton)
    composer.gotoScene("Scenes.Settings")
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
  result = true;
  result = load_settings()
  is_mute_musics = not result
  if(is_mute_musics) then
      audio.pause(bgMusicInMenu)
  else
      audio.resume(bgMusicInMenu)
  end
  if(event.phase == "did") then
    cmt = comet:new("default", 4, display.contentCenterX+42, display.contentCenterY)
    cmt:new_list(120)
    for i = 1, 20 do
      cmt:move()
    end
    cmt:animate("forward")
    button_settings:addEventListener("touch", settingsTouch)
    button_score_mode:addEventListener("touch", scoreModeTouch)
    button_arcade:addEventListener("touch", arcadeTouch)
    Runtime:addEventListener("enterFrame",enterFrame)
  end
end

function load_settings()
      local path = system.pathForFile( "settings.json" )
      local file = io.open( path, "r" )
      if file then
          local saveData = file:read( "*a" )
          --print(saveData)
          io.close( file )
          local jsonRead = json.decode(saveData)
          result = jsonRead.flagAudio
          return result
        end
      return nil
  end

function scene:hide(event)

  button_settings:removeEventListener("touch", settingsTouch)
  button_score_mode:removeEventListener("touch", scoreModeTouch)
  button_arcade:removeEventListener("touch", arcadeTouch)
  display.remove(cmt.sprite)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
