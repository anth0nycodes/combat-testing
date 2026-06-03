--!strict
local PlayerStateServiceServer = {}

-- Game Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

-- Remotes
local PlayerRemote = RS.Remotes.PlayerRemote :: RemoteEvent

function PlayerStateServiceServer.Init()
	Players.PlayerAdded:Connect(function(player: Player)
		local character = player.Character or player.CharacterAdded:Wait()

		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart
		if not humanoidRootPart then
			return
		end

		humanoidRootPart.Anchored = true
	end)

	PlayerRemote.OnServerEvent:Connect(function(player: Player, event: string)
		local character = player.Character or player.CharacterAdded:Wait()

		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart
		if not humanoidRootPart then
			return
		end

		if event == "UnanchorHumanoidRootPart" then
			humanoidRootPart.Anchored = false
		end
	end)
end

return PlayerStateServiceServer
