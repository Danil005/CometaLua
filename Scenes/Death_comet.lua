local composer = require("composer")

local scene = composer.newScene()

local function enterFrame(event)
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

local function toMenu(event)
    composer.removeScene( "Scenes.Game_arkada")
    composer.gotoScene("Scenes.Menu")
end

function scene:show(event)
    print(SCORE)
    local scene_group = self.view
    speed_background = 2
    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background2 = display.newImageRect(scene_group,"Sprites/backgroundReverse.png",display.contentWidth,display.contentHeight)
    background2.x = display.contentCenterX
    background2.y = -display.contentCenterY+1
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

function scene:hide(event)
    Runtime:removeEventListener("enterFrame",enterFrame)
end

scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
