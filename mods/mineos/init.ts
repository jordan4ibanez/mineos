namespace mineos {
  // It's Lisp! Oh my goodness.
  {dofile( minetest.get_modpath("mineos") + "/utility.lua");}
  loadFiles([
    "enums",
    "gui_components",
    "renderer",
    "system",
    /*hacks depends on renderer*/
    "hacks",
    "programs"
  ])

  // Begin mineos.
  const system = new System();
  system.triggerBoot();
  minetest.register_globalstep((delta: number) => {
    system.main(delta)
  })  
}