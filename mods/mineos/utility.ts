namespace mineos {
  export function loadFiles(filesToLoad: string[]): void {
    const currentMod = minetest.get_current_modname()
    const currentDirectory = minetest.get_modpath(currentMod)
    for (const file of filesToLoad) {
      dofile(currentDirectory + "/" + file + ".lua")
    }
  }
  vector.create = function(x?: number, y?: number, z?: number): Vec3 {
    let temp = vector.zero()
    temp.x = x || 0
    temp.y = y || 0
    temp.z = z || 0
    return temp
  };
  vector.create2d = function(x?: number, y?: number): Vec2 {
    let temp = {
      x: x || 0,
      y: y || 0
    }
    return temp
  }
}