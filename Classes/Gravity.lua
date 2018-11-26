Gravity = {}

function Gravity:new(x,y,zone1,zone2)

    local obj= {}
        obj.x = x
        obj.y = y-- Центр гравитации. (x, y).
        obj.zone1 = zone1
        obj.zone2 = zone2-- Зоны гравитации. [(radius, strength), (radius, strength)].
        obj.measure = display.contentWidth / 100 -- Единица силы гравитации. ( 1% экрана).
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- Перевод пикселей в меру
-- Вход: количество пикселей
-- Выход: количество процентов.
function Gravity:measure(pixels)
    return pixels / self.measure
end

-- Перевод меры в пиксели
-- Вход: количество процентов
-- Выход: целое количество процентов.
function Gravity:pixels(percents)
    return math.floor(self.measure*percents)
end

-- Катеты треугольника.
-- Вход: координаты кометы (x, y).
-- Выход: катеты треугольника от кометы до центра в пикселях.
function Gravity:get_legs(x,y)
    leg_a = math.abs(self.x - x)  -- Катет А
    leg_b = math.abs(self.y - y)  -- Катет B
    return {leg_a, leg_b}
end

-- Гипотенуза треугольника.
-- Вход: координаты кометы (x, y).
-- Выход: гипотенуза треугольника от кометы до центра в пикселях.
function Gravity:get_hype(legs)
    return math.sqrt(legs[1]*legs[1] + legs[2]*legs[2])
end

-- Положение кометы относительно планеты.
-- комета слева от планеты: -1
-- комета справа от планеты: 1
-- Вход: координаты кометы (x, y).
-- Выход: -1/1
function Gravity:get_location(x,y)
    if self.x- x >= 0 then
        return 1
    else
        return -1
    end
end

function Gravity:move(x, y)
  self.x = x
  self.y = y
end

-- Дистанция от координаты до центра.
-- Вход: координаты кометы (x, y).
-- Выход: расстояние от кометы до центра в пикселях.
function Gravity:distance(x,y)
    return math.floor(math.sqrt((x- self.x) *(x - self.x) + (y- self.y) *(y - self.y)))
end

-- Узнать силу, с которой гравитация будет действовать.
-- Вход: координаты кометы (x, y).
-- Выход: сила действия в универсальной мере.
function Gravity:get_strength(x,y)
    dist = self:distance(x,y)
    if dist <= self.zone1[1] then
        return self.zone1[2]
    elseif dist <= self.zone2[1] then
        return self.zone2[2]
    else
        return 0
    end
end

-- Узнать сдвиг кометы, спровоцированный планетой
-- Вход: координаты кометы (x, y).
-- Выход: Сдвиг для кометы и планеты в пикселях.
function Gravity:gravity(x,y)
    legs = self:get_legs(x,y)
    hype = self:get_hype(legs)
    cos_angle = legs[1]/hype

    move_comet = self:get_strength(x,y)*cos_angle
    if (x > self.x) then
        move_comet = -move_comet
    end
    strength_gravity = 1 - self:distance(x,y)/(self.y+self.zone2[1])
    if (y > self.y) then
      move_planet = 0.2*self:get_strength(x,y)
    end
    return {math.floor(move_comet+0.5), math.floor(move_planet+0.5)}
end

local function sign(a)
  if a < 0 then
    return -1
  else
    return 1
  end
end

function Gravity:gravity_2(x, y)
  legs = self:get_legs(x,y)
  local x_sign = sign(self.x - x)
  local y_sign
  if y - self.y > 0 then
    y_sign = 1
  else
    y_sign = 0
  end
  local c_percent = legs[1] + legs[2]
  local strength = self:get_strength(x,y)
  local move_x = x_sign * strength * legs[1] / c_percent
  local move_y = y_sign * strength * legs[2] / c_percent
  return {math.floor(move_x+0.5), math.floor(move_y+0.5) * 0.5}
end
