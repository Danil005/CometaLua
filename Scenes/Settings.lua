-- Scene Settings

local composer = require("composer")
local Menu = require("Scenes.Menu")
local scene = composer.newScene()

local background = nil
local image_comet = nil
local soundOfButton = audio.loadSound("audio/buttonsInMenu.wav")
local button_back = nil
local button_musics_on = nil
local button_musics_off = nil
local button_sounds_on = nil
local button_sounds_off = nil

local is_mute_musics = false
local is_mute_sounds = false

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
        is_mute_sounds = not is_mute_sounds
        if(is_mute_sounds) then
            button_sounds_off.alpha = 1
            button_sounds_on.alpha = 0
        else
            button_sounds_off.alpha = 0
            button_sounds_on.alpha = 1
        end
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

    button_musics_on = display.newImageRect( scene_group, "Sprites/knopka_muzyka.png", 60,61)
    button_musics_on.x = display.contentCenterX - 40
    button_musics_on.y = display.contentCenterY

    button_musics_off = display.newImageRect(scene_group,"Sprites/knopka_net_muzyka.png", 60,61)
    button_musics_off.x = display.contentCenterX - 40
    button_musics_off.y = display.contentCenterY
    button_musics_off.alpha = 0

    button_sounds_on = display.newImageRect( scene_group, "Sprites/knopka_zvuk.png", 60,61)
    button_sounds_on.x = display.contentCenterX + 40
    button_sounds_on.y = display.contentCenterY

    button_sounds_off = display.newImageRect( scene_group, "Sprites/knopka_net_zvuka.png", 60,61)
    button_sounds_off.x = display.contentCenterX + 40
    button_sounds_off.y = display.contentCenterY
    button_sounds_off.alpha = 0

end

function scene:show(event)
    local scene_group = self.view
    settings = loadSettings("settings.json")
    is_mute_musics = settings.flagAudio

    if(event.phase == "did") then
      button_back:addEventListener("touch", backTouch)

      button_musics_on:addEventListener("touch", mute_musics)
      button_musics_off:addEventListener("touch",mute_musics)

      button_sounds_on:addEventListener("touch",mute_sound)
      button_sounds_off:addEventListener("touch",mute_sound)

      title_scene = display.newText( "Настройки", 0, 0, native.systemFont, 30 )
      scene_group:insert(title_scene)
      title_scene.x = display.contentCenterX - 70
      title_scene.y = display.contentCenterY - 207
      title_scene:setFillColor( 1, 1, 1 )
      title_scene.anchorX = 0
    end
end

function scene:hide(event)
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

return scene
