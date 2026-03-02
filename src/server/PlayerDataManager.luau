local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = require(ReplicatedStorage.Shared.Utility)
local Backend = require(script.Parent:WaitForChild("Backend"))
local module = {}

local PLAYERS: { [string]: Player } = {}
local DATAS: { [string]: Backend.PlayerData } = {}

function module.Init()
	PLAYERS = {}
	DATAS = {}
end

function module.PlayerJoin(player: Player)
	local datas: Backend.PlayerData = Backend.SetupData(player)
	PLAYERS[tostring(player.UserId)] = player
	DATAS[tostring(player.UserId)] = datas
	Utility.Info(`{player.Name} datas: {datas.Money}`)
end

function module.PlayerLeave(player: Player)
	local datas: Backend.PlayerData = DATAS[tostring(player.UserId)]
	Backend.SaveData(player, datas)
	PLAYERS[tostring(player.UserId)] = nil
	DATAS[tostring(player.UserId)] = nil
	Utility.Info(`{player.Name} datas: {datas.Money}`)
end

function module.GameClosing()
	for _, player in pairs(PLAYERS) do
		module.PlayerLeave(player)
	end
end

local REMOTE_EVENT_FOLDER: Folder = Utility.CreateFolder("RemoteEvents")

Utility.CreateRemoteEvent("OnClick", REMOTE_EVENT_FOLDER, function(player: Player)
	local datas: Backend.PlayerData = DATAS[tostring(player.UserId)]
	datas.Money = datas.Money + 1
	Utility.Info(`{player.Name} datas: {datas.Money}`)
end)

return module
