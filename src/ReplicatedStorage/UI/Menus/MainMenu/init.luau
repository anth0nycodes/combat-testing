--!strict
local MainMenu = {}

-- Game Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")

-- Player
local player = Players.LocalPlayer
assert(player, "Player is not defined")
local playerGui = player:WaitForChild("PlayerGui")

-- Types
local MainMenuGuiTypes = require(script.Types)

-- UIs
local MainGameGui = require(script.Parent.MainGameGui)

-- GUIs
local mainMenuGuiTemplate = RS.Assets.GUIs.MainMenuGui :: MainMenuGuiTypes.MainMenuGui
local mainMenuGui = mainMenuGuiTemplate:Clone()
local mainMenu = mainMenuGui.MainMenu
local mainMenuButtons = mainMenu.Buttons
local playButton = mainMenuButtons.Play
local creditsButton = mainMenuButtons.Credits

local creditsGuiTemplate = RS.Assets.GUIs.CreditsGui :: MainMenuGuiTypes.CreditsGui
local creditsGui = creditsGuiTemplate:Clone()
local creditsMenu = creditsGui.CreditsMenu
local creditsMenuScale = creditsMenu.UIScale

-- Inputs
local combatContext = RS.Inputs.Combat
local playButtonAction = RS.Inputs.GUIs.MainMenu.PlayButton
local creditsButtonAction = RS.Inputs.GUIs.MainMenu.CreditsButton

-- Remotes
local PlayerRemote = RS.Remotes.PlayerRemote :: RemoteEvent

-- SFX
local buttonPress = RS.Assets.SFX.GuiButtonPress
local buttonRelease = RS.Assets.SFX.GuiButtonRelease

-- CameraPart
local cameraPart = workspace:WaitForChild("CameraPart") :: Part
local currentCamera = workspace.CurrentCamera
assert(currentCamera, "Camera is not defined")
local MOVE_SPEED = 225

-- Mouse
local mouse = player:GetMouse()

local function UpdateCamera()
	local cameraCenter = cameraPart.CFrame
	currentCamera.CFrame = cameraPart.CFrame
		* CFrame.Angles(
			math.rad(-(mouse.Y - cameraCenter.Y) / MOVE_SPEED),
			math.rad(-(mouse.X - cameraCenter.Y) / MOVE_SPEED),
			0
		)
end

-- Module Config
local isCreditsOpen = false

function MainMenu.Init()
	combatContext.Enabled = false
	playButtonAction.TapAndClick.UIButton = playButton
	creditsButtonAction.TapAndClick.UIButton = creditsButton
	mainMenuGui.Parent = playerGui
	creditsGui.Parent = playerGui

	local connection = RunService.RenderStepped:Connect(UpdateCamera)

	playButtonAction.Pressed:Connect(function()
		buttonPress:Play()
	end)

	playButtonAction.Released:Connect(function()
		combatContext.Enabled = true
		PlayerRemote:FireServer("UnanchorHumanoidRootPart")
		buttonRelease:Play()

		-- Initialize all main game GUIs
		MainGameGui.Init()
		connection:Disconnect()
		mainMenuGui:Destroy()
		creditsGui:Destroy()
	end)

	creditsButtonAction.Pressed:Connect(function()
		buttonPress:Play()
	end)

	creditsButtonAction.Released:Connect(function()
		buttonRelease:Play()
		isCreditsOpen = not isCreditsOpen
		TS:Create(creditsMenuScale, TweenInfo.new(0.25), { Scale = if isCreditsOpen then 1 else 0 }):Play()
	end)
end

return MainMenu
