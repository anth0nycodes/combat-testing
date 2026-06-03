local Types = {}

type Config = {
	Combo: number,
	ComboResetTime: number,
	IsAttacking: boolean,
	ComboBreakTime: number,
	LastAttackTime: number,
}

export type CombatServiceClientType = {
	Config: Config,
	Init: () -> (),
	BindEvents: () -> (),
	Attack: () -> (),
}

return Types
