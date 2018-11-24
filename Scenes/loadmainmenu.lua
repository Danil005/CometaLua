local composer = require( "composer" )
local scene = composer.newScene()

local myTimer
local loadingImage

-- Called when the scene's view does not exist:
function scene:create( event )
  local sceneGroup = self.view

  -- completely remove mainmenu
  composer.removeScene( "Scenes.Game_arkada" )

  print( "\nloadgame: create event" )
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
  local sceneGroup = self.view

  print( "loadgame: show event" )

  loadingImage = display.newImageRect( "Sprites/loading_Montazhnaya_oblast_1.png", 480, 320)
  loadingImage.x = 240; loadingImage.y = 160
  sceneGroup:insert( loadingImage )

  local changeScene = function()
      composer.gotoScene( "Scenes.Game_arkada", "flipFadeOutIn", 500 )
  end
  myTimer = timer.performWithDelay( 1000, changeScene, 1 )

end

-- Called when scene is about to move offscreen:
function scene:hide()

  if myTimer then timer.cancel( myTimer ); end

  print( "loadgame: hide event" )

end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )

  print( "destroying loadgame's view" )
end

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener( "create", scene )

-- "show" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "hide" event is dispatched before next scene's transition begins
scene:addEventListener( "hide", scene )

-- "destroy" event is dispatched before view is unloaded, which can be
scene:addEventListener( "destroy", scene )

return scene
