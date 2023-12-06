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
        fog_distance: 0,
        fog_start: 0
      }
    })

    player.set_moon({
      visible: false
    })

    player.set_sun({
      visible: false,
      sunrise_visible: false
    })

    // "OS sends the program things" or some nonsense
    minetest.register_on_player_receive_fields((_: ObjectRef, formName: string, fields: {[id: string] : any}) => {
      getSystem().triggerCallbacks(formName, fields)
    })
  })

  export function osFrameBufferPoll(): LuaMultiReturn<[Vec2, Vec2]> {
    let monitorInformation = minetest.get_player_window_information("singleplayer")
    if (monitorInformation == null) {
      return $multi(vector.create2d(1,1), vector.create2d(1,1))
    }
    
    let scaling = monitorInformation.max_formspec_size
    scaling.x *= 1.1
    scaling.y *= 1.1
    let size = monitorInformation.size
    return $multi(size, scaling)
  }

  // Shh, don't tell anyone this isn't actually talking to hardware.
  export function osKeyboardPoll(key: string): boolean {
    let a = minetest.get_player_by_name("singleplayer").get_player_control()
    switch (key) {
      case "up": return a.up
      case "down": return a.down
      case "left": return a.left
      case "right": return a.right
      case "jump": return a.jump
      case "aux1": return a.aux1
      case "sneak": return a.sneak
      case "dig": return a.dig
      case "place": return a.place
      case "LMB": return a.LMB
      case "RMB": return a.RMB
      case "zoom": return a.zoom
    }
    return false
  }

  // Automatically start mineos when the player loads in.
  minetest.register_on_joinplayer(() => {
    getSystem().triggerBoot()
  })


  System.out.println("hacks loaded.")
}