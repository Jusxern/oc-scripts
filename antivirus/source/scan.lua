local shell = require("shell")
local io = require('io')
local process = require('process')
local pipe = require('pipe')
local args, options = shell.parse(...)

--[[

Version: 0.2.2

    /$$$$$  /$$$$$$  /$$    /$$
   |__  $$ /$$__  $$| $$   | $$
      | $$| $$  \ $$| $$   | $$
      | $$| $$$$$$$$|  $$ / $$/
 /$$  | $$| $$__  $$ \  $$ $$/ 
| $$  | $$| $$  | $$  \  $$$/  
|  $$$$$$/| $$  | $$   \  $/   
 \______/ |__/  |__/    \_/    
                               
JustAntiVirus. By jusxern

added filters - 11.06
optimized some important functions - 25.07

]]

local function usage()
    io.write("Usage: scan [options] <filename1> ".."\n-n      will only print scan results\n--help  display this help and exit\nIcons meaning:\n⏳ - loading/processing.\n✅ - successfully passed a check.\n❗ - warning this code is suspicious.\n🛑  - code most likely contains virus.\n🔐 - running mathematical processes")
end

  if #args == 0 or options.help then
    usage()
    return 1
  end

  local path = args[1]
  local file=io.open(path)  
  local script = file:read("*a")

local I = {
  ['load'] = '⏳';
  ['warn'] = '❗';
  ['stop'] = '🛑';
  ['suc'] = '✅';
  ['brut'] = '🔐';
  ['tab'] = '        '
}

local MCode = {
  ['/lib/core'] = {I.warn..'manipulating core',2};
  ['/lib/core/boot.lua'] = {I.stop..'manipulating the boot.lua',3};
  ['/init.lua'] = {I.stop..'manipulating the Init.lua',3};
  ['loadstring'] = {I.warn..'may load suspicious code',2};
  ['load()'] = {I.warn..'may load suspicious code',2};
  ['eeprom.set'] = {I.stop..'manipulating eeprom data',3};
  ['virus'] = {I.warn..'virus mentioned in this code😮😡😡😡'};
  ['rm% %-rfv% /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-rvf% /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-frv% /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-fvr% /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-vrf% /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-vfr% /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-rfv% /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-rvf% /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-frv% /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-fvr% /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-vrf% /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-vfr% /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-rfv% /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-rvf% /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-frv% /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-fvr% /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-vrf% /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-vfr% /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-rfv% /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-rvf% /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-frv% /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-fvr% /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-vrf% /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-vfr% /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-rfv% /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-rvf% /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-frv% /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-fvr% /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-vrf% /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-vfr% /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-rfv% /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-rvf% /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-frv% /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-fvr% /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-vrf% /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-vfr% /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-rfv% /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-rvf% /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-frv% /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-fvr% /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-vrf% /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-vfr% /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-rfv% /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-rvf% /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-frv% /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-fvr% /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-vrf% /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-vfr% /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-r %-f %-v%  /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-r %-v %-f%  /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-f %-r %-v%  /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-f %-v %-r%  /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-v %-r %-f%  /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-v %-f %-r%  /usr']  = {I.stop..'deleting system directory /usr',3};
  ['rm% %-r %-f %-v%  /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-r %-v %-f%  /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-f %-r %-v%  /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-f %-v %-r%  /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-v %-r %-f%  /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-v %-f %-r%  /boot']  = {I.stop..'deleting system directory /boot',3};
  ['rm% %-r %-f %-v%  /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-r %-v %-f%  /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-f %-r %-v%  /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-f %-v %-r%  /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-v %-r %-f%  /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-v %-f %-r%  /dev']  = {I.stop..'deleting system directory /dev',3};
  ['rm% %-r %-f %-v%  /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-r %-v %-f%  /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-f %-r %-v%  /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-f %-v %-r%  /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-v %-r %-f%  /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-v %-f %-r%  /etc']  = {I.stop..'deleting system directory /etc',3};
  ['rm% %-r %-f %-v%  /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-r %-v %-f%  /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-f %-r %-v%  /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-f %-v %-r%  /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-v %-r %-f%  /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-v %-f %-r%  /home']  = {I.stop..'deleting system directory /home',3};
  ['rm% %-r %-f %-v%  /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-r %-v %-f%  /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-f %-r %-v%  /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-f %-v %-r%  /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-v %-r %-f%  /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-v %-f %-r%  /tmp']  = {I.stop..'deleting system directory /tmp',3};
  ['rm% %-r %-f %-v%  /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-r %-v %-f%  /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-f %-r %-v%  /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-f %-v %-r%  /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-v %-r %-f%  /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-v %-f %-r%  /mnt']  = {I.stop..'deleting system directory /mnt',3};
  ['rm% %-r %-f %-v%  /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-r %-v %-f%  /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-f %-r %-v%  /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-f %-v %-r%  /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-v %-r %-f%  /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% %-v %-f %-r%  /bin']  = {I.stop..'deleting system directory /bin',3};
  ['rm% -rfv  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -rvf  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -frv  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -fvr  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -vrf  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -vfr  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -rfv  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -rvf  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -frv  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -fvr  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -vrf  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -vfr  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -r -f -v  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -r -v -f  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -f -r -v  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -f -v -r  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -v -r -f  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -v -f -r  /'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -r -f -v  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -r -v -f  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -f -r -v  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -f -v -r  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -v -r -f  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['rm% -v -f -r  /.'] = {I.warn..'deleting directory with root perms', 2};
  ['^Bbytecode'] = {I.stop..'loads obfuscated code via bytecode obfuscating!\n'..I.tab..I.stop..'try to deobfuscate it and analyze!',3};
  ['^Vnobf'] = {I.suc..'variables are not obfuscated',1};
  ['^Vobf'] = {I.warn..'variables are obfuscated!',2};
  ['^Fnobf'] = {I.suc..'functions are not obfuscated',1};
  ['^Fobf'] = {I.stop..'functions are obfuscated!',3}
}

local vulnerabilities = {}

local function ParseScript(str)
  local ret = {}
  local counter = 0
  for ln in str:gmatch('[^\r\n]+') do
    table.insert(ret,ln)
  end
  return ret
end

local function IsAnMCode(str)
  local ret = {}
  local counter = 0
  for mc,desc in pairs(MCode) do
    counter = counter + 1
    
    local suc,err = pcall(function()
      if str:match(mc) then
        ret[mc] = str
      elseif counter == #MCode - 1 then
        return false
      end
    end)

    if err then
      print(str,mc,desc,err,'\n Finished capture')
      break
    end
  end
  return ret
end
--Cheking for any malicious code
function check()

function extract_load_bytecode(code)
    code = code:gsub("%-%-.*", "")
    local contents = {}
    for content in code:gmatch("%Wload%s*%((.-)%)") do
        table.insert(contents, content)
    end
    return #contents > 0 and contents or nil
end

for i,c in pairs(ParseScript(script)) do
  local pstr = IsAnMCode(c)
  for mc,str in pairs(pstr) do 
    if mc == "load()" then
      if extract_load_bytecode(str) then
        print(i..': '..str..' -> '..MCode[mc][1])
        table.insert(vulnerabilities,{i,mc})
      end
    else
      print(i..': '..str..' -> '..MCode[mc][1])
      table.insert(vulnerabilities,{i,mc})
    end
  end
end
print(string.rep('\n',3))


--Checking for obfustcating -- 25.7.2024 OPTIMIZED 😎
print(I.load..'Cheking for obfuscated variables...')
ObfuscatedVar = {}
local counter = 0
for i,c in pairs(ParseScript(script)) do
  if c:match('local') then
  for b=0,30 do
    if c:match('local v'..b) then
      ObfuscatedVar[c:match('v'..b)] = c
    end
  end
end
end
local loc = false for i,v in pairs(ObfuscatedVar) do if i ~= 0 and not loc then print(I.warn..'Script variables are obfuscated!') loc=true table.insert(vulnerabilities,{0,'^Vobf'})
end end

if loc == false then  print(I.suc..'script variables are not obfuscated') table.insert(vulnerabilities,{0,'^Vnobf'}) end


print('\n'..I.load..'Cheking for obfuscated functions...')
local suc = false
local counter = 0
for i,c in pairs(ParseScript(script)) do
  for i=0,80 do
    if c:match('function v'..i) then
      ObfuscatedVar[c:match('v'..i)] = c
      suc = true
    end
  end
end
if suc == false then  print(I.suc..'script functions are not obfuscated') table.insert(vulnerabilities,{0,'^Fnobf'}) else print(I.stop..'script functions are obfuscated!') table.insert(vulnerabilities,{0,'^Fobf'}) end


local suc = 0
  print('\n'..I.load..'Checking for loadstring...')
for i,c in pairs(vulnerabilities) do
  if c[2] == 'loadstring' or c[2] == 'load()' then
    print(I.warn..'found loadstring')
    suc = 1
    local sc = ParseScript(script)
    local script = sc[c[1]]
    local bValue = '\0\0'
    local processing = true
    if script:match("\\") then
    os.sleep(0)
    require('thread').create(function() 
    print(I.brut..'bruteforcing bytecode may occur lag!')
      while processing do
        bValue = ('\\'..tostring(math.floor(math.random(1,300)+0.5))..'\\'..tostring(math.floor(math.random(1,300)+0.5)))
        if script:match(bValue) ~= nil then
          processing = false
          print(I.suc..'Processing success, key:', bValue)
          suc = 2
          table.insert(vulnerabilities,{c[1],'^Bbytecode'}) 
        end
      end
   end)
  end
end
end

local loadstring_message = {
    (I.suc..'no loadstrings been found');
    (I.warn..'loadstrings were found');
    (I.stop..'bytecode loadstring found!')
}

print(loadstring_message[suc])

print(string.rep("\n",2))
    for i,v in pairs(vulnerabilities) do
      
    end
print('Scan results:')
print('More information above in the log ⬆\n')
for i,vuln in pairs(vulnerabilities) do
  local scriptCopy = ParseScript(script)
  os.sleep(0)
  print('ln: '..vuln[1],MCode[vuln[2]][1],i)
end
  end
  check()
  io.write('Run script? [y/N]\n')
  local input = io.read()
  if input == 'y' or input == 'Y' then
    loadfile(path)()
    return 0;
  end
  print("Returning to shell.\n")
  return 0;
