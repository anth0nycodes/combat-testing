--!strict

-- TODO: Swap out slayer animation assets for the actual slayer animations once they are done

-- Types
local Types = require(script.Parent.Types)
local Config = {} :: Types.ConfigType

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Slayer Animations
local SlayerAnimations = RS.Assets.Animations.Slayer

-- Slayer SFX
local NormalSlice = RS.Assets.SFX.Fighters.Slayer.Normal
local HeavySlice = RS.Assets.SFX.Fighters.Slayer.Heavy

Config.FighterConfig = {
	Animations = {
		SlayerAnimations.M1One,
		SlayerAnimations.M1Two,
		SlayerAnimations.M1Three,
	},
	SFX = { Normal = NormalSlice, Heavy = HeavySlice },
	Damage = { Normal = 3, Heavy = 8 },
	MaxComboCount = 3,
	Hitbox = {
		HitboxType = "Box",
		Size = Vector3.new(8, 8, 8),
		CFrame = CFrame.new(0, 0, -2.5),
	},
}

return Config
