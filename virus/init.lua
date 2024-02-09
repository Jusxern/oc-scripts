do
   io.write("CHLEN \n")
end

while true do
    local result, reason = xpcall(require("shell").getShell(), function(msg)
      return tostring(msg).."\n"..debug.traceback()
    end)
    if not result then
      io.stderr:write((reason ~= nil and tostring(reason) or "unknown error") .. "\n")
      io.write("Press any key to continue.\n")
      os.sleep(0.5)
      require("event").pull("key")
    end
  end
  
