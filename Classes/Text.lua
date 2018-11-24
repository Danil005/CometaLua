Text = {}

function Text:new(text, element)
  local obj = {}
      obj.text = text -- Текст
      obj.x = 0
      obj.y = 0
      obj.font = native.systemFont -- Шрифт
      obj.size = 30 -- Размер текста в px
      obj.r = 255 -- Цвет текста RED
      obj.g = 255 -- Цвет текста GREEN
      obj.b = 255 -- Цвет текста BLUE

      element = display.newText(obj.text, 0, 0, obj.font, obj.size)
      element.x = obj.x
      element.y = obj.y
      element:setFillColor(obj.r, obj.g, obj.b)
      element.anchorX = 0

      setmetatable(obj, self)
      self.__index = self
      return obj
end

-- Изменить местоположение текста
-- dx - позиция по x
-- dy - позиция по y

function Text:pos(dx, dy)
    self.x = display.contentCenterX - dx
    self.y = display.contentCenterY - dy
    print("INIT POS")
end

-- Изменение цвета текста
-- colores - цвет (black, white, red, green, blue или RGB-палитра)

function Text:color(colores)
  if colores == "black" then
    self.r = 0
    self.g = 0
    self.b = 0
  elseif colores == "white" then
    self.r = 255
    self.g = 255
    self.b = 255
  elseif colores == "red" then
    self.r = 255
    self.g = 0
    self.b = 0
  elseif colores == "green" then
    self.r = 0
    self.g = 255
    self.b = 0
  elseif colores == "blue" then
    self.r = 0
    self.g = 0
    self.b = 255
  else
    self.r = colores[0]
    self.g = colores[1]
    self.b = colores[2]
  end
end

-- Изменение шрифта текста
-- font - шрифт

function Text:font(font)
  self.font = font
end

-- Изменение размера текста
-- size - размер

function Text:size(size)
  self.size = size
end
