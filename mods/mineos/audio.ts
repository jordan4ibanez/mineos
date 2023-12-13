namespace mineos {
  //todo get notes from audacity tuner

  const translationKey: {[id: number] : number} = {
    0: 0.0000,
    1: 0.0594,
    2: 0.1220,
    3: 0.1890,
    4: 0.2590,
    5: 0.3340,
    6: 0.4140,
    7: 0.4980,
    8: 0.5870,
    9: 0.6810,
    10: 0.7810,
    11: 0.8870
  };

  let songRegistrationQueue: Song[] = []

  // I call this format SHIDI
  export class Song {
    // Songs always loop.
    name: string
    // Basically notes per second.
    tempo = 20
    volume = 1
    // Instrument: [notes]
    data: {[id: string] : number[]} = {}

    finalizedArrayLength = -1

    constructor(name: string) {
      this.name = name
    }
    // Double checks all the arrays are equal so nothing stupid happens.
    finalize() {
      let arraySize = -1
      for (const [instrument, notes] of Object.entries(this.data)) {
        if (arraySize == -1) {
          arraySize = notes.length
          continue;
        }

        if (notes.length != arraySize) {
          throw new Error(this.name + " HAS MISMATCHED DATA!")
        }
      }
      if (arraySize == -1) {
        throw new Error(this.name + " IS AN EMPTY SONG!")
      }
      this.finalizedArrayLength = arraySize
    }
  }



  // This hides any "minetesty" things from the rest of the system.
  export class AudioController {
    system: System

    updated = true

    songs: {[id: string] : Song} = {}
    currentSong: Song | null = null

    currentNote = 0
    accumulator = 0

    constructor(system: System) {
      this.system = system
      while (songRegistrationQueue.length > 0) {
        const song = songRegistrationQueue.pop()
        if (song == null) continue
        this.songs[song.name] = song        
      }
    }

    static registerSong(song: Song): void {
      const system = getSystemOrNull()
      song.finalize()
      if (system == null) {
        songRegistrationQueue.push(song)
        return
      }
      system.audioController.songs[song.name] = song
    }

    playSong(name: string): void {
      this.currentNote = 0
      this.accumulator = 0
      this.currentSong = this.songs[name]
      if (this.currentSong == null) {
        throw new Error(name + " IS NOT A REGISTERED SONG!")
      }
    }

    stopSong(): void {
      this.currentSong = null
    }

    update(delta: number) {

      if (this.updated) {
        // print("skipping")
        return
      }
      this.updated = true

      if (this.currentSong == null) {
        // print("error: no current song!")
        return
      }
      const goalTimer = (1 / this.currentSong.tempo)
      this.accumulator += delta
      if (this.accumulator >= goalTimer) {
        this.accumulator -= goalTimer
        // Play notes
        for (const [instrument, data] of Object.entries(this.currentSong.data)) {
          // print("playing " + instrument + " note " + this.currentNote)
          this.playNote(instrument, data[this.currentNote], this.currentSong.volume)
        }

        this.currentNote ++
        // And loop
        if (this.currentNote >= this.currentSong.finalizedArrayLength) {
          this.currentNote = 0
        }
      }
      
    }

    playNote(instrument: string, pitch: number, volume: number = 1): void {
      if (pitch == -1) return
      // This is lazy as heck.
      let fPitch = 1 + translationKey[pitch]!!
      minetest.sound_play(
        {name: instrument},
        {to_player: "singleplayer",
        gain: volume,
        pitch: fPitch
        })
    }

    playSound(name: string, volume: number, fade?: number): number {
      return minetest.sound_play(
        {name: name},
        {to_player: "singleplayer",
        gain: volume,
        fade: fade
        })
    }

    playSoundDelay(name: string, volume: number, delay: number): void {
      minetest.after(delay, () => {
        minetest.sound_play(
          {name: name},
          {to_player: "singleplayer",
          gain: volume,
          })
      })
    }
    playSoundRepeat(name: string, volume: number, fade?: number): number {
      return minetest.sound_play(
        {name: name},
        {to_player: "singleplayer",
        gain: volume,
        fade: fade,
        loop: true
        })
    }
  }
}