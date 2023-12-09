namespace mineos {

  const create = vector.create2d;

  class BitsBattle extends WindowProgram {
    loaded = false

    static counter = 0

    instance = 0

    map: number[][] = [
      [0,0,0,0,0,0,0,0]
    ]

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {
      super(system, renderer, audio, desktop, windowSize)
      this.instance = BitsBattle.counter
      BitsBattle.counter++
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

      // this.audioController.playSong("bitsTheme")

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

      // this.audioController.update(delta)
    }
  }


  DesktopEnvironment.registerProgram(BitsBattle)
}