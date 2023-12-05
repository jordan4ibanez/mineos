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
            fog = {fog_distance = 999999999, fog_start = 9999999999999}
        })
        player:set_moon({visible = false})
        player:set_sun({visible = false, sunrise_visible = false})
        minetest.register_on_player_receive_fields(function()
            mineos.getSystem():sendQuitSignal()
        end)
    end)
    function mineos.osFrameBufferPoll()
        local monitorInformation = minetest.get_player_window_information("singleplayer")
        if monitorInformation == nil then
            return vector.create2d(1, 1), vector.create2d(1, 1)
        end
        local scaling = monitorInformation.max_formspec_size
        scaling.x = scaling.x * 1.1
        scaling.y = scaling.y * 1.1
        local size = monitorInformation.size
        return size, scaling
    end
    function mineos.osKeyboardPoll(key)
        local a = minetest.get_player_by_name("singleplayer"):get_player_control()
        repeat
            local ____switch8 = key
            local ____cond8 = ____switch8 == "up"
            if ____cond8 then
                return a.up
            end
            ____cond8 = ____cond8 or ____switch8 == "down"
            if ____cond8 then
                return a.down
            end
            ____cond8 = ____cond8 or ____switch8 == "left"
            if ____cond8 then
                return a.left
            end
            ____cond8 = ____cond8 or ____switch8 == "right"
            if ____cond8 then
                return a.right
            end
            ____cond8 = ____cond8 or ____switch8 == "jump"
            if ____cond8 then
                return a.jump
            end
            ____cond8 = ____cond8 or ____switch8 == "aux1"
            if ____cond8 then
                return a.aux1
            end
            ____cond8 = ____cond8 or ____switch8 == "sneak"
            if ____cond8 then
                return a.sneak
            end
            ____cond8 = ____cond8 or ____switch8 == "dig"
            if ____cond8 then
                return a.dig
            end
            ____cond8 = ____cond8 or ____switch8 == "place"
            if ____cond8 then
                return a.place
            end
            ____cond8 = ____cond8 or ____switch8 == "LMB"
            if ____cond8 then
                return a.LMB
            end
            ____cond8 = ____cond8 or ____switch8 == "RMB"
            if ____cond8 then
                return a.RMB
            end
            ____cond8 = ____cond8 or ____switch8 == "zoom"
            if ____cond8 then
                return a.zoom
            end
        until true
        return false
    end
    minetest.register_on_joinplayer(function()
        mineos.getSystem():triggerBoot()
    end)
    print("hacks loaded.")
end
