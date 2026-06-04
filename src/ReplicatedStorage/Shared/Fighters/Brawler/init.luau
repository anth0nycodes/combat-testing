--!strict
-- Types
local Types = require(script.Parent.Types)
local Config = {} :: Types.ConfigType

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Brawler Animations
local BrawlerAnimations = RS.Assets.Animations.Brawler

-- Brawler SFX
local NormalStrike = RS.Assets.SFX.Fighters.Brawler.Normal
local HeavyStrike = RS.Assets.SFX.Fighters.Brawler.Heavy

Config.FighterConfig = {
	Animations = {
		BrawlerAnimations.M1One,
		BrawlerAnimations.M1Two,
		BrawlerAnimations.M1Three,
	},
	SFX = { Normal = NormalStrike, Heavy = HeavyStrike },
	Damage = { Normal = 3, Heavy = 8 },
	MaxComboCount = 3,
	Hitbox = {
		HitboxType = "Box",
		Size = Vector3.new(5, 5, 2),
		CFrame = CFrame.new(0, 0, -2.5),
	},
}

return Config
