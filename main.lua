display.setStatusBar( display.HiddenStatusBar)
math.randomseed( os.time() )


WIDTH = display.contentWidth
HEIGHT = display.contentHeight

require("Classes.Save")
local path = system.pathForFile("comet_data.json", system.DocumentsDirectory )
Saving = Save:new(path)

local composer = require( "composer" )
composer.gotoScene( "Scenes.Menu")
