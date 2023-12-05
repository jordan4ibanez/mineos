namespace mineos {
  //todo get notes from audacity tuner

  // This hides any "minetesty" things from the rest of the system.
  export class AudioController {
    playSound(name: string) {
      minetest.sound_play({name: name})
    }
  }
}