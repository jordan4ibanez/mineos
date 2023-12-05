namespace mineos {
  //todo get notes from audacity tuner

  // This hides any "minetesty" things from the rest of the system.
  export class AudioController {
    system: System

    constructor(system: System) {
      this.system = system
    }

    playSound(name: string, volume: number, fade?: number): number {
      return minetest.sound_play(
        {name: name},
        {to_player: "singleplayer",
        gain: volume,
        fade: fade
        })
    }
  }
}