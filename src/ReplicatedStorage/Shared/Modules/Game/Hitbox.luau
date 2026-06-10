--!strict
local HitboxClientModule = {}

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Modules
local SettingsModule = require(RS.UI.Menus.MainGameGui.Settings)
local FighterConfigModule = require(RS.Utils.FighterConfig)

-- Fighter Config
local fighterConfig = FighterConfigModule.get()

function HitboxClientModule.CreateHitbox(humanoidRootPart: BasePart)
	if fighterConfig.Hitbox.HitboxType == "Box" then
		if SettingsModule.Config.isHitboxChecked then
			local hitboxCFrame = humanoidRootPart.CFrame * fighterConfig.Hitbox.CFrame
			local hitboxSize = fighterConfig.Hitbox.Size
			local hitbox = Instance.new("Part")
			hitbox.Size = hitboxSize
			hitbox.Color = Color3.new(1, 0, 0)
			hitbox.Transparency = 0.8
			hitbox.Anchored = true
			hitbox.CanCollide = false
			hitbox.CFrame = hitboxCFrame
			hitbox.Parent = workspace

			task.delay(0.35, function()
				hitbox:Destroy()
			end)
		end
	end
end

return HitboxClientModule
