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

      this.addElement("background", {
        name: "background",
        hud_elem_type: HudElementType.image,
        position: create(0,0),
        text: "pixel.png",
        scale: create(0,0),
        alignment: create(1,1),
        offset: create(0,0),
        z_index: -5
      })
    }

    clearMemory(): void {
      // for (const [name, elementID] of Object.entries(this.memory)) {
      //   if (name == "background") continue
      //   const driver = this.system.getDriver()
      //   driver.hud_remove(elementID)
      //   delete this.memory[name]
      // }
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

    addElement(name: string, component: HudDefinition): void {
      const driver = this.system.getDriver()
      this.memory[name] = driver.hud_add(component)
    }

    getElement(name: string): HudDefinition {
      const driver = this.system.getDriver()
      const elementID = this.memory[name]
      if (elementID == null) throw new Error("renderer: component " + name + " does not exist.")
      return driver.hud_get(elementID)!!
    }

    setElementComponentValue(name: string, component: string, value: any): void {
      const driver = this.system.getDriver()
      const elementID = this.memory[name]
      if (elementID == null) throw new Error("renderer: component " + name + " does not exist.")
      driver.hud_change(elementID, component, value)
    }

    removeElement(name: string) {
      const driver = this.system.getDriver()
      const elementID = this.memory[name]
      if (elementID == null) throw new Error("renderer: component " + name + " does not exist.")
      driver.hud_remove(elementID)
      delete this.memory[name]
    }

    //!! DANGER !!
    
    /**
     * Skips accessing the internal memory.
     * WILL CREATE MEMORY LEAK IF DONE WRONG!
     */
    rawDraw(): void {

    }

    /**
     * Skips accessing the internal memory.
     * WILL CREATE MEMORY LEAK IF DONE WRONG!
     */
    rawDeleta(): void {
      
    }


    //!! END DANGER !!

    update() {
      // print("updating")
      // print(dump(this.frameBufferSize))
      this.setElementComponentValue("background", "scale", this.frameBufferSize)
      this.setElementComponentValue("background", "text", "pixel.png^[colorize:" + colors.color(this.clearColor.x, this.clearColor.y, this.clearColor.z) + ":255")
    }
  }

  print("renderer loaded.")
}