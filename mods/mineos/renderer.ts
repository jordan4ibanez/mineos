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
    // memory: {[id: string] : gui.Element} = {}
    shouldDraw = true
    frameBufferSize: Vec2 = create(0,0)
    frameBufferScale: Vec2 = create(0,0)
    system: System

    constructor(system: System) {
      this.system = system
    }

    clearMemory(): void {
      // for (const [name, _] of Object.entries(this.memory)) {
      //   if (name == "backgroundColor") continue
      //   delete this.memory[name]
      // }
    }

    removeComponent(name: string) {
      // delete this.memory[name]
    }

    internalUpdateClearColor(): void {
      // this.memory["backgroundColor"] = new BGColor({
      //   bgColor: colors.color(this.clearColor.x, this.clearColor.y, this.clearColor.z),
      //   fullScreen: "both",
      //   fullScreenbgColor: colors.colorScalar(50)
      // })
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
      // this.memory[name] = element
    }

    // getElement(name: string): gui.Element {
      // return this.memory[name]
    // }
  }

  print("renderer loaded.")
}