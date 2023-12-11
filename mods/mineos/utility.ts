namespace mineos {
  export function loadFiles(filesToLoad: string[]): void {
    const currentMod = minetest.get_current_modname()
    const currentDirectory = minetest.get_modpath(currentMod)
    for (const file of filesToLoad) {
      dofile(currentDirectory + "/" + file + ".lua")
    }
  }
  export function loadFile(file: string): any {
    const currentDirectory = minetest.get_modpath("mineos")
    return dofile(currentDirectory + "/" + file + ".lua")
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
  /**
   * Clamp a number between two number. (inclusive)
   * @param min Min value.
   * @param max Max value.
   * @param input Value to be clamped.
   * @returns Clamped value.
   */
  math.clamp = function(min: number, max: number, input: number): number {
    if (input < min) {
      return min
    } else if (input > max) {
      return max
    }
    return input
  }

  math.randomseed(os.time())
  const random = math.random;
  const gsub = string.gsub;
  const format = string.format
  // https://gist.github.com/jrus/3197011
  export function uuid(): string {
    const template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return gsub(template, "[xy]", (c: string) => {
      const v = (c == "x") && random(0, 0xf) || random(8, 0xb)
      return format("%x", v)
    })[0]
  }

  export const colorize = minetest.colorize;
}