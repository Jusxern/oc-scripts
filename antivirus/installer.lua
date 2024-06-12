local s = require('shell')
local i = require('io')

print('Insatlling JAV scan...')
s.execute('wget -f https://raw.githubusercontent.com/Jusxern/oc-scripts/main/antivirus/scan.lua /bin/scan.lua')
print('Installing IOVLua package...')
s.execute('wget -f https://raw.githubusercontent.com/Jusxern/oc-scripts/main/iovlua/iov.lua /lib/iov.lua')

i.write('Restart PC now? Y/n\n')
local input = i.read()
if input == '' or input == 'Y' or input == 'y' then
    s.execute('reboot')
end
print('Returning to Shell...')
