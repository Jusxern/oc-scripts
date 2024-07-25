
local component = require('component')
local s = require('shell')
local fs = require('filesystem')
local i = require('io')
local internet = require("internet")
if not component.isAvailable("internet") then
    io.stderr:write("This program requires an internet card to run.")
    return
end
local url = "https://raw.githubusercontent.com/Jusxern/oc-scripts/main/antivirus/scan_version"
print('Insatlling JAV scan...')
s.execute('wget -f https://raw.githubusercontent.com/Jusxern/oc-scripts/main/antivirus/scan.lua /bin/scan.lua')
print('Installing IOVLua package...')
s.execute('wget -f https://raw.githubusercontent.com/Jusxern/oc-scripts/main/iovlua/iov.lua /lib/iov.lua')
local input = i.read()
if input == 'N' or input == 'n' then
    local Url_version = ""
    local result, response = pcall(internet.request, url, nil, {["user-agent"]="JAC/AutoUpdate"})
    local content = response()
    for ln in content:gmatch('[^\r\n]+') do
        Url_version = ln
    end
    i.open("/usr/jav_version", "w"):write(Url_version)
    s.execute('wget -f https://raw.githubusercontent.com/Jusxern/oc-scripts/main/antivirus/javau.lua /usr/javau.lua')
end

i.write('Restart PC now? Y/n\n')
local input = i.read()
if input == '' or input == 'Y' or input == 'y' then
    s.execute('reboot')
end
print('Returning to Shell...')
