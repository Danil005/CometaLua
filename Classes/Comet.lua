comet = {}

-- local composer = require("composer")

-- local scene = composer.newScene()

-- Дохуя
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

local front_comet_sheet = graphics.newImageSheet( "images/default/comet_front.png", comet_options)
local left_comet_sheet = graphics.newImageSheet( "images/default/comet_left.png", comet_options)
local right_comet_sheet = graphics.newImageSheet( "images/default/comet_right.png", comet_options)
forward_comet_sheet = graphics.newImageSheet("images/default/comet_forward.png", comet_anim_options)

comet_data =
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

comet = {}

function comet:new(folder_name, power)
    local obj= {}
    obj.folder = folder_name -- Местоположение текущего скина
    obj.x = 150 -- коорд. x
    obj.y = 300 -- коорд. y
    obj.scale = 0.2
    obj.power = power
    obj.sprite = display.newSprite(forward_comet_sheet, comet_data) -- Сам спрайт кометы
    obj.poses_list = {} -- здесь будут позиции для плавной анимации

    setmetatable(obj, self)
    self.__index = self
    return obj
  end

function comet:animate(command)
    self.sprite:setSequence(command)
    self.sprite:scale(comet.self.scale, comet.self.scale)
    self.sprite:play()
  end

function comet:get_pos()
  for i = 1,#self.poses_list do
    print(self.poses_list[i])
  end
end

--local comet = display.newSprite(forward_comet_sheet, comet_data);
-- return scene

function comet:move(x)
  self.x = self.x + x
end

function comet:new_list(f_x) -- Положение касания, чтобы дальше него не заходить
  local l_x = self.x
  if f_x - l_x < 0 then
    c_sign = -1
  else
    c_sign = 1
  end

  local check_f_x = l_x

  for i = 1, 10 do -- цикл от 1 до 10 с шагом 1
    if math.abs(check_f_x - f_x) >= self.power then
      self.poses_list[i] = c_sign  * (self.power + c_sign * math.min(0, 8 - i)) -- чтобы было +х, +х, а в конце +х -1, +х -2
      check_f_x = check_f_x + self.poses_list[i]
    end
  end
end

function comet:next_position()
  if #self.poses_list == 0 then
    return self.x
  else
    result = self.x + self.poses_list[1]
    table.remove(self.poses_list, 1)
    return result
  end
end

function comet:move()
  self.x = self:next_position()
  print(self.x)
end

local test_comet = comet:new("noname", 4)

test_comet:new_list(120)
for i = 1, 20 do
  test_comet:move()
end
