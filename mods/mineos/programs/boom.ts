namespace mineos {

  const create = vector.create2d;
  const color = colors.colorHEX;

  class Boom extends WindowProgram {

    loaded = false
    currentPixelCount = 0
    currentColor = color(0,0,0)
    pixelMemory: number[] = []
    zIndex = 0
    // readonly basePos = create(100,100)
    cache = create(0,0)
    
    buffer: string[]
    

    constructor(system: System, renderer: Renderer, audio: AudioController, desktop: DesktopEnvironment, windowSize: Vec2) {
      super(system, renderer, audio, desktop, windowSize)
      const size = windowSize.x * windowSize.y
      this.buffer = Array.from({length: size}, (_,i) => "red")
      this.renderer.addElement("boomBuffer", {
        name: "boomBuffer",
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png",
        // number: this.currentColor,
        scale: create(1,1),
        alignment: create(1,1),
        offset: this.windowPosition,
        z_index: this.zIndex        
      })
    }

    test() {
      // minetest.encode_png
      // minetest.encode_base64
      
    }

    clear(): void {
      // print(this.pixelMemory.length)
      // for (let i = 0; i < this.pixelMemory.length; i++) {
      //   this.renderer.rawDelete(this.pixelMemory[i])
      // }
      // this.pixelMemory = []
    }

    drawPixel(x: number, y: number): void {
      // this.cache.x = x + this.basePos.x
      // this.cache.y = y + this.basePos.y
      // // print(pixelID)
      // const pixelID = this.renderer.rawDraw({
      //   name: "",
      //   hud_elem_type: HudElementType.image,
      //   position: create(0,0),
      //   text: "pixel.png",
      //   // number: this.currentColor,
      //   scale: create(1,1),
      //   alignment: create(1,1),
      //   offset: this.cache,
      //   z_index: this.zIndex
      // })
      // this.pixelMemory.push(pixelID)
      // this.zIndex++
    }

    flushBuffer(): void {
      
    }

    render(): void {
      this.clear()

      for (let x = 0; x < this.windowSize.x; x++) {
        for (let y = 0; y < this.windowSize.y; y++) {
          if (x % 8 == 0 && y % 8 == 0) {
            this.drawPixel(x,y) 
          }
        }
      }

      const rawData = minetest.encode_base64(minetest.encode_png(this.windowSize.x, this.windowSize.y, this.buffer, 9))
      this.renderer.setElementComponentValue("boomBuffer", "text", "[png:" + rawData)
      // print(rawData)
    }

    load(): void {
      
    }

    main(delta: number): void {
      if (!this.loaded) this.load()
      // print("BOOM BABY")
      this.render()
    }

  }
  DesktopEnvironment.registerProgram(Boom)
}