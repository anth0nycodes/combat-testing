--!strict
local SettingsModule = {}

-- Game Services
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Player
local player = Players.LocalPlayer
assert(player, "Player is not defined")
local playerGui = player.PlayerGui

-- Types
local Types = require(script.Types)

-- GUI Template
local settingsGuiTemplate = RS.Assets.GUIs.SettingsGui :: Types.SettingsGui

-- GUIs
local settingsGui = settingsGuiTemplate:Clone()
local settingsMenu = settingsGui.SettingsMenu
local settingsButton = settingsGui.SettingsButton
local settingsMenuScale = settingsMenu.UIScale
local settingsOptions = settingsMenu.Options
local showHitboxOption = settingsOptions.ShowHitbox
local hitboxOptionCheckbox = showHitboxOption.Checkbox

-- Inputs
local combatContext = RS.Inputs.Combat
local settingsButtonAction = RS.Inputs.GUIs.MainGame.SettingsButton

-- SFX
local buttonPress = RS.Assets.SFX.GuiButtonPress
local buttonRelease = RS.Assets.SFX.GuiButtonRelease

-- Module Config
local isSettingsOpen = false
SettingsModule.Config = {
	isHitboxChecked = false,
}

function SettingsModule.Init()
	settingsButtonAction.TapAndClick.UIButton = settingsButton
	settingsGui.Parent = playerGui
	settingsButtonAction.Pressed:Connect(SettingsModule.ToggleVisibility)
	settingsButtonAction.Released:Connect(function()
		buttonRelease:Play()
		local scaleAmount = if isSettingsOpen then 1 else 0
		local toggleTween =
			TS:Create(settingsMenuScale, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Scale = scaleAmount })
		toggleTween:Play()
	end)
	SettingsModule.HandleOptionChecked()
end

function SettingsModule.ToggleVisibility()
	buttonPress:Play()
	isSettingsOpen = not isSettingsOpen

	if isSettingsOpen then
		combatContext.Enabled = false
	else
		combatContext.Enabled = true
	end
end

function SettingsModule.HandleOptionChecked()
	hitboxOptionCheckbox.MouseButton1Down:Connect(function()
		buttonPress:Play()
	end)
	hitboxOptionCheckbox.MouseButton1Up:Connect(function()
		SettingsModule.Config.isHitboxChecked = not SettingsModule.Config.isHitboxChecked
		buttonRelease:Play()
		if SettingsModule.Config.isHitboxChecked then
			hitboxOptionCheckbox.Text = "✓"
		else
			hitboxOptionCheckbox.Text = ""
		end
	end)
end

return SettingsModule
