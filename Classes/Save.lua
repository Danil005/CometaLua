local json = require ("json")
Save = {}

function Save:new()
    local obj= {}
        obj.is_mute_musics = false
        obj.is_mute_sounds = false
        obj.scores = true
        obj.PATH = system.pathForFile("comet_data.json", system.DocumentsDirectory )

    setmetatable(obj, self)
    self.__index = self
    return obj
  end

function mysplit(inputstr, sep)
          if sep == nil then
                  sep = "%s"
          end
          local t={} ; i=1
          for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                  t[i] = str
                  i = i + 1
          end
          return t
end



function Save:toFile(path, save_data)
    local file, errorString = io.open(system.pathForFile( path, system.ResourceDirectory), "w")
    if not file then
        print("Error: " .. errorString)
    else
        file:write(json.encode(save_data))
        print(json.encode(save_data))
        io.close(file)
    end
    file = nil
end

function Save:getFile(path)
  local file = io.open(system.pathForFile(path, system.ResourceDirectory), "r")
  local data = json.decode(file:read( "*a" ))
  io.close( file )
  return data
end

function Save:fromFile()
    local file, errorString = io.open(self.PATH,"r")
    if not file then
        print( "File error: " .. errorString )
    else
        local data = json.decode( file:read( "*a" ) )
        io.close( file )
        self.is_mute_musics = data[1]
        self.is_mute_sounds = data[2]
        self.scores = data[3]
    end

    file = nil
end
