namespace mineos {
  // It's Lisp! Oh my goodness.
  {dofile( minetest.get_modpath("mineos") + "/utility.lua");}
  loadFiles([
    "enums",
    "colors",
    "gui_components",
    "renderer",
    "audio",
    "system",
    /*hacks depends on renderer*/
    "hacks",
    "programs"
  ])

  // Computer turns on. Beep boop.

  // Hard drive spins up.
  const system = new System();
  system.triggerBoot();

  // Now begins mineos.
  minetest.register_globalstep((delta: number) => {
    system.updateFrameBuffer(osFrameBufferPoll());
    system.main(delta)
  })  
}