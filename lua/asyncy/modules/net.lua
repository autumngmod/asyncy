---         msgId: { userId, co }
---@type { number: { userId: number, co: thread, t: number } }
net.awaiters = {}

local timeout = 10

timer.Create("asyncy-clear", 10, 0, function()
  for k, v in pairs(net.awaiters) do
    if v.t < os.time() then
      net.awaiters[k] = nil
    end
  end
end)

---@param client Player?
function net.StartAsync(name, callback, client)
  local co = coroutine.running()
  if not co then error("StartAsync must be called inside the coroutine") end

  local isValid = IsValid(client)

  net.Start(name)
  local id = net.WriteId()
  callback()
  if isValid then
    ---@diagnostic disable-next-line: param-type-mismatch
    net.Send(client)
  else
    net.SendToServer()
  end

  net.ReceiveAsync(name)
  net.awaiters[id] = { userId = isValid and client:UserID() or 0, co = co, t = os.time() + timeout }

  return coroutine.yield()
end

---@return number
local function generate_id()
  local id = math.random(0, 255) // 2^8-1

  if (net.awaiters[id]) then
    return generate_id()
  end

  return id
end

function net.WriteId(id)
  if (!id) then
    id = generate_id()
  end

  net.WriteUInt(id, 8)

  return id
end

-- well i think it should be private function
function net.ReadId()
  return net.ReadUInt(8)
end

---@param name string
---@param callback? fun(len: number, client: Player, id: number)
function net.ReceiveAsync(name, callback)
  net.Receive(name, function(len, client)
    local id = net.ReadId()

    local awaiter = net.awaiters[id]

    if (awaiter && awaiter.userId != (IsValid(client) and client:UserID() or 0)) then
      // client:Ban(0, true)
      return
    end

    if (callback) then
      callback(len, client, id)
    end

    if (awaiter) then
      coroutine.resume(awaiter.co)
    end

    net.awaiters[id] = nil
  end)
end