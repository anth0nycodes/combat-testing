--!strict

-- Types
local Types = require(script.Parent.Types)

local CombatServiceClient = {} :: Types.CombatServiceClientType

-- Game Services
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Modules
local HitboxClientModule = require(RS.Shared.Modules.Game.Hitbox)
local SettingsModule = require(RS.UI.Menus.MainGameGui.Settings)

-- Combat Actions
local m1Action = RS.Inputs.Combat.M1

-- Animations
local AnimationLoader = require(RS.Utils.AnimationLoader)
local BrawlerAnimations = RS.Assets.Animations.Brawler
local Animations = {
	BrawlerAnimations.M1One,
	BrawlerAnimations.M1Two,
	BrawlerAnimations.M1Three,
}

-- Players
local player = Players.LocalPlayer
if not player then return end
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid") :: Humanoid

-- SFX
local NormalStrike = RS.Assets.SFX.NormalStrike
local HeavyStrike = RS.Assets.SFX.HeavyStrike

-- Main
CombatServiceClient.Config = {
	Combo = 1,
	ComboResetTime = 0.80,
	IsAttacking = false,
	ComboBreakTime = 0,
	LastAttackTime = 0,
}

function CombatServiceClient.Init()
	CombatServiceClient.BindEvents()
end

function CombatServiceClient.BindEvents()
	m1Action.Pressed:Connect(function()
		local now = DateTime.now().UnixTimestampMillis / 1000
		if CombatServiceClient.Config.IsAttacking then return end
		if now < CombatServiceClient.Config.ComboBreakTime then return end
		
		CombatServiceClient.Attack()
	end)
end

function CombatServiceClient.Attack()
	CombatServiceClient.Config.IsAttacking = true
	local combo = CombatServiceClient.Config.Combo
	local currentTime = DateTime.now().UnixTimestampMillis / 1000
	local timeSinceLastAttack = currentTime - CombatServiceClient.Config.LastAttackTime
	
	if timeSinceLastAttack <= CombatServiceClient.Config.ComboResetTime then
		combo += 1
	else
		combo = 1
	end
	
	CombatServiceClient.Config.Combo = combo
	local isLastHit = CombatServiceClient.Config.Combo == 3
	
	if isLastHit then
		CombatServiceClient.Config.ComboBreakTime = currentTime + 1
	end
	
	if combo > 3 then
		combo = 1
	end
	
	CombatServiceClient.Config.LastAttackTime = currentTime
	
	local currentAnimationTrack = AnimationLoader.LoadAnimation(Animations[CombatServiceClient.Config.Combo])
	local strikeSound = if CombatServiceClient.Config.Combo == 3 then HeavyStrike else NormalStrike
	
	humanoid.WalkSpeed = 10
	currentAnimationTrack:Play()
	currentAnimationTrack:GetMarkerReachedSignal("Hit"):Connect(function()
		strikeSound:Play()
		HitboxClientModule.CreateHitbox(combo, SettingsModule.Config.isHitboxChecked)
	end)
	currentAnimationTrack.Stopped:Wait()
	humanoid.WalkSpeed = 16
	CombatServiceClient.Config.IsAttacking = false
end

return CombatServiceClient