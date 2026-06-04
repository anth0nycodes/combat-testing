--!strict
-- Types
local Types = require(script.Parent.Types)
local CombatServiceClient = {} :: Types.CombatServiceClientType

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Modules
local SettingsModule = require(RS.UI.Menus.MainGameGui.Settings)
local FighterConfigModule = require(RS.Utils.FighterConfig)

-- Fighter Config
local fighterConfig = FighterConfigModule.get()

-- Remotes
local AttackRemote = RS.Remotes.AttackRemote

-- Utils
local AnimationLoader = require(RS.Utils.AnimationLoader)

-- Combat Actions
local m1Action = RS.Inputs.Combat.M1

-- Module Config
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
		if CombatServiceClient.Config.IsAttacking then
			return
		end
		if now < CombatServiceClient.Config.ComboBreakTime then
			return
		end

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
	local isLastHit = CombatServiceClient.Config.Combo == fighterConfig.MaxComboCount

	if isLastHit then
		CombatServiceClient.Config.ComboBreakTime = currentTime + 1
	end

	if combo > fighterConfig.MaxComboCount then
		combo = 1
	end

	CombatServiceClient.Config.LastAttackTime = currentTime

	local currentAnimationTrack =
		AnimationLoader.LoadAnimation(fighterConfig.Animations[CombatServiceClient.Config.Combo])
	local strikeSound = if CombatServiceClient.Config.Combo == fighterConfig.MaxComboCount
		then fighterConfig.SFX.Heavy
		else fighterConfig.SFX.Normal

	currentAnimationTrack:Play()
	currentAnimationTrack:GetMarkerReachedSignal("Hit"):Connect(function()
		strikeSound:Play()
		AttackRemote:FireServer(combo, SettingsModule.Config.isHitboxChecked)
	end)
	currentAnimationTrack.Stopped:Wait()
	CombatServiceClient.Config.IsAttacking = false
end

return CombatServiceClient
