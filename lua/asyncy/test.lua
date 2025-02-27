if (SERVER) then
  util.AddNetworkString("justexample")

  net.ReceiveAsync("justexample", function(_, player, id)
    print("Player sended " .. net.ReadInt(4))

    net.Start("justexample")
    net.WriteString(id)
    net.WriteString("hello pups")
    net.Send(player)
  end)
else
  concommand.Add("send", function()
    asyncy:createRuntime(function()
      print("sending net message")

      net.StartAsync("justexample", function()
        net.WriteInt(4, 4)
      end)

      print("server response: ", net.ReadString())
    end)
  end)
end