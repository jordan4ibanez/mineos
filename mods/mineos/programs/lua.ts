namespace mineos {

  class LuaVM extends WindowProgram {

    main(delta: number): void {
      print("ye")
    }

  }

  DesktopEnvironment.registerProgram(LuaVM)
}