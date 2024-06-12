local shell = require('shell')
local io = require('io')
local uuid = require('uuid')
local vmlua = require('iov')
vmlua.bridge('VMLuaJAV')
local VMcode = [[
    local VMF = require'iov'.connect('VMLuaJAV').data.VMF
    local require = VMF.require
    local VMio = require('io')
    local computer = VMF.computer
    local govno = 'CHLEN'
    print('\nGuest: ',computer.address())
    pcall(function()
    --parasha 
    end)
]]
local code = [[
    print(govno)
]]
local UUIDS = {}
local Calls = {}
for i=1,100 do table.insert(UUIDS, uuid.next()) end

local VMF = {
    require = function(module) table.insert(Calls,{'require',module}) return require(module) end;
    computer = {
        ProgramLoactions = {};
        address = function() return UUIDS[1] end;
        addUser = function(name) return 1 end;
        beep = function(num) computer.beep(num) end;
        energy = function() return computer.energy() end;
        freeMemory = function() return computer.freeMemory() end;
        getArchitectures = function() return computer.getArchitectures() end;
        getArchitecture = function() return computer.getArchitecture() end;
        getBootAddress = function() return UUIDS[2] end;
        getDeviceInfo = function() return computer.getDeviceInfo() end;
        getProgramLocations = function() return VMF.ProgramLoactions end;
        isRobot = function() return false end;
        maxEnergy = function() return computer.maxEnergy() end;
        
    };
    pcall = function(f,...) table.insert(Calls,{'pcall',f,...}) end;
    
}
vmlua.transfer('VMLuaJAV',VMF,'VMF')
local output

local suc,err = pcall(function()
    return load(VMcode..'\n'..code)()
end)
vmlua.destroy('VMLuaJAV')
--print('\nHost: '..computer.address())
for i,v in pairs(Calls[1]) do print(i,v) end
print(suc,err,output)
