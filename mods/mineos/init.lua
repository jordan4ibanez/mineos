-- Lua Library inline imports
local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end
-- End of Lua Library inline imports
mineos = mineos or ({})
do
    do
        dofile(minetest.get_modpath("mineos") .. "/utility.lua")
    end
    mineos.loadFiles({
        "enums",
        "colors",
        "gui_components",
        "renderer",
        "audio",
        "system",
        "programs/programs",
        "hacks"
    })
    function mineos.initializeSystem(driver)
        local system = __TS__New(mineos.System, driver)
        minetest.register_globalstep(function(delta)
            system:main(delta)
        end)
    end
end
