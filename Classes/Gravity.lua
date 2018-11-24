Gravity = {}

function Gravity:new(center,zones)

    local obj= {}
        obj.center = center -- Центр гравитации. (x, y).
        obj.zones = zones -- Зоны гравитации. [(radius, strength), (radius, strength)].
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
function Gravity:get_legs(coords)
    leg_a = abs(self.center[0] - coords[0])  -- Катет А
    leg_b = abs(self.center[1] - coords[1])  -- Катет B
    return {leg_a, leg_b}
end

-- Гипотенуза треугольника.
-- Вход: координаты кометы (x, y).
-- Выход: гипотенуза треугольника от кометы до центра в пикселях.
function Gravity:get_hype(legs)
    return sqrt(legs[0]*legs[0] + legs[1]*legs[1])
end

-- Положение кометы относительно планеты.
-- комета слева от планеты: -1
-- комета справа от планеты: 1
-- Вход: координаты кометы (x, y).
-- Выход: -1/1
function Gravity:get_location(coords)
    if self.center[0] - coords[0] >= 0 then
        return 1
    else
        return -1
    end
end

-- Дистанция от координаты до центра.
-- Вход: координаты кометы (x, y).
-- Выход: расстояние от кометы до центра в пикселях.
function Gravity:distance(coords)
    return int(sqrt((coords[0] - self.center[0]) *(coords[0] - self.center[0]) + (coords[1] - self.center[1]) *(coords[1] - self.center[1])))
end

-- Узнать силу, с которой гравитация будет действовать.
-- Вход: координаты кометы (x, y).
-- Выход: сила действия в универсальной мере.
function Gravity:get_strength(coords)
    dist = self.distance(coords)
    if dist <= self.zones[0][0] then
        return self.zones[0][1]
    elseif dist <= self.zones[1][0] then
        return self.zones[1][1]
    else
        return 0
    end
end

-- Узнать сдвиг кометы, спровоцированный планетой
-- Вход: координаты кометы (x, y).
-- Выход: Сдвиг для кометы и планеты в пикселях.
function gravity(coords)
    legs = self.get_legs(coords)
    hype = self.get_hype(legs)
    cos_angle = legs[0]/hype

    move_comet = self.get_strength(coords)*cos_angle
    if coords[0] > self.center[0] then
        move_comet = -move_comet
    end
    strength_gravity = 1 - self.distance(coords)/(self.center[1]+self.zones[1][0])
    if (coords[1] > self.center[1]) then
      move_planet = strength_gravity*self.get_strength(coords)
    end

    return {round(move_comet), round(move_planet)}
end
