local composer = require("composer")

local scene = composer.newScene()

local json = require("json")
require("Classes.Comet")
require("Classes.Animations")
local background = nil
local cmt = nil
local backMusic = nil
local text_tap_to_start = nil
local button_settings = nil
local button_shop = nil

local back_layer = nil
local front_layer = nil

local options_for_asteroids =
{
    width = 100,
    height = 110,
    numFrames = 12,
    sheetContentWidth = 1200,
    sheetContentHeight = 110
}

local image_sheet_asteroids = graphics.newImageSheet("Sprites/asteroidcr.png",options_for_asteroids)

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

--Переменные кнопок
function scene:create(event)
    local scene_group = self.view

    background = Background:new(scene_group)

    front_layer = display.newGroup()
    back_layer = display.newGroup()

    back_layer:insert(background.bg_1)
    back_layer:insert(background.bg_2)

    --Установки кнопок на места
    button_settings = display.newImageRect(front_layer,"Sprites/knopka_nastroyki.png", WIDTH*0.15,WIDTH*0.15)
    button_settings.x = WIDTH*0.9
    button_settings.y = HEIGHT*0.05

    button_shop = display.newImageRect(front_layer,"Sprites/shop/shop_icon.png",WIDTH*0.15,WIDTH*0.15)
    button_shop.x = WIDTH*0.9
    button_shop.y = HEIGHT*0.15

    -- button_start = display.newImageRect(scene_group, "Sprites/tap_to_start.png",WIDTH/2,HEIGHT/16)
    -- button_start.x = display.contentCenterX
    -- button_start.y = display.contentCenterY * 1.9
    -- button_score_mode = display.newImageRect( scene_group,"Sprites/rezhim_vyzhivanie.png", 205,45)
    text_tap_to_start = display.newText({
        parent = front_layer,
        text = "TAP TO START",
        x = display.contentCenterX,
        y = HEIGHT * 0.95,
        width = WIDTH / 1.5,
        font = native.systemFont,
        fontSize = 24*resize_Font
    })
    scene_group:insert(back_layer)
    scene_group:insert(front_layer)
end

function scene:show(event)
    if (event.phase == "will") then
        if(composer.getScene("Scenes.Settings") ~= nil) then
            composer.removeScene( "Scenes.Settings")
        end
        if (composer.getScene("Scenes.Death_comet") ~= nil) then
            composer.removeScene("Scenes.Death_comet")
        end
        if (composer.getScene("Scenes.Shop") ~= nil) then
            composer.removeScene("Scenes.Shop")
        end
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
    elseif (event.phase == "did") then
        -- is_mute_musics = not result
        -- if(is_mute_musics) then
        --     audio.pause(backMusic)
        -- else
        --     audio.resume(backMusic)
        -- end
        backMusic = audio.loadStream("audio/bgMusicInMenu.mp3")
        audio.play( backMusic)
        audio.fade( { channel=1, time=6680, volume=0.5 } )
    end
end

function scene:hide(event)
    if (event.phase == "will") then
        Runtime:removeEventListener("enterFrame",enterFrame)
        button_settings:removeEventListener("touch", settingsTouch)
        button_shop:removeEventListener("touch",shopTouch)
        background.bg_1:removeEventListener("touch", scoreModeTouch)
        background.bg_2:removeEventListener("touch", scoreModeTouch)
    elseif(event.phase == "did") then
        audio.stop(backgroundMusic)
        display.remove(cmt.sprite)
    end
end

function scene:destroy(event)
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
scene:addEventListener("destroy",scene)

return scene
