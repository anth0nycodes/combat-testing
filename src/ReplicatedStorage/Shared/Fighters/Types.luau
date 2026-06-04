local Types = {}

type BoxHitboxConfig = {
	HitboxType: "Box",
	Size: Vector3,
	CFrame: CFrame,
}

type WeaponHitboxConfig = {
	HitboxType: "Weapon",
	WeaponPart: BasePart,
}

type ProjectileHitboxConfig = {
	HitboxType: "Projectile",
	Speed: number,
	Direction: Vector3,
}

type HitboxConfig = BoxHitboxConfig | WeaponHitboxConfig | ProjectileHitboxConfig

type FighterConfigType = {
	Animations: { Animation },
	SFX: {
		Normal: Sound,
		Heavy: Sound,
	},
	Damage: {
		Normal: number,
		Heavy: number,
	},
	MaxComboCount: number,
	Hitbox: HitboxConfig,
}

export type ConfigType = {
	FighterConfig: FighterConfigType,
}

return Types
