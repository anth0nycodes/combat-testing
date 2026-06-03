--!strict
local HitboxClientModule = {}

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Remotes
local AttackRemote = RS.Remotes.AttackRemote

function HitboxClientModule.CreateHitbox(combo: number, isHitboxChecked: boolean)
	AttackRemote:FireServer(combo, isHitboxChecked)
end

return HitboxClientModule