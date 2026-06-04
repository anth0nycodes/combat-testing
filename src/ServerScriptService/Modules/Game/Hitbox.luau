--!strict
local HitboxServerModule = {}

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Modules
local FighterConfigModule = require(RS.Utils.FighterConfig)

-- Fighter Config
local fighterConfig = FighterConfigModule.get()

function HitboxServerModule.CreateHitbox(player: Player, isHitboxChecked: boolean)
	local character = player.Character or player.CharacterAdded:Wait()
	local hitHumanoids: { Humanoid } = {}

	if fighterConfig.Hitbox.HitboxType == "Box" then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart
		if not humanoidRootPart then
			return hitHumanoids
		end

		local hitboxSize = fighterConfig.Hitbox.Size
		local hitboxCFrame = humanoidRootPart.CFrame * fighterConfig.Hitbox.CFrame

		if isHitboxChecked then
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

		local overlapParams = OverlapParams.new()
		overlapParams.ExcludeInstances = { character }

		local hitboxParts = workspace:GetPartBoundsInBox(hitboxCFrame, hitboxSize, overlapParams)

		for _, part in hitboxParts do
			local model = part:FindFirstAncestorOfClass("Model")
			if not model then
				continue
			end

			local humanoid = model:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				continue
			end

			-- Prevent multiple hits on the same humanoid in one attack
			if table.find(hitHumanoids, humanoid) then
				continue
			end

			table.insert(hitHumanoids, humanoid)
		end
	end

	return hitHumanoids
end

return HitboxServerModule
