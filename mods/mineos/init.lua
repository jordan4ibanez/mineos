mineos = mineos or ({})
do
    do
        dofile(minetest.get_modpath("mineos") .. "/utility.lua")
    end
    mineos.loadFiles({"enums", "hacks", "renderer"})
    print("mineos loaded.")
end
