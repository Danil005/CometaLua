local composer = require("composer")
local widget  = require ("widget")
require("Classes.Player")
local jost = require("Classes.Joyst")
require("Classes.Map")
system.activate("multitouch")
local player = nil
local joystick_ = nil
local world = nil
local refreshButt = nil
local background = nil
local buttMenu = nil
local buttBild = nil
local isBild = false
local menuGroup = display.newGroup()

local scene = composer.newScene()

local function updatePlayer()
    world:collisionPlayerWithObject(player)
    player:moved(world.mapGroup)
end

local function touchControl (event)
    local angle = joystick_:getAngle()

    if (angle >= 337.5 and 360 - angle < 22.5) then
        player:resetDirections()
        player.direction.right = true
    end
    if (angle >= 22.5 and angle < 67.5) then
        player:resetDirections()
        player.direction.up = true; player.direction.right = true
    end
    if (angle >= 67.5 and angle < 112.5) then
        player:resetDirections()
        player.direction.up = true;
    end
    if (angle >=112.5 and angle < 157.5) then
        player:resetDirections()
        player.direction.up = true; player.direction.left = true;
     end
    if (angle >= 157.5  and angle < 202.5) then
        player:resetDirections()
        player.direction.left = true;
    end
    if (angle >= 202.5 and angle < 247.5) then
        player:resetDirections()
        player.direction.left = true; player.direction.down = true;
    end
    if (angle >= 247.5 and angle < 292.5) then
        player:resetDirections()
        player.direction.down = true;
    end
    if (angle >= 292.5 and angle < 337.5) then
        player:resetDirections()
        player.direction.down = true; player.direction.right = true;
    end

    if (event.phase == "ended") then
        player:resetDirections()
    end
end


local function create_menu()
    local backMenu = display.newRoundedRect( menuGroup, display.contentCenterX,display.contentCenterY,display.contentWidth/2, display.contentHeight*0.9, 10 )
    backMenu:setFillColor(248/255,225/255,225/255)
    local buttContinue = widget.newButton( {
        shape = "roundedRect",
        width = display.contentWidth / 4,
        height = display.contentHeight / 6,
        cornerRadius = 10,
        fillColor = { default={ 228/255,205/255,199/255 }, over={ 228/255,225/255,199/255 } },
        labelColor = { default={ 0,0,0 }, over={ 0, 0, 0, 0.5 } },
        top = 0,
        left = -25,
        label = "Продолжить",
        font = "azerot",
        fontSize = 16,
        onPress = function(event)
            menuGroup.alpha = 0
            player.sprite.x = player.sprite.x + 1000
            joystick_.alpha = 1
        end
    } )
    local buttEnd = widget.newButton( {
        shape = "roundedRect",
        width = display.contentWidth / 4,
        height = display.contentHeight / 6,
        cornerRadius = 10,
        fillColor = { default={ 228/255,205/255,199/255 }, over={ 228/255,225/255,199/255 } },
        labelColor = { default={ 0,0,0 }, over={ 0, 0, 0, 0.5 } },
        top = 0,
        left = -25,
        label = "Выход",
        labelYOffset = 8,
        font = "azerot",
        fontSize = 32,
        onPress = function(event)
            menuGroup.alpha = 0
            player.sprite.x = player.sprite.x + 1000
            joystick_.alpha = 1
          --  scene:destroy()
            composer.gotoScene( "Scenes.menu" )
        end
    } )
    menuGroup:insert(buttContinue)
    menuGroup:insert(buttEnd)
    buttContinue.x = display.contentCenterX; buttContinue.y = display.contentCenterY-50
    buttEnd.x = display.contentCenterX; buttEnd.y = display.contentCenterY+50
    menuGroup.alpha = 0
end

local function show_menu()
    menuGroup.alpha = 1
    player.sprite.x = player.sprite.x - 1000
    joystick_.alpha = 0
end

local function touchOnBild(event)
    if (isBild) then isBild = false
    else isBild = true; end
    if (event.phase == "began") then buttBild.alpha = 0.5; end

end

local function create_scene(sceneGroup)
    background = display.newImageRect( sceneGroup,"Sprites/Landscape/background.png",display.contentWidth+500,display.contentHeight+500 )
    background.x = display.contentCenterX
    background.y= display.contentCenterY
    joystick_ = jost.new(display.contentWidth / 16,display.contentWidth / 8)

    joystick_.x = 50
    joystick_.y = display.contentHeight - joystick_.height / 2
    joystick_:activate()

    world = Map:new(50,50)

    world:createLandscape(spawn)
    sceneGroup:insert(world.mapGroup)
    world.mapGroup.x = -world.coordsSpawn[1]*32+10
    world.mapGroup.y = -world.coordsSpawn[2]*32+10
    player = Player:new(display.contentCenterX,display.contentCenterY)


    sceneGroup:insert(player.sprite)
    refreshButt = widget.newButton(
      {
          shape = "roundedRect",
          width = display.contentWidth / 4,
          height = display.contentHeight / 6,
          cornerRadius = 10,
          fillColor = { default={ 228/255,205/255,199/255 }, over={ 228/255,225/255,199/255 } },
          labelColor = { default={ 0,0,0 }, over={ 0, 0, 0, 0.5 } },
          top = 0,
          left = display.contentWidth - display.contentWidth/6,
          label = "Пересоздать",
          font = "azerot",
          onPress = function(event)
              scene:refresh()
              --composer.gotoScene( "Scenes.menu" )
          end
      }  )
    sceneGroup:insert(refreshButt)
    sceneGroup:insert(joystick_)
    create_menu()
    buttMenu = widget.newButton(
    {
        shape = "roundedRect",
        width = display.contentWidth / 6,
        height = display.contentHeight / 6,
        cornerRadius = 10,
        fillColor = { default={ 228/255,205/255,199/255 }, over={ 228/255,225/255,199/255 } },
        labelColor = { default={ 0,0,0 }, over={ 0, 0, 0, 0.5 } },
        top = 0,
        left = -25,
        label = "Меню",
        font = "azerot",

        onPress = function(event)
            show_menu()
        end
    } )
    buttBild = display.newImageRect( sceneGroup,"Sprites/buttBild.png",display.contentWidth/6,display.contentHeight/4)
    buttBild.x = display.contentWidth*0.95
    buttBild.y = display.contentHeight*0.8
    sceneGroup:insert(buttMenu)
    sceneGroup:insert(menuGroup)
end
function scene:create(event)
    local sceneGroup = self.view
    display.setDefault( "background", 1/102,1,1 )
    create_scene(sceneGroup)
end

function touchOnCell(event)
    if (event.phase == "began") then
        if (isBild) then
            local i_ = math.floor((event.x - world.mapGroup.x)/32)+4
            local j_ = math.floor((event.y - world.mapGroup.y)/32)+4
            world.mMap[i_-3][j_-3].alpha = 0.5
        end
    end
end

function scene:show(event)
    local sceneGroup = self.view
    if (event.phase == "will") then
        joystick_:addEventListener("touch",touchControl)
        buttBild:addEventListener("touch",touchOnBild)
        Runtime:addEventListener("enterFrame",updatePlayer)
        for i = 1,world.width-1 do
          for j = 1,world.height-1 do
              world.mMap[i][j]:addEventListener("touch",touchOnCell)
          end
        end
    end
end

function scene:hide(event)
    Runtime:removeEventListener("enterFrame", updatePlayer)
    buttBild:removeEventListener("touch",touchOnBild)
    joystick_:removeEventListener("touch",touchControl)
    self.view:insert(player.sprite)

end

function scene:destroy(event)
    display.remove( self.view )
end

function scene:refresh(event)
    local v = self.view
        transition.to(v, {time=500, alpha=0.5, transition=easing.inExpo, onComplete=function(e)
        --self:destroy()
        --self:create()
        composer.gotoScene( "Scenes.game" )

        transition.to(v, {time=500, alpha=1, transition=easing.outExpo})
    end})
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene
