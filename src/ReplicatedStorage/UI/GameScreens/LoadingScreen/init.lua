--!strict
local LoadingScreen = {}

-- Game Services
local TS = game:GetService("TweenService")
local RF = game:GetService("ReplicatedFirst")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")

-- Player
local player = Players.LocalPlayer
assert(player, "Player is not defined")
local playerGui = player.PlayerGui

-- Types
local Types = require(script.Types)

local loadingScreenGuiTemplate = RS.Assets.GUIs.LoadingScreenGui :: Types.LoadingScreenGui
local loadingScreenGui = loadingScreenGuiTemplate:Clone()
local loadingFrame = loadingScreenGui.LoadingFrame
local loadingCanvasGroup = loadingFrame.CanvasGroup
local loadingText = loadingFrame.LoadingText
local loadingBar = loadingCanvasGroup.LoadingBar
local loadingMeter = loadingBar.LoadingMeter
local loadingPercentage = loadingBar.Percentage
local fadeOutInfo = TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- UIs
local MainMenu = require(RS.UI.Menus.MainMenu)

function LoadingScreen.Init()
	MainMenu.Init()
	loadingScreenGui.Parent = playerGui
	RF:RemoveDefaultLoadingScreen()	
	
	local assets = RS.Assets:GetDescendants()
	local totalAssets = #assets
	
	for i, asset in ipairs(assets) do
		loadingText.Text = `Loading... ({i}/{totalAssets})`
		ContentProvider:PreloadAsync({ asset })
		local progress = i / totalAssets
		TS:Create(loadingMeter, TweenInfo.new(.25), {Size = UDim2.fromScale(progress, 1)}):Play()
		loadingPercentage.Text = `{math.round(progress * 100)}%`
	end
	
	loadingText.Text = `Loading complete!`
	loadingMeter.Size = UDim2.fromScale(1, 1)
	task.wait(.5)
	
	local tweens = {
		TS:Create(loadingFrame, fadeOutInfo, {
			BackgroundTransparency = 1
		}),
		TS:Create(loadingText, fadeOutInfo, {
			TextTransparency = 1
		}),
		TS:Create(loadingCanvasGroup, fadeOutInfo, {
			GroupTransparency = 1
		})
	}
	
	for _, tween in ipairs(tweens) do
		tween:Play()
	end
	
	tweens[3].Completed:Wait()
	loadingScreenGui:Destroy()
end

return LoadingScreen