namespace mineos {

  export class Renderer {
  
    buffer = ""
    memory: {[id: string] : gui.Element} = {}
    shouldDraw = true

    constructor() {
      print("hello I am a renderer")
    }

    getBuffer(): string {
      return this.buffer
    }

    grabRef(name: string): gui.Element | null {
      return this.memory[name] || null
    }

    update(): void {

    }

    draw(): void {
      this.shouldDraw = !this.shouldDraw
      if (!this.shouldDraw) return

      print("showing")

      minetest.show_formspec("singleplayer", "mineos", this.buffer)
    }
  }

  print("renderer loaded.")
}