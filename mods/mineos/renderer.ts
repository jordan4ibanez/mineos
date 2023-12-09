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
      print(this.system.getDriver().get_player_name() + "alkfjasdflkjasdflkasdj")
      print(HudElementType.image)
      print(colors.color(100,100,100))
      this.system.getDriver().hud_add({
        name: "testing",
        hud_elem_type: HudElementType.text,
        // position: create(0,0),
        text: "minetest.png",
        number: colors.colorHEX(100,100,100),
        size: create(0,0),
        scale: create(1,1),
        alignment: create(0,0),
        // offset: create(0,0),
        z_index: 100
        // name: "background",
        // hud_elem_type: HudElementType.text,
        // text: "hi",//minetest.colorize(colors.colorScalar(100), "hi there"),
        // scale: create(100,100),
        // position: create(0,0),
        // alignment: create(0,0),
        // offset: create(0,0),
        // size: create(10,10)
      })
      print("added afkjadsklfjasdfklsdajf")
    }

    clearMemory(): void {
      // for (const [name, elementID] of Object.entries(this.memory)) {
      //   if (name == "background") continue
      //   const driver = this.system.getDriver()
      //   driver.hud_remove(elementID)
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
  }

  print("renderer loaded.")
}