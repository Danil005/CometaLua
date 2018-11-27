Loading = {}
Asteroid = {}
Button = {}

function Asteroid:new(x, y)
    local obj= {}
    -- Дохуя
    local asteroid_options =
    {
      width = 100,
      height = 110,
      numFrames = 12,
      sheetContentWidth = 1200,
      sheetContentHeight = 110
    }
    local asteroid_distortion = graphics.newImageSheet("Sprites/de_asteroid.png", asteroid_options)
    local asteroid_data =
    {
      {
        name = "destroy",
        sheet = asteroid_distortion,
        start = 1,
        count = 12,
        time = 250,
        loopCount = 1
      }
    }
    obj.sprite = display.newSprite(asteroid_distortion, asteroid_data) -- Сам спрайт кометы
    obj.sprite.x = x
    obj.sprite.y = y

    setmetatable(obj, self)
    self.__index = self
    return obj
  end

function Asteroid:animate(command)

    local function mySpriteListener( event )

         if ( event.phase == "ended" ) then
              self.sprite:removeSelf()
              self.sprite = nil
         end
    end
    self.sprite:setSequence(command)
    self.sprite:play()
    self.sprite:addEventListener("sprite", mySpriteListener)
  end

function Asteroid:get_pos()
  for i = 1,#self.poses_list do
    print(self.poses_list[i])
  end
end

--local comet = display.newSprite(forward_comet_sheet, comet_data);
-- return scene

function Asteroid:move(x, y)
if (self.sprite ~= nil) then
  self.sprite.x = self.sprite.x + x
  self.sprite.y = self.sprite.y + y
end
end

function Asteroid:set_position(x, y)
  self.sprite.x = x
  self.sprite.y = y
end




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



function Button:new(button_name, size_x, size_y, x, y)
  obj = {}
  obj.image = display.newImageRect("Sprites/" .. button_name, size_x, size_y)
  obj.image.x = x
  obj.image.y = y

  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Button:next_frame()
  self.image.alpha = self.image.alpha * 0.7
end

--timer.performWithDelay( 1000, display.remove(test_boom.sprite))
