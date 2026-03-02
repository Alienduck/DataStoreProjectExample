-- Services
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
function Server.SetupData(player: Player): PlayerData?
	local key = tostring(player.UserId)
	local success, result = pcall(function()
		return PlayerStore:GetAsync(key)
	end)

	if success then
		return result or table.clone(DATA_TEMPLATE)
	else
		return nil
	end
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
