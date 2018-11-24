require("Gravity")
Planet = {}

-- Всякая хуйня

local options =
{
    width = 1666,
    height = 1667,
    numFrames = 4,
    sheetContentWidth = 6667,
    sheetContentHeight = 1667
}
local planets_list = {}
planets_list[1] = graphics.newImageSheet( "Sprites/planet_1.png",options)
planets_list[2] = graphics.newImageSheet("Sprites/planet_2.png",options)
planets_list[3] = graphics.newImageSheet("Sprites/planet_3.png",options)
planets_list[4] = graphics.newImageSheet("Sprites/planet_4.png",options)

function Planet:new(x, y, form, side, zones)
    local obj= {}
    obj.sprite = display.newImageRect(planet_list[form], 2, side, side) -- Сам спрайт кометы
    obj.sprite.x = x
    obj.sprite.y = y
    obj.g = Gravity:new({x,y}, zones)

    setmetatable(obj, self)
    self.__index = self
    return obj
  end

function Planet:move(x, y)
  self.sprite.x = x
  self.sprite.y = y
  self.g:move(x, y)
end

function Planet:gravity(x, y)
  return Gravity:gravity({x, y})
end
