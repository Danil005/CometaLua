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
        back:setFillColor(0/255,0/255,0/255)
        back.alpha = 0.7
        local optionsText =
        {
            text = "wasted",
            x = display.contentCenterX,
            y = display.contentCenterY - 80,
            width = 240,
            font = native.systemFont,
            fontSize = 35,
            align = "center"  -- Alignment parameter
        }
        local optionsText2 =
        {
          text = "\n\nscore: " .. math.floor(SCORE),
          x = display.contentCenterX,
          y = display.contentCenterY,
          width = 240,
          font = native.systemFont,
          fontSize = 20,
          align = "center"  -- Alignment parameter
        }
        local textResult = display.newText(optionsText)
        local textResult2 = display.newText(optionsText2)
        textResult:setFillColor(231/255,56/255,69/255)
        textResult2:setFillColor(255/255,255/255,255/255)
        table_after_death:insert(textResult)
        table_after_death:insert(textResult2)
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
