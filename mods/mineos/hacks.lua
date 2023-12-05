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
    end)
    print("hacks loaded.")
end
