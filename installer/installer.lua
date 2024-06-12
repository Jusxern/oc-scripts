local filesystem = require("filesystem")
local shell = require("shell")
local io = require('io')
local args, options = shell.parse(...)
if args[1] then url = 'https://raw.githubusercontent.com/Jusxern/oc-scripts/main/'..args[1]..'/installer.lua' end
local path = '/tmp/JAI-'..math.floor(math.random(1111111,9999999) +0.5)..'.lua'

local function usage()
    print("Usage: jai [options] <name> "..[[  
        Example: jai -q antivirus
        -q, --quiet         do not print results to stdout
        -d, --description   gives description of an package
    ]])
end

if #args == 0 or options.help then
    usage()
    return 1
end
print('')
shell.execute('wget '..url..' '..path..' && '..path)
