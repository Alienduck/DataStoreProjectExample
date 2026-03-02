local DataStoreService = game:GetService("DataStoreService")

local Server = {}

-- DataStore
local PlayerStore: DataStore = DataStoreService:GetDataStore("PlayerStore")

export type PlayerData = {
	Money: number,
}

local DATA_TEMPLATE: PlayerData = {
	Money = 0,
}

function Server.SetupData(player: Player): PlayerData
	return PlayerStore:GetAsync(tostring(player.UserId)) or table.clone(DATA_TEMPLATE)
end

function Server.SaveData(player: Player, datas: PlayerData)
	PlayerStore:SetAsync(tostring(player.UserId), datas)
	print(`Datas save for player: {player.Name}`)
end

return Server
