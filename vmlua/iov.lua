local iov = {}

local bridges = {}

function iov.bridge(name)
    if not name then error('No name provided for IOV bridge') return 1; end
    bridge = {
        ['data'] = {};
        ['callbacks'] = {}
    }
    bridges[name] = bridge
end

function iov.connect(name)
    if bridges[name] then return bridges[name] else return end
end

function iov.transfer(name,value,index)
    if not bridges[name] then return 1 end;
    local suc, err = pcall(function()
        bridges[name]['data'][index] = value
    end)
    if suc then return true 
    elseif err then return err
    end
end

function iov.destroy(name)
    print(name..' IOV bridge has been closed')
    bridges[name] = {}
end

function iov.getBridges()
    return bridges;
end

return iov
