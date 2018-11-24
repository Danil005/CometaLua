local composer = require("composer")
local gravity = require("Classes.Gravity")
local scene = composer.newScene()

local options =
{
    width = 1666,
    height = 1667,
    numFrames = 4,
    sheetContentWidth = 6667,
    sheetContentHeight = 1667
}


local background = nil
local background2 = nil
local comet = nil
local speed_comet = 2
local is_moved = false
local planet = nil
local list_planets = {}
local image_sheet_planet1 = graphics.newImageSheet( "Sprites/planet_1.png",options)
local image_sheet_planet2 = graphics.newImageSheet("Sprites/planet_2.png",options)
local image_sheet_planet3 = graphics.newImageSheet("Sprites/planet_3.png",options)
local image_sheet_planet4 = graphics.newImageSheet("Sprites/planet_4.png",options)

--[[
local soundOfComet = audio.loadSound("audio/soundOfComet.mp3")
local backgroundMusic = audio.loadStream("audio/backgroundMusic.mp3")
audio.play( backgroundMusic, {channel, loops=-1, fadein=50000 })
audio.fade( { channel=1, time=6680, volume=0.5 } )
function playAudio(event)
  if(event.phase == "ended") then
    audio.setVolume(0)
    --audio.play( soundOfComet )
  end
end
]]
local a = {1,4}

local function generate_planets()
    local scene_group = scene.view
    local count_planets = 1
    local side = math.random(80,120)
    local form = math.random(0,3)
    if (form == 0) then planet= display.newImageRect(image_sheet_planet1,2,side,side)
    elseif (form == 1) then planet = display.newImageRect(image_sheet_planet2,2,side,side)
    elseif (form == 2) then planet = display.newImageRect(image_sheet_planet3,2,side,side)
    else planet = display.newImageRect(scene_group,image_sheet_planet4,2,side,side) end
    planet.x = display.contentCenterX
    planet.y = 0

end

local function generate_planet()

    local radius = math.random(20,60)
    local pos = math.random(-20, 20)
    planet = display.newCircle(display.contentCenterX + pos,0,radius)
    planet:setFillColor(100/255,70/255,255/255)
    gravity_planet = Gravity:new({contentCenterX,0},{{5,4},{10,2}})

end

local function controller(event)
    if (event.phase == "began") then
        is_moved = true
    elseif(event.phase == "ended") then
        is_moved = false
    end
    moved_comet(event.x)

end

--Бесконечный цикл
local function enterFrame(event)
    if (planet.y < HEIGHT) then
        planet.y = planet.y + 2
    else
        display.remove(planet)
        generate_planets()
    end
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

function scene:create(event)
    local scene_group = self.view
    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background2 = display.newImageRect(scene_group,"Sprites/backgroundReverse.png",display.contentWidth,display.contentHeight)
    background2.x = display.contentCenterX
    background2.y = -display.contentCenterY+1
    comet = display.newCircle( scene_group, display.contentCenterX,display.contentCenterY,20 )
    comet.x = display.contentCenterX
    comet.y = display.contentCenterY*1.5
    generate_planets()
end

function scene:show(event)
    if (event.phase == "did") then
        Runtime:addEventListener("enterFrame", enterFrame) -- Добавление бесконечного цикла
      --  background:addEventListener("touch",controller)
      --  background:addEventListener("touch", playAudio)
    end
end

function scene:hide(event)
    Runtime:removeEventListener("enterFrame",enterFrame)
    background:removeEventListener("touch",controller)
  --  background:removeEventListener("touch", soundOfComet)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)


return scene
