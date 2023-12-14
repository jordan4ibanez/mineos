# mineos
 An operating system for Minetest

Join my discord to watch me ramble like a maniac: https://discord.gg/Z2wCscTB4F

Singleplayer only. If you run this on a server you should probably be using linux.

Don't bother running make because I already did that for you. * see below if you want to mess with it.

You can move around the desktop like a normal, hastily made, slapped together standard win-like DE.

Moving around the desktop icons does literally nothing but it's cool.

It tells you your local system time.

Boom controls:
wasd: move
mouse: look
aux1: release mouse
shift: toggle texture performance mode
zoom: toggle framebuffer performance mode

Bit's Battle:
wasd: move

gong:
ws: move









I wouldn't mess with the Lua code, it's auto generated. Only mess with the TS code and run make. 
There is ``make`` ``make linux`` and ``make windows``. The last two will attempt to auto start the game.

If you want to mess with this or maybe you would want to use TS for your minetest things.
 
First you need node, if you're on ubuntu it's super outdated so get it here https://github.com/nodesource/distributions#ubuntu-versions

Next you need TypeScriptToLua
```
sudo npm install --save-dev typescript-to-lua typescript
```

Next you need Lua types for TS or else the compiler doesn't know what's going on.
```
sudo npm install --save-dev lua-types
```