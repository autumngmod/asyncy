asyncy = {}

---@return thread
function asyncy:createRuntime(callback)
  local thread = coroutine.create(callback)

  coroutine.resume(thread)

  return thread
end

--- its literally includeCS
---
---@param path string
local function includeLua(path)
  if (SERVER) then
    AddCSLuaFile(path)
  end

  return include(path)
end

--
includeLua("asyncy/modules/net.lua")
-- #uncomment it to include tests
-- includeLua("asyncy/test.lua")