--!strict
-- Types
local Types = require(script.Parent.Types)
local CombatServiceClient = {} :: Types.CombatServiceClientType

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Modules
local HitboxClientModule = require(RS.Shared.Modules.Game.Hitbox)
local FighterConfigModule = require(RS.Utils.FighterConfig)

-- Player
local character: Model
local humanoid: Humanoid

-- Fighter Config
local fighterConfig = FighterConfigModule.get()

-- Remotes
local AttackRemote = RS.Remotes.AttackRemote
local BlockRemote = RS.Remotes.BlockRemote

-- Utils
local AnimationLoader = require(RS.Utils.AnimationLoader)
local CharacterLoader = require(RS.Utils.CharacterLoader)

-- Combat Actions
local m1Action = RS.Inputs.Combat.M1
local blockAction = RS.Inputs.Combat.Block

-- Block Animation
local blockTrack: AnimationTrack

-- Module Config
CombatServiceClient.Config = {
	Combo = 1,
	ComboResetTime = 0.80,
	IsAttacking = false,
	IsBlocking = false,
	BlockMeter = 100,
	IsStunned = false,
	ComboBreakTime = 0,
	LastAttackTime = 0,
}

local function onCharacterAdded(newCharacter: Model, newHumanoid: Humanoid)
	character = newCharacter
	humanoid = newHumanoid
end

function CombatServiceClient.Init()
	CharacterLoader.Init(onCharacterAdded)
	AnimationLoader.Init()
	CombatServiceClient.BindEvents()
end

function CombatServiceClient.BindEvents()
	m1Action.Pressed:Connect(function()
		local now = DateTime.now().UnixTimestampMillis / 1000
		if
			humanoid.Health <= 0
			or CombatServiceClient.Config.IsAttacking
			or CombatServiceClient.Config.IsStunned
			or CombatServiceClient.Config.IsBlocking
			or now < CombatServiceClient.Config.ComboBreakTime
		then
			return
		end

		CombatServiceClient.Attack()
	end)

	blockAction.Pressed:Connect(function()
		CombatServiceClient.Block()
	end)

	blockAction.Released:Connect(function()
		CombatServiceClient.Config.IsBlocking = false
		if blockTrack then
			blockTrack:Stop()
		end
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
		AnimationLoader.LoadAnimation(fighterConfig.M1Animations[CombatServiceClient.Config.Combo])
	local strikeSound = if CombatServiceClient.Config.Combo == fighterConfig.MaxComboCount
		then fighterConfig.SFX.Heavy
		else fighterConfig.SFX.Normal

	currentAnimationTrack:Play()
	currentAnimationTrack:GetMarkerReachedSignal("Hit"):Connect(function()
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
		strikeSound:Play()
		HitboxClientModule.CreateHitbox(humanoidRootPart)
		AttackRemote:FireServer(combo)
	end)
	currentAnimationTrack.Stopped:Wait()
	CombatServiceClient.Config.IsAttacking = false
end

function CombatServiceClient.Block()
	if CombatServiceClient.Config.IsStunned or CombatServiceClient.Config.IsAttacking or humanoid.Health <= 0 then
		return
	end
	task.wait(0.0375) -- Small delay to prevent blocking immediately after attacking
	if not blockAction:GetState() then -- Bail if player released block during startup delay
		return
	end
	print("Block")
	blockTrack = AnimationLoader.LoadAnimation(fighterConfig.BlockAnimation)
	CombatServiceClient.Config.IsBlocking = true
	blockTrack:Play()
	BlockRemote:FireServer()
end

return CombatServiceClient
