# Reqr
Reqr is a powerful module to ease the requiring/importing of scripts that are injected into the client. It is very lightweight and simple, and less than 100 lines. It all revolves around one function: `import`. This is the function used to import scripts. Reqr is open-source, and free for the anyone to use for their project. If you would like to contribute, you're very welcome to do so.
## Installation
Reqr works by injecting a function called `import` into your environment. This function can be used to call other scripts, and is the only function. You only need to load reqr once. From that script, every imported script will also have an injected environment (meaning they can call the `import` function as well). If you do not feel comfortable loading a remote URL, you're more than welcome to clone it into your own repository. Reqr is proudly subject to the Unlisence, meaning you can do whatever you want with it without worring about copyright or anything like that.
```lua
local reqr = loadstring(game:HttpGet("https://raw.githubusercontent.com/senselessdemon/reqr/main/init.lua", true))
```
Once you have this function loaded in, you can call it with the starting path. This is the path of the current script, and will be used to import other scripts. Below is an example. 
```lua
reqr("http://raw.githubusercontent.com/senselessdemon/coolproject/src/lol.lua")
```

## Importing
Calling this function will inject an `import` function that can be used to require/import other scripts. You can call with two ways. The first is by just writing the path from the initial starting point given in the `reqr` function that injected into the environment. This will be universal throughout scripts.
```lua
local Button = import("ui/button.lua")
local Switch = import("ui/switch.lua")
```
The other way is to import in the perspective of the script. This can be done by using the `.` operator, which will set the initial position of the path to the script's directory.
```lua
-- file: ui/button.lua
local Switch = import("./switch.lua")
```
As you saw before, the `/` operator was used to descend through the directories. This was designed to be similar to filesystems.
Another operator is the `..` operator. This is used to ascend through parents. Here's another example of how `ui/button.lua` could import `ui/switch.lua`.
```lua
local Switch = import("./../ui/switch.lua")
```
The segment `./..` can be replaced by just doing `..` in the beginning. This is a very useful shortcut, and is demonstrated below as a replacement for the last code segment.
```lua
local Switch = import("../ui/switch.lua")
```
