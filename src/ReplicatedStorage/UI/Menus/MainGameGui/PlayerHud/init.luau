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
local CombatServiceClient = require(RS.Shared.Services.CombatService.CombatServiceClient)

-- Utils
local CharacterLoader = require(RS.Utils.CharacterLoader)

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

local function updateHealthStat()
	local playerHealth = math.round(humanoid.Health) -- Round because when regenerating, health can be a decimal
	local playerMaxHealth = humanoid.MaxHealth
	local healthMeterSize = playerHealth / playerMaxHealth
	healthMeter.Size = UDim2.fromScale(healthMeterSize, 1)
	healthPercentage.Text = `{playerHealth}%`
end

local function updateBlockStat()
	local blockValue = character:GetAttribute("BlockMeter") or 100
	local blockMeterSize = CombatServiceClient.Config.BlockMeter / 100
	blockMeter.Size = UDim2.fromScale(blockMeterSize, 1)
	blockPercentage.Text = `{blockValue}%`
end

local function onCharacterAdded(newCharacter: Model, newHumanoid: Humanoid)
	character = newCharacter
	humanoid = newHumanoid
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
