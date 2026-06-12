--!strict
-- Types
local Types = require(script.Parent.Types)
local Config = {} :: Types.ConfigType

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Brawler Animations
local BrawlerAnimations = RS.Assets.Animations.Brawler

-- Brawler SFX
local NormalStrikeSFX = RS.Assets.SFX.Fighters.Brawler.Normal
local HeavyStrikeSFX = RS.Assets.SFX.Fighters.Brawler.Heavy
local BlockBreakSFX = RS.Assets.SFX.Fighters.Brawler.BlockBreak

Config.FighterConfig = {
	Animations = {
		M1Animations = {
			BrawlerAnimations.M1One,
			BrawlerAnimations.M1Two,
			BrawlerAnimations.M1Three,
		},
		BlockAnimation = BrawlerAnimations.Block,
		BlockBreakAnimation = BrawlerAnimations.BlockBreak,
		ParryStunAnimation = BrawlerAnimations.ParryStun,
		KnockbackAnimation = BrawlerAnimations.Knockback,
	},
	Stuns = {
		BlockBreakDuration = 2,
		ParryDuration = 2,
	},
	WalkSpeed = { Base = 16, Attacking = 12, Blocking = 8, BlockBroken = 2 },
	SFX = { NormalAttack = NormalStrikeSFX, HeavyAttack = HeavyStrikeSFX, BlockBreak = BlockBreakSFX },
	Damage = { Normal = 3, Heavy = 8 },
	MaxComboCount = 3,
	Hitbox = {
		HitboxType = "Box",
		Size = Vector3.new(5, 5, 2),
		CFrame = CFrame.new(0, 0, -2.5),
	} :: Types.BoxHitboxConfig,
}

return Config
