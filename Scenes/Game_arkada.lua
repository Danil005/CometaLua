local composer = require("composer")
require("Classes.Comet")
require("Classes.Gravity")
require("Classes.Animations")

local scene = composer.newScene()

--Создание списка графических листов для отрисовки планет-----------------------
local options =
{
    width = 1666,
    height = 1667,
    numFrames = 4,
    sheetContentWidth = 6667,
    sheetContentHeight = 1667
}
local list_planets = {}
local image_sheet_planet1 = graphics.newImageSheet("Sprites/planet_1.png",options)
local image_sheet_planet2 = graphics.newImageSheet("Sprites/planet_2.png",options)
local image_sheet_planet3 = graphics.newImageSheet("Sprites/planet_3.png",options)
local image_sheet_planet4 = graphics.newImageSheet("Sprites/planet_4.png",options)
list_planets[1] = image_sheet_planet1
list_planets[2] = image_sheet_planet2
list_planets[3] = image_sheet_planet3
list_planets[4] = image_sheet_planet4
--------------------------------------------------------------------------------

--Объявление переменных сцены---------------------------------------------------
local move_x = nil -- Переменная хранит координату X положения пальца на экране
local background = nil -- Задний фон
local cmt = nil -- Объект кометы
local speed_comet = 2 -- Скорость кометы
local is_moved = false -- Происходит ли движение кометы
local planet = nil -- Объект планеты
local planet_circles = {} -- Список гравитационных полей планеты
local planet_radius = nil -- Радиус планеты
local speed_planets = 1 -- Скорость планеты
local speed_background = 0.5 -- Скорость заднего фона
local speed_asteroids = 2 -- Скорость астероидов
local planet_gr = nil -- Группа для планеты и ее полей
local prev_final_move -- Для расчета движения кометы
local asteroid_list = nil -- Список астероидов на сцене
local button_start = nil -- Кнопка старта
local text_score = nil -- Текст очков
local gravity_planet = nil -- Объект гравитации планеты
local is_life = true -- Жива ли комета

SCORE = 0 -- Обнуляем глобальную переменную
--------------------------------------------------------------------------------

--Загрузка и включение музыки---------------------------------------------------
local soundOfComet = audio.loadSound("audio/soundOfComet.mp3")
local backgroundMusic = audio.loadStream("audio/backgroundMusic.mp3")
audio.play( backgroundMusic, {channel, loops=-1, fadein=50000 })
audio.fade( { channel=1, time=6680, volume=0.5 } )
function playAudio(event)
  if(event.phase == "ended") then
    audio.setVolume(0)
    audio.play( soundOfComet )
  end
end
--------------------------------------------------------------------------------

--Загрузка графического листа для анимации астероидов и функция их создания-----
local options_for_asteroids =
{
    width = 100,
    height = 110,
    numFrames = 1,
    sheetContentWidth = 1200,
    sheetContentHeight = 110
}

local image_sheet_asteroids = graphics.newImageSheet("Sprites/asteroidcr.png",options_for_asteroids)

local function generate_asteroids()
    local count_asteroids = math.random(2,4)
    asteroid_list = {}
    for i = 1, count_asteroids do
        asteroid_list[i] = display.newImageRect(scene.view,image_sheet_asteroids,1,40,40)
        local temp_x = math.random(10,WIDTH-10)
        local temp_y = math.random(-20,10)
        asteroid_list[i].x = temp_x
        asteroid_list[i].y = temp_y
    end
end
--------------------------------------------------------------------------------

--Создание планеты--------------------------------------------------------------
local function generate_planet()
    local scene_group = scene.view
    local count_planets = 1
    local side = math.random(100,160)
    local form = math.random(1,4)

    planet = display.newImageRect(scene_group,list_planets[form],2,side,side)
    planet_circles[1] = display.newImageRect(list_planets[form],3,side*1.4,side*1.4)
    planet_circles[2] = display.newImageRect(list_planets[form],4,side*2,side*2)

    planet_gr = display.newGroup()
    planet_gr:insert(planet_circles[2])
    planet_gr:insert(planet_circles[1])
    planet_gr:insert(planet)
    scene_group:insert(planet_gr)
    local temp_x = math.random(10,WIDTH-10)
    planet_gr.x = temp_x
    planet_gr.y = -100
    planet_radius = side / 2

end
--------------------------------------------------------------------------------

--Прослушивает нажатия по экрану и задает текущую координату по X---------------
local function controller(event)
    if (event.phase == "began" or event.phase == "moved") then
        move_x = event.x
    end
    if (event.phase =="ended") then
        move_x = nil
    end
end
--------------------------------------------------------------------------------

--Нахождение дистанции между двумя точками--------------------------------------
local function distance(ax, ay, bx, by)
  return math.sqrt((ax - bx)*(ax - bx) + (ay - by)*(ay - by))
end
--------------------------------------------------------------------------------

--Функция проверки на столкновение кометы с астероидом--------------------------
local function intersect(asteroid, comet)
  --local asteroid_radius = 20
  return (distance(asteroid.x, asteroid.y, comet.x, comet.y) <= comet.radius and asteroid.y <= comet.y)
end
--------------------------------------------------------------------------------

--Бесконечный цикл
local function enterFrame(event)
    SCORE = SCORE + 1 --Каждый кадр добавляем +1 к очкам
    text_score.text = SCORE -- Выводим каждый кадр текст с очками
    speed_planets = SCORE / 4000 -- В зависимости от очков увеличивается скорость планеты
    speed_background = SCORE / 4000 -- Также с задним фоном
    local movement = nil -- Локальная переменная для расчета передвижения кометы под действием гравитации
    if (asteroid_list == nil) then -- Если на экране нет астероидов,то создаем
        generate_asteroids()
    else
        local is_exit = false -- Отслеживаем выход астероидов за пределы экрана
        for i = 1,#asteroid_list do
            if (asteroid_list[i].animation ~= nil) then
                asteroid_list[i].animation:move(0, speed_asteroids)
            end
            asteroid_list[i].y = asteroid_list[i].y + speed_asteroids
            if (asteroid_list[i].y > HEIGHT *1.2) then
                display.remove(asteroid_list[i])
                is_exit = true
            elseif (intersect(asteroid_list[i], cmt) and asteroid_list[i].in_animation ~= 1) then
                SCORE = SCORE + math.floor(30 * speed_background)
                asteroid_list[i].in_animation = 1
                asteroid_list[i].alpha = 0
                asteroid_list[i].animation = Asteroid:new(asteroid_list[i].x,asteroid_list[i].y)
                asteroid_list[i].animation.sprite:scale(0.5,0.5,0.5)
                asteroid_list[i].animation:animate("destroy")
            end
        end
        if (is_exit) then
            asteroid_list = nil
        end
    end

    if (planet == nil) then
        generate_planet()
        gravity_planet = Gravity:new(planet_gr.x,planet_gr.y,{planet_radius*1.4,3},{planet_radius*2.2,1.6})
    elseif (cmt ~= nil) then
        movement = gravity_planet:gravity_2(cmt.x,cmt.y)
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
        if (gravity_planet ~= nil and gravity_planet:distance(cmt.x, cmt.y) <= planet_radius - 10) then
            for i = 1,#asteroid_list do
                display.remove(asteroid_list[i])
            end
            composer.gotoScene("Scenes.Death_comet")
        else
            final_move = cmt:next_position() + movement[1]
            if (movement[1] > 0 or movement[2] > 0) then
                SCORE = SCORE + math.floor(speed_background * 2)
            end
        end
    else
        final_move = cmt:next_position()
    end
    if ((final_move == nil and prev_final_move ~= nil) or (final_move ~= nil and prev_final_move == nil)) then
        if (cmt ~= nil and final_move - cmt.x > 0) then
            if prev_final_move < 0 then
                cmt:animate("high_right")
            end
        elseif (cmt ~= nil and final_move - cmt.x < 0) then
            if (prev_final_move >= 0) then
                cmt:animate("high_left")
            end
        else
            if (cmt ~= nil and prev_final_move ~= 0) then
                cmt:animate("forward")
            end
        end
    end

    prev_final_move = final_move - cmt.x

    cmt:new_x(final_move - cmt.x)

    if (move_x ~= nil) then
        cmt:new_list(move_x)
    end
    if (cmt.x < 30) then
        cmt:new_x(30 - cmt.x)
    elseif (cmt.x > WIDTH * 0.90) then
        cmt:new_x(WIDTH * 0.90 - cmt.x)
    end

    background:move(speed_background * 3)
end

function scene:create(event)
    local scene_group = self.view
    background = Background:new(scene_group)

    local optionsText =
    {
        text = math.floor(SCORE),
        x = 150,
        y = 10,
        width = 240,
        font = native.systemFont,
        fontSize = 24*resize_Font,
    }
    text_score = display.newText(optionsText)
    scene_group:insert(5, text_score)
end

function scene:show(event)
    local scene_group = self.view
    if (event.phase == "will") then
        cmt = comet:new(current_comet_skin, 2, display.contentCenterX, display.contentCenterY*1.5, 0.075)
        cmt:animate("forward")
        cmt.sprite:scale(cmt.scale, cmt.scale)
        Runtime:addEventListener("enterFrame", enterFrame) -- Добавление бесконечного цикла
        background.bg_1:addEventListener("touch",controller)
        background.bg_2:addEventListener("touch",controller)

        --background:addEventListener("touch", playAudio)
    elseif (event.phase == "did") then
        table.insert(scene_group, 6, table_after_death)
    end
end

function scene:hide(event)
    if (event.phase == "will") then
        Runtime:removeEventListener("enterFrame",enterFrame)
        background.bg_1:removeEventListener("touch",controller)
        background.bg_2:removeEventListener("touch",controller)
    elseif (event.phase == "did") then
        display.remove(cmt.sprite)
        display.remove(planet_gr)
        if (backgroundMusic ~= nil) then
            audio.stop(backgroundMusic)
        end
    end
    --background:removeEventListener("touch", soundOfComet)
end

function scene:destroy(event)
    Runtime:removeEventListener("enterFrame",enterFrame)
    background.bg_1:removeEventListener("touch",controller)
    background.bg_2:removeEventListener("touch",controller)
    display.remove(cmt.sprite)
    display.remove(planet_gr)
    if (backgroundMusic ~= nil) then
        audio.stop(backgroundMusic)
    end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)


return scene
