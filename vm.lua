local shell = require('shell')
local io = require('io')
local uuid = require('uuid')
local vmlua = require('iov')
vmlua.bridge('VMLuaJAV')
local VMcode = [[
    local VMF = require'iov'.connect('VMLuaJAV').data.VMF

    local computer = VMF.computer
    local require = VMF.require
    local pcall = VMF.pcall
   
    computer.shutdown(true)

    print('\nGuest: ',computer.address())
]]
local code = [[
    
]]
local UUIDS = {}
local Calls = {}
for i=1,100 do table.insert(UUIDS, uuid.next()) end

VMF = {
    ['addcall'] = function(name,...) table.insert(Calls,{name,...}) end;
    ['computer'] = {
        address = function()             return UUIDS[1] end;
        addUser = function(name)         return false end;
        beep = function(num)             computer.beep(num) end;
        energy = function()              return computer.energy() end;
        freeMemory = function()          return computer.freeMemory() end;
        totalMemory = function()         return VMF.computer.freememory() end;
        getArchitectures = function()    return computer.getArchitectures() end;
        getArchitecture = function()     return computer.getArchitecture() end;
        getBootAddress = function()      return UUIDS[2] end;
        setBootAddress = function(addr)  VMF.addcall('setBootAddress',addr) return true end;
        getDeviceInfo = function()       return computer.getDeviceInfo() end;
        getProgramLocations = function() return {} end;
        isRobot = function()             return false end;
        energy = function()              return 500 end;
        maxEnergy = function()           return computer.maxEnergy() end;
        tmpAddress = function()          return UUIDS[3] end;
        uptime = function()              return 100 end;
        shutdown = function(reboot)      VMF.addcall('computer shutdown','reboot? '..tostring(reboot)) end;
    };
    ['io'] = {

    };
    ['uuid'] = {
        ['next'] = function() return uuid.next() end;
    };
    ['pcall'] = function(f,...) table.insert(Calls,{'pcall',f,...}) end;
}
VMF.require = function(module) VMF.addcall('require',module) return VMF[module] end;

vmlua.transfer('VMLuaJAV',VMF,'VMF')
local suc,err = pcall(function()
    return load(VMcode..'\n'..code)()
end)
vmlua.destroy('VMLuaJAV')
for i,v in pairs(Calls) do for _,b in pairs(v) do print('Call:',i,b) end end
print(suc,err)
