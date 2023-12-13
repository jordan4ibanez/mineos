namespace mineos {
  // It's not Pong it's Gong!
  class Gong extends WindowProgram {
    main(delta: number): void {
      print("gongtastic!")
    }
  }
  DesktopEnvironment.registerProgram(Gong)
}