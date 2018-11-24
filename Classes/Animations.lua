local loading_options =
{
  width = 1119,
  height = 1856,
  numFrames = 5,
  sheetContentWidth = 5596,
  sheetContentHeight = 1856
}

local comet_options =
{
    width = 1119,
    height = 1856,
    numFrames = 5,
    sheetContentWidth = 5596,
    sheetContentHeight = 1856
}

local comet_anim_options =
{
  width =330,
  height = 1702,
  numFrames = 30,
  sheetContentWidth = 9900,
  sheetContentHeight = 1702
}

local front_comet_sheet = graphics.newImageSheet( "images/comet_front.png", comet_options)
local left_comet_sheet = graphics.newImageSheet( "images/comet_left.png", comet_options)
local right_comet_sheet = graphics.newImageSheet( "images/comet_right.png", comet_options)
local forward_comet_sheet = graphics.newImageSheet("images/comet_forward.png", comet_anim_options)

local comet_data =
{
  {
    name = "front",
    sheet = front_comet_sheet,
    start = 1,
    count = 5,
    time = 800,
    loopCount = 0
  },
  {
    name = "left",
    sheet = left_comet_sheet,
    start = 1,
    count = 5,
    time = 800,
    loopCount = 0
  },
  {
    name = "right",
    sheet = right_comet_sheet,
    start = 1,
    count = 5,
    time = 300,
    loopCount = 0
  },
  {
    name = "forward",
    sheet = forward_comet_sheet,
    start = 1,
    count = 30,
    time = 1000,
    loopCount = 0
  }
}

local comet = display.newSprite(forward_comet_sheet, comet_data);
comet:setSequence("forward")
comet.x = 150
comet.y = 300
comet:play();

comet:scale(0.2, 0.2);
-- return scene
