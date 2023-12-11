# mineos
 An operating system for Minetest

Don't bother running make because I already did that for you.

### BUT

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