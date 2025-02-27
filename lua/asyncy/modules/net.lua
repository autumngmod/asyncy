print "net override"

net.awaiters = {}

---@param client Player?
function net.StartAsync(name, callback, client)
  local co = coroutine.running()
  if not co then error("StartAsync must be called inside the coroutine") end

  local id = "async:" .. tostring(co)

  net.Start(name)
  net.WriteString(id)
  callback()
  if IsValid(client) then
    ---@diagnostic disable-next-line: param-type-mismatch
    net.Send(client)
  else
    net.SendToServer()
  end

  net.ReceiveAsync(name)
  net.awaiters[id] = co

  return coroutine.yield()
end

---@param name string
---@param callback? fun(len: number, player: Player, id: string)
function net.ReceiveAsync(name, callback)
  net.Receive(name, function(len, client)
    local id = net.ReadString()

    local awaiter = net.awaiters[id]

    if (callback) then
      callback(len, client, id)
    end

    if (awaiter) then
      coroutine.resume(awaiter)
      print("resumed")
      net.awaiters[id] = nil
    end
  end)
end