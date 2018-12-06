display.setStatusBar( display.HiddenStatusBar)

math.randomseed( os.time() )

WIDTH = display.contentWidth
HEIGHT = display.contentHeight
SCORE = 0
resize_Font = WIDTH / 320

local composer = require( "composer" )
composer.recycleOnSceneChange = true
composer.gotoScene( "Scenes.Menu")
