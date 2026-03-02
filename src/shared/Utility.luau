--[[
	- Utility
	- Alienduck
	- 16/10/2025
	- v0.1.6
	@summary Fournit des fonctions utilitaires communes : logs, remote creation, outils joueurs, etc.
]]

---------------------------------------------------------------------
-- Services
---------------------------------------------------------------------

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestService = game:GetService("TestService")

---------------------------------------------------------------------
-- Objet principal
---------------------------------------------------------------------

local Utility = {}

---------------------------------------------------------------------
-- LOGS
---------------------------------------------------------------------

-- Information (Studio uniquement)
function Utility.Info(message: string, scriptCall: string?)
	if RunService:IsStudio() then
		TestService:Message(`[INFO]: {message} | [FROM]: {scriptCall or script.Name}`)
	end
end

-- Avertissement (Studio uniquement)
function Utility.Warn(message: string, scriptCall: string?)
	if RunService:IsStudio() then
		warn(`{scriptCall or script.Name}: {message}.`)
	end
end

-- Erreur (Studio uniquement)
function Utility.Error(message: string, scriptCall: string?)
	if RunService:IsStudio() then
		error(`{scriptCall or script.Name}: {message}.`)
	end
end

---------------------------------------------------------------------
-- FOLDERS & REMOTES
---------------------------------------------------------------------

-- Crée un dossier s’il n’existe pas
function Utility.CreateFolder(name: string, parent: Instance?)
	local targetParent = parent or ReplicatedStorage
	local existing = targetParent:FindFirstChild(name)
	if existing and existing:IsA("Folder") then
		return existing
	end

	if RunService:IsClient() then
		-- Attendre jusqu'à 5s que le serveur le crée
		local replicated = targetParent:WaitForChild(name, 5)
		if replicated and replicated:IsA("Folder") then
			return replicated
		end
		-- Si toujours rien, log et créer en dernier recours
		Utility.Warn(`[Utility] Création forcée du dossier '${name}' côté client`, script.Name)
	end

	local newFolder = Instance.new("Folder")
	newFolder.Name = name
	newFolder.Parent = targetParent
	return newFolder
end

-- Crée ou récupère un RemoteEvent
function Utility.CreateRemoteEvent(
	name: string,
	parent: Instance?,
	callback: ({}) -> ()? | (player: Player, ...any) -> ()?
): RemoteEvent
	local targetParent = parent or ReplicatedStorage
	local remote: RemoteEvent = targetParent:FindFirstChild(name)

	if remote and remote:IsA("RemoteEvent") then
		if callback then
			if RunService:IsServer() and remote.OnServerEvent then
				remote.OnServerEvent:Connect(callback :: (Player, ...any) -> ())
			elseif RunService:IsClient() and remote.OnClientEvent then
				remote.OnClientEvent:Connect(callback)
			end
		end
		return remote
	end

	local newRemote = Instance.new("RemoteEvent")
	newRemote.Name = name
	newRemote.Parent = targetParent

	if callback then
		if RunService:IsServer() then
			newRemote.OnServerEvent:Connect(callback)
		else
			newRemote.OnClientEvent:Connect(callback)
		end
	end

	return newRemote
end

-- Crée ou récupère un RemoteFunction
function Utility.CreateRemoteFunction(
	name: string,
	parent: Instance?,
	callback: ({}) -> ()? | (player: Player) -> ()?
): RemoteFunction
	local targetParent = parent or ReplicatedStorage
	local remote = targetParent:FindFirstChild(name)

	if remote and remote:IsA("RemoteFunction") then
		if callback then
			if RunService:IsServer() then
				remote.OnServerInvoke = callback
			elseif RunService:IsClient() then
				remote.OnClientInvoke = callback
			end
		end
		return remote
	end

	remote = Instance.new("RemoteFunction")
	remote.Name = name
	remote.Parent = targetParent

	if callback then
		if RunService:IsServer() then
			remote.OnServerInvoke = callback
		else
			remote.OnClientInvoke = callback
		end
	end

	return remote
end

-- Crée ou récupère un BindableEvent
function Utility.CreateBindableEvent(
	name: string,
	parent: Instance?,
	callback: ({}) -> ()? | (player: Player) -> ()?
): BindableEvent
	local targetParent = parent or ReplicatedStorage
	local existing = targetParent:FindFirstChild(name)
	if existing then
		return existing
	end

	local event = Instance.new("BindableEvent")
	event.Name = name
	event.Parent = targetParent
	if callback then
		event.Event:Connect(callback)
	end
	return event
end

-- Crée ou récupère un BindableFunction
function Utility.CreateBindableFunction(
	name: string,
	parent: Instance?,
	callback: ({}) -> ()? | (player: Player) -> ()?
): BindableFunction
	local targetParent = parent or ReplicatedStorage
	local existing = targetParent:FindFirstChild(name)
	if existing then
		return existing
	end

	local func = Instance.new("BindableFunction")
	func.Name = name
	func.Parent = targetParent
	if callback then
		func.OnInvoke = callback
	end
	return func
end

---------------------------------------------------------------------
-- RETURN
---------------------------------------------------------------------

return Utility
