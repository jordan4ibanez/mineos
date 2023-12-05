namespace mineos {
  minetest.register_on_joinplayer((player: ObjectRef) => {
    player.set_physics_override({
      gravity: 0
    });
    
    player.hud_set_flags({
      hotbar: false,
      healthbar: false,
      crosshair: false,
      wielditem: false,
      breathbar: false,
      minimap: false,
      basic_debug: false,
      chat: false
    })
  })

  print("hacks loaded.")
}