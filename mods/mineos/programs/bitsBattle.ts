namespace mineos {

  const create = vector.create2d;

  /*
  2 layers fg/bg

  0 - bg_tile.png - nothing
  note: 0 is auto assigned then drawn on top of. I'm pretty lazy.
  1 - fg_tile.png - wall

  2 - blue_lock.png   - aqua lock
  3 - red_lock.png    - red lock
  4 - yellow_lock.png - yellow lock
  5 - green_lock.png  - green lock

  6 - blue_key.png   - aqua key
  7 - red_key.png    - red key
  8 - yellow_key.png - yellow key
  9 - green_key.png  - green key

  10 - chip - computer chip

  11 - socket - blocks exit until you collect all chips

  12 - exit - exits the level

  in this case it just changes the window title to "You win!"

  No other levels, not enough time in this jam.
  */

  // This makes the map more readable
  const _ = 0
  const w = 1
  const E = 12
  
  // keys
  const b = 2
  const r = 3
  const y = 4
  const g = 5

  // locks
  const B = 6
  const R = 7
  const Y = 8
  const G = 9

  const S = 11
  const C = 10

  class BitsBattle extends WindowProgram {
    loaded = false
    static counter = 0
    instance = 0
    //! Map is mutable!
    // 17x16
    // level 1 of chips challenge
    chipsRemaining = 11
    MAP_WIDTH = 17
    MAP_HEIGHT = 16
    map: number[][] = [
      [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
      [_,_,_,w,w,w,w,w,_,w,w,w,w,w,_,_,_],
      [_,_,_,w,_,_,_,w,w,w,_,_,_,w,_,_,_],
      [_,_,_,w,_,C,_,w,E,w,_,C,_,w,_,_,_],
      [_,w,w,w,w,w,G,w,S,w,G,w,w,w,w,w,_],
      [_,w,_,_,_,B,_,_,_,_,_,R,_,_,_,w,_],
      [_,w,_,C,_,w,_,_,_,_,_,w,_,C,_,w,_],
      [_,w,w,w,w,w,C,_,_,_,C,w,w,w,w,w,_],
      [_,w,_,C,_,w,_,_,_,_,_,w,_,C,_,w,_],
      [_,w,_,_,_,R,_,_,C,_,_,B,_,_,_,w,_],
      [_,w,w,w,w,w,w,Y,w,Y,w,w,w,w,w,w,_],
      [_,_,_,_,_,w,_,_,w,_,_,w,_,_,_,_,_],
      [_,_,_,_,_,w,_,C,w,C,_,w,_,_,_,_,_],
      [_,_,_,_,_,w,_,_,w,_,_,w,_,_,_,_,_],
      [_,_,_,_,_,w,w,w,w,w,w,w,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
    ]

    pos = create(8, 7)

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {
      super(system, renderer, audio, desktop, windowSize)
      this.instance = BitsBattle.counter
      BitsBattle.counter++

      // Check everything!
      assert(this.map.length == this.MAP_HEIGHT)
      for (const arr of this.map) {
        assert(arr.length == this.MAP_WIDTH)
      }

      this.renderer.addElement("chips_challenge_bg" + this.instance, {
        name: "chips_challenge_bg_" + this.instance,
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png^[colorize:" + colors.color(70,70,70) + ":255",
        // number: colors.colorHEX(50,50,50),
        scale: this.windowSize,
        alignment: create(1,1),
        offset: create(
          this.getPosX(),
          this.getPosY(),
        ),
        z_index: 1
      })

      this.setWindowTitle("Bit's Battle")
    }

    move() {
      print("moving bits battle")
      this.renderer.setElementComponentValue("chips_challenge_bg" + this.instance, "offset", this.windowPosition)
    }

    destructor(): void {
      print("bits battle destroyed")
      this.renderer.removeElement("chips_challenge_bg" + this.instance)
    }

    load() {
      System.out.println("Loading Bits' Battle!")
      let bitsTheme = new Song("bitsTheme")
      bitsTheme.tempo = 5.5
      //0,2,4,5,7 acceptable notes
      bitsTheme.data["bassTrumpet"] = 
      [ 0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,

        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,

        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2];

      bitsTheme.data["trumpet"] = 
      [ -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,2,4,0,7,2,0,5,4,0,7,2,        

        0,0,7,0,0,7,0,0,7,0,0,7,
        0,2,4,0,7,2,0,5,4,0,7,2,
        0,0,7,0,0,7,0,0,7,0,0,7,

        0,2,4,0,7,2,0,5,4,0,7,2,
        0,0,7,0,0,7,0,0,7,0,0,7,
        0,2,4,0,7,2,0,5,4,0,7,2,];

      AudioController.registerSong(bitsTheme)

      this.audioController.playSong("bitsTheme")

      // this.renderer.addElement("left", new gui.Button({
      //   position: create(25,10),
      //   size: create(1,1),
      //   name: "left",
      //   label: "left"
      // }))

      // this.renderer.addElement("down", new gui.Button({
      //   position: create(26,10),
      //   size: create(1,1),
      //   name: "down",
      //   label: "down"
      // }))

      // this.renderer.addElement("right", new gui.Button({
      //   position: create(27,10),
      //   size: create(1,1),
      //   name: "right",
      //   label: "right"
      // }))

      // this.renderer.addElement("up", new gui.Button({
      //   position: create(26,9),
      //   size: create(1,1),
      //   name: "up",
      //   label: "up"
      // }))






      this.loaded = true
      System.out.println("Bit's Battle loaded!");
    }

    main(delta: number): void {
      if (!this.loaded) this.load()

      print("bits battle instance " + this.instance + " is running " + delta)

      this.audioController.update(delta)
    }
  }


  DesktopEnvironment.registerProgram(BitsBattle)
}