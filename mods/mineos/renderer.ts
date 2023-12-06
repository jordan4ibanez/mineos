namespace mineos {
  const create = vector.create2d

  const generate = gui.generate
  const FormSpec = gui.FormSpec
  const BackGround = gui.Background
  const BGColor = gui.BGColor
  const List = gui.List
  const ListColors = gui.ListColors
  const ListRing = gui.ListRing

  export class Renderer {
  
    buffer = ""
    clearColor: Vec3 = vector.create(0,0,0)
    memory: {[id: string] : gui.Element} = {}
    shouldDraw = true
    frameBufferSize: Vec2 = create(0,0)
    frameBufferScale: Vec2 = create(0,0)
    system: System

    constructor(system: System) {
      this.system = system
    }

    clearMemory(): void {
      for (const [name, _] of Object.entries(this.memory)) {
        if (name == "backgroundColor") continue
        delete this.memory[name]
      }
    }

    removeComponent(name: string) {
      delete this.memory[name]
    }

    internalUpdateClearColor(): void {
      this.memory["backgroundColor"] = new BGColor({
        bgColor: colors.color(this.clearColor.x, this.clearColor.y, this.clearColor.z),
        fullScreen: "both",
        fullScreenbgColor: colors.colorScalar(50)
      })
    }

    setClearColor(r: number, g: number, b: number): void {
      this.clearColor.x = r
      this.clearColor.y = g
      this.clearColor.z = b;
      this.internalUpdateClearColor()
    }

    getBuffer(): string {
      return this.buffer
    }

    addElement(name: string, element: gui.Element) {
      this.memory[name] = element
    }

    getElement(name: string): gui.Element {
      return this.memory[name]
    }

    grabRef(name: string): gui.Element | null {
      return this.memory[name] || null
    }

    finalizeBuffer(): void {
      let obj = new FormSpec({
        size: this.frameBufferScale,
        padding: create(-0.01, -0.01),
        elements: []
      })
      obj.elements.push(this.memory.backgroundColor)
      for (const [name, elem] of Object.entries(this.memory)) {
        if (name == "backgroundColor") continue
        obj.elements.push(elem)
      }
      this.buffer = generate(obj)
    }

    update(): void {
      // System.out.println(this.buffer)
      this.finalizeBuffer()
    }

    draw(): void {
      this.shouldDraw = !this.shouldDraw
      if (!this.shouldDraw) {
        return
      }
      this.update()
      minetest.show_formspec("singleplayer", "mineos", this.buffer)
    }
  }

  print("renderer loaded.")
}