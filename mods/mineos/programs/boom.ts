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


  // RGBA
  const CHANNELS = 4


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

  class Boom extends WindowProgram {
    readonly BUFFER_SIZE_Y = 100
    readonly BUFFER_SIZE_X = this.BUFFER_SIZE_Y * CHANNELS
    readonly BUFFERS_ARRAY_WIDTH = 5

    loaded = false
    currentPixelCount = 0
    clearColor = v3f(0,0,0)
    pixelMemory: number[] = []
    zIndex = 0
    // readonly basePos = create(100,100)
    cache = create(0,0)

    // Think of this as opengl buffering.
    // 0 - vsync off
    // 1 - vsync
    // 2 - double buffering
    // 3 - triple buffering
    // You can technically do values like 10 for really low FPS/crazy buffering. The world is your oyster.
    frameAccum = 0
    buffering = 0
    
    buffers: string[][] = []

    readonly mapWidth = 24
    readonly mapHeight = 24
    readonly worldMap: number[][] = [
      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1],
      [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1],
      [1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    ];

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {

      // Boom is special, it runs in 500x500 resolution because this is for a gamejam
      if (windowSize.x != 500 || windowSize.y != 500) {
        throw new Error("BOOM MUST RUN IN 500 X 500!")
      }
      super(system, renderer, audio, desktop, windowSize)

      const size = this.BUFFER_SIZE_X * this.BUFFER_SIZE_Y

      for (let x = 0; x < this.BUFFERS_ARRAY_WIDTH; x++) {
        for (let y = 0; y < this.BUFFERS_ARRAY_WIDTH; y++) {
          
          this.buffers.push(Array.from({length: size}, (_,i) => ((i + 1) % 4 == 0) ? char(255) : char(0)))

          this.renderer.addElement("boomBuffer" + x + " " + y, {
            name: "boomBuffer" + x + " " + y,
            hud_elem_type: HudElementType.image,
            position: create(0,0),
            text: "pixel.png",
            // number: this.currentColor,
            scale: create(1,1),
            alignment: create(1,1),
            offset: create(
              this.windowPosition.x + (this.BUFFER_SIZE_Y * x),
              this.windowPosition.y + (this.BUFFER_SIZE_Y * y),
            ),
            z_index: this.zIndex        
          })
        }
      }
    }
  
    bufferKey(x: number, y: number): number {
      return (x % this.BUFFERS_ARRAY_WIDTH) + (y * this.BUFFERS_ARRAY_WIDTH)
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

      for (let x = 0; x < this.BUFFERS_ARRAY_WIDTH; x++) {
        for (let y = 0; y < this.BUFFERS_ARRAY_WIDTH; y++) {

          const currentBuffer = this.buffers[this.bufferKey(x,y)]

          let stringThing = concat(currentBuffer)

          const rawPNG = encode_png(this.BUFFER_SIZE_Y,this.BUFFER_SIZE_Y, stringThing, 9)
          const rawData = encode_base64(rawPNG)

          this.renderer.setElementComponentValue("boomBuffer" + x + " " + y, "text", "[png:" + rawData)
        }
      }
    }

    

    rayCast() {
      const posX = 22
      const posY = 12
      const dirX = -1
      const dirY = 0
      const planeX = 0
      const planeY = 0.66
      const time = 0
      const oldTime = 0

      const w = this.windowSize.x
      const h = this.windowSize.y

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
        if(drawStart < 0) drawStart = 0;
        let drawEnd = lineHeight / 2 + h / 2;
        if(drawEnd >= h) drawEnd = h - 1;

        // Optimize this part
        let color: Vec3 = v3f();
        switch(this.worldMap[mapX][mapY]) {
          case 1:  color = v3f(255,0,0);    break; //red
          case 2:  color = v3f(0,255,0);  break; //green
          case 3:  color = v3f(0,0,255);   break; //blue
          case 4:  color = v3f(255,255,255);  break; //white
          default: color = v3f(255,255,0); break; //yellow
        }
      
        //give x and y sides different brightness
        if(side == 1) {
          color.x /= 2;
          color.y /= 2;
          color.z /= 2;
        }


      }
    }

    render(delta: number): void {
      this.clear()

      this.rayCast()

      // for (let x = 0; x < this.windowSize.x; x++) {
      //   for (let y = 0; y < this.windowSize.y; y++) {
      //     const calc = (((x + this.offset) % this.windowSize.x) / this.windowSize.x)
          //! cool colors:
          // this.drawPixel(x,y, calc * 100, 1, (y / this.windowSize.y) * 100)

          // this.drawPixel(x,y, floor(random() * 255), floor(random() * 255), floor(random() * 255))
        // }
      // }



      // this.drawLine(0,0, 100,200, "red");
      // this.drawModel();

      this.flushBuffers()
    }

    load(): void {
      
    }

    main(delta: number): void {
      if (!this.loaded) this.load()
      this.render(delta)
    }

  }
  DesktopEnvironment.registerProgram(Boom)
}