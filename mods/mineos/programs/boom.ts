namespace mineos {

  const v3f = vector.create;
  const v2f = vector.create2d;
  const create = vector.create2d;
  const color = colors.color;

  // Following a tutorial on how to do this: https://github.com/ssloy/tinyrenderer/wiki

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

  function v2add(a: Vec2, b: Vec2): Vec2 {
    return v2f(
      a.x + b.x,
      a.y + b.y
    )
  }
  function v2sub(a: Vec2, b: Vec2): Vec2 {
    return v2f(
      a.x - b.x,
      a.y - b.y
    )
  }
  function v2mul(a: Vec2, scalar: number): Vec2 {
    return v2f(
      a.x * scalar,
      a.y * scalar
    )
  }
  function v3pow(a: Vec3, b: Vec3): Vec3 {
    return v3f(
      a.x ^ b.x,
      a.y ^ b.y,
      a.z ^ b.z
    )
  }


  function v3fxor(a: Vec3, b: Vec3): Vec3 {
    return v3f(
      bit.bxor(a.x, b.x),
      bit.bxor(a.y, b.y),
      bit.bxor(a.z, b.z)
    )
  }

  class Boom extends WindowProgram {

    readonly BUFFER_SIZE = 100
    readonly BUFFERS_ARRAY_WIDTH = 5

    loaded = false
    currentPixelCount = 0
    clearColor = v3f(100,100,100)
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



    model: Vec2[] = [
      v2f(10,10),
      v2f(100,30),
      v2f(190,160)
    ]
    drawModel(): void {
      const width = 200
      const height = 200
      const offset = v2f(100,100)
      this.triangle(this.model,"red")

      // this.triangle(v2f(x0, y0), v2f)

      // for (let i = 0; i < 3; i++) {
      //   const v0 = this.model[i]
      //   // Wraps around to 0
      //   const v1 = this.model[(i + 1) % 3]

      //   const x0 = (v0.x + 1) * width / 2
      //   const y0 = ((v0.y * -1) + 1) * height / 2
      //   const x1 = (v1.x + 1) * width / 2
      //   const y1 = ((v1.y * -1) + 1) * height / 2
      //   this.drawLine(x0, y0, x1, y1, "black")
      // }
    }

    barycentric(pts: Vec2[], P: Vec2): Vec3 { 

      let u: Vec3 = v3fxor( v3f(pts[2].x - pts[0].x, pts[1].x - pts[0].x, pts[0].x - P.x), v3f(pts[2].y - pts[0].y, pts[1].y - pts[0].y, pts[0].y - P.y));
      
      if (math.abs(u.z) < 1) {
        // print("uh oh")
        return v3f(-1,1,1)
      }
      // print("Not uh oh")
      return v3f(1 - (u.x + u.y) / u.z, u.y / u.z, u.x / u.z);
    } 
   
    triangle(pts: Vec2[], color: string): void {
      let bboxmin: Vec2 = v2f(199, 199)//v2f(this.windowSize.x - 1, this.windowSize.y - 1); 
      let bboxmax: Vec2 = v2f(0, 0);
      const clamp = v2f(199, 199)//v2f(this.windowSize.x - 1, this.windowSize.y - 1); 

      for (let i = 0; i < 3; i++) { 
        bboxmin.x = math.max(0, math.floor(math.min(bboxmin.x, pts[i].x)));
        bboxmin.y = math.max(0, math.floor(math.min(bboxmin.y, pts[i].y)));

        bboxmax.x = math.min(clamp.x, math.floor(math.max(bboxmax.x, pts[i].x)));
        bboxmax.y = math.min(clamp.y, math.floor(math.max(bboxmax.y, pts[i].y)));
      }

      let P: Vec2 = v2f(0,0)
      for (P.x = bboxmin.x; P.x <= bboxmax.x; P.x++) { 
        // print("at: " + P.x)
        for (P.y = bboxmin.y; P.y <= bboxmax.y; P.y++) { 

          let bc_screen: Vec3 = this.barycentric(pts, P); 

          if (bc_screen.x < 0 || bc_screen.y < 0 || bc_screen.z < 0) {
            continue
          }
          // print("drawing pixel at " + P.x + ", " + P.y)
          this.drawPixelString(P.x, P.y, color)
        } 
      } 
    } 
   

    // https://github.com/ssloy/tinyrenderer/wiki/Lesson-1:-Bresenham%E2%80%99s-Line-Drawing-Algorithm#timings-fifth-and-final-attempt
    drawLine(x0: number, y0: number, x1: number, y1: number, color: string): void {

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
          this.drawPixelString(y, x, color)
        } else {
          this.drawPixelString(x, y, color)
        }
        error2 += derror2
        if (error2 > dx) {
          y += (y1 > y0) ? 1 : -1
          error2 -= dx * 2
        }
      }
    }

    bufferKey(x: number, y: number): number {
      return (x % this.BUFFERS_ARRAY_WIDTH) + (y * this.BUFFERS_ARRAY_WIDTH)
    }

    clear(): void {
      const clearString = color(this.clearColor.x, this.clearColor.y, this.clearColor.z)
      for (let x = 0; x < this.windowSize.x; x++) {
        for (let y = 0; y < this.windowSize.y; y++) {
          this.drawPixelString(x,y, clearString)
        }
      }
    }

    drawPixelString(x: number, y: number, string: string) {
      x = math.round(x)
      y = math.round(y)
      const bufferX = math.floor(x / this.BUFFER_SIZE)
      const bufferY = math.floor(y / this.BUFFER_SIZE)
      const inBufferX = (x % this.BUFFER_SIZE)
      const inBufferY = (y % this.BUFFER_SIZE)
      const currentBuffer = this.buffers[this.bufferKey(bufferX, bufferY)]
      currentBuffer[(inBufferX % this.BUFFER_SIZE) + (inBufferY * this.BUFFER_SIZE)] = string
    }

    drawPixel(x: number, y: number, r: number, g: number, b: number): void {
      x = math.round(x)
      y = math.round(y)
      const bufferX = math.floor(x / this.BUFFER_SIZE)
      const bufferY = math.floor(y / this.BUFFER_SIZE)
      const inBufferX = (x % this.BUFFER_SIZE)
      const inBufferY = (y % this.BUFFER_SIZE)
      const currentBuffer = this.buffers[this.bufferKey(bufferX, bufferY)]
      currentBuffer[(inBufferX % this.BUFFER_SIZE) + (inBufferY * this.BUFFER_SIZE)] = color(r,g,b)
    }

    flushBuffers() {
      for (let x = 0; x < this.BUFFERS_ARRAY_WIDTH; x++) {
        for (let y = 0; y < this.BUFFERS_ARRAY_WIDTH; y++) {
          const currentBuffer = this.buffers[this.bufferKey(x,y)]
          const rawPNG = minetest.encode_png(this.BUFFER_SIZE, this.BUFFER_SIZE, currentBuffer, 9)
          const rawData = minetest.encode_base64(rawPNG)
          this.renderer.setElementComponentValue("boomBuffer" + x + " " + y, "text", "[png:" + rawData)
        }
      }
    }

    offset = 0

    render(delta: number): void {
      this.clear()

      // this.offset += delta * 100
      // for (let x = 0; x < this.windowSize.x; x++) {
      //   for (let y = 0; y < this.windowSize.y; y++) {
      //     const calc = (((x + this.offset) % this.windowSize.x) / this.windowSize.x)
      //     this.drawPixel(x,y, 
      //       calc * 100, 1, (y / this.windowSize.y) * 100)
      //   }
      // }

      // this.drawLine(0,0, 100,200, "red");
      this.drawModel();

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