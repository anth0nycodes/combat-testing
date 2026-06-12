local Types = {}

export type BoxHitboxConfig = {
	HitboxType: "Box",
	Size: Vector3,
	CFrame: CFrame,
}

export type WeaponHitboxConfig = {
	HitboxType: "Weapon",
	WeaponPart: BasePart,
}

export type ProjectileHitboxConfig = {
	HitboxType: "Projectile",
	Speed: number,
	Direction: Vector3,
}

type HitboxConfig = BoxHitboxConfig | WeaponHitboxConfig | ProjectileHitboxConfig

type FighterConfigType = {
	Animations: {
		M1Animations: { Animation },
		BlockAnimation: Animation,
		BlockBreakAnimation: Animation,
		ParryStunAnimation: Animation,
		KnockbackAnimation: Animation,
	},
	Stuns: {
		BlockBreakDuration: number,
		ParryDuration: number,
	},
	WalkSpeed: { Base: number, Attacking: number, Blocking: number, BlockBroken: number },
	SFX: {
		NormalAttack: Sound,
		HeavyAttack: Sound,
		BlockBreak: Sound,
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
