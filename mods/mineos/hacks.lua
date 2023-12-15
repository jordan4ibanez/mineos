mineos = mineos or ({})
do
    minetest.register_on_joinplayer(function(player)
        player:set_physics_override({gravity = 0})
        player:hud_set_flags({
            hotbar = false,
            healthbar = false,
            crosshair = false,
            wielditem = false,
            breathbar = false,
            minimap = false,
            basic_debug = false,
            chat = false
        })
        player:set_sky({
            base_color = "black",
            body_orbit_tilt = 0,
            type = SkyParametersType.regular,
            textures = {},
            clouds = false,
            sky_color = {
                day_sky = "black",
                day_horizon = "black",
                dawn_sky = "black",
                dawn_horizon = "black",
                night_horizon = "black",
                night_sky = "black",
                indoors = "black",
                fog_moon_tint = "black",
                fog_sun_tint = "black",
                fog_tint_type = SkyParametersFogTintType.default
            },
            fog = {fog_distance = 0, fog_start = 0}
        })
        player:set_moon({visible = false})
        player:set_sun({visible = false, sunrise_visible = false})
    end)
    function mineos.osFrameBufferPoll()
        local monitorInformation = minetest.get_player_window_information("singleplayer")
        if monitorInformation == nil then
            return vector.create2d(1, 1), 1
        end
        local scaling = monitorInformation.real_hud_scaling
        local size = monitorInformation.size
        return size, scaling
    end
    function mineos.osKeyboardPoll(key)
        local a = minetest.get_player_by_name("singleplayer"):get_player_control()
        repeat
            local ____switch7 = key
            local ____cond7 = ____switch7 == "up"
            if ____cond7 then
                return a.up
            end
            ____cond7 = ____cond7 or ____switch7 == "down"
            if ____cond7 then
                return a.down
            end
            ____cond7 = ____cond7 or ____switch7 == "left"
            if ____cond7 then
                return a.left
            end
            ____cond7 = ____cond7 or ____switch7 == "right"
            if ____cond7 then
                return a.right
            end
            ____cond7 = ____cond7 or ____switch7 == "jump"
            if ____cond7 then
                return a.jump
            end
            ____cond7 = ____cond7 or ____switch7 == "aux1"
            if ____cond7 then
                return a.aux1
            end
            ____cond7 = ____cond7 or ____switch7 == "sneak"
            if ____cond7 then
                return a.sneak
            end
            ____cond7 = ____cond7 or ____switch7 == "dig"
            if ____cond7 then
                return a.dig
            end
            ____cond7 = ____cond7 or ____switch7 == "place"
            if ____cond7 then
                return a.place
            end
            ____cond7 = ____cond7 or ____switch7 == "LMB"
            if ____cond7 then
                return a.LMB
            end
            ____cond7 = ____cond7 or ____switch7 == "RMB"
            if ____cond7 then
                return a.RMB
            end
            ____cond7 = ____cond7 or ____switch7 == "zoom"
            if ____cond7 then
                return a.zoom
            end
        until true
        return false
    end
    minetest.register_on_joinplayer(function(driver)
        mineos.initializeSystem(driver)
        mineos.getSystem():triggerBoot()
    end)
    minetest.register_on_mods_loaded(function()
        minetest.set_timeofday(0)
    end)
    mineos.System.out:println("hacks loaded.")
end
