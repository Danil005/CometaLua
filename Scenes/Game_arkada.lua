local composer = require("composer")
local gravity = require("Classes.Gravity")
require("Classes.Comet")
require("Classes.Gravity")
require("Classes.Animations")

local scene = composer.newScene()

local options =
{
    width = 1666,
    height = 1667,
    numFrames = 4,
    sheetContentWidth = 6667,
    sheetContentHeight = 1667
}
local list_planets = {}
local image_sheet_planet1 = graphics.newImageSheet( "Sprites/planet_1.png",options)
local image_sheet_planet2 = graphics.newImageSheet("Sprites/planet_2.png",options)
local image_sheet_planet3 = graphics.newImageSheet("Sprites/planet_3.png",options)
local image_sheet_planet4 = graphics.newImageSheet("Sprites/planet_4.png",options)

list_planets[1] = image_sheet_planet1
list_planets[2] = image_sheet_planet2
list_planets[3] = image_sheet_planet3
list_planets[4] = image_sheet_planet4

local move_x = nil
local cof = 4 -- Коофицент для получения кол-во очков
local background = nil
local background2 = nil
local cmt = nil
local speed_comet = 2
local is_moved = false
local planet = nil
local planet_circles = {}
local planet_radius = nil
local speed_planets = 1
local speed_background = 0.5
local speed_asteroids = 2
local planet_gr = nil
local prev_final_move = 0
local asteroid_group = nil
local asteroid_list = nil

--[[
local soundOfComet = audio.loadSound("audio/soundOfComet.mp3")
local backgroundMusic = audio.loadStream("audio/backgroundMusic.mp3")
audio.play( backgroundMusic, {channel, loops=-1, fadein=50000 })
audio.fade( { channel=1, time=6680, volume=0.5 } )
function playAudio(event)
  if(event.phase == "ended") then
  --  audio.setVolume(0)
    --audio.play( soundOfComet )
  end
end
]]
local gravity_planet = nil

local M = {}

M.score = 0  -- Set the score to 0 initially

function M.init( options )

    local customOptions = options or {}
    local opt = {}
    opt.fontSize = customOptions.fontSize or 24
    opt.font = customOptions.font or native.systemFont
    opt.x = customOptions.x or display.contentCenterX
    opt.y = customOptions.y or opt.fontSize*0.5
    opt.maxDigits = customOptions.maxDigits or 6
    opt.leadingZeros = customOptions.leadingZeros or false

    local prefix = ""
    if ( opt.leadingZeros ) then
        prefix = "0"
    end
    M.format = "%" .. prefix .. opt.maxDigits .. "d"

    -- Create the score display object
    M.scoreText = display.newText( string.format( M.format, 0 ), opt.x, opt.y, opt.font, opt.fontSize )

    return M.scoreText
end

function M.set( value )

    M.score = tonumber(value)
    M.scoreText.text = string.format( M.format, M.score )
end

function M.get()

    return M.score
end

function M.add( amount )

    M.score = M.score + tonumber(amount)
    M.scoreText.text = string.format( M.format, M.score )
end

local options_for_asteroids =
{
    width = 100,
    height = 110,
    numFrames = 12,
    sheetContentWidth = 1200,
    sheetContentHeight = 110
}
local image_sheet_asteroids = graphics.newImageSheet("Sprites/asteroidcr.png",options_for_asteroids)

local function generate_asteroids()
    asteroid_group = display.newGroup()
    local count_asteroids = math.random(2,4)
    asteroid_list = {}
    for i = 1, count_asteroids do
        asteroid_list[i] = display.newImageRect(image_sheet_asteroids,2,40,40)
        local temp_x = math.random(10,WIDTH-10)
        local temp_y = math.random(-20,10)
        asteroid_list[i].x = temp_x
        asteroid_list[i].y = temp_y
        asteroid_group:insert(asteroid_list[i])

    end
end


local function generate_planet()
    local scene_group = scene.view
    local count_planets = 1
    local side = math.random(100,160)
    local form = math.random(1,4)

    planet = display.newImageRect(scene_group,list_planets[form],2,side,side)
    planet_circles[1] = display.newImageRect(list_planets[form],3,side*1.3,side*1.3)
    planet_circles[2] = display.newImageRect(list_planets[form],4,side*2,side*2)

    planet_gr = display.newGroup()
    planet_gr:insert(planet_circles[2])
    planet_gr:insert(planet_circles[1])
    planet_gr:insert(planet)
    local temp_x = math.random(10,WIDTH-10)
    planet_gr.x = temp_x
    planet_gr.y = -100
    planet_radius = side / 2

end


local function count_numbers()
    M.add(speed_planets*0.5)
end


local function controller(event)
    if (event.phase == "began" or event.phase == "moved") then
        move_x = event.x
    end
    if (event.phase =="ended") then
        move_x = nil
    end
end

local delta_speed = 0.0005

local function intersect(ast)
    if (ast.x > cmt.sprite.x and ast.x+40 < cmt.sprite.x + 60) then
        if (ast.y +40 > cmt.sprite.y and ast.y < cmt.sprite.y + 60) then
            return true
        end
    end
    return false
end

local function check_with_asteroid()
    for i = 1,#asteroid_list do
        if (intersect(asteroid_list[i])) then
            print(1)
            display.remove(asteroid_list[i])
            table.remove(asteroid_list,i)
        end
    end
end

local is_life = true

--Бесконечный цикл
local function enterFrame(event)

    speed_planets = speed_planets + delta_speed
    speed_background = speed_background  + delta_speed
    local movement = nil
    if (asteroid_group == nil) then
        generate_asteroids()
    else
        asteroid_group.y = asteroid_group.y + speed_asteroids
    end

    if (asteroid_group.y > HEIGHT*1.2) then
        display.remove(asteroid_group)
        asteroid_group = nil
    end

    if (planet == nil) then
        generate_planet()
        gravity_planet = Gravity:new(planet_gr.x,planet_gr.y,{planet_radius*1.3,4},{planet_radius*2.5,1})
    elseif (cmt ~= nil) then
        movement = gravity_planet:gravity_2(cmt.sprite.x,cmt.sprite.y)
        planet_gr.y = planet_gr.y + movement[2] + speed_planets
        gravity_planet.y = gravity_planet.y + speed_planets + movement[2]
    end
    if (planet_gr.y > HEIGHT*1.2) then
        gravity_planet = nil
        display.remove(planet_gr)
        planet = nil
        planet_gr = nil
    end

    local final_move = 0

      if (movement ~= nil) then
          if (gravity_planet:distance(cmt.sprite.x,cmt.sprite.y) < planet_radius) then
              composer.gotoScene("Scenes.Death_comet")
          else
              final_move = cmt:next_position() + movement[1]
          end
      else
          final_move = cmt:next_position()
      end
        if cmt ~= nil and final_move - cmt.sprite.x > 0 then
          if prev_final_move <= 0 then
            cmt:animate("high_right")
          end
        elseif cmt ~= nil and final_move - cmt.sprite.x < 0 then
          if prev_final_move >= 0 then
            cmt:animate("high_left")
          end
        else
          if cmt ~= nil and prev_final_move ~= 0 then
            cmt:animate("forward")
          end
        end

        prev_final_move = final_move - cmt.sprite.x

        cmt.sprite.x = final_move

        if (move_x ~= nil) then
            cmt:new_list(move_x)
        end
        if (cmt.sprite.x < 30) then
            cmt.sprite.x = 30
        elseif (cmt.sprite.x > WIDTH * 0.90) then
            cmt.sprite.x = WIDTH * 0.90
        end
        count_numbers()

    if (background.y <= display.contentCenterY*3-10) then
        background.y = background.y + speed_background
    else
        background.y = -display.contentCenterY
    end

    if (background2.y <= display.contentCenterY*3-10) then
        background2.y = background2.y + speed_background
    else
        background2.y = -display.contentCenterY
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

    M.init({x = display.contentCenterX+90, y = display.contentCenterY/15})
end

function scene:show(event)
    local scene_group = self.view
    if (event.phase == "did") then
        cmt = comet:new(current_comet_skin,2,display.contentCenterX,display.contentCenterY*1.5)
        cmt.sprite:scale(0.5,0.5)

        cmt:new_list(120)
        for i = 1, 20 do
          cmt:move()
        end
        cmt:animate("forward")
        cmt.sprite:scale(cmt.scale, cmt.scale)
        Runtime:addEventListener("enterFrame", enterFrame) -- Добавление бесконечного цикла
        background:addEventListener("touch",controller)
        background2:addEventListener("touch",controller)

      --  background:addEventListener("touch", playAudio)
    end
    table.insert(scene_group,table_after_death)
end

function scene:hide(event)
    Runtime:removeEventListener("enterFrame",enterFrame)
    background:removeEventListener("touch",controller)
    background2:removeEventListener("touch",controller)
    display.remove(cmt.sprite)
    display.remove(planet_gr)
    display.remove(asteroid_group)
  --  background:removeEventListener("touch", soundOfComet)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)


return scene
