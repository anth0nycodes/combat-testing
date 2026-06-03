--!strict
local Players = game:GetService("Players")

local AnimationLoader = {}

function AnimationLoader.LoadAnimation(animation: Animation): AnimationTrack
	local player = Players.LocalPlayer
	assert(player, "AnimationLoader.LoadAnimation can only be called from a Client script!")

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	local animator = humanoid:WaitForChild("Animator") :: Animator
	local animationTrack = animator:LoadAnimation(animation)
	return animationTrack
end

type AnimationLoader = typeof(AnimationLoader)

return AnimationLoader :: AnimationLoader
