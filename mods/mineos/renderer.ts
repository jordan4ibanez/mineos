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
    memory: {[id: string] : gui.Element} = {}
    shouldDraw = true

    constructor() {
      this.memory["bacgkroundColor"] = new BGColor({
        bgColor: colors.colorScalar(1),
        fullScreen: "both",
        fullScreenbgColor: colors.colorScalar(1)
      })
    }

    getBuffer(): string {
      return this.buffer
    }

    grabRef(name: string): gui.Element | null {
      return this.memory[name] || null
    }


    finalizeBuffer(): void {
      let obj = new FormSpec({
        size: create(12,12),
        elements: []
      })
      obj.elements.push(this.memory["backgroundColor"])
      this.buffer = generate(obj)
    }

    update(): void {
      this.finalizeBuffer()
    }

    draw(): void {
      this.shouldDraw = !this.shouldDraw
      if (!this.shouldDraw) return
      this.update()
      minetest.show_formspec("singleplayer", "mineos", this.buffer)
    }
  }

  print("renderer loaded.")
}