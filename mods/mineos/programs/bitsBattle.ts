namespace mineos {

  const create = vector.create2d;

  // This can be a static function, it's immutable anyways.
  function mapToTexture(tileID: number): string {
    switch(tileID) {
      case 0: return "bg_tile.png"
      case 1: return "fg_tile.png"

      case 2: return "blue_lock.png"
      case 3: return "red_lock.png"
      case 4: return "yellow_lock.png"
      case 5: return "green_lock.png"

      case 6: return "blue_key.png"
      case 7: return "red_key.png"
      case 8: return "yellow_key.png"
      case 9: return "green_key.png"

      case 10: return "chip.png"
      case 11: return "chip_socket.png"
      case 12: return "exit.png"
      default: throw new Error("How did this even get a different value? " + tileID)
    }
  }

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

  10 - chip.png - computer chip

  11 - chip_socket.png - blocks exit until you collect all chips

  12 - exit.png - exits the level

  in this case it just changes the window title to "You win!"

  No other levels, not enough time in this jam.
  */

  // This makes the map more readable
  // nothing & wall
  const _ = 0
  const w = 1
  
  // locks
  const B = 2
  const R = 3
  const Y = 4
  const G = 5

  // keys
  const b = 6
  const r = 7
  const y = 8
  const g = 9

  // chips & socket
  const C = 10
  const S = 11

  // exit
  const E = 12

  class BitsBattle extends WindowProgram {

    // I could break this down into functions, but I don't feel like it
    collisionDetection(newTile: number, x: number, y: number): boolean {
      switch(newTile) {
        case 0: return true
        case 1: return false
        case 2: {
          if (this.blueKeys > 0) {
            this.map[y][x] = 0
            this.blueKeys--
            return true
          }
          return false
        }
        case 3: {
          if (this.redKeys > 0) {
            this.map[y][x] = 0
            this.redKeys--
            return true
          }
          return false
        }
        case 4: {
          if (this.yellowKeys > 0) {
            this.map[y][x] = 0
            this.yellowKeys--
            return true
          }
          return false
        }
        case 5: {
          if (this.greenKeys > 0) {
            this.map[y][x] = 0
            this.greenKeys--
            return true
          }
          return false
        }
        case 6: {
          this.blueKeys++
          this.map[y][x] = 0
          return true
        }
        case 7: {
          this.redKeys++
          this.map[y][x] = 0
          return true
        }
        case 8: {
          this.yellowKeys++
          this.map[y][x] = 0
          return true
        }
        case 9: {
          this.greenKeys++
          this.map[y][x] = 0
          return true
        }

        default: return false
      }
    }

    blueKeys = 0
    redKeys = 0
    yellowKeys = 0
    greenKeys = 0


    loaded = false
    static counter = 0
    instance = 0
    //! Map is mutable!
    // 17x16
    // level 1 of chips challenge
    chipsRemaining = 11
    readonly MAP_WIDTH = 17
    readonly MAP_HEIGHT = 16
    // The second green key in level 1 doesn't go away.
    // I'm too lazy to implement this, so there's 2 green keys.
    map: number[][] = [
      [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
      [_,_,_,w,w,w,w,w,_,w,w,w,w,w,_,_,_],
      [_,_,_,w,_,_,_,w,w,w,_,_,_,w,_,_,_],
      [_,_,_,w,_,C,_,w,E,w,_,C,_,w,_,_,_],
      [_,w,w,w,w,w,G,w,S,w,G,w,w,w,w,w,_],
      [_,w,_,y,_,B,_,_,_,_,_,R,_,y,_,w,_],
      [_,w,_,C,_,w,b,_,_,_,r,w,_,C,_,w,_],
      [_,w,w,w,w,w,C,_,_,_,C,w,w,w,w,w,_],
      [_,w,_,C,_,w,b,_,_,_,r,w,_,C,_,w,_],
      [_,w,_,_,_,R,_,_,C,_,_,B,_,_,_,w,_],
      [_,w,w,w,w,w,w,Y,w,Y,w,w,w,w,w,w,_],
      [_,_,_,_,_,w,_,_,w,_,_,w,_,_,_,_,_],
      [_,_,_,_,_,w,_,C,w,C,_,w,_,_,_,_,_],
      [_,_,_,_,_,w,_,g,w,g,_,w,_,_,_,_,_],
      [_,_,_,_,_,w,w,w,w,w,w,w,_,_,_,_,_],
      [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
    ]

    upWasDown = false
    downWasDown = false
    leftWasDown = false
    rightWasDown = false

    // 9x9
    readonly VISIBLE_SIZE = 9
    readonly TILE_PIXEL_SIZE = 32
    readonly TILE_SCALE = 1.5
    readonly TILE_OFFSET = 32

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

      this.windowSize.x = 640
      this.windowSize.y = 480
      this.updateHandleWidth(640)

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

      const startX = this.pos.x - 4
      const startY = this.pos.y - 4

      // Create the initial tile buffers. FG blank, BG bg_tile
      // We're gonna create a little space in the top 

      for (let x = 0; x < this.VISIBLE_SIZE; x++) {
        for (let y = 0; y < this.VISIBLE_SIZE; y++) {
          for (let layer = 0; layer <= 1; layer ++) {

            const realX = x + startX
            const realY = y + startY

            // 1 is the foreground
            const tex = (layer == 1) ? "nothing.png" : "bg_tile.png"

            this.renderer.addElement(this.grabTileKey(x,y,layer), {
              name: this.grabTileKey(x,y,layer),
              hud_elem_type: HudElementType.image,
              position: create(0,0),
              text: tex,
              scale: create(this.TILE_SCALE,this.TILE_SCALE),
              alignment: create(1,1),
              offset: create(
                this.getPosX() + (x * (this.TILE_PIXEL_SIZE * this.TILE_SCALE)) + this.TILE_OFFSET,
                this.getPosY() + (y * (this.TILE_PIXEL_SIZE * this.TILE_SCALE)) + this.TILE_OFFSET,
              ),
              z_index: 1
            })
          }
        }
      }

      this.update()

      this.setWindowTitle("Bit's Battle")
    }

    update(): void {
      const startX = this.pos.x - 4
      const startY = this.pos.y - 4

      for (let x = 0; x < this.VISIBLE_SIZE; x++) {
        for (let y = 0; y < this.VISIBLE_SIZE; y++) {

          const realX = x + startX
          const realY = y + startY

          if (realX < 0 || realY < 0 || realX >= this.MAP_WIDTH || realY >= this.MAP_HEIGHT)  {
            continue
          }

          let texture = mapToTexture(this.map[realY][realX])

          if (realX == this.pos.x && realY == this.pos.y) {
            texture = "bit_byte.png"
          }

          this.renderer.setElementComponentValue(this.grabTileKey(x,y,1), "text", texture)
        }
      }
    }

    grabTileKey(x: number, y: number, layer: number): string {
      return "chips_challenge_tile_" + x + "_" + y + "_" + layer + "_" + this.instance
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

      this.loaded = true
      System.out.println("Bit's Battle loaded!");
    }



    tryMove(x: number, y: number): void {
      const newX = this.pos.x + x
      const newY = this.pos.y + y
      if (this.collisionDetection(this.map[newY][newX], newX, newY)) {
        this.pos.x = newX
        this.pos.y = newY
        this.update()
      }
    }

    doControls(): void {
      // Up is down and down is dow and right is down and left is down, this isn't confusing at all. I'm floating away at this point
      const upDown = this.system.isKeyDown("up")
      const upPressed = upDown && !this.upWasDown
      this.upWasDown = upDown
      const downDown = this.system.isKeyDown("down")
      const downPressed = downDown && !this.downWasDown
      this.downWasDown = downDown
      const leftDown = this.system.isKeyDown("left")
      const leftPressed = leftDown && !this.leftWasDown
      this.leftWasDown = leftDown
      const rightDown = this.system.isKeyDown("right")
      const rightPressed = rightDown && !this.rightWasDown
      this.rightWasDown = rightDown

      // Filter it like chips challenge, only one key at a time.
      if (upPressed) {
        print("up")
        this.tryMove(0, -1)
      } else if (downPressed) {
        print("down")
        this.tryMove(0, 1)
      } else if (leftPressed) {
        this.tryMove(-1, 0)
      } else if (rightPressed) {
        this.tryMove(1, 0)
      }
    }

    main(delta: number): void {
      if (!this.loaded) this.load()

      // print("bits battle instance " + this.instance + " is running " + delta)
      this.doControls()


      this.audioController.update(delta)
    }
  }


  DesktopEnvironment.registerProgram(BitsBattle)
}