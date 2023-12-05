namespace mineos {

  export class Renderer {
  
    buffer = ""
    memory: {[id: string] : gui.Element} = {}

    constructor() {
      print("hello I am a renderer")
    }

    getBuffer(): string {
      return this.buffer
    }

    grabRef(name: string): gui.Element | null {
      return this.memory[name] || null
    }
  }

  print("renderer loaded.")
}