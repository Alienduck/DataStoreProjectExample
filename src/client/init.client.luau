-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Modules
local Clicker = require(ReplicatedStorage.Shared.Clicker)
local Utility = require(ReplicatedStorage.Shared.Utility)

-- Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Players.LocalPlayer.PlayerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Remote Events
local REMOTE_FOLDER = Utility.CreateFolder("RemoteEvents")
local OnClick = Utility.CreateRemoteEvent("OnClick", REMOTE_FOLDER)

-- Cookie Button
local CookieButton = Clicker.New(screenGui)
local button = CookieButton.Button

-- Tween
local activeTween: Tween? = nil
local T_INFO = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

--[[
	Function to tween scale of the cookie button
	@param scale: number
]]
local function playTween(scale: number)
	if activeTween then
		activeTween:Cancel()
	end
	activeTween = TweenService:Create(button, T_INFO, { Size = UDim2.fromScale(scale, scale) })
	if activeTween then
		activeTween:Play()
	end
end

CookieButton:OnClick(function()
	OnClick:FireServer()
	playTween(0.19)
end)

CookieButton:OnRelease(function()
	playTween(0.2)
end)
CookieButton:OnHover(function()
	playTween(0.21)
end)
CookieButton:EndHover(function()
	playTween(0.2)
end)
