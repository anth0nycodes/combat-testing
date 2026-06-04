--!strict
local FighterConfig = {}

-- Game Services
local RS = game:GetService("ReplicatedStorage")

function FighterConfig.get()
	local Fighters = RS.Shared.Fighters
	local fighter = Fighters.Brawler -- Default to Brawler for now, can change later when implementing fighter selection logic
	local fighterConfigModule = require(fighter)
	local fighterConfig = fighterConfigModule.FighterConfig
	return fighterConfig
end

return FighterConfig
