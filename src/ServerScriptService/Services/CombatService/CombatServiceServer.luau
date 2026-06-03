--!strict
local CombatServiceServer = {}

-- Game Services
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

-- Modules
local HitboxServerModule = require(SSS.Modules.Game.Hitbox)

-- Remotes
local AttackRemote = RS.Remotes.AttackRemote

function CombatServiceServer.Init()
	AttackRemote.OnServerEvent:Connect(function(player: Player, combo: number, isHitboxChecked: BoolValue)
		local DAMAGE = if combo == 3 then 15 else 5
		local humanoids = HitboxServerModule.CreateHitbox(player, isHitboxChecked)
		if not humanoids then return end
		
		for _, humanoid in humanoids do
			if humanoid.Health <= 0 then continue end
			humanoid:TakeDamage(DAMAGE)
		end
	end)
end

return CombatServiceServer