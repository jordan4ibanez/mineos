mineos = mineos or ({})
do
    function mineos.loadFiles(filesToLoad)
        local currentMod = minetest.get_current_modname()
        local currentDirectory = minetest.get_modpath(currentMod)
        for ____, file in ipairs(filesToLoad) do
            dofile(((currentDirectory .. "/") .. file) .. ".lua")
        end
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
    mineos.colorize = minetest.colorize
end
