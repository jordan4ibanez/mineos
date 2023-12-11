namespace mineos {

  const v3f = vector.create;
  const v2f = vector.create2d;
  const create = vector.create2d;
  const color = colors.color;
  const floor = math.floor;
  const abs = math.abs;
  const char = string.char;
  const concat = table.concat
  const encode_png = minetest.encode_png;
  const encode_base64 = minetest.encode_base64;
  const random = math.random;
  const cos = math.cos;
  const sin = math.sin;
  const round = math.round;
  const yaw_to_dir = minetest.yaw_to_dir;


  // RGBA
  const CHANNELS = 4

  // Vector cache
  const vecA = vector.create(0,0,0)
  const vecB = vector.create(0,0,0)

  {
    const n = -1

    math.randomseed(os.time())
    let song: Song = new Song("boom_theme")
    song.tempo = 8
    song.volume = 0.5
    song.data["guitar"] = [

      0,0,0,0,6,0,0,5,
      0,0,0,0,6,0,0,5,
      0,0,0,0,6,0,0,5,
      0,0,3,n,n,n,n,n,

      0,0,0,0,6,0,0,5,
      0,0,0,0,6,0,0,5,
      0,0,0,0,6,0,0,5,
      0,0,3,n,n,n,n,n,

      0,0,0,0,6,0,0,5,
      0,0,0,0,6,0,0,5,
      0,0,0,0,6,0,0,5,
      0,0,3,n,n,n,n,n,

      //1
      3,5,10,5,3,5,10,3,
      1,5,10,5,1,5,10,1,
      0,5,10,5,0,5,10,0,
      0,5,9,5,0,5,9,0,
      //2
      3,5,10,5,3,5,10,3,
      1,5,10,5,1,5,10,1,
      0,5,10,5,0,5,10,0,
      0,5,9,5,0,5,9,0,
      //3
      3,5,10,5,3,5,10,3,
      1,5,10,5,1,5,10,1,
      0,5,10,5,0,5,10,0,
      0,5,9,5,0,5,9,0,
      //4
      3,5,10,5,3,5,10,3,
      1,5,10,5,1,5,10,1,
      0,5,10,5,0,5,10,0,
      0,5,9,5,0,5,9,0,
      //5
      3,5,10,5,3,5,10,3,
      1,5,10,5,1,5,10,1,
      0,5,10,5,0,5,10,0,
      0,5,9,5,0,5,9,0,
      //6
      3,5,10,5,3,5,10,3,
      1,5,10,5,1,5,10,1,
      0,5,10,5,0,5,10,0,
      0,5,9,5,0,5,9,0,

      //1
      3,10,5,3,10,5,3,5,
      1,10,5,1,10,5,1,5,
      0,10,5,0,10,5,0,5,
      0,9,5,0,9,5,0,5,
      //2
      3,10,5,3,10,5,3,5,
      1,10,5,1,10,5,1,5,
      0,10,5,0,10,5,0,5,
      0,9,5,0,9,5,0,5,
      //3
      3,10,5,3,10,5,3,5,
      1,10,5,1,10,5,1,5,
      0,10,5,0,10,5,0,5,
      0,9,5,0,9,5,0,5,
      //4
      3,10,5,3,10,5,3,5,
      1,10,5,1,10,5,1,5,
      0,10,5,0,10,5,0,5,
      0,9,5,0,9,5,0,5,
      //5
      3,10,5,3,10,5,3,5,
      1,10,5,1,10,5,1,5,
      0,10,5,0,10,5,0,5,
      0,9,5,0,9,5,0,5,
      //6
      3,10,5,3,10,5,3,5,
      1,10,5,1,10,5,1,5,
      0,10,5,0,10,5,0,5,
      0,9,5,0,9,5,0,5,
    ]
    // song.data["trumpet"] = Array.from({length: 256}, (_,i) => math.random(-1,11))
    // song.data["bassTrumpet"] = Array.from({length: 256}, (_,i) => math.random(-1,11))
    AudioController.registerSong(song)
  }


  // Following a tutorial on how to do this: https://lodev.org/cgtutor/raycasting.html

  function swap(i: number, z: number): [number, number] {
    const oldI = i
    i = z
    z = oldI
    return [i,z]
  }

  function v2swap(i: Vec2, z: Vec2): [Vec2, Vec2] {
    const oldI = i
    i = z
    z = oldI
    return [i, z]
  }

  class Sprite {
    x: number
    y: number
    texture: number
    constructor(x: number, y: number, texture: number) {
      this.x = x
      this.y = y
      this.texture = texture
    }
  }
  function s(x: number, y: number, texture: number): Sprite {
    return new Sprite(x,y,texture)
  }

  class Mob {
    alive = true
    x: number
    y: number
    yaw = random() * (math.pi * 2)
    footstepAccumulator = math.random()
    readonly sprite: number
    constructor(x: number, y: number, sprite: number) {
      this.x = x
      this.y = y
      this.sprite = sprite
    }
  }

  // Bullet is just another word for raycast
  class Bullet {
    x: number
    y: number
    dirX: number
    dirY: number
    constructor(x: number, y: number, dirX: number, dirY: number) {
      this.x = x
      this.y = y
      this.dirX = dirX
      this.dirY = dirY
    }
  }

  // This program does not have a dynamic buffer because it was enough trouble following a tutorial on a software raycaster.
  // Locked into 5/4 resolution at 800 x 640.
  class Boom extends WindowProgram {

    performanceBuffer: boolean = true
    performanceMode: boolean = false
    //! If you enable performanceBuffer in 4k, make sure you enable this as well!
    enable4kPerformanceMode = false
    inPerformanceMode = 1
    
    readonly BUFFER_SIZE_Y = 100
    readonly BUFFER_SIZE_X = this.BUFFER_SIZE_Y * CHANNELS
    BUFFERS_ARRAY_SIZE_X = 0//(this.performanceBuffer) ? 4 : 8
    BUFFERS_ARRAY_SIZE_Y = 0//(this.performanceBuffer) ? 4 : 7

    loaded = false
    currentPixelCount = 0
    clearColor = v3f(0,0,0)
    pixelMemory: number[] = []
    zIndex = 0
    // readonly basePos = create(100,100)
    cache = create(0,0)
    footstepAccumulator = 0

    shiftWasPressed = false
    auxWasPressed = false
    zWasPressed = false

    currentBullet: Bullet | null = null

    // Think of this as opengl buffering.
    // 0 - vsync off
    // 1 - vsync
    // 2 - double buffering
    // 3 - triple buffering
    // You can technically do values like 10 for really low FPS/crazy buffering. The world is your oyster.
    frameAccum = 0
    buffering = 0
    
    buffers: string[][] = []


    playerPos = create(22,12)
    playerDir = create(-1, 0)
    time = 0
    oldTime = 0
    planeX = 0
    planeY = 0.66
    readonly texWidth = 64
    readonly texHeight = 64

    readonly mapWidth = 24
    readonly mapHeight = 24

    readonly textures: number[][] = loadFile("programs/boom/png_data").fileData;

    readonly worldMap: number[][] = [
      [8,8,8,8,8,8,8,8,8,8,8,4,4,6,4,4,6,4,6,4,4,4,6,4],
      [8,0,0,0,0,0,0,0,0,0,8,4,0,0,0,0,0,0,0,0,0,0,0,4],
      [8,0,3,3,0,0,0,0,0,8,8,4,0,0,0,0,0,0,0,0,0,0,0,6],
      [8,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6],
      [8,0,3,3,0,0,0,0,0,8,8,4,0,0,0,0,0,0,0,0,0,0,0,4],
      [8,0,0,0,0,0,0,0,0,0,8,4,0,0,0,0,0,6,6,6,0,6,4,6],
      [8,8,8,8,0,8,8,8,8,8,8,4,4,4,4,4,4,6,0,0,0,0,0,6],
      [7,7,7,7,0,7,7,7,7,0,8,0,8,0,8,0,8,4,0,4,0,6,0,6],
      [7,7,0,0,0,0,0,0,7,8,0,8,0,8,0,8,8,6,0,0,0,0,0,6],
      [7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,6,0,0,0,0,0,4],
      [7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,6,0,6,0,6,0,6],
      [7,7,0,0,0,0,0,0,7,8,0,8,0,8,0,8,8,6,4,6,0,6,6,6],
      [7,7,7,7,0,7,7,7,7,8,8,4,0,6,8,4,8,3,3,3,0,3,3,3],
      [2,2,2,2,0,2,2,2,2,4,6,4,0,0,6,0,6,3,0,0,0,0,0,3],
      [2,2,0,0,0,0,0,2,2,4,0,0,0,0,0,0,4,3,0,0,0,0,0,3],
      [2,0,0,0,0,0,0,0,2,4,0,0,0,0,0,0,4,3,0,0,0,0,0,3],
      [1,0,0,0,0,0,0,0,1,4,4,4,4,4,6,0,6,3,3,0,0,0,3,3],
      [2,0,0,0,0,0,0,0,2,2,2,1,2,2,2,6,6,0,0,5,0,5,0,5],
      [2,2,0,0,0,0,0,2,2,2,0,0,0,2,2,0,5,0,5,0,0,0,5,5],
      [2,0,0,0,0,0,0,0,2,0,0,0,0,0,2,5,0,5,0,5,0,5,0,5],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5],
      [2,0,0,0,0,0,0,0,2,0,0,0,0,0,2,5,0,5,0,5,0,5,0,5],
      [2,2,0,0,0,0,0,2,2,2,0,0,0,2,2,0,5,0,5,0,0,0,5,5],
      [2,2,2,2,1,2,2,2,2,2,2,1,2,2,2,5,5,5,5,5,5,5,5,5]
    ]

    // Mobs point into the sprite array
    mobs: Mob[] = []


    sprite: Sprite[] = [
      s(20.5, 11.5, 10), //green light in front of playerstart
      //green lights in every room
      s(18.5,4.5, 10),
      s(10.0,4.5, 10),
      s(10.0,12.5,10),
      s(3.5, 6.5, 10),
      s(3.5, 20.5,10),
      s(3.5, 14.5,10),
      s(14.5,20.5,10),

      //row of pillars in front of wall: fisheye test
      s(18.5, 10.5, 9),
      s(18.5, 11.5, 9),
      s(18.5, 12.5, 9),

      //some barrels around the map
      s(21.5, 1.5, 8),
      s(15.5, 1.5, 8),
      s(16.0, 1.8, 8),
      s(16.2, 1.2, 8),
      s(3.5,  2.5, 8),
      s(9.5, 15.5, 8),
      s(10.0, 15.1,8),
      s(10.5, 15.8,8),
    ]

    ZBuffer: number[]
    spriteOrder: number[]
    spriteDistance: number[]

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {

      // Boom is special, it runs in 500x500 resolution because this is for a gamejam
      // if (windowSize.x != 500 || windowSize.y != 500) {
      //   throw new Error("BOOM MUST RUN IN 500 X 500!")
      // }

      super(system, renderer, audio, desktop, windowSize)

      for (let i = 0; i < 40; i++) {
        this.sprite.push(s(20.5, 11.5, math.random(11,12)))

        this.mobs.push(new Mob(
          20.5, 12.5, this.sprite.length - 1
        ))
      }

      

      // for (const arr of this.textures) {
        // print("Length: " + arr.length)
        // print("GOAL: " + (this.texHeight * this.texWidth * CHANNELS))
        // assert(arr.length == this.texHeight * this.texWidth * CHANNELS)
        // print(this.texHeight * this.texWidth * CHANNELS)
      // }

      this.ZBuffer = Array.from({length: this.windowSize.x}, (_,i) => 0)
      this.spriteOrder = Array.from({length: this.sprite.length}, (_,i) => 0)
      this.spriteDistance = Array.from({length: this.sprite.length}, (_,i) => 0)

      this.generateBuffers()

    }

    generateBuffers(): void {

      this.BUFFERS_ARRAY_SIZE_X = (this.performanceBuffer) ? 4 : 8
      this.BUFFERS_ARRAY_SIZE_Y = (this.performanceBuffer) ? 4 : 7

      const size = this.BUFFER_SIZE_X * this.BUFFER_SIZE_Y

      this.setWindowSize(
        this.BUFFER_SIZE_Y * this.BUFFERS_ARRAY_SIZE_X,
        (this.BUFFER_SIZE_Y * this.BUFFERS_ARRAY_SIZE_X) * (4 / 5)
      )
      this.updateHandleWidth(this.BUFFER_SIZE_Y * 4)

      for (let x = 0; x < this.BUFFERS_ARRAY_SIZE_X; x++) {
        for (let y = 0; y < this.BUFFERS_ARRAY_SIZE_Y; y++) {
          
          this.buffers.push(Array.from({length: size}, (_,i) => ((i + 1) % 4 == 0) ? char(0) : char(0)))

          const buffer_scale = (this.enable4kPerformanceMode) ?
            create(2,2) : create (1,1)

          this.renderer.addElement("boomBuffer" + x + " " + y, {
            name: "boomBuffer" + x + " " + y,
            hud_elem_type: HudElementType.image,
            position: create(0,0),
            text: "pixel.png",
            // number: this.currentColor,
            scale: buffer_scale,
            alignment: create(1,1),
            offset: create(
              this.getPosX() + (this.BUFFER_SIZE_Y * x * ((this.enable4kPerformanceMode) ? 2 : 1)),
              this.getPosY() + (this.BUFFER_SIZE_Y * y * ((this.enable4kPerformanceMode) ? 2 : 1)),
            ),
            z_index: this.zIndex        
          })
        }
      }
    }


    cleanAllBuffers(): void {
      for (let x = 0; x < this.BUFFERS_ARRAY_SIZE_X; x++) {
        for (let y = 0; y < this.BUFFERS_ARRAY_SIZE_Y; y++) {
          const id = "boomBuffer" + x + " " + y
          this.renderer.removeElement(id)
        }
      }
      this.buffers = []
    }

    cyclePerformanceMode(): void {

      this.inPerformanceMode++
      if (this.inPerformanceMode > 2) {
        this.inPerformanceMode = 0
      }
      switch (this.inPerformanceMode) {
        case 0: {
          print("ULTRA QUALITY")
          this.performanceBuffer = false
          this.enable4kPerformanceMode = false
          this.cleanAllBuffers()
          this.generateBuffers()
          break
        }
        case 1: {
          print("LOW QUALITY")
          this.performanceBuffer = true
          this.cleanAllBuffers()
          this.generateBuffers()
          break
        }
        case 2: {
          print("LOW QUALITY 4k")
          this.enable4kPerformanceMode = true
          const buffer_scale = (this.enable4kPerformanceMode) ?
            create(2,2) : create (1,1)

          for (let x = 0; x < this.BUFFERS_ARRAY_SIZE_X; x++) {
            for (let y = 0; y < this.BUFFERS_ARRAY_SIZE_Y; y++) {
              const id = "boomBuffer" + x + " " + y
              this.renderer.setElementComponentValue(
                id,
                "scale", 
                buffer_scale
              )
              this.renderer.setElementComponentValue(
                id,
                "offset", 
                create(
                  this.getPosX() + (this.BUFFER_SIZE_Y * x * ((this.enable4kPerformanceMode) ? 2 : 1)),
                  this.getPosY() + (this.BUFFER_SIZE_Y * y * ((this.enable4kPerformanceMode) ? 2 : 1)),
                )
              )
            }
          }
          // This is a special case because we're upscaling the framebuffer, which means the window isn't correctly sized OOPS
          this.updateHandleWidth(this.windowSize.x * 2)

          break
        }
      }

    }

  
    bufferKey(x: number, y: number): number {
      return (x % this.BUFFERS_ARRAY_SIZE_X) + (y * this.BUFFERS_ARRAY_SIZE_X)
    }

    clear(): void {
      for (let x = 0; x < this.windowSize.x; x++) {
        for (let y = 0; y < this.windowSize.y; y++) {
          this.drawPixel(x,y, this.clearColor.x, this.clearColor.y, this.clearColor.z)
        }
      }
    }

    drawPixel(x: number, y: number, r: number, g: number, b: number): void {
      x = floor(x)
      y = floor(y)

      const bufferX = floor(x / this.BUFFER_SIZE_Y)
      const bufferY = floor(y / this.BUFFER_SIZE_Y)

      const currentBuffer = this.buffers[this.bufferKey(bufferX, bufferY)]

      const inBufferX = (x % this.BUFFER_SIZE_Y)
      const inBufferY = (y % this.BUFFER_SIZE_Y)

      const index = ((inBufferX % this.BUFFER_SIZE_Y) + (inBufferY * this.BUFFER_SIZE_Y)) * CHANNELS

      currentBuffer[index] = char(floor(r))
      currentBuffer[index + 1] = char(floor(g))
      currentBuffer[index + 2] = char(floor(b))
      currentBuffer[index + 3] = char(floor(255))
    }

    flushBuffers() {
      this.frameAccum++
      if (this.frameAccum > this.buffering) {
        this.frameAccum = 0
      } else {
        // print ("skipped " + this.frameAccum)
        return
      }

      for (let x = 0; x < this.BUFFERS_ARRAY_SIZE_X; x++) {
        for (let y = 0; y < this.BUFFERS_ARRAY_SIZE_Y; y++) {

          const currentBuffer = this.buffers[this.bufferKey(x,y)]

          let stringThing = concat(currentBuffer)

          const rawPNG = encode_png(this.BUFFER_SIZE_Y,this.BUFFER_SIZE_Y, stringThing, 9)
          const rawData = encode_base64(rawPNG)

          this.renderer.setElementComponentValue("boomBuffer" + x + " " + y, "text", "[png:" + rawData)
        }
      }
    }

    // https://github.com/ssloy/tinyrenderer/wiki/Lesson-1:-Bresenham%E2%80%99s-Line-Drawing-Algorithm#timings-fifth-and-final-attempt
    drawLine(x0: number, y0: number, x1: number, y1: number, r: number, b: number, g: number): void {

      let steep = false

      if (math.abs(x0 - x1) < math.abs(y0 - y1)) {
        [x0,y0] = swap(x0, y0);
        [x1,y1] = swap(x1, y1);
        steep = true
      }
      if (x0 > x1) {
        [x0, x1] = swap(x0, x1);
        [y0, y1] = swap(y0, y1);
      }

      let dx = x1 - x0;
      let dy = y1 - y0;
      let derror2 = math.abs(dy) * 2;
      let error2 = 0
      let y = y0

      for (let x = x0; x <= x1; x++) {
        if (steep) {
          this.drawPixel(y, x, r, g, b)
        } else {
          this.drawPixel(x, y, r, g, b)
        }
        error2 += derror2
        if (error2 > dx) {
          y += (y1 > y0) ? 1 : -1
          error2 -= dx * 2
        }
      }
    }


    playerControls(delta: number) {

      // Toggle capturing mouse with aux1
      const auxPressed = this.system.isKeyDown("aux1")
      if (auxPressed && !this.auxWasPressed) {
        if (this.desktop.isMouseLocked()) {
          this.desktop.unlockMouse()
        } else {
          this.desktop.lockMouse()
        }
      }

      this.auxWasPressed = auxPressed

      // Don't control boom if the mouse isn't locked into the window
      if (!this.desktop.isMouseLocked()) {
        return
      }

      const shiftPressed = this.system.isKeyDown("sneak")

      if (shiftPressed && !this.shiftWasPressed) {
        this.performanceMode = !this.performanceMode
      }

      this.shiftWasPressed = shiftPressed

      const zPressed = this.system.isKeyDown("zoom")

      if (zPressed && !this.zWasPressed) {
        this.cyclePerformanceMode()
      }

      this.zWasPressed = zPressed


      if (this.system.isMouseClicked()) {
        this.currentBullet = new Bullet(
          this.playerPos.x,
          this.playerPos.y,
          this.playerDir.x,
          this.playerDir.y
        )
        this.audioController.playSound("gunshot", 1)
      }

      const moveSpeed = delta * 5.0
      
      let moving = false

      if (this.system.isKeyDown("up")) {
        if(this.worldMap[floor(this.playerPos.x + this.playerDir.x * moveSpeed)][floor(this.playerPos.y)] == 0) {
          this.playerPos.x += this.playerDir.x * moveSpeed;
        }
        if(this.worldMap[floor(this.playerPos.x)][floor(this.playerPos.y + this.playerDir.y * moveSpeed)] == 0) {
          this.playerPos.y += this.playerDir.y * moveSpeed;
        }
        moving = true
      }

      if (this.system.isKeyDown("down")) {
        if(this.worldMap[floor(this.playerPos.x - this.playerDir.x * moveSpeed)][floor(this.playerPos.y)] == 0) {
          this.playerPos.x -= this.playerDir.x * moveSpeed;
        }
        if(this.worldMap[floor(this.playerPos.x)][floor(this.playerPos.y - this.playerDir.y * moveSpeed)] == 0){
          this.playerPos.y -= this.playerDir.y * moveSpeed;
        }
        moving = true
      }

      if (this.system.isKeyDown("right")) {

        if(this.worldMap[floor(this.playerPos.x + this.planeX * moveSpeed)][floor(this.playerPos.y)] == 0) {
          this.playerPos.x += this.planeX * moveSpeed;
        }
        if(this.worldMap[floor(this.playerPos.x)][floor(this.playerPos.y + this.planeY * moveSpeed)] == 0) {
          this.playerPos.y += this.planeY * moveSpeed;
        }
        moving = true
      }

      if (this.system.isKeyDown("left")) {

        if(this.worldMap[floor(this.playerPos.x - this.planeX * moveSpeed)][floor(this.playerPos.y)] == 0) {
          this.playerPos.x -= this.planeX * moveSpeed;
        }
        if(this.worldMap[floor(this.playerPos.x)][floor(this.playerPos.y - this.planeY * moveSpeed)] == 0) {
          this.playerPos.y -= this.planeY * moveSpeed;
        }
        moving = true
      }

      // print(this.system.getMouseDelta().x)

      const rotSpeed = this.system.getMouseDelta().x
      let oldDirX = this.playerDir.x;
      this.playerDir.x = this.playerDir.x * cos(-rotSpeed) - this.playerDir.y * sin(-rotSpeed);
      this.playerDir.y = oldDirX * sin(-rotSpeed) + this.playerDir.y * cos(-rotSpeed);
      let oldPlaneX = this.planeX;
      this.planeX = this.planeX * cos(-rotSpeed) - this.planeY * sin(-rotSpeed);
      this.planeY = oldPlaneX * sin(-rotSpeed) + this.planeY * cos(-rotSpeed);

      if (moving) {
        this.footstepAccumulator += delta

        if (this.footstepAccumulator >= 0.5) {
          this.playFootstep()
          this.footstepAccumulator = 0
        }
        // print(this.footstepAccumulator)
      }
    }

    playFootstep() {
      this.audioController.playNote("footstep", math.random(0,5))
    }

    sortSprites(): void {
      const amount = this.sprite.length

      // was: std::vector<std::pair<double, int>> sprites(amount);
      let sprites: [number, number][] = Array.from({length: amount}, (_,i) => [0,0])

      // Was array pointer
      let order = this.spriteOrder
      let dist = this.spriteDistance

      for(let i = 0; i < amount; i++) {
        sprites[i][0] = dist[i];
        sprites[i][1] = order[i];
      }
      
      //  std::sort(sprites.begin(), sprites.end());
      table.sort(sprites, (a: [number, number], b: [number, number]) => a[0] < b[0])
      
      // restore in reverse order to go from farthest to nearest
      for(let i = 0; i < amount; i++) {
        dist[i] = sprites[amount - i - 1][0];
        order[i] = sprites[amount - i - 1][1];
      }
    }

    rayCast(): void {
      const posX = this.playerPos.x
      const posY = this.playerPos.y
      const dirX = this.playerDir.x
      const dirY = this.playerDir.y
      const planeX = this.planeX
      const planeY = this.planeY

      const w = this.windowSize.x
      const h = this.windowSize.y
      const screenHeight = h
      const screenWidth = w

      // Floorcasting
      for(let y = 0; y < h; y++) {
        let rayDirX0 = dirX - planeX;
        let rayDirY0 = dirY - planeY;
        let rayDirX1 = dirX + planeX;
        let rayDirY1 = dirY + planeY;
        let p = y - screenHeight / 2;
        let posZ = 0.5 * screenHeight;

        let rowDistance = posZ / p;
        let floorStepX = rowDistance * (rayDirX1 - rayDirX0) / screenWidth;
        let floorStepY = rowDistance * (rayDirY1 - rayDirY0) / screenWidth;

        let floorX = posX + rowDistance * rayDirX0;
        let floorY = posY + rowDistance * rayDirY0;

        for(let x = 0; x < screenWidth; ++x) {
          let cellX = floor(floorX);
          let cellY = floor(floorY);

          // get the texture coordinate from the fractional part
          let tx = floor(bit.band(this.texWidth * (floorX - cellX), (this.texWidth - 1))) ;
          let ty = floor(bit.band(this.texHeight * (floorY - cellY), (this.texHeight - 1)));

          //? Make the ceiling/floor look horrible to improve performance
          if (this.performanceMode) {
            tx = floor(tx / 4) * 4
            ty = floor(ty / 4) * 4
          }
          

          floorX += floorStepX;
          floorY += floorStepY;

          // choose texture and draw the pixel
          let floorTexture = 3;
          let ceilingTexture = 6;

           {// floor
            const container = this.textures[floorTexture]
            const index = (this.texWidth * ty + tx) * CHANNELS
            let r: number = container[index]
            let g: number = container[index + 1]
            let b: number = container[index + 2]

            this.drawPixel(x,y, r, g, b)
          }
          {
            const container = this.textures[ceilingTexture]
            const index = (this.texWidth * ty + tx) * CHANNELS
            let r: number = container[index]
            let g: number = container[index + 1]
            let b: number = container[index + 2]

            //ceiling (symmetrical, at screenHeight - y - 1 instead of y)
            // make a bit darker
            r = bit.band(bit.rshift(r, 1), 8355711)
            g = bit.band(bit.rshift(g, 1), 8355711)
            b = bit.band(bit.rshift(b, 1), 8355711)

            this.drawPixel(x,screenHeight - y - 1, r, g, b)
          }
        }
        
      }

      // Wallcasting
      for (let x = 0; x < w; x++) {
        let cameraX = 2 * x / w - 1
        let rayDirX = dirX + planeX * cameraX
        let rayDirY = dirY + planeY * cameraX

        let mapX = floor(posX)
        let mapY = floor(posY)

        let sideDistX = 0
        let sideDistY = 0

        let deltaDistX = (rayDirX == 0) ? 1e30 : abs(1 / rayDirX)
        let deltaDistY = (rayDirY == 0) ? 1e30 : abs(1 / rayDirY)

        let perpWallDist = 0

        let stepX = 0
        let stepY = 0

        let hit = 0
        let side = 0

        if (rayDirX < 0) {
          stepX = -1
          sideDistX = (posX - mapX) * deltaDistX
        } else {
          stepX = 1
          sideDistX = (mapX + 1.0 - posX) * deltaDistX
        }
        if (rayDirY < 0) {
          stepY = -1
          sideDistY = (posY - mapY) * deltaDistY
        } else {
          stepY = 1
          sideDistY = (mapY + 1.0 - posY) * deltaDistY
        }

        while(hit == 0) {
          if (sideDistX < sideDistY) {
            sideDistX += deltaDistX;
            mapX += stepX;
            side = 0;
          } else {
            sideDistY += deltaDistY;
            mapY += stepY;
            side = 1;
          }

          if (this.worldMap[mapX][mapY] > 0) hit = 1;
        }

        if(side == 0) perpWallDist = (sideDistX - deltaDistX);
        else          perpWallDist = (sideDistY - deltaDistY);

        //Calculate height of line to draw on screen
        let lineHeight = floor(h / perpWallDist);

        //calculate lowest and highest pixel to fill in current stripe
        let drawStart = -lineHeight / 2 + h / 2;
        if (drawStart < 0) drawStart = 0;
        let drawEnd = lineHeight / 2 + h / 2;
        if (drawEnd >= h) drawEnd = h - 1;

        let wallX; //where exactly the wall was hit
        if (side == 0) {
          wallX = posY + perpWallDist * rayDirY;
        } else {
          wallX = posX + perpWallDist * rayDirX;
        }
        wallX -= floor(wallX);

        //x coordinate on the texture
        let texX = 0
        if (this.performanceMode) {
          const precision = 64
          const divisor = 4
          texX = floor(((floor((wallX * precision) / divisor) * divisor) / precision) * this.texWidth);
        } else {
          texX = floor(wallX * this.texWidth);
        }

        if (side == 0 && rayDirX > 0) {
          texX = this.texWidth - texX - 1;
        }
        if (side == 1 && rayDirY < 0) {
          texX = this.texWidth - texX - 1;
        }

        // Textured
        const texNum = this.worldMap[mapX][mapY] - 1;

        // How much to increase the texture coordinate per screen pixel
        let step = 1.0 * this.texHeight / lineHeight;
        // Starting texture coordinate
        let texPos = (drawStart - h / 2 + lineHeight / 2) * step;
        for(let y = drawStart; y < drawEnd; y++) {
          // Cast the texture coordinate to integer, and mask with (texHeight - 1) in case of overflow
          
          let texY = 0 
          if (this.performanceMode) {
            texY = bit.band(floor(texPos / 4) * 4, (this.texHeight - 1));
          } else {
            texY = bit.band(floor(texPos), (this.texHeight - 1));
          }
          texPos += step;
          const container = this.textures[texNum]
          const index = (this.texHeight * texY + texX) * CHANNELS
          let r: number = container[index]
          let g: number = container[index + 1]
          let b: number = container[index + 2]
          //make color darker for y-sides: R, G and B byte each divided through two with a "shift" and an "and"
          if(side == 1) {
            r = bit.band(bit.rshift(r, 1), 8355711)
            g = bit.band(bit.rshift(g, 1), 8355711)
            b = bit.band(bit.rshift(b, 1), 8355711)
          };
          this.drawPixel(x,y, r, g, b)
        }
        
        // Set the Depth Buffer
        this.ZBuffer[x] = perpWallDist

        // Untextured

        // Optimize this part
        // let color: Vec3 = v3f();
        // switch(this.worldMap[mapX][mapY]) {
        //   case 1:  color = v3f(255,0,0);    break; //red
        //   case 2:  color = v3f(0,255,0);  break; //green
        //   case 3:  color = v3f(0,0,255);   break; //blue
        //   case 4:  color = v3f(255,255,255);  break; //white
        //   default: color = v3f(255,255,0); break; //yellow
        // }
        //give x and y sides different brightness
        // if(side == 1) {
        //   color.x /= 2;
        //   color.y /= 2;
        //   color.z /= 2;
        // }

        // this.drawLine(
        //   x, drawStart,
        //   x, drawEnd,
        //   color.x,
        //   color.y,
        //   color.z
        // )

      }

      // Spritecasting
      // Sort the sprites from far to close
      for(let i = 0; i < this.sprite.length; i++) {
        this.spriteOrder[i] = i;
        this.spriteDistance[i] = ((posX - this.sprite[i].x) * (posX - this.sprite[i].x) + (posY - this.sprite[i].y) * (posY - this.sprite[i].y)); //sqrt not taken, unneeded
      }

      this.sortSprites();

      const numSprites = this.sprite.length

      for(let i = 0; i < numSprites; i++) {
        let spriteX = this.sprite[this.spriteOrder[i]].x - posX;
        let spriteY = this.sprite[this.spriteOrder[i]].y - posY;
        let invDet = 1.0 / (planeX * dirY - dirX * planeY);
        let transformX = invDet * (dirY * spriteX - dirX * spriteY);
        let transformY = invDet * (-planeY * spriteX + planeX * spriteY);
        let spriteScreenX = floor((w / 2) * (1 + transformX / transformY));
        let spriteHeight = abs(floor(h / (transformY)));
        let drawStartY = floor(-spriteHeight / 2 + h / 2);
        if(drawStartY < 0) drawStartY = 0;
        let drawEndY = floor(spriteHeight / 2 + h / 2);
        if(drawEndY >= h) drawEndY = h - 1;
        //calculate width of the sprite
        let spriteWidth = abs(floor(h / (transformY)));
        let drawStartX = floor(-spriteWidth / 2 + spriteScreenX);
        if(drawStartX < 0) drawStartX = 0;
        let drawEndX = spriteWidth / 2 + spriteScreenX;
        if(drawEndX >= w) drawEndX = w - 1;
        //loop through every vertical stripe of the sprite on screen
        for(let stripe = drawStartX; stripe < drawEndX; stripe++) {
          let texX = floor((256 * (stripe - (-spriteWidth / 2 + spriteScreenX)) * this.texWidth / spriteWidth) / 256);
          if(transformY > 0 && stripe > 0 && stripe < w && transformY < this.ZBuffer[stripe]) {
            // for every pixel of the current stripe
            for(let y = drawStartY; y < drawEndY; y++) {
              let d = floor((y) * 256 - h * 128 + spriteHeight * 128); //256 and 128 factors to avoid floats
              let texY = floor(((d * this.texHeight) / spriteHeight) / 256);

              const selectedTexture = this.sprite[this.spriteOrder[i]].texture
              const container = this.textures[selectedTexture]
              const index = (this.texWidth * math.clamp(0,16379, texY) + math.clamp(0, 16379, texX)) * CHANNELS

              let r: number = container[index]
              let g: number = container[index + 1]
              let b: number = container[index + 2]
              let a: number = container[index + 3]

              if (a > 0) {
                this.drawPixel(stripe, y, r,g,b)
              }
            }
          }
        }
      }
    }

    drawCrosshair(): void {
      // This isn't accurate for some reason
      const centerX = floor(this.windowSize.x / 2)
      const centerY = floor(this.windowSize.y / 2)
      const crossHairWidth = 10
      this.drawLine(centerX - crossHairWidth, centerY, centerX + crossHairWidth, centerY, 255,255,255)
      this.drawLine(centerX, centerY - crossHairWidth, centerX, centerY + crossHairWidth, 255,255,255)
    }

    render(delta: number): void {
      this.clear()
      this.rayCast()
      this.drawCrosshair()
      this.flushBuffers()
    }

    load(): void {
      this.desktop.lockMouse()
      // This is horrible
      this.audioController.playSong("boom_theme")
      this.loaded = true
    }

    mobsThink(delta: number): void {
      const moveSpeed = delta * 5.0

      for (let mob of this.mobs) {
        if (!mob.alive) continue

        const dir = yaw_to_dir(mob.yaw)
        let hit = false

        if(this.worldMap[floor(mob.x + dir.x * moveSpeed)][floor(mob.y)] == 0) {
          mob.x += dir.x * moveSpeed;
        } else {
          hit = true
        }
        if(this.worldMap[floor(mob.x)][floor(mob.y + dir.z * moveSpeed)] == 0) {
          mob.y += dir.z * moveSpeed;
        } else {
          hit = true
        }

        if (hit) {
          mob.yaw = math.random() * (math.pi * 2)
        }

        mob.footstepAccumulator += delta
        if (mob.footstepAccumulator > 0.5 + math.random()) {
          mob.footstepAccumulator = 0
          this.playFootstep()
        }

        // Then update the sprite
        const sp = this.sprite[mob.sprite]
        sp.x = mob.x
        sp.y = mob.y
      }
    }

    addBulletHole(x: number, z: number): void {
      this.spriteOrder.push(0)
      this.spriteDistance.push(0)
      this.sprite.push(s(
        x,z,15
      ))
    }

    processBullet(): void {
      if (!this.currentBullet) return

      let bullet = this.currentBullet;

      let hitWall = false
      let hitMob = false

      const moveSpeed = 0.01

      let firstIter = true

      while (!hitWall && !hitMob) {
        if(this.worldMap[floor(bullet.x + bullet.dirX * moveSpeed)][floor(bullet.y)] == 0) {
          bullet.x += bullet.dirX * moveSpeed;
        } else {
          hitWall = true
          break;
        }
        if(this.worldMap[floor(bullet.x)][floor(bullet.y + bullet.dirY * moveSpeed)] == 0) {
          bullet.y += bullet.dirY * moveSpeed;
        } else {
          hitWall = true
          break;
        }

        vecA.x = bullet.x
        vecA.y = bullet.y

        // Stop this from randomly killing mobs behind you
        if (!firstIter) {
          for (const mob of this.mobs) {
            vecB.x = mob.x
            vecB.y = mob.y

            const dist = vector.distance(vecA, vecB)
            if (dist < 0.4 && mob.alive) {
              mob.alive = false
              this.sprite[mob.sprite].texture += 2
              hitMob = true;
              break
            }
          }
          if (hitMob) {
            break
          }
        }
        firstIter = false
      }

      if (hitMob) {
        this.audioController.playSoundDelay("mobExplode", 1, 0.15)
        this.currentBullet = null
      }

      if (hitWall) {
        if (this.currentBullet != null) {
          this.addBulletHole(this.currentBullet.x, this.currentBullet.y)
        }
        this.audioController.playSoundDelay("bulletRicochet", 1, 0.15)
        this.currentBullet = null
      }
    }

    main(delta: number): void {
      if (!this.loaded) this.load()
      this.audioController.update(delta)
      this.mobsThink(delta)
      this.playerControls(delta)
      this.processBullet()
      this.render(delta)
    }

  }
  DesktopEnvironment.registerProgram(Boom)
}