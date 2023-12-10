namespace mineos {

  const create = vector.create2d;
  const color = colors.color;

  class Boom extends WindowProgram {

    readonly BUFFER_SIZE = 100
    readonly BUFFERS_ARRAY_WIDTH = 5

    loaded = false
    currentPixelCount = 0
    currentColor = color(0,0,0)
    pixelMemory: number[] = []
    zIndex = 0
    // readonly basePos = create(100,100)
    cache = create(0,0)
    
    buffers: string[][] = []

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {

      // Boom is special, it runs in 500x500 resolution because this is for a gamejam
      if (windowSize.x != 500 || windowSize.y != 500) {
        throw new Error("BOOM MUST RUN IN 500 X 500!")
      }
      super(system, renderer, audio, desktop, windowSize)
      const size = this.BUFFER_SIZE * this.BUFFER_SIZE

      for (let x = 0; x < this.BUFFERS_ARRAY_WIDTH; x++) {
        for (let y = 0; y < this.BUFFERS_ARRAY_WIDTH; y++) {

          this.buffers.push(Array.from({length: size}, (_,i) => "red"))

          this.renderer.addElement("boomBuffer" + x + " " + y, {
            name: "boomBuffer" + x + " " + y,
            hud_elem_type: HudElementType.image,
            position: create(0,0),
            text: "pixel.png",
            // number: this.currentColor,
            scale: create(1,1),
            alignment: create(1,1),
            offset: create(
              this.windowPosition.x + (this.BUFFER_SIZE * x),
              this.windowPosition.y + (this.BUFFER_SIZE * y),
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
    }

    drawPixel(x: number, y: number, r: number, g: number, b: number): void {
      const bufferX = math.floor(x / this.BUFFER_SIZE)
      const bufferY = math.floor(y / this.BUFFER_SIZE)
      const inBufferX = (x % this.BUFFER_SIZE)
      const inBufferY = (y % this.BUFFER_SIZE)

      // print(x + " " + bufferX + " | " + inBufferX)
      const currentBuffer = this.buffers[this.bufferKey(bufferX, bufferY)]
      currentBuffer[(inBufferX % this.BUFFER_SIZE) + (inBufferY * this.BUFFER_SIZE)] = color(r,g,b)
    }

    flushBuffer(): void {
      
    }

    offset = 0

    render(delta: number): void {
      this.clear()

      this.offset += delta * 100

      for (let x = 0; x < this.windowSize.x; x++) {
        for (let y = 0; y < this.windowSize.y; y++) {
          // if (x % 8 == 0 && y % 8 == 0) {
            // print((x / this.windowSize.x) * 100)
            const calc = (((x + this.offset) % this.windowSize.x) / this.windowSize.x)
            // print(calc)
            this.drawPixel(x,y, 
              calc * 100, 1, (y / this.windowSize.y) * 100)//y) 
          // }
        }
      }

      for (let x = 0; x < this.BUFFERS_ARRAY_WIDTH; x++) {
        for (let y = 0; y < this.BUFFERS_ARRAY_WIDTH; y++) {
          const currentBuffer = this.buffers[this.bufferKey(x,y)]
          const rawData = minetest.encode_base64(minetest.encode_png(this.BUFFER_SIZE, this.BUFFER_SIZE, currentBuffer, 9))
          this.renderer.setElementComponentValue("boomBuffer" + x + " " + y, "text", "[png:" + rawData)
        }
      }

      // for (let i = 0; i < this.buffer.length; i++) {
      //   this.buffer[i] = color(math.random() * 100, math.random() * 100, math.random() * 100)
      // }

      // 
      // this.renderer.setElementComponentValue("boomBuffer", "text", "[png:" + rawData)
      // print(rawData)
    }

    load(): void {
      
    }

    main(delta: number): void {
      if (!this.loaded) this.load()
      // print("BOOM BABY")
      this.render(delta)
    }

  }
  DesktopEnvironment.registerProgram(Boom)
}