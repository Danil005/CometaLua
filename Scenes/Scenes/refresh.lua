local composer = require("composer")
local scene = composer.newScene()

function scene:show()
    composer.gotoScene( "Scenes.game")
end

scene:addEventListener("show",scene)

return scene
