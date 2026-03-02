-- Services
local Players = game:GetService("Players")

-- Modules
local PlayerDataManager = require(script.PlayerDataManager)

-- Init
PlayerDataManager.Init()

-- When player join
local PlayerJoinCon: RBXScriptConnection = Players.PlayerAdded:Connect(function(player: Player)
	PlayerDataManager.PlayerJoin(player)
end)

-- When player leave
local PlayerLeaveCon: RBXScriptConnection = Players.PlayerRemoving:Connect(function(player: Player)
	PlayerDataManager.PlayerLeave(player)
end)

-- When game closing
game:BindToClose(function()
	-- On déconnecte pour éviter que la sauvegarde lorsque les joueurs quittent se lance en même temps (performance)
	if PlayerJoinCon then
		PlayerJoinCon:Disconnect()
	end
	if PlayerLeaveCon then
		PlayerLeaveCon:Disconnect()
	end

	-- On lance la sauvegarde générale
	PlayerDataManager.GameClosing()
end)
