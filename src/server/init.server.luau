-- Services
local Players = game:GetService("Players")

-- Modules
local PlayerDataManager = require(script.PlayerDataManager)

-- When player join
local PlayerJoinCon: RBXScriptConnection = Players.PlayerAdded:Connect(function(player: Player)
	PlayerDataManager.PlayerJoin(player)
end)

-- When player leave
local PlayerLeaveCon: RBXScriptConnection = Players.PlayerRemoving:Connect(function(player: Player)
	PlayerDataManager.PlayerLeave(player)
end)

-- When game closing
game.Close:Once(function(...)
	PlayerJoinCon:Disconnect()
	PlayerLeaveCon:Disconnect()
	PlayerDataManager.GameClosing()
end)
