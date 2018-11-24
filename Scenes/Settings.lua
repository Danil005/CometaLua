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

function mute_musics(event)
  if(event.phase == "began") then

  end
end

function mute_sounds(event)
  if(event.phase == "began") then
  end
end

function unmute_musics(event)
  if(event.phase == "began") then
  end
end

function unmute_sounds(event)
  if(event.phase == "began") then
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

    button_mute_musics = display.newImageRect( scene_group, "Sprites/knopka_muzyka.png", 60,61)
    button_mute_musics.x = display.contentCenterX - 40
    button_mute_musics.y = display.contentCenterY

    button_mute_sounds = display.newImageRect( scene_group, "Sprites/knopka_zvuk.png", 60,61)
    button_mute_sounds.x = display.contentCenterX + 40
    button_mute_sounds.y = display.contentCenterY
end

function scene:show(event)
  if(event.phase == "did") then
    button_back:addEventListener("touch", backTouch)
    button_mute_musics:addEventListener("touch", mute_musics)
    button_mute_sounds:addEventListener("touch", mute_sounds)

    title_scene = display.newText( "Настройки", 0, 0, native.systemFont, 30 )
    title_scene.x = display.contentCenterX - 70
    title_scene.y = display.contentCenterY - 207
    title_scene:setFillColor( 1, 1, 1 )
    title_scene.anchorX = 0
  end
end

function scene:hide(event)
  button_back:removeEventListener("touch", backTouch)
  button_mute_musics:removeEventListener("touch", mute_musics)
  button_mute_sounds:removeEventListener("touch", mute_sounds)
  display.remove(title_scene)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
