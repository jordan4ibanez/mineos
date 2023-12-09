namespace mineos {
  const create = vector.create2d

  export class Renderer {
  
    
    clearColor: Vec3 = vector.create(0,0,0)
    memory: {[id: string] : number} = {}
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

    addElement(name: string, component: GUIComponent): void {
      const driver = this.system.getDriver()
      this.memory[name] = driver.hud_add(component)
    }

    getElement(name: string): GUIComponent {
      const driver = this.system.getDriver()
      const elementID = this.memory[name]
      if (elementID == null) throw new Error("renderer: component " + name + " does not exist.")
      return driver.hud_get(elementID)!!
    }

    setElementComponentValue(name: string, component: string, value: any): void {
      const elementID = this.memory[name]
      if (elementID == null) throw new Error("renderer: component " + name + " does not exist.")
                  
    }
  }

  print("renderer loaded.")
}