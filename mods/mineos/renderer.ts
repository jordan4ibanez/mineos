namespace mineos {

  export class Renderer {
  
    buffer = ""
    // memory: Array<

    constructor() {
      print("hello I am a renderer")
    }

    getBuffer(): string {
      return this.buffer
    }
  }

  print("renderer loaded.")
}