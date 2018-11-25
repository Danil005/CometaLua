local json = require ("json")
Save = {}

function Save:new(path)
    local obj= {}
        obj.is_mute_musics = false
        obj.is_mute_sounds = false
        obj.scores = true
        obj.PATH = path
    setmetatable(obj, self)
    self.__index = self
    return obj
  end

function Save:toFile()
    local save_data = {
        self.is_mute_musics,
        self.is_mute_sounds,
        self.scores
    }
    local file, errorString = io.open(self.PATH,"w")
    if not file then
        print("Error: " .. errorString)
    else
        file:write(json.encode(save_data))
        print(json.encode(save_data))
        io.close(file)
    end
    file = nil
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
