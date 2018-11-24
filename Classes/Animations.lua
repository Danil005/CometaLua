local composer = require("composer")

local scene = composer.newScene()

local comet_options =
{
    width = 1119,
    height = 1856,
    numFrames = 5,
    sheetContentWidth = 5596,
    sheetContentHeight = 1856
}

local front_comet_sheet = graphics.newImageSheet( "images/comet_front.png", comet_options )
local comet_data =
{
  {
    name = "front",
    sheet = front_comet_sheet,
    start = 1,
    count = 5,
    time = 800,
    loopCount = 0
  }
}

local comet = display.newSprite(front_comet_sheet, comet_data);
comet:setSequence("front")
comet.x = 150
comet.y = 300
comet:play();

comet:scale(0.2, 0.2);
return scene
