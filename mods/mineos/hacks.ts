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

    player.set_sky({
      base_color: "black",
      body_orbit_tilt: 0,
      type: SkyParametersType.regular,
      textures: [],
      clouds: false,
      sky_color: {
        day_sky: "black",
        day_horizon: "black",
        dawn_sky: "black",
        dawn_horizon: "black",
        night_horizon: "black",
        night_sky: "black",
        indoors: "black",
        fog_moon_tint: "black",
        fog_sun_tint: "black",
        fog_tint_type: SkyParametersFogTintType.default
      },
      fog: {
        fog_distance: 999999999,
        fog_start: 9999999999999
      }
    })

    player.set_moon({
      visible: false
    })

    player.set_sun({
      visible: false,
      sunrise_visible: false
    })

    //TODO FIXME:remove this when the GUI is implemented
    minetest.register_on_player_receive_fields(() => {
      getSystem().sendQuitSignal()
    })
  })

  export function osFrameBufferPoll(): Vec2 {
    let monitorInformation = minetest.get_player_window_information("singleplayer")
    if (monitorInformation == null) {
      return vector.create2d(1,1)
    }
    let size = monitorInformation.max_formspec_size
    size.x *= 1.1
    size.y *= 1.1
    return size
  }

  print("hacks loaded.")
}