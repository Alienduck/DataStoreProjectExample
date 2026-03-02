local Players = game:GetService("Players")
local PlayerDataManager = require(script.PlayerDataManager)

local PlayerJoinCon: RBXScriptConnection = Players.PlayerAdded:Connect(function(player: Player)
	PlayerDataManager.PlayerJoin(player)
end)

local PlayerLeaveCon: RBXScriptConnection = Players.PlayerRemoving:Connect(function(player: Player)
	PlayerDataManager.PlayerLeave(player)
end)

game.Close:Once(function(...)
	PlayerJoinCon:Disconnect()
	PlayerLeaveCon:Disconnect()
	PlayerDataManager.GameClosing()
end)
