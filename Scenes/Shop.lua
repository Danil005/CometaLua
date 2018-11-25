-- Scene Settings
local json = require("json")
local composer = require("composer")
local Menu = require("Scenes.Menu")
local arcade = require("Scenes.Game_arkada")
local widget = require( "widget" )

local scene = composer.newScene()
local soundOfButton = audio.loadSound("audio/buttonsInMenu.mp3")
local button_back = nil
local speed_background = 2
local background = nil
local background2 = nil


local function backTouch(event)
    if(event.phase == "began") then
      audio.play(soundOfButton)
      composer.gotoScene("Scenes.Menu")
    end
end

local function scrollListener( event )

    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end

    return true
end

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
function scene:create(event)
    local scene_group = self.view

    background = display.newImageRect( scene_group, "Sprites/background.png",display.contentWidth,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background2 = display.newImageRect(scene_group,"Sprites/backgroundReverse.png",display.contentWidth,display.contentHeight)
    background2.x = display.contentCenterX
    background2.y = -display.contentCenterY+1

    button_back = display.newImageRect( scene_group, "Sprites/knopka_nazad.png", 25,35)
    button_back.x = display.contentWidth - 270
    button_back.y = display.contentHeight - 450

    element_shop_cometa_antired =  display.newImageRect( scene_group, "Sprites/shop/skin_default_icon.png", 50, 50)
    element_shop_cometa_antired.x = display.contentCenterX - 90
    element_shop_cometa_antired.y = display.contentCenterY - 120

    local element_shop_cometa_default_text = display.newText(scene_group, "Default", display.contentWidth, display.contentHeight, 200, 100, native.systemFont, 16 )
    element_shop_cometa_default_text.x = display.contentCenterX +48
    element_shop_cometa_default_text.y = display.contentCenterY - 81
    element_shop_cometa_default_text:setFillColor( 255, 255, 255 )

    local element_shop_cometa_default_text_buy = display.newText(scene_group, "Выбрана", display.contentWidth, display.contentHeight, 200, 100, native.systemFont, 16 )
    element_shop_cometa_default_text_buy.x = display.contentWidth + 5
    element_shop_cometa_default_text_buy.y = display.contentCenterY - 81
    element_shop_cometa_default_text_buy:setFillColor( 255, 255, 255 )


    element_shop_cometa_antired =  display.newImageRect( scene_group, "Sprites/shop/skin_anti_red_icon.png", 50, 50)
    element_shop_cometa_antired.x = display.contentCenterX - 90
    element_shop_cometa_antired.y = display.contentCenterY - 60

    local element_shop_cometa_antired_text = display.newText(scene_group, "RedSplash", display.contentWidth, display.contentHeight, 200, 100, native.systemFont, 16 )
    element_shop_cometa_antired_text.x = display.contentCenterX +48
    element_shop_cometa_antired_text.y = display.contentCenterY - 20
    element_shop_cometa_antired_text:setFillColor( 255, 255, 255 )

    local element_shop_cometa_antired_text_buy = display.newText(scene_group, "Выбрать", display.contentWidth, display.contentHeight, 200, 100, native.systemFont, 16 )
    element_shop_cometa_antired_text_buy.x = display.contentWidth + 5
    element_shop_cometa_antired_text_buy.y = display.contentCenterY - 20
    element_shop_cometa_antired_text_buy:setFillColor( 255, 255, 255 )

    local element_shop_cometa_antired_text_price = display.newText(scene_group, "2000₽", display.contentWidth, display.contentHeight, 200, 100, native.systemFont, 12 )
    element_shop_cometa_antired_text_price.x = display.contentWidth + 5
    element_shop_cometa_antired_text_price.y = display.contentCenterY - 5
    element_shop_cometa_antired_text_price:setFillColor( 255, 255, 255 )
    -- element_shop_cometa_antired = display.newCircle( display.contentWidth, display.contentHeight, 10)

end

function scene:show(event)
    local scene_group = self.view
    if(event.phase == "did") then

      button_back:addEventListener("touch", backTouch)

      -- local scrollView = widget.newScrollView(
      --     {
      --         top = 100,
      --         left = 10,
      --         width = WIDTH,
      --         height = HEIGHT,
      --         scrollWidth = 600,
      --         scrollHeight = 800,
      --         listener = scrollListener
      --     }
      -- )

      -- scrollView:insert()

      title_scene = display.newImageRect("Sprites/nastroyki.png", 168,33)
      scene_group:insert(title_scene)
      title_scene.x = display.contentCenterX - 82.5
      title_scene.y = display.contentCenterY - 210
      title_scene:setFillColor( 1, 1, 1 )
      title_scene.anchorX = 0

      Runtime:addEventListener("enterFrame", enterFrame) -- Добавление бесконечного цикла
    end
end


function scene:hide(event)
    Runtime:removeEventListener("enterFrame",enterFrame)
    button_back:removeEventListener("touch", backTouch)
    display.remove(title_scene)
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene
