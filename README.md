# asyncy
``asyncy`` - a small library that allows you to simulate asynchronous operations using Lua's built-in ``coroutine``.

> [!TIP]
> It's not asynchronous programming, it's just a “parody” of it. But I would like to add that everything works perfectly well, and in general it can be called asynchronous with a stretch.

# Installation
* Via command line:
```bash
cd GarrysModDS/garrysmod/addons
git clone https://github.com/autumngmod/asyncy
```

# Usage
To use asynchronous, you must wrap a function that will use asynchronous functions in ``asyncy.createRuntime``.
```lua
concommand.Add("testmsg", function()
  asyncy.createRuntime(function()
    -- here you can do anything you want using asynchronous functions
  end)
end)
```

## Networking
We have now implemented the basic asynchronous functions for ``net.Send``/``net.Start``

Lets see example:
### Serverside
```lua
util.AddNetworkString("justexample")

-- here we receive a network message from the player
net.ReceiveAsync("justexample", function(_, player, id)
  print("Player sended " .. net.ReadInt(4))

  -- sending a response that the player is waiting for on the client side
  net.Start("justexample")
  net.WriteString(id) -- WriteString(id) is required (in responses) because the Lua clientside uses it to identify which message the player has received a response to.
  net.WriteString("hello pups") -- some additional data
  net.Send(player) -- sending response
end)
```
### Clientside
```lua
concommand.Add("send", function()
  asyncy.createRuntime(function()
    print("sending net message")

    net.StartAsync("justexample", function()
      net.WriteInt(4, 4)
    end)

    print("server response: ", net.ReadString())
  end)
end)
```

i hate callbacks.