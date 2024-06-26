local shell = require('shell')
local io = require('io')
local uuid = require('uuid')
local vmlua = require('iov')
local process = require("process")
local component = require('component')
vmlua.bridge('VMLuaJAV')
local VMcode = [[
    local VMF = require'iov'.connect('VMLuaJAV').data.VMF
    local require = VMF.require
    local pcall = VMF.pcall
    local computer = VMF.computer

    print('\nGuest: ',computer.address())
]]
local code = [[

]]
local UUIDS = {}
local Calls = {}
for i=1,100 do table.insert(UUIDS, uuid.next()) end

VMF = {
    ['addcall'] = function(name,...) table.insert(Calls,{name,...}) end;
    ['USERS'] = {};
    ['computer'] = {
        shutdown = function(reboot)      VMF.addcall('computer shutdown','reboot? '..tostring(reboot)) end;
        setBootAddress = function(addr)  VMF.addcall('setBootAddress',addr) return true end;
        addUser = function(name)         table.insert(VMF.USERS,name) return true end;
        getArchitectures = function()    return computer.getArchitectures() end;
        getArchitecture = function()     return computer.getArchitecture() end;
        totalMemory = function()         return VMF.computer.freememory() end;
        getDeviceInfo = function()       return computer.getDeviceInfo() end;
        freeMemory = function()          return computer.freeMemory() end;
        maxEnergy = function()           return computer.maxEnergy() end;
        energy = function()              return computer.energy() end;
        beep = function(num)             computer.beep(num) end;
        users = function()               return VMF.USERS end;
        getBootAddress = function()      return UUIDS[2] end;
        address = function()             return UUIDS[1] end;
        tmpAddress = function()          return UUIDS[3] end;
        addUser = function(name)         return false end;
        isRobot = function()             return false end;
        energy = function()              return 500 end;
        uptime = function()              return 100 end;
        getProgramLocations = function() return {} end;
        runlevel = function()            return 1; end;
        --TODO: ADD PUSH/PULL SIGNAL
    };
    ['io'] = {};
    ['uuid'] = {['next'] = function() return uuid.next() end};
    ['shell'] = {
        execute =             function(cmd) table.insert(Calls, {'shell.execute',"'"..cmd.."'"}) return true end;
        aliases =             function() return pairs(process.info().data.aliases) end;
        getWorkingDirectory = function() return os.getenv("PWD") or "/" end;
        resolve =             function() return nil, "file not found" end;
        parse =               function(...) return shell.parse(...) end;
        getPath =             function() return os.getenv("PATH") end;
        setWorkingDirectory = function() return true end;
        getAlias =            function() return nil end;
        setAlias =            function() end;
        setPath =             function() end;
    };
    ['pcall'] = function(f,...) return pcall(f) end;
    ['require'] = function(module) VMF.addcall('require',module) return VMF[module] end;
    ['component'] = require('component')}
VMF.component.eeprom = {
    set = function(content) VMF.addcall('eeprom set',content) return nil, "storage is readonly" end
};

vmlua.transfer('VMLuaJAV',VMF,'VMF')
local suc,err = pcall(function()
    return load(VMcode..'\n'..code)()
end)
vmlua.destroy('VMLuaJAV')
for i,v in pairs(Calls) do for _,b in pairs(v) do print('Call:',i,b) end end
print(suc,err)
