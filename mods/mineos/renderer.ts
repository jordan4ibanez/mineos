namespace mineos {
  const create = vector.create2d

  export class Renderer {
  
    
    clearColor: Vec3 = vector.create(0,0,0)
    // memory: {[id: string] : gui.Element} = {}
    shouldDraw = true
    frameBufferSize: Vec2 = create(0,0)
    frameBufferScale: number = 1
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

    // getBuffer(): string {
    //   return this.buffer
    // }

    addElement(name: string) {
      this.system.driver
      // this.memory[name] = element
    }

    // getElement(name: string): gui.Element {
      // return this.memory[name]
    // }
  }

  print("renderer loaded.")
}