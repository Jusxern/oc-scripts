local component = require("component")
local internet = require("internet")
local s = require("shell")
local version = io.open("/usr/jav_version"):read("*a")
local Url_version = ""
local url = "https://raw.githubusercontent.com/Jusxern/oc-scripts/main/antivirus/scan_version"

if not component.isAvailable("internet") then
    io.stderr:write("This program requires an internet card to run.")
    return
end

local result, response = pcall(internet.request, url, nil, {["user-agent"]="JAC/AutoUpdate"})
local content = response()
for ln in content:gmatch('[^\r\n]+') do
    Url_version = ln
end

if Url_version == version then
    io.write("JAV Latest version already installed.\n")
else
    io.write("JAV Auto-updating...\n")
    s.execute("wget -f https://raw.githubusercontent.com/Jusxern/oc-scripts/main/antivirus/scan.lua /bin/scan.lua && wget -f https://raw.githubusercontent.com/Jusxern/oc-scripts/main/iovlua/iov.lua /lib/iov.lua")
    io.open("/usr/jav_version", "w"):write(Url_version)
    io.write("JAV Updated")
end
