namespace mineos {
  class Renderer {
    constructor() {
      print("hello I am a renderer")
    }
  }

  // Now move it into namespace.
  export const renderer = new Renderer();

  print("renderer loaded.")
}