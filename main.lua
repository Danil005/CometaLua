
display.setStatusBar( display.HiddenStatusBar)
math.randomseed( os.time() )

local composer = require("composer")

WIDTH = display.contentWidth
HEIGHT = display.contentHeight

-- require("Classes.Animations")
composer.gotoScene("Scenes.Menu")
