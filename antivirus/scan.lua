local filesystem = require("filesystem")
local shell = require("shell")
local io = require('io')
local args, options = shell.parse(...)

--[[
    /$$$$$  /$$$$$$  /$$    /$$
   |__  $$ /$$__  $$| $$   | $$
      | $$| $$  \ $$| $$   | $$
      | $$| $$$$$$$$|  $$ / $$/
 /$$  | $$| $$__  $$ \  $$ $$/ 
| $$  | $$| $$  | $$  \  $$$/  
|  $$$$$$/| $$  | $$   \  $/   
 \______/ |__/  |__/    \_/    
                               
JustAntiVirus. By jusxern

This is just an base for antivirus.
Actual filters will be added soon! (So it will not work for rn lol)


]]
local function usage()
    print("Usage: scan [options] <filename1> "..[[  
        -n      will only print scan results
        --help  display this help and exit
        Icons meaning:
        ⏳ - loading/processing.
        ✅ - successfully passed a check.
        ⚠ - warning this code is suspicious.
        🛑  - code most likely contains virus.
        🔐 - running mathematical processes
    ]])
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
  ['warn'] = '⚠️';
  ['stop'] = '🛑';
  ['suc'] = '✅';
  ['brut'] = '🔐';
  ['tab'] = '        '
}

local MCode = {
  ['directory.root'] = {I.warn..'gives access to root directory.', 2};
  ['directory.root ='] = {I.stop..'overwrites root directory',3};
  ['directory.root='] = {I.stop..'overwrites root directory',3};
  ['directory.root.Init'] = {I.stop..'manipulating the Init.lua',3};
  ['loadstring'] = {I.warn..'may load suspicious code',2};
  ['^Bbytecode'] = {I.stop..'loads obfuscated code via bytecode obfuscating!\n'..I.tab..I.stop..'try to deobfuscate it and analyze!',3};
  ['^Vnobf'] = {I.suc..'variables are not obfuscated',1};
  ['^Vobf'] = {I.warn..'variables are obfuscated!',2};
  ['^Fnobf'] = {I.suc..'functions are not obfuscated',1};
  ['^Fobf'] = {I.stop..'functions are obfuscated!',3};
}

local vulnerabilities = {}

local function ParseScript(str,p)
  local ret = {}
  local counter = 0
  if p then print('Program code:') end
  for ln in str:gmatch('[^\r\n]+') do
    counter = counter + 1
    table.insert(ret,ln)
    if p then
    print(counter, ln)
    end
  end
  return ret
end

local function IsAnMCode(str)
  local ret = {}
  local counter = 0
  for mc,desc in pairs(MCode) do
    counter = counter + 1
    if str:match(mc) then
      ret[mc] = str
    elseif counter == #MCode - 1 then
      return false
    end
  end
  return ret
end

--Cheking for any malicious code
  function check()
for i,c in pairs(ParseScript(script, true)) do
  local pstr = IsAnMCode(c)
  for mc,str in pairs(pstr) do 
    print(i..': '..str..' -> '..MCode[mc][1])
    vulnerabilities[math.random(1,200000)] ={i,mc}
  end
end
print(string.rep('\n',3))
--Checking for obfustcating
print(I.load..'Cheking for obfuscated variables...')
ObfuscatedVar = {}
local counter = 0
for i,c in pairs(ParseScript(script)) do
  for i=0,30000 do
    if c:match('local v'..i) then
      ObfuscatedVar[c:match('v'..i)] = c
    end
  end
end
local loc = false for i,v in pairs(ObfuscatedVar) do if i ~= 0 and not loc then print(I.warn..'Script variables are obfuscated!') loc=true vulnerabilities[math.random(1,200000)] ={0,'^Vobf'}
end end
if loc == false then  print(I.suc..'script variables are not obfuscated') vulnerabilities[math.random(1,200000)] ={0,'^Vnobf'} end
print('\n'..I.load..'Cheking for obfuscated functions...')
local suc = false
local counter = 0
for i,c in pairs(ParseScript(script)) do
  for i=0,30000 do
    if c:match('function v'..i) then
      ObfuscatedVar[c:match('v'..i)] = c
      suc = true
    end
  end
end
if suc == false then  print(I.suc..'script functions are not obfuscated') vulnerabilities[math.random(1,200000)] ={0,'^Fnobf'} else print(I.stop..'script functions are obfuscated!') vulnerabilities[math.random(1,200000)] ={0,'^Fobf'} end
local suc = 0
  print('\n'..I.load..'Checking for loadstring...')
for i,c in pairs(vulnerabilities) do
  if c[2] == 'loadstring' then
    print(I.warn..'found loadstring()')
    suc = 1
    local sc = ParseScript(script)
    local script = sc[c[1]]
    local bValue = '\0\0'
    local processing = true
    print(I.brut..'bruteforcing bytecode may occur lag!')
    counter = 0
    while processing do
      counter=counter+1
      bValue = ('\\'..math.floor(math.random(1,999)+0.5)..'\\'..math.floor(math.random(1,999)))
--      print(bValue)
      if script:match(bValue) ~= nil then
        processing = false
        print(I.suc..'Processing success, key:', bValue)
        suc = 2
        vulnerabilities[math.random(1,200000)] ={c[1],'^Bbytecode'}
      end
      if counter >= 1000000 then
        break
      end
    end
  end
end

if suc == 0 then print(I.suc..'no loadstrings been found')
elseif suc == 1 then print(I.warn..'loadstrings were found')
elseif suc == 2 then print(I.stop..'bytecode loadstring was found!')
end
print(string.rep("\n",2))
    for i,v in pairs(vulnerabilities) do
      
    end
print('Scan results:')
print('More information above ⬆\n')
for i,vuln in pairs(vulnerabilities) do
  local scriptCopy = ParseScript(script)
  print('ln: '..vuln[1],MCode[vuln[2]][1])
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
