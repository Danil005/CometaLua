local composer = require ("composer")
local widget = require ("widget")
composer.removeScene( "Scenes.game" )
local scene = composer.newScene()

local background = nil
local spriteElf = nil
local buttonStart = nil
local buttonOptions =nil

local function pressedPlay()
    composer.gotoScene("Scenes.loadScene")
end

function scene:create()
    local GroupScene = self.view
    background = display.newImageRect( GroupScene,"Sprites/Menu/back.png",display.contentWidth + 400,display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    buttonStart = widget.newButton({
        shape = "roundedRect",
        width = display.contentWidth / 3,
        height = display.contentHeight / 5,
        cornerRadius = 10,
        label = "Играть",
        font = "azerot",
        fontSize = 32,
        labelYOffset = 8,
        labelColor = { default={ 0,0,0 }, over={ 0, 0, 0,} },
	      fillColor = { default={ 228/255,205/255,199/255 }, over={ 228/255,225/255,199/255 } },
        onEvent = pressedPlay
    })
    buttonStart.x = display.contentCenterX
    buttonStart.y = display.contentCenterY*0.9
    buttonOptions = widget.newButton( {
        shape = "roundedRect",
        width = display.contentWidth/3,
        height = display.contentHeight/5,
        cornerRadius = 10,
        label = "Настройки",
        font = "azerot",
        fontSize = 30,
        labelYOffset = 8,
        labelColor = { default={ 0,0,0 }, over={ 0, 0, 0,} },
	      fillColor = { default={ 228/255,205/255,199/255 }, over={ 228/255,225/255,199/255 } }
    } )
    buttonOptions.x = display.contentCenterX
    buttonOptions.y = display.contentCenterY*1.4
    GroupScene:insert(buttonStart)
    GroupScene:insert(buttonOptions)
    spriteElf = display.newImageRect(GroupScene,"Sprites/Menu/elves.png",display.contentWidth/3,display.contentHeight/1.6 )
    spriteElf.x = display.contentCenterX*1.2
    spriteElf.y = display.contentCenterY*0.6
    GroupScene:insert(spriteElf)
end

function scene:show(event)
    if (event.phase == "will") then composer.removeHidden( ); end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

return scene
