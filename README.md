# mineos
 An operating system for Minetest

Join my discord to watch me ramble like a maniac: https://discord.gg/Z2wCscTB4F

## A ramble about this _"game"_

Singleplayer only. If you run this on a server you should probably be using linux.

Don't bother running make because I already did that for you. * see below if you want to mess with it.

You can move around the desktop like a normal, hastily made, slapped together standard win-like DE.

Moving around the desktop icons does literally nothing but it's cool.

It tells you your local system time.

You can move windows around, and close them. This is an actual multitasking OS.

The audio controller is horrifically slapped together and you'll see why if you try to run two games at once that play songs.

The Core of the operating system is System. This is the controller for everything. The computer basically.

The Desktop is a Program that runs on the System. Yes this literally is a Progam that the System is running.

The Desktop can run multiple Programs. These are WindowPrograms. They literally inherit from Program. So this means that this is basically a miniature tree-like hierarchy.

A WindowProgram generally has a garbage collected nature. But like OpenGL in GC langs, you need to manually clean up the Renderer's memory. This is where the destructor comes in.

I could have simplified the underlying infrastructure when working with the Renderer, but this is a gamejam game and I don't have much time.

## Game controls

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

## Messing with this contraption.

I have set it up to specifically 

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

## A small note
You could technically make this run in multiplayer. You could even have it so there's a REAL email/IRC clients running on everyone's desktop then have multiplayer games on the server. This is way out of the scope of a gamejam game but I laid out the framework for you to build upon. I'm sure you can do it! I believe in you.