--!strict
local PlayerHudModule = {}

-- Game Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

-- Types
local Types = require(script.Types)

-- Player
local player = Players.LocalPlayer
assert(player, "Player is not defined")
local character: Model
local humanoid: Humanoid
local playerGui = player.PlayerGui

-- Modules
local FighterConfigModule = require(RS.Utils.FighterConfig)

-- Utils
local CharacterLoader = require(RS.Utils.CharacterLoader)
local AnimationLoader = require(RS.Utils.AnimationLoader)

-- Fighter Config
local fighterConfig = FighterConfigModule.get()

-- SFX
local HealthDrainSFX = RS.Assets.SFX.HealthDrain :: Sound
local BlockDrainSFX = RS.Assets.SFX.BlockDrain :: Sound

-- GUIs
local playerHudGuiTemplate = RS.Assets.GUIs.PlayerHudGui :: Types.PlayerHudGui
local playerHudGui = playerHudGuiTemplate:Clone()
local playerStats = playerHudGui.Container.PlayerStats

local healthStat = playerStats.Health
local healthPercentage = healthStat.HealthPercentage
local healthMeter = healthStat.HealthGroup.HealthBar.HealthMeter

local blockStat = playerStats.Block
local blockPercentage = blockStat.BlockPercentage
local blockMeter = blockStat.BlockGroup.BlockBar.BlockMeter

local previousPlayerHealth: number
local previousBlockMeter: number

local function updateHealthStat()
	local currentPlayerHealth = math.round(humanoid.Health) -- Round because when regenerating, health can be a decimal
	local playerMaxHealth = humanoid.MaxHealth
	local currentPlayerHealthRatio = currentPlayerHealth / playerMaxHealth
	local currentPlayerHealthPercentage = math.round(currentPlayerHealthRatio * 100)

	if currentPlayerHealth < previousPlayerHealth then
		local knockbackTrack = AnimationLoader.LoadAnimation(fighterConfig.Animations.KnockbackAnimation)
		HealthDrainSFX:Play()
		knockbackTrack:Play()
	end
	previousPlayerHealth = currentPlayerHealth

	healthMeter.Size = UDim2.fromScale(currentPlayerHealthRatio, 1)
	healthPercentage.Text = `{currentPlayerHealthPercentage}%`
end

local function updateBlockStat()
	local currentBlockMeter = math.round(character:GetAttribute("BlockMeter") :: number)

	if currentBlockMeter < previousBlockMeter then
		BlockDrainSFX:Play()
	end
	previousBlockMeter = currentBlockMeter

	local blockMeterSize = currentBlockMeter / 100
	blockMeter.Size = UDim2.fromScale(blockMeterSize, 1)
	blockPercentage.Text = `{currentBlockMeter}%`
end

local function onCharacterAdded(newCharacter: Model, newHumanoid: Humanoid)
	character = newCharacter
	humanoid = newHumanoid
	previousPlayerHealth = math.round(humanoid.Health)
	previousBlockMeter = math.round(character:GetAttribute("BlockMeter") :: number)
	updateHealthStat()
	updateBlockStat()
	humanoid.HealthChanged:Connect(updateHealthStat)
	character:GetAttributeChangedSignal("BlockMeter"):Connect(updateBlockStat)
end

function PlayerHudModule.Init()
	playerHudGui.Parent = playerGui
	CharacterLoader.Init(onCharacterAdded)
end

return PlayerHudModule
