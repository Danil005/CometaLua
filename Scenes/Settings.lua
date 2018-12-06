-- Scene Settings
local json = require("json")
local composer = require("composer")
local Menu = require("Scenes.Menu")
local arcade = require("Scenes.Game_arkada")
local scene = composer.newScene()
local background = nil
local image_comet = nil
local soundOfButton = audio.loadSound("audio/buttonsInMenu.mp3")
local button_back = nil
local button_musics_on = nil
local button_musics_off = nil
local button_sounds_on = nil
local button_sounds_off = nil
local is_mute_musics = false
local is_mute_sounds = false
local speed_background = 2
local background = nil

function save_settings()
   local saveGame = {}
     if value then
        saveGame["value"] = value
     end

     local jsonSaveGame = json.encode(saveGame)

     local path = system.pathForFile( "saveSettings.json", system.DocumentsDirectory )
     local file = io.open( path, "w" )
      file:write( jsonSaveGame )
     io.close( file )
    file = nil
end


local function backTouch(event)
    if(event.phase == "began") then
      audio.play(soundOfButton)
      composer.gotoScene("Scenes.Menu")
    end
end

local function mute_musics(event)
    if (event.phase == "began") then
        is_mute_musics = not is_mute_musics
        if(is_mute_musics) then
          button_musics_off.alpha = 1
          button_musics_on.alpha = 0
          audio.pause(bgMusicInMenu)
        else
          button_musics_off.alpha = 0
          button_musics_on.alpha = 1
          audio.resume(bgMusicInMenu)
        end
    end
end

local function mute_sound(event)
    if (event.phase == "began") then
        audio.play(soundOfButton)
        is_mute_sounds = not is_mute_sounds
        if(is_mute_sounds) then
            button_sounds_off.alpha = 1
            button_sounds_on.alpha = 0
            audio.setVolume(0, { soundOfButton = soundOfButton })
        else
            button_sounds_off.alpha = 0
            button_sounds_on.alpha = 1
            audio.setVolume(1, { soundOfButton = soundOfButton })
        end
    end
end

local function enterFrame(event)

    background:move(speed_background)
end
function scene:create(event)
    local scene_group = self.view
    composer.removeScene("Scenes.Menu")

    background = Background:new(scene_group)

    button_back = display.newImageRect( scene_group, "Sprites/knopka_nazad.png", 25,35)
    button_back.x = 25
    button_back.y = 35

    button_musics_on = display.newImageRect( scene_group, "Sprites/knopka_muzyka.png", 60,61)
    button_musics_on.x = display.contentCenterX - 60
    button_musics_on.y = display.contentCenterY

    button_musics_off = display.newImageRect(scene_group,"Sprites/knopka_net_muzyka.png", 60,61)
    button_musics_off.x = display.contentCenterX - 60
    button_musics_off.y = display.contentCenterY
    button_musics_off.alpha = 0

    button_sounds_on = display.newImageRect( scene_group, "Sprites/knopka_zvuk.png", 60,61)
    button_sounds_on.x = display.contentCenterX
    button_sounds_on.y = display.contentCenterY

    button_sounds_off = display.newImageRect( scene_group, "Sprites/knopka_net_zvuka.png", 60,61)
    button_sounds_off.x = display.contentCenterX
    button_sounds_off.y = display.contentCenterY
    button_sounds_off.alpha = 0


    end

function scene:show(event)
    local scene_group = self.view
    if(event.phase == "did") then

      button_back:addEventListener("touch", backTouch)

      button_musics_on:addEventListener("touch", mute_musics)
      button_musics_off:addEventListener("touch",mute_musics)
      button_sounds_on:addEventListener("touch",mute_sound)
      button_sounds_off:addEventListener("touch",mute_sound)

      title_scene = display.newImageRect("Sprites/nastroyki.png", 168,33)
      scene_group:insert(title_scene)
      title_scene.x = display.contentCenterX - 82.5
      title_scene.y = display.contentCenterY - 210
      title_scene:setFillColor( 1, 1, 1 )
      title_scene.anchorX = 0

      Runtime:addEventListener("enterFrame", enterFrame) -- Добавление бесконечного цикла
    end
end


function scene:hide(event)
    -- Saving.is_mute_musics = is_mute_musics
    -- Saving.is_mute_sounds = is_mute_sounds
    -- Saving:toFile()
    Runtime:removeEventListener("enterFrame",enterFrame)
    button_back:removeEventListener("touch", backTouch)
    button_musics_on:removeEventListener("touch", mute_musics)
    button_musics_off:removeEventListener("touch",mute_musics)
    button_sounds_on:removeEventListener("touch",mute_sound)
    button_sounds_off:removeEventListener("touch",mute_sound)

    display.remove(title_scene)
end

function scene:destroy(event)
    Runtime:removeEventListener("enterFrame",enterFrame)
    button_back:removeEventListener("touch", backTouch)
    button_musics_on:removeEventListener("touch", mute_musics)
    button_musics_off:removeEventListener("touch",mute_musics)
    button_sounds_on:removeEventListener("touch",mute_sound)
    button_sounds_off:removeEventListener("touch",mute_sound)

    display.remove(title_scene)
end



scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene
