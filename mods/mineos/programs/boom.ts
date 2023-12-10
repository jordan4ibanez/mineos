namespace mineos {

  const v3f = vector.create;
  const v2f = vector.create2d;
  const create = vector.create2d;
  const color = colors.color;

  class Vertex implements Vec3 {
    z: number;
    x: number;
    y: number;
    r: number;
    g: number;
    b: number;
    constructor(x: number, y: number, z: number, r: number, g: number, b: number) {
      this.x = x
      this.y = y
      this.z = z
      this.r = r
      this.g = g
      this.b = b
    }

    __eq(other: Vec3): boolean {
      throw new Error("Method not implemented.");
    }
    __unm(): Vec3 {
      throw new Error("Method not implemented.");
    }
    __add(other: Vec3): Vec3 {
      throw new Error("Method not implemented.");
    }
    __sub(other: Vec3): Vec3 {
      throw new Error("Method not implemented.");
    }
    __mul(other: Vec3): Vec3 {
      throw new Error("Method not implemented.");
    }
    __div(other: Vec3): Vec3 {
      throw new Error("Method not implemented.");
    }
  }
  function vert(x: number, y: number, z: number, r: number, g: number, b: number): Vertex {
    return new Vertex(x,y,z,r,g,b)
  } 

  class EdgeEquation {
    a: number;
    b: number;
    c: number;
    tie: boolean;
  
    constructor(v0: Vec2, v1: Vec2) {
      this.a = v0.y - v1.y;
      this.b = v1.x - v0.x;
      this.c = - (this.a * (v0.x + v1.x) + this.b * (v0.y + v1.y)) / 2;
      this.tie = (this.a != 0) ? (this.a > 0) : (this.b > 0);
    }

    /// Evaluate the edge equation for the given point.
    evaluate(x: number, y: number): number {
      return this.a * x + this.b * y + this.c;
    }
  
    /// Test if the given point is inside the edge.
    /// Test for a given evaluated value.
    test(x: number, y?: number): boolean {
      if (y) {
        return this.test(this.evaluate(x, y));
      } else {
        return (x > 0 || x == 0 && this.tie);
      }
    }
  }

  class ParameterEquation {
    a: number;
    b: number;
    c: number;
  
    constructor(p0: number,p1: number,p2: number,e0: EdgeEquation,e1: EdgeEquation,e2: EdgeEquation,area: number) {
      let factor: number = 1.0 / (2.0 * area);
  
      this.a = factor * (p0 * e0.a + p1 * e1.a + p2 * e2.a);
      this.b = factor * (p0 * e0.b + p1 * e1.b + p2 * e2.b);
      this.c = factor * (p0 * e0.c + p1 * e1.c + p2 * e2.c);
    }
  
    /// Evaluate the parameter equation for the given point.
    evaluate(x: number, y: number): number {
      return this.a * x + this.b * y + this.c;
    }
  };
  

  // Following a tutorial on how to do this: https://trenki2.github.io/blog/2017/06/06/developing-a-software-renderer-part1/

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



    model: Vertex[] = [
      vert(0,200,   0, 1.0, 0.0, 0.0),
      vert(150,0, 0, 0.0, 0.0, 1.0),
      vert(300,200,  0, 0.0, 1.0, 0.0)
    ]
    drawModel(): void {
      const width = 200
      const height = 200
      const offset = v2f(100,100)
      this.drawTriangle(this.model[0], this.model[1], this.model[2], "red")

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
  

    drawTriangle(v0: Vertex, v1: Vertex, v2: Vertex, color: string): void {
      // Compute triangle bounding box.
      let minX = math.min(math.min(v0.x, v1.x), v2.x);
      let maxX = math.max(math.max(v0.x, v1.x), v2.x);
      let minY = math.min(math.min(v0.y, v1.y), v2.y);
      let maxY = math.max(math.max(v0.y, v1.y), v2.y);

      //! manually guessed
      let m_minX = 0
      let m_minY = 0
      let m_maxX = 300
      let m_maxY = 300

      // Clip to scissor rect.
      minX = math.max(minX, m_minX);
      maxX = math.min(maxX, m_maxX);
      minY = math.max(minY, m_minY);
      maxY = math.min(maxY, m_maxY);

      // Compute edge equations.
      let e0 = new EdgeEquation(v1, v2);
      let e1 = new EdgeEquation(v2, v0);
      let e2 = new EdgeEquation(v0, v1);

      let area = 0.5 * (e0.c + e1.c + e2.c);
      
      // Check if triangle is backfacing.
      if (area < 0)
        return;

      // const red = 1.0
      // const green = 0
      // const blue = 0

      let r = new ParameterEquation(v0.r, v1.r, v2.r, e0, e1, e2, area);
      let g = new ParameterEquation(v0.g, v1.g, v2.g, e0, e1, e2, area);
      let b = new ParameterEquation(v0.b, v1.b, v2.b, e0, e1, e2, area);

      // Add 0.5 to sample at pixel centers.
      for (let x = minX + 0.5, xm = maxX + 0.5; x <= xm; x += 1.0)
      for (let y = minY + 0.5, ym = maxY + 0.5; y <= ym; y += 1.0)
      {
        if (e0.test(x, y) && e1.test(x, y) && e2.test(x, y))
        {
          const rint = r.evaluate(x, y) * 100;
          const gint = g.evaluate(x, y) * 100;
          const bint = b.evaluate(x, y) * 100;
          // print(rint)
          this.drawPixel(x, y, rint, gint, bint)
          // Uint32 color = SDL_MapRGB(m_surface->format, rint, gint, bint);
          // putpixel(m_surface, x, y, color);
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