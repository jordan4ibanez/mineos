mineos = mineos or ({})
do
    function mineos.loadFiles(filesToLoad)
        local currentMod = minetest.get_current_modname()
        local currentDirectory = minetest.get_modpath(currentMod)
        for ____, file in ipairs(filesToLoad) do
            dofile(((currentDirectory .. "/") .. file) .. ".lua")
        end
    end
    function mineos.loadFile(file)
        local currentDirectory = minetest.get_modpath("mineos")
        return dofile(((currentDirectory .. "/") .. file) .. ".lua")
    end
    vector.create = function(x, y, z)
        local temp = vector.zero()
        temp.x = x or 0
        temp.y = y or 0
        temp.z = z or 0
        return temp
    end
    vector.create2d = function(x, y)
        local temp = {x = x or 0, y = y or 0}
        return temp
    end
    math.clamp = function(min, max, input)
        if input < min then
            return min
        elseif input > max then
            return max
        end
        return input
    end
    math.randomseed(os.time())
    local random = math.random
    local gsub = string.gsub
    local format = string.format
    function mineos.uuid()
        local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
        return (gsub(
            template,
            "[xy]",
            function(c)
                local v = c == "x" and random(0, 15) or random(8, 11)
                return format("%x", v)
            end
        ))
    end
    mineos.colorize = minetest.colorize
end
