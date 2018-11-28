local composer = require("composer")

local scene = composer.newScene()

local function enterFrame(event)
  background:move(speed_background)
end

local function toMenu(event)
    composer.removeScene("Scenes.Game_arkada")
    composer.removeScene("Scenes.Menu")
    composer.gotoScene("Scenes.Menu")
end

function scene:show(event)
    local scene_group = self.view
    if (event.phase == "will") then
        speed_background = 1
        background = Background:new(scene_group)
        local table_after_death = display.newGroup()
        local back = display.newRoundedRect( table_after_death,display.contentCenterX, display.contentCenterY, WIDTH/1.5, HEIGHT/2,10 )
        back:setFillColor(74/255,117/255,247/255)
        local optionsText =
        {
            text = "Потрачено...\n\nОчки: " .. math.floor(SCORE),
            x = display.contentCenterX,
            y = display.contentCenterY,
            width = 240,
            font = native.systemFont,
            fontSize = 20,
            align = "center"  -- Alignment parameter
        }
        local textResult = display.newText(optionsText)
        textResult:setFillColor(247/255,167/255,74/255)
        table_after_death:insert(textResult)
        scene_group:insert(table_after_death)
        Runtime:addEventListener("enterFrame",enterFrame)
        table_after_death:addEventListener("touch",toMenu)
    end
end

function scene:hide(event)
    if (event.phase == "will") then
        Runtime:removeEventListener("enterFrame",enterFrame)
    end
end

function scene:destroy(event)
    Runtime:removeEventListener("enterFrame",enterFrame)
end

scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene
