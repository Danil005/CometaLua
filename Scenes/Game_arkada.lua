local composer = require("composer")
local scene = composer.newScene()

local background = nil
local comet = nil
local speed_comet = 2
local is_moved = false
local planet = nil

local function moved_comet(x)
    if (x > comet.x and is_moved) then
        comet.x = comet.x + speed_comet
    elseif (is_moved and x < comet.x) then
        comet.x = comet.x - speed_comet
    end
    if (comet.x < 50) then
        comet.x = 50
    end
    if (comet.x > WIDTH*0.9) then
        comet.x = WIDTH*0.9
    end
end

local function generate_planet()
    
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

end

function scene:create(event)
    local scene_group = self.view
    background = display.newImageRect(scene_group,"Sprites/background.png",WIDTH,HEIGHT)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    comet = display.newCircle( scene_group, display.contentCenterX,display.contentCenterY,20 )
    comet.x = display.contentCenterX
    comet.y = display.contentCenterY*1.5

end

function scene:show(event)
    if (event.phase == "did") then
        Runtime:addEventListener("enterFrame", enterFrame) -- Добавление бесконечного цикла
        background:addEventListener("touch",controller)
    end
end

function scene:hide(event)
    Runtime:removeEventListener("enterFrame",enterFrame)
    background:removeEventListener("touch",controller)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)


return scene
