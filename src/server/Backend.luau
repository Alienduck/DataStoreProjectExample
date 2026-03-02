local DataStoreService = game:GetService("DataStoreService")

local Server = {}

-- DataStore
local PlayerStore: DataStore = DataStoreService:GetDataStore("PlayerStore")

-- Data template type (for intellisense)
export type PlayerData = {
	Money: number,
}

-- Data template
local DATA_TEMPLATE: PlayerData = {
	Money = 0,
}

--[[
	Setup data for a player
	@param player: Player
	@return: PlayerData
]]
function Server.SetupData(player: Player): PlayerData
	return PlayerStore:GetAsync(tostring(player.UserId)) or table.clone(DATA_TEMPLATE)
end

--[[
	Save data for a player
	@param player: Player
	@param datas: PlayerData
]]
function Server.SaveData(player: Player, datas: PlayerData)
	PlayerStore:SetAsync(tostring(player.UserId), datas)
	print(`Datas save for player: {player.Name}`)
end

return Server
