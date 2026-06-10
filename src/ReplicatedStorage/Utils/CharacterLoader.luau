--!strict
local CharacterLoader = {}

-- Game Services
local Players = game:GetService("Players")

-- Player
local player = Players.LocalPlayer

function CharacterLoader.Init(callback: (character: Model, humanoid: Humanoid) -> ())
	local function onCharacterAdded(newCharacter: Model)
		local humanoid = newCharacter:WaitForChild("Humanoid") :: Humanoid
		callback(newCharacter, humanoid)
	end

	if player.Character then
		onCharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
end

return CharacterLoader
