Loading = {}

local loading_options =
{
  width = 1119,
  height = 1856,
  numFrames = 5,
  sheetContentWidth = 5596,
  sheetContentHeight = 1856
}

function Loading:new(x, y, size)
  obj = {}
  obj.image = display.newImageRect("Sprites/loading.png", size, size)
  obj.image.x = x
  obj.image.y = y

  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Loading:next_frame()
  self.image.rotation = self.image.rotation + 3
end
