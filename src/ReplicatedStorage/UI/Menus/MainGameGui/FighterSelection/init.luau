--!strict
local FighterSelectionModule = {}

-- Game Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

-- Types
local Types = require(script.Types)

-- Player
local player = Players.LocalPlayer
assert(player, "Player is not defined")
local playerGui = player.PlayerGui

-- Inputs
local fighterSelectionButtonAction = RS.Inputs.GUIs.MainGame.FighterSelectionButton

-- GUIs
local fighterSelectionGuiTemplate = RS.Assets.GUIs.FighterSelectionGui :: Types.FighterSelectionGui
local fighterSelectionGui = fighterSelectionGuiTemplate:Clone()
local fighterSelectionButton = fighterSelectionGui.Container.FighterSelectionButton
local fighterList = fighterSelectionGui.Container.FighterList

-- SFX
local buttonPress = RS.Assets.SFX.GuiButtonPress
local buttonRelease = RS.Assets.SFX.GuiButtonRelease

-- Module Config
local isFighterListOpen = false

function FighterSelectionModule.Init()
	fighterSelectionButtonAction.TapAndClick.UIButton = fighterSelectionButton
	fighterSelectionGui.Parent = playerGui
	fighterSelectionButtonAction.Pressed:Connect(FighterSelectionModule.ToggleFighters)
	fighterSelectionButtonAction.Released:Connect(function()
		buttonRelease:Play()
		fighterList.Visible = isFighterListOpen
	end)
end

function FighterSelectionModule.ToggleFighters()
	buttonPress:Play()
	isFighterListOpen = not isFighterListOpen
end

return FighterSelectionModule
