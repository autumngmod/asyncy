asyncy = {}

---@return thread
function asyncy.createRuntime(callback)
  local thread = coroutine.create(callback)

  coroutine.resume(thread)

  return thread
end

async = asyncy.createRuntime

--- its literally includeCS
---
---@param path string
local function includeLua(path)
  if (SERVER) then
    AddCSLuaFile(path)
  end

  return include(path)
end

includeLua("asyncy/modules/net.lua")
-- includeLua("asyncy/modules/http.lua")

-- #uncomment it to include tests
-- includeLua("asyncy/test.lua")