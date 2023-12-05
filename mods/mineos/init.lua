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
        "gui_components",
        "renderer",
        "system",
        "hacks"
    })
    local system = __TS__New(mineos.System)
    system:triggerBoot()
    minetest.register_globalstep(function(delta)
        system:main(delta)
    end)
end
