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

    element_shop_cometa_default   =  display.newImageRect( scene_group, "Sprites/shop/default.png", display.contentWidth - 200, display.contentHeight - 300)
    element_shop_cometa_default.x = display.contentCenterX
    element_shop_cometa_default.y = display.contentCenterY

    element_shop_cometa_red   =  display.newImageRect( scene_group, "Sprites/shop/red_splash.png", display.contentWidth - 200, display.contentHeight - 300)
    element_shop_cometa_red.x = display.contentCenterX + 999999
    element_shop_cometa_red.y = display.contentCenterY

    element_select_button = display.newImageRect( scene_group, "Sprites/shop/select_button.png", 120, 35)
    element_select_button.x = display.contentCenterX
    element_select_button.y = display.contentHeight / 2 + 150
end

function moving(event)
  if (event.phase == "began") then
    if event.x >= 250 then
      element_shop_cometa_red.x = display.contentCenterX
      element_shop_cometa_red.y = display.contentCenterY

      element_shop_cometa_default.x = 999999
      element_shop_cometa_default.y = 999999
      print("PRESS RIGHT")
    end
    if event.x <= 100 then
      element_shop_cometa_default.x = display.contentCenterX
      element_shop_cometa_default.y = display.contentCenterY

      element_shop_cometa_red.x = 999999
      element_shop_cometa_red.y = 999999
      print("PRESS LEFT")
    end
  end
  if (event.phase =="ended") then

  end
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

      title_scene = display.newImageRect("Sprites/shop/shop_text.png", 168,33)
      scene_group:insert(title_scene)
      title_scene.x = display.contentCenterX - 82.5
      title_scene.y = display.contentCenterY - 210
      title_scene:setFillColor( 1, 1, 1 )
      title_scene.anchorX = 0

      Runtime:addEventListener("enterFrame", enterFrame) -- Добавление бесконечного цикла
      background:addEventListener("touch", moving)
      background2:addEventListener("touch", moving)
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
