
display.setStatusBar( display.HiddenStatusBar)
math.randomseed( os.time() )

local composer = require("composer")

WIDTH = display.contentWidth
HEIGHT = display.contentHeight

--composer.gotoScene("Scenes.Menu")
require("Classes.Comet")
