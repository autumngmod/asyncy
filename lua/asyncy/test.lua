if (SERVER) then
  util.AddNetworkString("justexample")

  asyncy:createRuntime(function()
    net.StartAsync("justexample", function() end, Player(3))
    print("client responded me")
  end)
else
  net.ReceiveAsync("justexample", function(_, _, id)
    print("content")

    net.Start("justexample")
    net.WriteId(id)
    net.SendToServer()
  end)
end