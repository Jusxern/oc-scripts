local vmlua = {}

local bridges = {}

function vmlua.bridge(name)
    if not name then error('No name provided for VmLua bridge') return 1; end
    bridge = {
        ['data'] = {};
        ['callbacks'] = {}
    }
    bridges[name] = bridge
end

function vmlua.connect(name)
    if bridges[name] then return bridges[name] else return end
end

function vmlua.transfer(name,value,index)
    if not bridges[name] then return 1 end;
    local suc, err = pcall(function()
        bridges[name]['data'][index] = value
    end)
    if suc then return true 
    elseif err then return err
    end
end

function vmlua.destroy(name)
    print(name..' vm has been closed')
    bridges[name] = {}
end

function vmlua.getBridges()
    return bridges;
end

return vmlua
