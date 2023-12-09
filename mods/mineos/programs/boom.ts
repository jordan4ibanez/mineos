namespace mineos {
  class Boom extends WindowProgram {

    main(delta: number): void {
      print("BOOM BABY")
    }

  }
  DesktopEnvironment.registerProgram(Boom)
}