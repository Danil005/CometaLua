display.setStatusBar( display.HiddenStatusBar)
math.randomseed( os.time() )


WIDTH = display.contentWidth
HEIGHT = display.contentHeight

local composer = require( "composer" )
composer.gotoScene( "Scenes.Menu")
