--!strict
local HitboxServerModule = {}

function HitboxServerModule.CreateHitbox(player: Player, isHitboxChecked: BoolValue)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart

	local hitboxCFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -2.5)
	local hitboxSize = Vector3.new(5, 5, 2)
	
	local overlapParams = OverlapParams.new()
	overlapParams.ExcludeInstances = {character} -- excludes the attacker's character from the hitbox
	
	if isHitboxChecked then
		local hitbox = Instance.new("Part")
		hitbox.Size = hitboxSize
		hitbox.Color = Color3.new(1, 0, 0)
		hitbox.Transparency = 0.8
		hitbox.CFrame = hitboxCFrame
		hitbox.CanCollide = false
		hitbox.Anchored = true
		hitbox.Parent = workspace
		
		task.delay(0.35, function()
			hitbox:Destroy()
		end)
	end

	local hitboxParts = workspace:GetPartBoundsInBox(hitboxCFrame, hitboxSize, overlapParams)
	local humanoids: { Humanoid } = {}

	for _, part in hitboxParts do
		local model = part:FindFirstAncestorOfClass("Model")
		if not model then continue end

		local humanoid = model:FindFirstChildOfClass("Humanoid")
		if not humanoid then continue end
		
		-- prevents a single attack from dealing damage multiple times
		if table.find(humanoids, humanoid) then continue end
		table.insert(humanoids, humanoid)
	end
		
	return humanoids
end

return HitboxServerModule
